Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYB2Aoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYB2Aoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYB2Anx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:43:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbYB2Ant (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:43:49 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/37] Permit filesystem local caching [ver #34]
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 29 Feb 2008 00:43:33 +0000
Message-ID: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add local caching for network filesystems such as NFS.  To give a
really quick overview of the way the facility works:

	+---------+
	|         |
	|   NFS   |--+
	|         |  |
	+---------+  |   +----------+
	             |   |          |
	+---------+  +-->|          |
	|         |      |          |
	|   AFS   |----->| FS-Cache |
	|         |      |          |--+
	+---------+  +-->|          |  |
	             |   |          |  |   +--------------+   +--------------+
	+---------+  |   +----------+  |   |              |   |              |
	|         |  |                 +-->|  CacheFiles  |-->|  Ext3        |
	|  ISOFS  |--+                     |  /var/cache  |   |  /dev/sda6   |
	|         |                        +--------------+   +--------------+
	+---------+


 (1) NFS, say, asks FS-Cache to store/retrieve data for it;

 (2) FS-Cache asks the cache backend, in this case CacheFiles to honour the
     operation;

 (3) CacheFiles 'opens' a file in a mounted filesystem, say Ext3, and does read
     and write operations of a sort on it;

 (4) Ext3 decides how the cache data is laid out on disk - CacheFiles just
     attempts to use one sparse file per netfs inode.

 (5) If NFS asks for data from the cache, but the file has a hole in it, NFS
     falls back to asking the server.  The data obtained from the server is
     then written over the hole in the file.

To look at it another way:

	+---------+
	|         |
	| Server  |
	|         |
	+---------+
	     |                  NETWORK
	~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	     |
	     |           +----------+
	     V           |          |
	+---------+      |          |
	|         |      |          |
	|   NFS   |----->| FS-Cache |
	|         |      |          |--+
	+---------+      |          |  |   +--------------+   +--------------+
	     |           |          |  |   |              |   |              |
	     V           +----------+  +-->|  CacheFiles  |-->|  Ext3        |
	+---------+                        |  /var/cache  |   |  /dev/sda6   |
	|         |                        +--------------+   +--------------+
	|   VFS   |                                ^                     ^
	|         |                                |                     |
	+---------+                                +--------------+      |
	     |                  KERNEL SPACE                      |      |
	~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|~~~~~~|~~~~
	     |                  USER SPACE                        |      |
	     V                                                    |      |
	+---------+                                           +--------------+
	|         |                                           |              |
	| Process |                                           | cachefilesd  |
	|         |                                           |              |
	+---------+                                           +--------------+

FS-Cache attempts to provide a caching facility to a network filesystem such
that it's transparent to the users of that network filesystem.


The patches can roughly be broken down into a number of sets:

  (*) 01-keys-inc-payload.diff
  (*) 02-keys-search-keyring.diff
  (*) 03-keys-callout-blob.diff

      Three patches to the keyring code made to help the CIFS people.
      Included because patches 05-07 modify the same code.

  (*) 04-keys-get-label.diff

      A patch to allow the security label of a key to be retrieved.
      Included because patches 05-07 modify the same code.

  (*) 05-security-current-fsugid.diff
  (*) 06-security-separate-task-bits.diff
  (*) 07-security-subjective.diff
  (*) 08-security-kernel_service-class.diff
  (*) 09-security-kernel-service.diff
  (*) 10-security-nfsd.diff

      Patches to permit the subjective security of a task to be overridden.
      All the security details in task_struct are decanted into a new struct
      that task_struct then has two pointers two: one that defines the
      objective security of that task (how other tasks may affect it) and one
      that defines the subjective security (how it may affect other objects).

      Note that I have dropped the idea of struct cred for the moment.  With
      the amount of stuff that was excluded from it, it wasn't actually any
      use to me.  However, it can be added later.

      This is required for CacheFiles and potentially other cache backends:

	It has been required that I call vfs_mkdir() and suchlike rather than
	bypassing security and calling inode ops directly.  Therefore the VFS
	and LSM get to deny the cache backend access to the cache data because
	under some circumstances the caching code is running in the security
	context of whatever process issued the original syscall on the netfs.

	Furthermore, the security parameters with which a file is created (UID,
	GID, security label) would be derived from that process that issued the
	system call, thus potentially preventing other processes from accessing
	the cache, including cache management daemons such as cachefilesd.

	What is required is to temporarily override the security of the process
	that issued the system call.  We can't, however, just do an in-place
	change of the security data as that affects the process as an object,
	not just as a subject.  This means it may lose signals or ptrace events
	for example, and affects what the process looks like in /proc.

	So what I've done is to make a logical split in the security between
	the objective security (task->sec) and the subjective security
	(task->act_as).  The objective security holds the intrinsic security
	properties of a process and is never overridden.  This is what appears
	in /proc, and is what is used when a process is the target of an
	operation by some other process (SIGKILL for example).

	The subjective security holds the active security properties of a
	process, and may be overridden.  This is not seen externally, and is
	used whan a process acts upon another object, for example SIGKILLing
	another process or opening a file.

	The new hooks allow SELinux (or Smack or whatever) to reject a request
	for a kernel service (such as cachefiles) to run in a context of a
	specific security label or to create files and directories with another
	security label.

      These hooks may also be useful for NFSd.


  (*) 11-release-page.diff
  (*) 12-fscache-page-flags.diff
  (*) 13-add_wait_queue_tail.diff
  (*) 14-fscache.diff

      Patches to provide a local caching facility for network filesystems.

      FS-Cache is a layer that takes requests from any one of a number of
      netfs's and passes them to an appropriate cache, if there is one.
      FS-Cache makes operations requested by the netfs transparently
      asynchronous where possible.

      FS-Cache also protects the netfs against (a) there being no cache, (b)
      the cache suffering a fatal I/O error and (c) the cache being removed;
      and protects the cache against (d) the netfs uncaching pages that the
      cache is using and (e) conflicting operations from the netfs, some of
      which may be queued for asynchronous processing.

      A number of documents in text file format that describe the FS-Cache
      interface are added by the latter patch

      Documentation/filesystems/caching/fscache.txt gives an overview of the
      facility and describes the statistical data it makes available.

      Documentation/filesystems/caching/netfs-api.txt describes the API by
      which a network filesystem would make use of the FS-Cache facility.

      Documentation/filesystems/caching/backend-api.txt describes the API that
      a cache backend must implement to provide caching services through
      FS-Cache.

      The second of the above patches adds two extra page flags that FS-Cache
      then uses to keep track of two bits of per-cached-page information:

	 (1) This page is known by the cache, and that the cache must be
	     informed if the page is going to go away.  It's an indication to
	     the netfs that the cache has an interest in this page, where an
	     interest may be a pointer to it, resources allocated or reserved
	     for it, or I/O in progress upon it.

	 (2) This page is being written to disk by the cache, and that it
	     cannot be released until completion.  Ideally it shouldn't be
	     changed until completion either so as to maintain the known state
	     of the cache.  This cannot be unified with PG_writeback as the
	     page may be being written to both the server and the cache at the
	     same time or at different times.

      To avoid using extra page bits, I could, for example, set up a radix tree
      per data storage object to keep track of both these bits, however this
      would mean that the netfs would have to do a call, spinlock, conditional
      jumps, etc to find out either state.

      On the other hand, if we can spare two page flags, those are sufficient.

      Note that the cache doesn't necessarily need to be able to find the netfs
      pages, but may have to allocate/pin resources for backing them.

      Further note that PG_private may not be used as I want to be able to use
      caching with ISOFS eventually, and PG_private is owned by the block
      buffer code.

      These bits can be otherwise used by any filesystem that doesn't want to
      use FS-Cache.

  (*) 15-cachefiles-ia64.diff
  (*) 16-cachefiles-ext3-f_mapping.diff
  (*) 17-cachefiles-write.diff
  (*) 18-cachefiles-monitor.diff
  (*) 19-cachefiles-export.diff
  (*) 20-cachefiles.diff

      Patches to provide a local cache in a directory of an already mounted
      filesystem.

      The latter patch adds a document in text file format that describes the
      CacheFiles cache backend and gives instructions on how it is set up and
      used.  This will be Documentation/filesystems/caching/cachefiles.txt when
      the patch is applied.

  (*) 21-nfs-comment.diff
  (*) 22-nfs-fscache-option.diff
  (*) 23-nfs-fscache-kconfig.diff
  (*) 24-nfs-fscache-top-index.diff
  (*) 25-nfs-fscache-server-obj.diff
  (*) 26-nfs-fscache-super-obj.diff
  (*) 27-nfs-fscache-inode-obj.diff
  (*) 28-nfs-fscache-use-inode.diff
  (*) 29-nfs-fscache-invalidate-pages.diff
  (*) 30-nfs-fscache-iostats.diff
  (*) 31-nfs-fscache-page-management.diff
  (*) 32-nfs-fscache-read-context.diff
  (*) 33-nfs-fscache-read-fallback.diff
  (*) 34-nfs-fscache-read-from-cache.diff
  (*) 35-nfs-fscache-store-to-cache.diff
  (*) 36-nfs-fscache-mount.diff
  (*) 37-nfs-fscache-display.diff

      Patches to provide NFS with local caching.

      A couple of questions on the NFS iostat changes: (1) Should I update the
      iostat version number; (2) is it permitted to have conditional iostats?


I've fixed a number of bugs, including the lack of locking around per-inode
cookie handling in NFS, and updated the documentation in a couple of patches.

I've been testing these patches by throwing batches of eight parallel "tar cf"
commands across three different 350MB NFS-based kernel trees (3 tars on first
tree, 3 on second, 2 on third), sometimes with one or more of the trees
preloaded into the cache.  The complete working data set does not fit into the
RAM of my test machine, so even three tars that can be entirely satisfied from
the cache may have to reread everything from disk.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-34.tar.bz2


To use this version of CacheFiles, the cachefilesd-0.9 is also required.  It
is available as an SRPM:

	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.9-1.fc7.src.rpm

Or as individual bits:

	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.9.tar.bz2
	http://people.redhat.com/~dhowells/fscache/cachefilesd.fc
	http://people.redhat.com/~dhowells/fscache/cachefilesd.if
	http://people.redhat.com/~dhowells/fscache/cachefilesd.te
	http://people.redhat.com/~dhowells/fscache/cachefilesd.spec

The .fc, .if and .te files are for manipulating SELinux.

David
