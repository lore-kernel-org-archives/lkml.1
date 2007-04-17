Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbXDQNJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbXDQNJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXDQNJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:09:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54675 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbXDQNJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:09:08 -0400
Date: Tue, 17 Apr 2007 18:46:21 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  1/15] Add union mount documentation
Message-ID: <20070417131621.GB4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Add union mount documentation.

This is an attempt to document some of the implementation details
and issues of union mount.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 Documentation/union-mounts.txt |  489 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 489 insertions(+)

--- /dev/null
+++ b/Documentation/union-mounts.txt
@@ -0,0 +1,489 @@
+VFS BASED UNION MOUNT
+=====================
+
+1. Overview
+2. Union stack
+3. Lookup
+4. Readdir
+5. Copyup
+6. Whiteout
+	6.1. Creation and deletion
+	6.2. Whiteout filetype support
+	6.3. Directory renaming
+7. Usage
+8. State of the code
+9. Extracted mail comments
+
+1. Overview
+-----------
+Union mount allows mounting of two or more filesystems transparently on
+a single mount point. The contents(files or directories) of all the
+filesystems become visible at the mount point after a union mount. If
+there are files of same name in multiple layers, only the topmost files remain
+visible in a union mount. However (currently) common named directories are
+again union-ed to present a unified view at the subdir level.
+
+In this approach of unioning filesystems, the layering information of
+different components of the union mount are maintained at the VFS layer.
+Hence we call this a VFS based union mount.
+
+2. Union stack
+--------------
+Union stack reflects the stacking of two or more filesystems of the
+union mount. The stacking or the layering information is maintained
+as part of dentry structures of the mountpoint and mount root.
+
+The union stack information in the dentry structure looks like this:
+
+struct dentry {
+	...
+
+#ifdef CONFIG_UNION_MOUNT
+	struct dentry *d_overlaid;	/* overlaid directory */
+	struct dentry *d_topmost;	/* topmost directory */
+	struct union_info *d_union;	/* union stack info */
+#endif
+	...
+};
+
+struct union_info {
+	struct mutex u_mutex;
+	atomic_t u_count;
+};
+
+There is one union_info shared by all dentries which are part of
+a union and u_count member holds the number of references to the union
+stack. When this reaches zero, the union stack ceases to exist and
+the union_info is freed.
+
+Union stack is essentially a singly linked list of dentries of the union
+with d_topmost as the head of the list and d_overlaid points
+to the next member of the stack. The walking of union stack is guarded by
+the u_mutex member.
+
+dget() references every dentry of the overlaid union stack to make sure
+that no dentry of the stack is discarded from memory while others are
+still in use. Since walking of union stack is protected by a mutex,
+dget() can now sleep.
+
+dput() also walks the union stack and releases references to all the
+dentries that are part of the union. If a dentry's reference count
+in a union stack reaches zero, it implies that the dentries above it
+in the stack must also be unused and the union stack can be safely
+destroyed at this point.
+
+Since dget() can sleep with union mount, it becomes necessary to
+fix many callers of dget() to release and re-acquire any spinlocks
+they are holding until they acquire the union lock(mutex).
+
+3. Lookup
+---------
+With union mount, it becomes necessary to lookup pathnames not only
+in the topmost filesystem but also in the underlying filesystems.
+
+In case of looking up a filename, the lookup routines as a rule return
+the match from the topmost layer. However if the file is not found
+in the topmost layer, the lookup routines have been modified to
+find the file in the underlying filesystems of the union stack.
+
+When looking up a directory under a union mount point, the lookup
+code has been modified to build a union stack (if necessary).
+
+When looking up a name in a union directory, it is necessary to
+guarantee that the returned union stack remains valid. Hence
+concurrent lookups are prevented by obtaining the mutex lock during
+lookups.
+
+4. Readdir
+----------
+The core functionality of union mount, viz., the merged view of
+multiple directories is provided by the readdir()/getdents() routines.
+This is achieved by reading the contents of every directory of the union
+stack and by merging the result.
+
+The directory entries are read starting from the top layer and they
+are maintained in a cache. Subsequently when the entries from the bottom layers
+of the union stack are read they are checked for duplicates (in the cache)
+before being passed out to the user space. There can be multiple calls
+to readdir/getdents routines for reading the entries of a single directory.
+But union directory cache is not maintained across these calls. Instead
+for every call, the previously read entries are re-read into the cache
+and newly read entries are compared against these for duplicates before
+being they are returned to user space. We are aware that this is not
+the most ideal solution for merging the directory entries. This approach
+involves setting up the cache for every getdents() call, re-reading some
+of the entries again into the cache and destroying the cache at the end
+of getdents() call. And this happens for every getdents() call.
+
+But there is an even bigger problem. Since readdir() on the union directory
+returns contents of all the underlying directories, it is possible
+that the file position exceeds the inode size of the first directory.
+Therefore the file position is rearranged to select the correct directory
+in the union stack. This is done by subtracting the inode size if the
+file position exceeds it and selecting the next member of the union stack next.
+
+This works well with filesystems like ext2/3 that use flat file directories.
+The directory entry offsets are arranged linear and are always smaller than
+the inode size of the directory. Modern filesystems have implemented
+directories differently and just return special cookies as directory entry
+offsets which are unrelated to the position in the directory or the inode
+size. So the current approach of directory merging is working only for
+file systems like ext2 and ext3.
+
+5. Copyup
+---------
+In this implementation of union mount, only the files residing in
+the topmost layer are writable. With this restriction, when a file residing
+in a bottom layer is opened for writing, it is copied up to the topmost layer
+and the write is allowed there. The copyup is done by first creating the
+file in the topmost layer and then copying the contents of the file.
+
+If it becomes necessary to create a directory structure in the top layer
+while copying up a file, then it is done so.
+
+Every time a file is opened for writing, we have introduced a check to
+see if this file belongs to a union and if so resides in the bottom
+layer of the union stack. Only then the copyup operation is performed.
+VFS routines are used directly to create the file in the topmost layer.
+However to copy the contents of the file from within the kernel splice
+routines are used.
+
+6. Whiteout
+-----------
+A whiteout file is a placeholder for a file that does not exist from a
+logical point of view. VFS returns -ENOENT for any reference to whiteouts.
+
+Typically whiteouts are created in the topmost layer when a file in
+the lower layer is deleted. The whiteout essentially masks out the file
+in the lower layer.
+
+6.1 Creation and deletion
+
+With union mount, a top layer whiteout is created in the following scenarios:
+- A file/directory which resides only the bottom layer is removed.
+- A file/directory which resides in both the layers are removed.
+
+The VFS calls like unlink(), rename() and rmdir() have been modified to create
+a whiteout automatically when the above situation occurs.
+
+A whiteout is automatically deleted whenever a new file or directory
+with a corresponding name is created. This happens in calls like
+create(), mknod(), symlink(), link() and mkdir().
+
+There is a special case in mkdir(). When a whiteout is replaced by a
+directory, it is marked opaque (by using new S_OPAQUE inode flag).
+And lookup wouldn't descend down to lower directories if a directory
+is marked opaque. This is needed in the following scenario:
+
+# rm -rf dir/
+# mkdir dir
+
+The newly created dir/ has to be marked opaque, otherwise the contents
+of union stack would become visible again. And it is not expected to
+find a non-empty directory immediately after it's creation.
+
+6.2. Whiteout filetype support
+
+Creation or deletion of whiteouts is a persistent operation and hence it
+needs support from the underlying filesystem.
+
+Linux already defines DT_WHT(include/linux/fs.h) for whiteout directory
+entry (file)type. In addition we need to define the whiteout filetype
+for which we make use of an unused bit in the filetype bitmask and
+define S_IFWHT (include/linux/stat.h).
+
+Filesystems which support the whiteout filetype should set the FS_WHT
+flag (include/linux/fs.h) on .fs_type in their file_system_type structure.
+
+Additionally they have to implement the whiteout inode operation.
+
+int (*whiteout)(struct inode *dir, struct dentry *dentry);
+
+where 'dentry' is the negative dentry to be masked out under the parent 'dir'.
+
+In the current implementation, there is an inode for every whiteout in the
+filesystem. But since a whiteout doesn't have any usable attribute apart
+from it's name(name of the whiteout file is stored as directory entry
+in the parent directory), it is an ideal candidate for being replaced by
+a singleton object. We have plans to explore this option at a later point
+in time.
+
+In ext2 and ext3 filesystems, whiteout is introduced as an incompatible
+feature and only readonly mounts are allowed without whiteout support.
+tune2fs(8) from e2fsprogs has been modified to add whiteout support to
+ext2/3.
+
+6.3. Directory renaming
+<TODO>
+
+7. Usage
+--------
+The way to union mount filesystems on two devices /dev/sda1 and /dev/sda2,
+on a mountpoint union/ is like this:
+
+- Mount the first filesystem normally and this becomes the lower layer
+of the union stack.
+# mount /dev/sda1 union/
+
+- Mount the second filesystem as a union on top of first
+# mount --union /dev/sda2 union/
+
+The mount(8) command from util-linux needs to be modified to make it
+interpret the --union option.
+
+After this the union/ will have the merged contents of /dev/sda1
+and /dev/sda2.
+
+8. State of the code
+--------------------
+The entire code is in highly experimental stage at present.
+
+These are a number of (un)known issues/shortcomings:
+
+- Unstable, might crash any time. Hasn't undergone any decent levels
+  of testing.
+- We are touching some fastpaths in the lookup code and introducing the
+  latency of obtaining a mutex in dget() (only for union mount cases).
+  We haven't yet benchmarked this to check the (adverse) effects.
+- Known to union mount correctly only two filesystems. Not tried with more.
+- Unioning of subdirectories within a union mount is working, but is buggy.
+- Whiteout support in ext3 is not thoroughly analyzed/tested for correctness.
+- The side effects of union mount changes on other subsystems
+  (eg cpuset, aio, dnotify, inotify etc which are touched by union
+  mount changes) haven't been tested yet.
+- bind/move vs union mount not yet handled.
+- Readdir has issues as noted above.
+- Some lockdep warnings need to be addressed still.
+- In general some code cleanliness issues are yet to be handled.
+
+9. Extracted mail comments
+--------------------------
+
+These are some of the extracts from an old linux-fsdevel post.
+
+----
+Andries Brouwer wrote:
+>
+> On "union mounts".
+> We must first have a theory on what "union mount" means.
+> Union is a commutative operator, but here there is no symmetry
+> at all, so "union" is a misnomer. There is an order.
+>
+> One might consider partial orders, so that one obtains a tree of mounts,
+> but I do not know any applications, and there is the problem of naming.
+> So, for simplicity, maybe there is a linear order.
+>
+> Things happen in the top one. All others are read-only.
+>
+
+Yes, that is correct. This is naturally since the stacking of vfsmount objects
+has been like this before.
+
+----
+
+Alexander Viro wrote:
+>
+> > Does not same thing apply also for common subdirectories?
+>
+> Not. union-mount != unionfs, it does not descend into subdirectories.
+> There is no way in hell to do that and permit sharing the union-mount
+> components between several mountpoints. unionfs is very different animal
+> and there the main point is that you are getting real, honest
+> copy-on-write, i.e. if you have foo/bar/baz on underlying filesystem than
+> any attempt to access foo will create a shadowing directory in the upper
+> layer, any attempt to access foo/bar will do the same for foo/bar and
+> attempt to write into the foo/bar/baz will lead to copying the thing into
+> the upper layer and changing it there. _Very_ useful when you have a
+> read-only fs and want to run make on it, for one thing - everything
+> new/modified gets into the covering layer, along with the accessed part of
+> directory tree. Very nice, but completely different - there are things
+> impossible for one and doable on another.
+>
+
+----
+
+Werner Almesberger wrote:
+>
+> Hmm, now I'm throughly confused :-( What is the "union" in here then ?
+> Is it that a lookup for a top-level component searches all file system
+> in that list, or does it simply mean that all the file systems are
+> internally linked to the same place, but only one of them is truly
+> visible ?
+>
+> E.g., given
+>
+> # mount /dev/a /mnt
+> # mkdir -p /mnt/foo/blah /mnt/bar
+> # umount /dev/a
+> # mount /dev/b /mnt
+> # mkdir -p /mnt/foo/zulu /mnt/baz
+> # mount -o union /dev/a /mnt
+>
+> # cd /mnt/foo/blah              works ?
+> # cd /mnt/foo/zulu              works too ? (no, I guess)
+> # cd /mnt/baz                   works ?
+> # cd /mnt/bar                   works too ?
+> # cd /mnt; touch file           works ? on which device is the file created ?
+> # cd /mnt/foo; touch file	  works ?
+> # cd /mnt/foo/blah; touch file  works ?
+> # cd /mnt/foo/zulu; touch file  works too ? (no, I guess)
+>
+
+# cd /mnt/foo/blah              works !
+# cd /mnt/foo/zulu              works !
+# cd /mnt/baz                   works !
+# cd /mnt/bar                   works !
+# cd /mnt; touch file           file created on /dev/a
+# cd /mnt/foo; touch file	file created on /dev/a
+# cd /mnt/foo/blah; touch file  file created on /dev/a
+# cd /mnt/foo/zulu; touch file  zulu copied to /dev/a and file created on it
+
+----
+
+Alexander Viro wrote:
+>
+> A) suppose we have a bunch of filesystems union-mounted on /foo/bar. We do
+>    chdir("/foo/bar"), what should become busy? Variants:
+>    mountpoint, first element, last element, all of them.
+> B) after the action in (A) we add another filesystem to the set. Again, what
+>    should happen to the busy/not busy status of the components?
+> C) we start with the normal mount and union-mount something else.
+>    Question: what is the desired result (almost definitely the set of old
+>    and new mounted stuff) and who should become busy?
+> D) In the cases above, what do we want to get from stat(2)?
+> E) What do we want to do if we do normal mount atop of the union-mount?
+>    Variants: try to replace, return -EBUSY. Doing replace (i.e. if
+>    everything can be umounted - do it and mount the new fs in place of the
+>    union) is attractive - we probably might treat the normal mount same way,
+>    which kills the "I've clicked in my point'n'drool krapplication ten times
+>    and it mounted CD ten times, waaaaaah" bug reports.
+>    Disadvantage: may need small fixes to mount(8) (basically, "if we already
+>    have mtab entry for this mountpoint and mount succeeds - discard the old
+>    one").
+>
+
+I don't understand the union mount as a set of mounts because we also need a
+strict order to remove duplicate filenames from the directory
+listing. Therefore after union mounting a filesystem the mount-points
+filesystem is busy. A chdir() to the mount-point makes the last mounted
+filesystem busy since a lookup returns the root directory of the topmost
+filesystem.
+
+----
+
+Alexander Viro wrote:
+> >
+> > >     A) suppose we have a bunch of filesystems union-mounted on
+> > > /foo/bar. We do chdir("/foo/bar"), what should become busy? Variants:
+> > > mountpoint, first element, last element, all of them.
+> >
+> > I believe that all of them. Or, we can make alternative and mark
+> > none of them busy (together with Tigran yet-to-write force unmount) -
+> > if there is reason why cwd should make filesystem busy at all...
+>
+> Ouch. "All" means that we can't, e.g expire elements of union.
+>
+
+
+----
+
+Andries Brouwer wrote:
+>
+> > 	A) suppose we have a bunch of filesystems union-mounted on
+> > /foo/bar. We do chdir("/foo/bar"), what should become busy? Variants:
+> > mountpoint, first element, last element, all of them.
+>
+> Last element.
+>
+> > 	B) after the action in (A) we add another filesystem to the set.
+> > Again, what should happen to the busy/not busy status of the components?
+>
+> Previous top one has now become busy. All other were busy already.
+>
+> > 	C) we start with the normal mount and union-mount something else.
+> > Question: what is the desired result (almost definitely the set of old and
+> > new mounted stuff) and who should become busy?
+>
+> First element now is busy.
+>
+> > 	D) In the cases above, what do we want to get from stat(2)?
+>
+> stat(2)  on this directory looks at the top one
+>
+> > 	E) What do we want to do if we do normal mount atop of the
+> > union-mount? Variants: try to replace,
+>
+> No. Very strange semantics for a mount.
+>
+> > return -EBUSY.
+>
+> Yes, quite reasonable. But I would prefer the third: just succeed.
+> We have a file hierarchy, and do a mount - well, we already know what that
+>  means, and we just do it.
+>
+> [I would prefer to return -EBUSY only when the same filesystem was already
+> mounted (in the same way) on the same mount point.]
+>
+
+
+----
+
+Neil Brown wrote:
+>
+> A "mount" is an ordered list (pile) of directories.
+> One of these elements is the "mountpoint", and it is particularly
+> distiguished because ".." from the "mount" goes through ".." of the
+> "mountpoint".    ".." of all other directories is not accessable.
+>
+> Each directory in the pile has two flags (well, three if you count
+> IS_MOUNTPOINT):
+>
+>   IS_WRITABLE: You can create things in here.
+>   IS_VISIBLE: You can see inside this.
+>
+> Thus, a traditional mount has two directories in the pile.
+> The bottom one IS_MOUNTPOINT
+> The top one IS_WRITABLE|IS_VISIBLE
+>
+> With mount -o union, you can set what ever flags you like, though
+> having IS_WRITABLE and not IS_VISIBLE would be a problem.
+> However you can only have one IS_MOUNTPOINT directory.
+>
+> Now the rules:
+>
+> 1/ on "lookup", you do a lookup in each IS_VISIBLE directory from the
+>     top down until you find a match or you hit the bottom.
+>
+> 2/ If you decide to create something (*) then it goes in the uppermost
+>    IS_WRITABLE directory.
+>
+> 3/ "stat" (of ".") sees the IS_MOUNTPOINT directory if it IS_VISIBLE,
+>    otherwise the lowest IS_VISIBLE directory.
+>    Possibly n_links could be fiddled, but I don't know how important
+>    that is.
+>
+> 4/ The "mount" keeps only the IS_MOUNTPOINT directory busy.
+>
+> 5/ An open or cd to the mount makes the directory which "stat" sees
+>    busy.
+>
+> 6/ A mount is not allowed if it would change 'the directory which
+>    "stat" sees', and that directory is "busy".
+>
+> (*) It is unclear to me when creation should be allowed.
+>    If I say "mkdir fred", and fred does not exist in or above the
+>    uppermost IS_WRITABLE directory, but does exist is a lower
+>    IS_VISIBLE directory, should the create succeed or fail?
+>    Would that same be true for
+>      open("fred", O_CREAT)  which is "create if it doesn't exist"
+>    or open("fred", O_CREAT|O_EXCL) which is "create and it mustn't exist".
+>
+
+For the complete thread refer to:
+http://marc.theaimsgroup.com/?l=linux-fsdevel&m=96035682927821&w=2
+
+---
+- Bharata B Rao <bharata@linux.vnet.ibm.com>
+- Jan Blunck <j.blunck@tu-harburg.de>
+
+April 2007
