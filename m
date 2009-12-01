Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZLAFhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZLAFhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZLAFhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:37:37 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33594 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZLAFhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:37:36 -0500
Date: Tue, 1 Dec 2009 00:37:09 -0500
Message-Id: <200912010537.nB15b977031207@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/41] union-mount: Documentation 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:16 PDT."
             <1256152779-10054-19-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Val, I first read the documentation, but didn't comment on it until I've
read the rest of the patches.  I won't repeat in detail what I've said in
the other patches regarding the documentation: listing short-term and
long-term tasks in order, adding a "limitations" section, etc.  I'll try
here to focus only on new issues (other than "please spell check the
doc" :-)

In message <1256152779-10054-19-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:

> +Terminology
> +===========
> +
> +The main analogy for writable overlays is that a writable file system
> +is mounted "on top" of a read-only file system.  Lookups start at the
> +"top" read-write file system and travel "down" to the "bottom"
> +read-only file system only if no blocking entry exists on the top
> +layer.
> +
> +Top layer: The read-write file system.  Lookups begin here.
> +
> +Bottom layer: The read-only file system.  Lookups end here.

Recall my gripes about terminology: top/bottom, upper/lower, this/next, etc.
The docs and srcs should use consistent terminology.

> +Path: Combination of the vfsmount and dentry structure.
> +
> +Follow down: Given a path from the top layer, find the corresponding
> +path on the bottom layer.
> +
> +Follow up: Given a path from the bottom layer, find the corresponding
> +path on the top layer.
> +
> +Whiteout: A directory entry in the top layer that prevents lookups
> +from travelling down to the bottom layer.  Created on unlink()/rmdir()
> +if a corresponding directory entry exists in the bottom layer.
> +
> +Opaque: A flag on a directory in the top layer that prevents lookups
> +of entries in this directory from travelling down to the bottom
> +layer (unless there is an explicit fallthru entry allowing that for a
> +particular entry).  Set on creation of a directory that replaces a
> +whiteout, and after a directory copyup.
> +
> +Fallthru: A directory entry which allows lookups to "fall through" to
> +the bottom layer for that exact directory entry.  This serves as a
> +placeholder for directory entries from the bottom layer during
> +readdir().  Fallthrus override opaque flags.

The problem I have with this Terminology section is that it does more than
just define terms: it also describes their use.  Because of that, you have a
chicken-and-egg text here; the description of Opaque refers to Fallthru and
vise verse, so there's no clean order to those two terms.  I have to read
this section twice before I can understand it.  Good text doesn't require
multiple passes (like a good compiler :-)

A better way would be to make his section JUST describe terms.  And then
follow it with a section which describes HOW those terms are used and
interact with each other.  That'll break the chick-and-egg cycles.

> +
> +File copyup: Create a file on the top layer that has the same properties
> +and contents as the file with the same pathname on the bottom layer.
> +
> +Directory copyup: Copy up the visible directory entries from the
> +bottom layer as fallthrus in the matching top layer directory.  Mark
> +the directory opaque to avoid unnecessary negative lookups on the
> +bottom layer.
> +
> +Examples
> +========
> +
> +What happens when I...
> +
> +- creat() /newfile -> creates on top layer
> +- unlink() /oldfile -> creates a whiteout on top layer
> +- Edit /existingfile -> copies up to top layer at open(O_WR) time
> +- truncate /existingfile -> copies up to top layer + N bytes if specified
> +- touch()/chmod()/chown()/etc. -> copies up to top layer
> +- mkdir() /newdir -> creates on top layer
> +- rmdir() /olddir -> creates a whiteout on top layer
> +- mkdir() /olddir after above -> creates on top layer w/ opaque flag
> +- readdir() /shareddir -> copies up entries from bottom layer as fallthrus
> +- link() /oldfile /newlink -> copies up /oldfile, creates /newlink on top layer
> +- symlink() /oldfile /symlink -> nothing special
> +- rename() /oldfile /newfile -> copies up /oldfile to /newfile on top layer
> +- rename() dir -> EXDEV

These examples are premature.  You haven't yet described HOW the various ops
in UM work in sufficient detail.  I'd move examples much further down.

Also, these examples come out of nowhere.  You haven't describe the
environment for me in sufficient detail.  What is /newfile and /oldfile and
/existingfile: in which layer(s) do they live?

Also, now that I've gone over the rest of the patches, there are
discrepancies b/t these examples and what your code does (e.g., patch 41
changed how rename behaves).  Finally, I don't think all ops have been
defined here:

- ls/readdir/stat?
- open(O_WR)?

> +Getting to a root file system with a writable overlay:
> +
> +- Mount the base read-only file system as the root file system
> +- Mount the read-only file system again on /newroot
> +- Mount the writable overlay on /newroot:
> +   # mount -o union /dev/sda /newroot
> +- pivot_root to /newroot
> +- Start init
> +
> +See scripts/pivot.sh in the UML devkit linked to from:
> +
> +http://valerieaurora.org/union/
> +
> +VFS implementation
> +==================
> +
> +Writable overlays are implemented as an integral part of the VFS,
> +rather than as a VFS client file system (i.e., a stacked file system
> +like unionfs or ecryptfs).  Implementing writable overlays inside the
> +VFS eliminates the need for duplicate copies of VFS data structures,
> +unnecessary indirection, and code duplication, but requires very
> +maintainable, low-to-zero overhead code.  Writable overlays require no
> +change to file systems serving as the read-only layer, and requires
> +some minor support from file systems serving as the read-write layer.
> +File systems that want to be the writable layer must implement the new
> +->whiteout() and ->fallthru() inode operations, which create special
> +dummy directory entries.
> +
> +union_mount structure
> +---------------------
> +
> +The primary data structure for writable overlays is the union_mount
> +structure, which connects overlapping directory dentries into a "union
> +stack":
> +
> +struct union_mount {
> +	atomic_t u_count;		/* reference count */
> +	struct mutex u_mutex;
> +	struct list_head u_unions;	/* list head for d_unions */
> +	struct list_head u_list;	/* list head for mnt_unions */
> +	struct hlist_node u_hash;	/* list head for searching */
> +	struct hlist_node u_rhash;	/* list head for reverse searching */
> +
> +	struct path u_this;		/* this is me */
> +	struct path u_next;		/* this is what I overlay */
> +};
> +
> +The union_mount is referenced from the corresponding directory's
> +dentry:
> +
> +struct dentry {
> +[...]
> +#ifdef CONFIG_UNION_MOUNT
> +	/*
> +	 * The following fields are used by the VFS based union mount
> +	 * implementation. Both are protected by union_lock!
> +	 */
> +	struct list_head d_unions;	/* list of union_mounts */
> +	unsigned int d_unionized;	/* unions referencing this dentry */
> +#endif
> +[...]
> +};
> +
> +Each top layer directory with the potential for a lookup to fall
> +through to the bottom layer has a union_mount structure stored in a
> +union_mount hash table.  The union_mount's can be looked up both by the
> +top layer's path (via union_lookup()) and the bottom layer's path (via
> +union_rlookup()).  Once you have the path (vfsmount and dentry pair)
> +of a file, the union stack can be followed down, layer by layer, with
> +follow_union_down(), and up with follow_union_mount().
> +
> +All union_mount's are allocated from a kmem cache when the
> +corresponding dentries are created.  union_mount's are allocated when
> +the first referencing dentry is allocated and freed when all of the
> +referencing dentries are freed - that is, the dcache drives the union
> +cache.  While writable overlays only use two layers, the union stack
> +infrastructure is capable of supporting an arbitrary number of file
> +system layers (leaving aside locking issues).
> +
> +Todo:
> +
> +- Rename union_mount structure - it's per directory, not per mount

You have tons of 'todo' items sprinkled throughout this doc and the sources.
It's ok for them to be in the sources, but please have one giant 'todo'
section here with every issue/item that needs to be addressed, so it's
easier for anyone to find out the current status of this project.

> +Userland support
> +================

About userland support: a while back I created a lightweight version of
unionfs which used native whiteouts, using an older version of Jan's patches
which supported whiteouts and opaque dirs natively in lower file systems.  I
then found it then necessary to expose whiteouts and opaques to userland,
for testing/debugging purposes.  I think you'll need to do the same: support
query/add/remove methods for whiteouts, opaques, and fallthrus.  I did it
with top-level ioctls in fs/ioctl.c: it seemed like the most reasonable
option short of creating new syscalls.  I can dig up my patches if you're
interested.

Exposing these to userland is important: you have to be able to write
regression suites which test that the kernel code properly creates
whiteouts, opaques, etc.  You have to be able to hand-create small file
systems pre-populated with whiteouts et al, and test how the kernel handles
them (e.g., creat(2) of a file who was a whiteout before, or mkdir() of an
opaque'd dir).  All this would be useful for the long term LTP-like
test-ability of UM.

----

Finally, Val, thanks for taking over this project, for the code and
documentation, and the ongoing efforts.  Good luck.

Sincerely,
Erez.
