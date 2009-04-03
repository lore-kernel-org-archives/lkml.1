Return-Path: <linux-kernel-owner+w=401wt.eu-S935206AbZDCP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbZDCP72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933551AbZDCPzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911AbZDCPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/41] FS-Cache: Add the FS-Cache netfs API and documentation
	[ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:12 +0100
Message-ID: <20090403155512.28714.14507.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the API for a generic facility (FS-Cache) by which filesystems (such as AFS
or NFS) may call on local caching capabilities without having to know anything
about how the cache works, or even if there is a cache:

	+---------+
	|         |                        +--------------+
	|   NFS   |--+                     |              |
	|         |  |                 +-->|   CacheFS    |
	+---------+  |   +----------+  |   |  /dev/hda5   |
	             |   |          |  |   +--------------+
	+---------+  +-->|          |  |
	|         |      |          |--+
	|   AFS   |----->| FS-Cache |
	|         |      |          |--+
	+---------+  +-->|          |  |
	             |   |          |  |   +--------------+
	+---------+  |   +----------+  |   |              |
	|         |  |                 +-->|  CacheFiles  |
	|  ISOFS  |--+                     |  /var/cache  |
	|         |                        +--------------+
	+---------+

General documentation and documentation of the netfs specific API are provided
in addition to the header files.

As this patch stands, it is possible to build a filesystem against the facility
and attempt to use it.  All that will happen is that all requests will be
immediately denied as if no cache is present.

Further patches will implement the core of the facility.  The facility will
transfer requests from networking filesystems to appropriate caches if
possible, or else gracefully deny them.

If this facility is disabled in the kernel configuration, then all its
operations will trivially reduce to nothing during compilation.


WHY NOT I_MAPPING?
==================

I have added my own API to implement caching rather than using i_mapping to do
this for a number of reasons.  These have been discussed a lot on the LKML and
CacheFS mailing lists, but to summarise the basics:

 (1) Most filesystems don't do hole reportage.  Holes in files are treated as
     blocks of zeros and can't be distinguished otherwise, making it difficult
     to distinguish blocks that have been read from the network and cached from
     those that haven't.

 (2) The backing inode must be fully populated before being exposed to
     userspace through the main inode because the VM/VFS goes directly to the
     backing inode and does not interrogate the front inode's VM ops.

     Therefore:

     (a) The backing inode must fit entirely within the cache.

     (b) All backed files currently open must fit entirely within the cache at
     	 the same time.

     (c) A working set of files in total larger than the cache may not be
     	 cached.

     (d) A file may not grow larger than the available space in the cache.

     (e) A file that's open and cached, and remotely grows larger than the
     	 cache is potentially stuffed.

 (3) Writes go to the backing filesystem, and can only be transferred to the
     network when the file is closed.

 (4) There's no record of what changes have been made, so the whole file must
     be written back.

 (5) The pages belong to the backing filesystem, and all metadata associated
     with that page are relevant only to the backing filesystem, and not
     anything stacked atop it.



OVERVIEW
========

FS-Cache provides (or will provide) the following facilities:

 (1) Caches can be added / removed at any time, even whilst in use.

 (2) Adds a facility by which tags can be used to refer to caches, even if
     they're not available yet.

 (3) More than one cache can be used at once.  Caches can be selected
     explicitly by use of tags.

 (4) The netfs is provided with an interface that allows either party to
     withdraw caching facilities from a file (required for (1)).

 (5) A netfs may annotate cache objects that belongs to it.  This permits the
     storage of coherency maintenance data.

 (6) Cache objects will be pinnable and space reservations will be possible.

 (7) The interface to the netfs returns as few errors as possible, preferring
     rather to let the netfs remain oblivious.

 (8) Cookies are used to represent indices, files and other objects to the
     netfs.  The simplest cookie is just a NULL pointer - indicating nothing
     cached there.

 (9) The netfs is allowed to propose - dynamically - any index hierarchy it
     desires, though it must be aware that the index search function is
     recursive, stack space is limited, and indices can only be children of
     indices.

(10) Indices can be used to group files together to reduce key size and to make
     group invalidation easier.  The use of indices may make lookup quicker,
     but that's cache dependent.

(11) Data I/O is effectively done directly to and from the netfs's pages.  The
     netfs indicates that page A is at index B of the data-file represented by
     cookie C, and that it should be read or written.  The cache backend may or
     may not start I/O on that page, but if it does, a netfs callback will be
     invoked to indicate completion.  The I/O may be either synchronous or
     asynchronous.

(12) Cookies can be "retired" upon release.  At this point FS-Cache will mark
     them as obsolete and the index hierarchy rooted at that point will get
     recycled.

(13) The netfs provides a "match" function for index searches.  In addition to
     saying whether a match was made or not, this can also specify that an
     entry should be updated or deleted.


FS-Cache maintains a virtual index tree in which all indices, files, objects
and pages are kept.  Bits of this tree may actually reside in one or more
caches.

                                           FSDEF
                                             |
                        +------------------------------------+
                        |                                    |
                       NFS                                  AFS
                        |                                    |
           +--------------------------+                +-----------+
           |                          |                |           |
        homedir                     mirror          afs.org   redhat.com
           |                          |                            |
     +------------+           +---------------+              +----------+
     |            |           |               |              |          |
   00001        00002       00007           00125        vol00001   vol00002
     |            |           |               |                         |
 +---+---+     +-----+      +---+      +------+------+            +-----+----+
 |   |   |     |     |      |   |      |      |      |            |     |    |
PG0 PG1 PG2   PG0  XATTR   PG0 PG1   DIRENT DIRENT DIRENT        R/W   R/O  Bak
                     |                                            |
                    PG0                                       +-------+
                                                              |       |
                                                            00001   00003
                                                              |
                                                          +---+---+
                                                          |   |   |
                                                         PG0 PG1 PG2

In the example above, two netfs's can be seen to be backed: NFS and AFS.  These
have different index hierarchies:

 (*) The NFS primary index will probably contain per-server indices.  Each
     server index is indexed by NFS file handles to get data file objects.
     Each data file objects can have an array of pages, but may also have
     further child objects, such as extended attributes and directory entries.
     Extended attribute objects themselves have page-array contents.

 (*) The AFS primary index contains per-cell indices.  Each cell index contains
     per-logical-volume indices.  Each of volume index contains up to three
     indices for the read-write, read-only and backup mirrors of those volumes.
     Each of these contains vnode data file objects, each of which contains an
     array of pages.

The very top index is the FS-Cache master index in which individual netfs's
have entries.

Any index object may reside in more than one cache, provided it only has index
children.  Any index with non-index object children will be assumed to only
reside in one cache.


The FS-Cache overview can be found in:

	Documentation/filesystems/caching/fscache.txt

The netfs API to FS-Cache can be found in:

	Documentation/filesystems/caching/netfs-api.txt

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 Documentation/filesystems/caching/fscache.txt   |  330 ++++++++++
 Documentation/filesystems/caching/netfs-api.txt |  778 +++++++++++++++++++++++
 include/linux/fscache.h                         |  548 ++++++++++++++++
 3 files changed, 1656 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/caching/fscache.txt
 create mode 100644 Documentation/filesystems/caching/netfs-api.txt
 create mode 100644 include/linux/fscache.h


diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
new file mode 100644
index 0000000..a759d91
--- /dev/null
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -0,0 +1,330 @@
+			  ==========================
+			  General Filesystem Caching
+			  ==========================
+
+========
+OVERVIEW
+========
+
+This facility is a general purpose cache for network filesystems, though it
+could be used for caching other things such as ISO9660 filesystems too.
+
+FS-Cache mediates between cache backends (such as CacheFS) and network
+filesystems:
+
+	+---------+
+	|         |                        +--------------+
+	|   NFS   |--+                     |              |
+	|         |  |                 +-->|   CacheFS    |
+	+---------+  |   +----------+  |   |  /dev/hda5   |
+	             |   |          |  |   +--------------+
+	+---------+  +-->|          |  |
+	|         |      |          |--+
+	|   AFS   |----->| FS-Cache |
+	|         |      |          |--+
+	+---------+  +-->|          |  |
+	             |   |          |  |   +--------------+
+	+---------+  |   +----------+  |   |              |
+	|         |  |                 +-->|  CacheFiles  |
+	|  ISOFS  |--+                     |  /var/cache  |
+	|         |                        +--------------+
+	+---------+
+
+Or to look at it another way, FS-Cache is a module that provides a caching
+facility to a network filesystem such that the cache is transparent to the
+user:
+
+	+---------+
+	|         |
+	| Server  |
+	|         |
+	+---------+
+	     |                  NETWORK
+	~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+	     |
+	     |           +----------+
+	     V           |          |
+	+---------+      |          |
+	|         |      |          |
+	|   NFS   |----->| FS-Cache |
+	|         |      |          |--+
+	+---------+      |          |  |   +--------------+   +--------------+
+	     |           |          |  |   |              |   |              |
+	     V           +----------+  +-->|  CacheFiles  |-->|  Ext3        |
+	+---------+                        |  /var/cache  |   |  /dev/sda6   |
+	|         |                        +--------------+   +--------------+
+	|   VFS   |                                ^                     ^
+	|         |                                |                     |
+	+---------+                                +--------------+      |
+	     |                  KERNEL SPACE                      |      |
+	~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|~~~~~~|~~~~
+	     |                  USER SPACE                        |      |
+	     V                                                    |      |
+	+---------+                                           +--------------+
+	|         |                                           |              |
+	| Process |                                           | cachefilesd  |
+	|         |                                           |              |
+	+---------+                                           +--------------+
+
+
+FS-Cache does not follow the idea of completely loading every netfs file
+opened in its entirety into a cache before permitting it to be accessed and
+then serving the pages out of that cache rather than the netfs inode because:
+
+ (1) It must be practical to operate without a cache.
+
+ (2) The size of any accessible file must not be limited to the size of the
+     cache.
+
+ (3) The combined size of all opened files (this includes mapped libraries)
+     must not be limited to the size of the cache.
+
+ (4) The user should not be forced to download an entire file just to do a
+     one-off access of a small portion of it (such as might be done with the
+     "file" program).
+
+It instead serves the cache out in PAGE_SIZE chunks as and when requested by
+the netfs('s) using it.
+
+
+FS-Cache provides the following facilities:
+
+ (1) More than one cache can be used at once.  Caches can be selected
+     explicitly by use of tags.
+
+ (2) Caches can be added / removed at any time.
+
+ (3) The netfs is provided with an interface that allows either party to
+     withdraw caching facilities from a file (required for (2)).
+
+ (4) The interface to the netfs returns as few errors as possible, preferring
+     rather to let the netfs remain oblivious.
+
+ (5) Cookies are used to represent indices, files and other objects to the
+     netfs.  The simplest cookie is just a NULL pointer - indicating nothing
+     cached there.
+
+ (6) The netfs is allowed to propose - dynamically - any index hierarchy it
+     desires, though it must be aware that the index search function is
+     recursive, stack space is limited, and indices can only be children of
+     indices.
+
+ (7) Data I/O is done direct to and from the netfs's pages.  The netfs
+     indicates that page A is at index B of the data-file represented by cookie
+     C, and that it should be read or written.  The cache backend may or may
+     not start I/O on that page, but if it does, a netfs callback will be
+     invoked to indicate completion.  The I/O may be either synchronous or
+     asynchronous.
+
+ (8) Cookies can be "retired" upon release.  At this point FS-Cache will mark
+     them as obsolete and the index hierarchy rooted at that point will get
+     recycled.
+
+ (9) The netfs provides a "match" function for index searches.  In addition to
+     saying whether a match was made or not, this can also specify that an
+     entry should be updated or deleted.
+
+(10) As much as possible is done asynchronously.
+
+
+FS-Cache maintains a virtual indexing tree in which all indices, files, objects
+and pages are kept.  Bits of this tree may actually reside in one or more
+caches.
+
+                                           FSDEF
+                                             |
+                        +------------------------------------+
+                        |                                    |
+                       NFS                                  AFS
+                        |                                    |
+           +--------------------------+                +-----------+
+           |                          |                |           |
+        homedir                     mirror          afs.org   redhat.com
+           |                          |                            |
+     +------------+           +---------------+              +----------+
+     |            |           |               |              |          |
+   00001        00002       00007           00125        vol00001   vol00002
+     |            |           |               |                         |
+ +---+---+     +-----+      +---+      +------+------+            +-----+----+
+ |   |   |     |     |      |   |      |      |      |            |     |    |
+PG0 PG1 PG2   PG0  XATTR   PG0 PG1   DIRENT DIRENT DIRENT        R/W   R/O  Bak
+                     |                                            |
+                    PG0                                       +-------+
+                                                              |       |
+                                                            00001   00003
+                                                              |
+                                                          +---+---+
+                                                          |   |   |
+                                                         PG0 PG1 PG2
+
+In the example above, you can see two netfs's being backed: NFS and AFS.  These
+have different index hierarchies:
+
+ (*) The NFS primary index contains per-server indices.  Each server index is
+     indexed by NFS file handles to get data file objects.  Each data file
+     objects can have an array of pages, but may also have further child
+     objects, such as extended attributes and directory entries.  Extended
+     attribute objects themselves have page-array contents.
+
+ (*) The AFS primary index contains per-cell indices.  Each cell index contains
+     per-logical-volume indices.  Each of volume index contains up to three
+     indices for the read-write, read-only and backup mirrors of those volumes.
+     Each of these contains vnode data file objects, each of which contains an
+     array of pages.
+
+The very top index is the FS-Cache master index in which individual netfs's
+have entries.
+
+Any index object may reside in more than one cache, provided it only has index
+children.  Any index with non-index object children will be assumed to only
+reside in one cache.
+
+
+The netfs API to FS-Cache can be found in:
+
+	Documentation/filesystems/caching/netfs-api.txt
+
+The cache backend API to FS-Cache can be found in:
+
+	Documentation/filesystems/caching/backend-api.txt
+
+
+=======================
+STATISTICAL INFORMATION
+=======================
+
+If FS-Cache is compiled with the following options enabled:
+
+	CONFIG_FSCACHE_PROC=y (implied by the following two)
+	CONFIG_FSCACHE_STATS=y
+	CONFIG_FSCACHE_HISTOGRAM=y
+
+then it will gather certain statistics and display them through a number of
+proc files.
+
+ (*) /proc/fs/fscache/stats
+
+     This shows counts of a number of events that can happen in FS-Cache:
+
+	CLASS	EVENT	MEANING
+	=======	=======	=======================================================
+	Cookies	idx=N	Number of index cookies allocated
+		dat=N	Number of data storage cookies allocated
+		spc=N	Number of special cookies allocated
+	Objects	alc=N	Number of objects allocated
+		nal=N	Number of object allocation failures
+		avl=N	Number of objects that reached the available state
+		ded=N	Number of objects that reached the dead state
+	ChkAux	non=N	Number of objects that didn't have a coherency check
+		ok=N	Number of objects that passed a coherency check
+		upd=N	Number of objects that needed a coherency data update
+		obs=N	Number of objects that were declared obsolete
+	Pages	mrk=N	Number of pages marked as being cached
+		unc=N	Number of uncache page requests seen
+	Acquire	n=N	Number of acquire cookie requests seen
+		nul=N	Number of acq reqs given a NULL parent
+		noc=N	Number of acq reqs rejected due to no cache available
+		ok=N	Number of acq reqs succeeded
+		nbf=N	Number of acq reqs rejected due to error
+		oom=N	Number of acq reqs failed on ENOMEM
+	Lookups	n=N	Number of lookup calls made on cache backends
+		neg=N	Number of negative lookups made
+		pos=N	Number of positive lookups made
+		crt=N	Number of objects created by lookup
+	Updates	n=N	Number of update cookie requests seen
+		nul=N	Number of upd reqs given a NULL parent
+		run=N	Number of upd reqs granted CPU time
+	Relinqs	n=N	Number of relinquish cookie requests seen
+		nul=N	Number of rlq reqs given a NULL parent
+		wcr=N	Number of rlq reqs waited on completion of creation
+	AttrChg	n=N	Number of attribute changed requests seen
+		ok=N	Number of attr changed requests queued
+		nbf=N	Number of attr changed rejected -ENOBUFS
+		oom=N	Number of attr changed failed -ENOMEM
+		run=N	Number of attr changed ops given CPU time
+	Allocs	n=N	Number of allocation requests seen
+		ok=N	Number of successful alloc reqs
+		wt=N	Number of alloc reqs that waited on lookup completion
+		nbf=N	Number of alloc reqs rejected -ENOBUFS
+		ops=N	Number of alloc reqs submitted
+		owt=N	Number of alloc reqs waited for CPU time
+	Retrvls	n=N	Number of retrieval (read) requests seen
+		ok=N	Number of successful retr reqs
+		wt=N	Number of retr reqs that waited on lookup completion
+		nod=N	Number of retr reqs returned -ENODATA
+		nbf=N	Number of retr reqs rejected -ENOBUFS
+		int=N	Number of retr reqs aborted -ERESTARTSYS
+		oom=N	Number of retr reqs failed -ENOMEM
+		ops=N	Number of retr reqs submitted
+		owt=N	Number of retr reqs waited for CPU time
+	Stores	n=N	Number of storage (write) requests seen
+		ok=N	Number of successful store reqs
+		agn=N	Number of store reqs on a page already pending storage
+		nbf=N	Number of store reqs rejected -ENOBUFS
+		oom=N	Number of store reqs failed -ENOMEM
+		ops=N	Number of store reqs submitted
+		run=N	Number of store reqs granted CPU time
+	Ops	pend=N	Number of times async ops added to pending queues
+		run=N	Number of times async ops given CPU time
+		enq=N	Number of times async ops queued for processing
+		dfr=N	Number of async ops queued for deferred release
+		rel=N	Number of async ops released
+		gc=N	Number of deferred-release async ops garbage collected
+
+
+ (*) /proc/fs/fscache/histogram
+
+	cat /proc/fs/fscache/histogram
+	+HZ   +TIME OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS
+	===== ===== ========= ========= ========= ========= =========
+
+     This shows the breakdown of the number of times each amount of time
+     between 0 jiffies and HZ-1 jiffies a variety of tasks took to run.  The
+     columns are as follows:
+
+	COLUMN		TIME MEASUREMENT
+	=======		=======================================================
+	OBJ INST	Length of time to instantiate an object
+	OP RUNS		Length of time a call to process an operation took
+	OBJ RUNS	Length of time a call to process an object event took
+	RETRV DLY	Time between an requesting a read and lookup completing
+	RETRIEVLS	Time between beginning and end of a retrieval
+
+     Each row shows the number of events that took a particular range of times.
+     Each step is 1 jiffy in size.  The +HZ column indicates the particular
+     jiffy range covered, and the +TIME field the equivalent number of seconds.
+
+
+=========
+DEBUGGING
+=========
+
+The FS-Cache facility can have runtime debugging enabled by adjusting the value
+in:
+
+	/sys/module/fscache/parameters/debug
+
+This is a bitmask of debugging streams to enable:
+
+	BIT	VALUE	STREAM				POINT
+	=======	=======	===============================	=======================
+	0	1	Cache management		Function entry trace
+	1	2					Function exit trace
+	2	4					General
+	3	8	Cookie management		Function entry trace
+	4	16					Function exit trace
+	5	32					General
+	6	64	Page handling			Function entry trace
+	7	128					Function exit trace
+	8	256					General
+	9	512	Operation management		Function entry trace
+	10	1024					Function exit trace
+	11	2048					General
+
+The appropriate set of values should be OR'd together and the result written to
+the control file.  For example:
+
+	echo $((1|8|64)) >/sys/module/fscache/parameters/debug
+
+will turn on all function entry debugging.
+
diff --git a/Documentation/filesystems/caching/netfs-api.txt b/Documentation/filesystems/caching/netfs-api.txt
new file mode 100644
index 0000000..4db125b
--- /dev/null
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -0,0 +1,778 @@
+			===============================
+			FS-CACHE NETWORK FILESYSTEM API
+			===============================
+
+There's an API by which a network filesystem can make use of the FS-Cache
+facilities.  This is based around a number of principles:
+
+ (1) Caches can store a number of different object types.  There are two main
+     object types: indices and files.  The first is a special type used by
+     FS-Cache to make finding objects faster and to make retiring of groups of
+     objects easier.
+
+ (2) Every index, file or other object is represented by a cookie.  This cookie
+     may or may not have anything associated with it, but the netfs doesn't
+     need to care.
+
+ (3) Barring the top-level index (one entry per cached netfs), the index
+     hierarchy for each netfs is structured according the whim of the netfs.
+
+This API is declared in <linux/fscache.h>.
+
+This document contains the following sections:
+
+	 (1) Network filesystem definition
+	 (2) Index definition
+	 (3) Object definition
+	 (4) Network filesystem (un)registration
+	 (5) Cache tag lookup
+	 (6) Index registration
+	 (7) Data file registration
+	 (8) Miscellaneous object registration
+	 (9) Setting the data file size
+	(10) Page alloc/read/write
+	(11) Page uncaching
+	(12) Index and data file update
+	(13) Miscellaneous cookie operations
+	(14) Cookie unregistration
+	(15) Index and data file invalidation
+	(16) FS-Cache specific page flags.
+
+
+=============================
+NETWORK FILESYSTEM DEFINITION
+=============================
+
+FS-Cache needs a description of the network filesystem.  This is specified
+using a record of the following structure:
+
+	struct fscache_netfs {
+		uint32_t			version;
+		const char			*name;
+		struct fscache_cookie		*primary_index;
+		...
+	};
+
+This first two fields should be filled in before registration, and the third
+will be filled in by the registration function; any other fields should just be
+ignored and are for internal use only.
+
+The fields are:
+
+ (1) The name of the netfs (used as the key in the toplevel index).
+
+ (2) The version of the netfs (if the name matches but the version doesn't, the
+     entire in-cache hierarchy for this netfs will be scrapped and begun
+     afresh).
+
+ (3) The cookie representing the primary index will be allocated according to
+     another parameter passed into the registration function.
+
+For example, kAFS (linux/fs/afs/) uses the following definitions to describe
+itself:
+
+	struct fscache_netfs afs_cache_netfs = {
+		.version	= 0,
+		.name		= "afs",
+	};
+
+
+================
+INDEX DEFINITION
+================
+
+Indices are used for two purposes:
+
+ (1) To aid the finding of a file based on a series of keys (such as AFS's
+     "cell", "volume ID", "vnode ID").
+
+ (2) To make it easier to discard a subset of all the files cached based around
+     a particular key - for instance to mirror the removal of an AFS volume.
+
+However, since it's unlikely that any two netfs's are going to want to define
+their index hierarchies in quite the same way, FS-Cache tries to impose as few
+restraints as possible on how an index is structured and where it is placed in
+the tree.  The netfs can even mix indices and data files at the same level, but
+it's not recommended.
+
+Each index entry consists of a key of indeterminate length plus some auxilliary
+data, also of indeterminate length.
+
+There are some limits on indices:
+
+ (1) Any index containing non-index objects should be restricted to a single
+     cache.  Any such objects created within an index will be created in the
+     first cache only.  The cache in which an index is created can be
+     controlled by cache tags (see below).
+
+ (2) The entry data must be atomically journallable, so it is limited to about
+     400 bytes at present.  At least 400 bytes will be available.
+
+ (3) The depth of the index tree should be judged with care as the search
+     function is recursive.  Too many layers will run the kernel out of stack.
+
+
+=================
+OBJECT DEFINITION
+=================
+
+To define an object, a structure of the following type should be filled out:
+
+	struct fscache_cookie_def
+	{
+		uint8_t name[16];
+		uint8_t type;
+
+		struct fscache_cache_tag *(*select_cache)(
+			const void *parent_netfs_data,
+			const void *cookie_netfs_data);
+
+		uint16_t (*get_key)(const void *cookie_netfs_data,
+				    void *buffer,
+				    uint16_t bufmax);
+
+		void (*get_attr)(const void *cookie_netfs_data,
+				 uint64_t *size);
+
+		uint16_t (*get_aux)(const void *cookie_netfs_data,
+				    void *buffer,
+				    uint16_t bufmax);
+
+		enum fscache_checkaux (*check_aux)(void *cookie_netfs_data,
+						   const void *data,
+						   uint16_t datalen);
+
+		void (*get_context)(void *cookie_netfs_data, void *context);
+
+		void (*put_context)(void *cookie_netfs_data, void *context);
+
+		void (*mark_pages_cached)(void *cookie_netfs_data,
+					  struct address_space *mapping,
+					  struct pagevec *cached_pvec);
+
+		void (*now_uncached)(void *cookie_netfs_data);
+	};
+
+This has the following fields:
+
+ (1) The type of the object [mandatory].
+
+     This is one of the following values:
+
+	(*) FSCACHE_COOKIE_TYPE_INDEX
+
+	    This defines an index, which is a special FS-Cache type.
+
+	(*) FSCACHE_COOKIE_TYPE_DATAFILE
+
+	    This defines an ordinary data file.
+
+	(*) Any other value between 2 and 255
+
+	    This defines an extraordinary object such as an XATTR.
+
+ (2) The name of the object type (NUL terminated unless all 16 chars are used)
+     [optional].
+
+ (3) A function to select the cache in which to store an index [optional].
+
+     This function is invoked when an index needs to be instantiated in a cache
+     during the instantiation of a non-index object.  Only the immediate index
+     parent for the non-index object will be queried.  Any indices above that
+     in the hierarchy may be stored in multiple caches.  This function does not
+     need to be supplied for any non-index object or any index that will only
+     have index children.
+
+     If this function is not supplied or if it returns NULL then the first
+     cache in the parent's list will be chosed, or failing that, the first
+     cache in the master list.
+
+ (4) A function to retrieve an object's key from the netfs [mandatory].
+
+     This function will be called with the netfs data that was passed to the
+     cookie acquisition function and the maximum length of key data that it may
+     provide.  It should write the required key data into the given buffer and
+     return the quantity it wrote.
+
+ (5) A function to retrieve attribute data from the netfs [optional].
+
+     This function will be called with the netfs data that was passed to the
+     cookie acquisition function.  It should return the size of the file if
+     this is a data file.  The size may be used to govern how much cache must
+     be reserved for this file in the cache.
+
+     If the function is absent, a file size of 0 is assumed.
+
+ (6) A function to retrieve auxilliary data from the netfs [optional].
+
+     This function will be called with the netfs data that was passed to the
+     cookie acquisition function and the maximum length of auxilliary data that
+     it may provide.  It should write the auxilliary data into the given buffer
+     and return the quantity it wrote.
+
+     If this function is absent, the auxilliary data length will be set to 0.
+
+     The length of the auxilliary data buffer may be dependent on the key
+     length.  A netfs mustn't rely on being able to provide more than 400 bytes
+     for both.
+
+ (7) A function to check the auxilliary data [optional].
+
+     This function will be called to check that a match found in the cache for
+     this object is valid.  For instance with AFS it could check the auxilliary
+     data against the data version number returned by the server to determine
+     whether the index entry in a cache is still valid.
+
+     If this function is absent, it will be assumed that matching objects in a
+     cache are always valid.
+
+     If present, the function should return one of the following values:
+
+	(*) FSCACHE_CHECKAUX_OKAY		- the entry is okay as is
+	(*) FSCACHE_CHECKAUX_NEEDS_UPDATE	- the entry requires update
+	(*) FSCACHE_CHECKAUX_OBSOLETE		- the entry should be deleted
+
+     This function can also be used to extract data from the auxilliary data in
+     the cache and copy it into the netfs's structures.
+
+ (8) A pair of functions to manage contexts for the completion callback
+     [optional].
+
+     The cache read/write functions are passed a context which is then passed
+     to the I/O completion callback function.  To ensure this context remains
+     valid until after the I/O completion is called, two functions may be
+     provided: one to get an extra reference on the context, and one to drop a
+     reference to it.
+
+     If the context is not used or is a type of object that won't go out of
+     scope, then these functions are not required.  These functions are not
+     required for indices as indices may not contain data.  These functions may
+     be called in interrupt context and so may not sleep.
+
+ (9) A function to mark a page as retaining cache metadata [optional].
+
+     This is called by the cache to indicate that it is retaining in-memory
+     information for this page and that the netfs should uncache the page when
+     it has finished.  This does not indicate whether there's data on the disk
+     or not.  Note that several pages at once may be presented for marking.
+
+     The PG_fscache bit is set on the pages before this function would be
+     called, so the function need not be provided if this is sufficient.
+
+     This function is not required for indices as they're not permitted data.
+
+(10) A function to unmark all the pages retaining cache metadata [mandatory].
+
+     This is called by FS-Cache to indicate that a backing store is being
+     unbound from a cookie and that all the marks on the pages should be
+     cleared to prevent confusion.  Note that the cache will have torn down all
+     its tracking information so that the pages don't need to be explicitly
+     uncached.
+
+     This function is not required for indices as they're not permitted data.
+
+
+===================================
+NETWORK FILESYSTEM (UN)REGISTRATION
+===================================
+
+The first step is to declare the network filesystem to the cache.  This also
+involves specifying the layout of the primary index (for AFS, this would be the
+"cell" level).
+
+The registration function is:
+
+	int fscache_register_netfs(struct fscache_netfs *netfs);
+
+It just takes a pointer to the netfs definition.  It returns 0 or an error as
+appropriate.
+
+For kAFS, registration is done as follows:
+
+	ret = fscache_register_netfs(&afs_cache_netfs);
+
+The last step is, of course, unregistration:
+
+	void fscache_unregister_netfs(struct fscache_netfs *netfs);
+
+
+================
+CACHE TAG LOOKUP
+================
+
+FS-Cache permits the use of more than one cache.  To permit particular index
+subtrees to be bound to particular caches, the second step is to look up cache
+representation tags.  This step is optional; it can be left entirely up to
+FS-Cache as to which cache should be used.  The problem with doing that is that
+FS-Cache will always pick the first cache that was registered.
+
+To get the representation for a named tag:
+
+	struct fscache_cache_tag *fscache_lookup_cache_tag(const char *name);
+
+This takes a text string as the name and returns a representation of a tag.  It
+will never return an error.  It may return a dummy tag, however, if it runs out
+of memory; this will inhibit caching with this tag.
+
+Any representation so obtained must be released by passing it to this function:
+
+	void fscache_release_cache_tag(struct fscache_cache_tag *tag);
+
+The tag will be retrieved by FS-Cache when it calls the object definition
+operation select_cache().
+
+
+==================
+INDEX REGISTRATION
+==================
+
+The third step is to inform FS-Cache about part of an index hierarchy that can
+be used to locate files.  This is done by requesting a cookie for each index in
+the path to the file:
+
+	struct fscache_cookie *
+	fscache_acquire_cookie(struct fscache_cookie *parent,
+			       const struct fscache_object_def *def,
+			       void *netfs_data);
+
+This function creates an index entry in the index represented by parent,
+filling in the index entry by calling the operations pointed to by def.
+
+Note that this function never returns an error - all errors are handled
+internally.  It may, however, return NULL to indicate no cookie.  It is quite
+acceptable to pass this token back to this function as the parent to another
+acquisition (or even to the relinquish cookie, read page and write page
+functions - see below).
+
+Note also that no indices are actually created in a cache until a non-index
+object needs to be created somewhere down the hierarchy.  Furthermore, an index
+may be created in several different caches independently at different times.
+This is all handled transparently, and the netfs doesn't see any of it.
+
+For example, with AFS, a cell would be added to the primary index.  This index
+entry would have a dependent inode containing a volume location index for the
+volume mappings within this cell:
+
+	cell->cache =
+		fscache_acquire_cookie(afs_cache_netfs.primary_index,
+				       &afs_cell_cache_index_def,
+				       cell);
+
+Then when a volume location was accessed, it would be entered into the cell's
+index and an inode would be allocated that acts as a volume type and hash chain
+combination:
+
+	vlocation->cache =
+		fscache_acquire_cookie(cell->cache,
+				       &afs_vlocation_cache_index_def,
+				       vlocation);
+
+And then a particular flavour of volume (R/O for example) could be added to
+that index, creating another index for vnodes (AFS inode equivalents):
+
+	volume->cache =
+		fscache_acquire_cookie(vlocation->cache,
+				       &afs_volume_cache_index_def,
+				       volume);
+
+
+======================
+DATA FILE REGISTRATION
+======================
+
+The fourth step is to request a data file be created in the cache.  This is
+identical to index cookie acquisition.  The only difference is that the type in
+the object definition should be something other than index type.
+
+	vnode->cache =
+		fscache_acquire_cookie(volume->cache,
+				       &afs_vnode_cache_object_def,
+				       vnode);
+
+
+=================================
+MISCELLANEOUS OBJECT REGISTRATION
+=================================
+
+An optional step is to request an object of miscellaneous type be created in
+the cache.  This is almost identical to index cookie acquisition.  The only
+difference is that the type in the object definition should be something other
+than index type.  Whilst the parent object could be an index, it's more likely
+it would be some other type of object such as a data file.
+
+	xattr->cache =
+		fscache_acquire_cookie(vnode->cache,
+				       &afs_xattr_cache_object_def,
+				       xattr);
+
+Miscellaneous objects might be used to store extended attributes or directory
+entries for example.
+
+
+==========================
+SETTING THE DATA FILE SIZE
+==========================
+
+The fifth step is to set the physical attributes of the file, such as its size.
+This doesn't automatically reserve any space in the cache, but permits the
+cache to adjust its metadata for data tracking appropriately:
+
+	int fscache_attr_changed(struct fscache_cookie *cookie);
+
+The cache will return -ENOBUFS if there is no backing cache or if there is no
+space to allocate any extra metadata required in the cache.  The attributes
+will be accessed with the get_attr() cookie definition operation.
+
+Note that attempts to read or write data pages in the cache over this size may
+be rebuffed with -ENOBUFS.
+
+This operation schedules an attribute adjustment to happen asynchronously at
+some point in the future, and as such, it may happen after the function returns
+to the caller.  The attribute adjustment excludes read and write operations.
+
+
+=====================
+PAGE READ/ALLOC/WRITE
+=====================
+
+And the sixth step is to store and retrieve pages in the cache.  There are
+three functions that are used to do this.
+
+Note:
+
+ (1) A page should not be re-read or re-allocated without uncaching it first.
+
+ (2) A read or allocated page must be uncached when the netfs page is released
+     from the pagecache.
+
+ (3) A page should only be written to the cache if previous read or allocated.
+
+This permits the cache to maintain its page tracking in proper order.
+
+
+PAGE READ
+---------
+
+Firstly, the netfs should ask FS-Cache to examine the caches and read the
+contents cached for a particular page of a particular file if present, or else
+allocate space to store the contents if not:
+
+	typedef
+	void (*fscache_rw_complete_t)(struct page *page,
+				      void *context,
+				      int error);
+
+	int fscache_read_or_alloc_page(struct fscache_cookie *cookie,
+				       struct page *page,
+				       fscache_rw_complete_t end_io_func,
+				       void *context,
+				       gfp_t gfp);
+
+The cookie argument must specify a cookie for an object that isn't an index,
+the page specified will have the data loaded into it (and is also used to
+specify the page number), and the gfp argument is used to control how any
+memory allocations made are satisfied.
+
+If the cookie indicates the inode is not cached:
+
+ (1) The function will return -ENOBUFS.
+
+Else if there's a copy of the page resident in the cache:
+
+ (1) The mark_pages_cached() cookie operation will be called on that page.
+
+ (2) The function will submit a request to read the data from the cache's
+     backing device directly into the page specified.
+
+ (3) The function will return 0.
+
+ (4) When the read is complete, end_io_func() will be invoked with:
+
+     (*) The netfs data supplied when the cookie was created.
+
+     (*) The page descriptor.
+
+     (*) The context argument passed to the above function.  This will be
+         maintained with the get_context/put_context functions mentioned above.
+
+     (*) An argument that's 0 on success or negative for an error code.
+
+     If an error occurs, it should be assumed that the page contains no usable
+     data.
+
+     end_io_func() will be called in process context if the read is results in
+     an error, but it might be called in interrupt context if the read is
+     successful.
+
+Otherwise, if there's not a copy available in cache, but the cache may be able
+to store the page:
+
+ (1) The mark_pages_cached() cookie operation will be called on that page.
+
+ (2) A block may be reserved in the cache and attached to the object at the
+     appropriate place.
+
+ (3) The function will return -ENODATA.
+
+This function may also return -ENOMEM or -EINTR, in which case it won't have
+read any data from the cache.
+
+
+PAGE ALLOCATE
+-------------
+
+Alternatively, if there's not expected to be any data in the cache for a page
+because the file has been extended, a block can simply be allocated instead:
+
+	int fscache_alloc_page(struct fscache_cookie *cookie,
+			       struct page *page,
+			       gfp_t gfp);
+
+This is similar to the fscache_read_or_alloc_page() function, except that it
+never reads from the cache.  It will return 0 if a block has been allocated,
+rather than -ENODATA as the other would.  One or the other must be performed
+before writing to the cache.
+
+The mark_pages_cached() cookie operation will be called on the page if
+successful.
+
+
+PAGE WRITE
+----------
+
+Secondly, if the netfs changes the contents of the page (either due to an
+initial download or if a user performs a write), then the page should be
+written back to the cache:
+
+	int fscache_write_page(struct fscache_cookie *cookie,
+			       struct page *page,
+			       gfp_t gfp);
+
+The cookie argument must specify a data file cookie, the page specified should
+contain the data to be written (and is also used to specify the page number),
+and the gfp argument is used to control how any memory allocations made are
+satisfied.
+
+The page must have first been read or allocated successfully and must not have
+been uncached before writing is performed.
+
+If the cookie indicates the inode is not cached then:
+
+ (1) The function will return -ENOBUFS.
+
+Else if space can be allocated in the cache to hold this page:
+
+ (1) PG_fscache_write will be set on the page.
+
+ (2) The function will submit a request to write the data to cache's backing
+     device directly from the page specified.
+
+ (3) The function will return 0.
+
+ (4) When the write is complete PG_fscache_write is cleared on the page and
+     anyone waiting for that bit will be woken up.
+
+Else if there's no space available in the cache, -ENOBUFS will be returned.  It
+is also possible for the PG_fscache_write bit to be cleared when no write took
+place if unforeseen circumstances arose (such as a disk error).
+
+Writing takes place asynchronously.
+
+
+MULTIPLE PAGE READ
+------------------
+
+A facility is provided to read several pages at once, as requested by the
+readpages() address space operation:
+
+	int fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
+					struct address_space *mapping,
+					struct list_head *pages,
+					int *nr_pages,
+					fscache_rw_complete_t end_io_func,
+					void *context,
+					gfp_t gfp);
+
+This works in a similar way to fscache_read_or_alloc_page(), except:
+
+ (1) Any page it can retrieve data for is removed from pages and nr_pages and
+     dispatched for reading to the disk.  Reads of adjacent pages on disk may
+     be merged for greater efficiency.
+
+ (2) The mark_pages_cached() cookie operation will be called on several pages
+     at once if they're being read or allocated.
+
+ (3) If there was an general error, then that error will be returned.
+
+     Else if some pages couldn't be allocated or read, then -ENOBUFS will be
+     returned.
+
+     Else if some pages couldn't be read but were allocated, then -ENODATA will
+     be returned.
+
+     Otherwise, if all pages had reads dispatched, then 0 will be returned, the
+     list will be empty and *nr_pages will be 0.
+
+ (4) end_io_func will be called once for each page being read as the reads
+     complete.  It will be called in process context if error != 0, but it may
+     be called in interrupt context if there is no error.
+
+Note that a return of -ENODATA, -ENOBUFS or any other error does not preclude
+some of the pages being read and some being allocated.  Those pages will have
+been marked appropriately and will need uncaching.
+
+
+==============
+PAGE UNCACHING
+==============
+
+To uncache a page, this function should be called:
+
+	void fscache_uncache_page(struct fscache_cookie *cookie,
+				  struct page *page);
+
+This function permits the cache to release any in-memory representation it
+might be holding for this netfs page.  This function must be called once for
+each page on which the read or write page functions above have been called to
+make sure the cache's in-memory tracking information gets torn down.
+
+Note that pages can't be explicitly deleted from the a data file.  The whole
+data file must be retired (see the relinquish cookie function below).
+
+Furthermore, note that this does not cancel the asynchronous read or write
+operation started by the read/alloc and write functions, so the page
+invalidation and release functions must use:
+
+	bool fscache_check_page_write(struct fscache_cookie *cookie,
+				      struct page *page);
+
+to see if a page is being written to the cache, and:
+
+	void fscache_wait_on_page_write(struct fscache_cookie *cookie,
+					struct page *page);
+
+to wait for it to finish if it is.
+
+
+==========================
+INDEX AND DATA FILE UPDATE
+==========================
+
+To request an update of the index data for an index or other object, the
+following function should be called:
+
+	void fscache_update_cookie(struct fscache_cookie *cookie);
+
+This function will refer back to the netfs_data pointer stored in the cookie by
+the acquisition function to obtain the data to write into each revised index
+entry.  The update method in the parent index definition will be called to
+transfer the data.
+
+Note that partial updates may happen automatically at other times, such as when
+data blocks are added to a data file object.
+
+
+===============================
+MISCELLANEOUS COOKIE OPERATIONS
+===============================
+
+There are a number of operations that can be used to control cookies:
+
+ (*) Cookie pinning:
+
+	int fscache_pin_cookie(struct fscache_cookie *cookie);
+	void fscache_unpin_cookie(struct fscache_cookie *cookie);
+
+     These operations permit data cookies to be pinned into the cache and to
+     have the pinning removed.  They are not permitted on index cookies.
+
+     The pinning function will return 0 if successful, -ENOBUFS in the cookie
+     isn't backed by a cache, -EOPNOTSUPP if the cache doesn't support pinning,
+     -ENOSPC if there isn't enough space to honour the operation, -ENOMEM or
+     -EIO if there's any other problem.
+
+ (*) Data space reservation:
+
+	int fscache_reserve_space(struct fscache_cookie *cookie, loff_t size);
+
+     This permits a netfs to request cache space be reserved to store up to the
+     given amount of a file.  It is permitted to ask for more than the current
+     size of the file to allow for future file expansion.
+
+     If size is given as zero then the reservation will be cancelled.
+
+     The function will return 0 if successful, -ENOBUFS in the cookie isn't
+     backed by a cache, -EOPNOTSUPP if the cache doesn't support reservations,
+     -ENOSPC if there isn't enough space to honour the operation, -ENOMEM or
+     -EIO if there's any other problem.
+
+     Note that this doesn't pin an object in a cache; it can still be culled to
+     make space if it's not in use.
+
+
+=====================
+COOKIE UNREGISTRATION
+=====================
+
+To get rid of a cookie, this function should be called.
+
+	void fscache_relinquish_cookie(struct fscache_cookie *cookie,
+				       int retire);
+
+If retire is non-zero, then the object will be marked for recycling, and all
+copies of it will be removed from all active caches in which it is present.
+Not only that but all child objects will also be retired.
+
+If retire is zero, then the object may be available again when next the
+acquisition function is called.  Retirement here will overrule the pinning on a
+cookie.
+
+One very important note - relinquish must NOT be called for a cookie unless all
+the cookies for "child" indices, objects and pages have been relinquished
+first.
+
+
+================================
+INDEX AND DATA FILE INVALIDATION
+================================
+
+There is no direct way to invalidate an index subtree or a data file.  To do
+this, the caller should relinquish and retire the cookie they have, and then
+acquire a new one.
+
+
+===========================
+FS-CACHE SPECIFIC PAGE FLAG
+===========================
+
+FS-Cache makes use of a page flag, PG_private_2, for its own purpose.  This is
+given the alternative name PG_fscache.
+
+PG_fscache is used to indicate that the page is known by the cache, and that
+the cache must be informed if the page is going to go away.  It's an indication
+to the netfs that the cache has an interest in this page, where an interest may
+be a pointer to it, resources allocated or reserved for it, or I/O in progress
+upon it.
+
+The netfs can use this information in methods such as releasepage() to
+determine whether it needs to uncache a page or update it.
+
+Furthermore, if this bit is set, releasepage() and invalidatepage() operations
+will be called on a page to get rid of it, even if PG_private is not set.  This
+allows caching to attempted on a page before read_cache_pages() to be called
+after fscache_read_or_alloc_pages() as the former will try and release pages it
+was given under certain circumstances.
+
+This bit does not overlap with such as PG_private.  This means that FS-Cache
+can be used with a filesystem that uses the block buffering code.
+
+There are a number of operations defined on this flag:
+
+	int PageFsCache(struct page *page);
+	void SetPageFsCache(struct page *page)
+	void ClearPageFsCache(struct page *page)
+	int TestSetPageFsCache(struct page *page)
+	int TestClearPageFsCache(struct page *page)
+
+These functions are bit test, bit set, bit clear, bit test and set and bit
+test and clear operations on PG_fscache.
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
new file mode 100644
index 0000000..feb3b0e
--- /dev/null
+++ b/include/linux/fscache.h
@@ -0,0 +1,548 @@
+/* General filesystem caching interface
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * NOTE!!! See:
+ *
+ *	Documentation/filesystems/caching/netfs-api.txt
+ *
+ * for a description of the network filesystem interface declared here.
+ */
+
+#ifndef _LINUX_FSCACHE_H
+#define _LINUX_FSCACHE_H
+
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/pagemap.h>
+#include <linux/pagevec.h>
+
+#if defined(CONFIG_FSCACHE) || defined(CONFIG_FSCACHE_MODULE)
+#define fscache_available() (1)
+#define fscache_cookie_valid(cookie) (cookie)
+#else
+#define fscache_available() (0)
+#define fscache_cookie_valid(cookie) (0)
+#endif
+
+
+/*
+ * overload PG_private_2 to give us PG_fscache - this is used to indicate that
+ * a page is currently backed by a local disk cache
+ */
+#define PageFsCache(page)		PagePrivate2((page))
+#define SetPageFsCache(page)		SetPagePrivate2((page))
+#define ClearPageFsCache(page)		ClearPagePrivate2((page))
+#define TestSetPageFsCache(page)	TestSetPagePrivate2((page))
+#define TestClearPageFsCache(page)	TestClearPagePrivate2((page))
+
+/* pattern used to fill dead space in an index entry */
+#define FSCACHE_INDEX_DEADFILL_PATTERN 0x79
+
+struct pagevec;
+struct fscache_cache_tag;
+struct fscache_cookie;
+struct fscache_netfs;
+
+typedef void (*fscache_rw_complete_t)(struct page *page,
+				      void *context,
+				      int error);
+
+/* result of index entry consultation */
+enum fscache_checkaux {
+	FSCACHE_CHECKAUX_OKAY,		/* entry okay as is */
+	FSCACHE_CHECKAUX_NEEDS_UPDATE,	/* entry requires update */
+	FSCACHE_CHECKAUX_OBSOLETE,	/* entry requires deletion */
+};
+
+/*
+ * fscache cookie definition
+ */
+struct fscache_cookie_def {
+	/* name of cookie type */
+	char name[16];
+
+	/* cookie type */
+	uint8_t type;
+#define FSCACHE_COOKIE_TYPE_INDEX	0
+#define FSCACHE_COOKIE_TYPE_DATAFILE	1
+
+	/* select the cache into which to insert an entry in this index
+	 * - optional
+	 * - should return a cache identifier or NULL to cause the cache to be
+	 *   inherited from the parent if possible or the first cache picked
+	 *   for a non-index file if not
+	 */
+	struct fscache_cache_tag *(*select_cache)(
+		const void *parent_netfs_data,
+		const void *cookie_netfs_data);
+
+	/* get an index key
+	 * - should store the key data in the buffer
+	 * - should return the amount of amount stored
+	 * - not permitted to return an error
+	 * - the netfs data from the cookie being used as the source is
+	 *   presented
+	 */
+	uint16_t (*get_key)(const void *cookie_netfs_data,
+			    void *buffer,
+			    uint16_t bufmax);
+
+	/* get certain file attributes from the netfs data
+	 * - this function can be absent for an index
+	 * - not permitted to return an error
+	 * - the netfs data from the cookie being used as the source is
+	 *   presented
+	 */
+	void (*get_attr)(const void *cookie_netfs_data, uint64_t *size);
+
+	/* get the auxilliary data from netfs data
+	 * - this function can be absent if the index carries no state data
+	 * - should store the auxilliary data in the buffer
+	 * - should return the amount of amount stored
+	 * - not permitted to return an error
+	 * - the netfs data from the cookie being used as the source is
+	 *   presented
+	 */
+	uint16_t (*get_aux)(const void *cookie_netfs_data,
+			    void *buffer,
+			    uint16_t bufmax);
+
+	/* consult the netfs about the state of an object
+	 * - this function can be absent if the index carries no state data
+	 * - the netfs data from the cookie being used as the target is
+	 *   presented, as is the auxilliary data
+	 */
+	enum fscache_checkaux (*check_aux)(void *cookie_netfs_data,
+					   const void *data,
+					   uint16_t datalen);
+
+	/* get an extra reference on a read context
+	 * - this function can be absent if the completion function doesn't
+	 *   require a context
+	 */
+	void (*get_context)(void *cookie_netfs_data, void *context);
+
+	/* release an extra reference on a read context
+	 * - this function can be absent if the completion function doesn't
+	 *   require a context
+	 */
+	void (*put_context)(void *cookie_netfs_data, void *context);
+
+	/* indicate pages that now have cache metadata retained
+	 * - this function should mark the specified pages as now being cached
+	 * - the pages will have been marked with PG_fscache before this is
+	 *   called, so this is optional
+	 */
+	void (*mark_pages_cached)(void *cookie_netfs_data,
+				  struct address_space *mapping,
+				  struct pagevec *cached_pvec);
+
+	/* indicate the cookie is no longer cached
+	 * - this function is called when the backing store currently caching
+	 *   a cookie is removed
+	 * - the netfs should use this to clean up any markers indicating
+	 *   cached pages
+	 * - this is mandatory for any object that may have data
+	 */
+	void (*now_uncached)(void *cookie_netfs_data);
+};
+
+/*
+ * fscache cached network filesystem type
+ * - name, version and ops must be filled in before registration
+ * - all other fields will be set during registration
+ */
+struct fscache_netfs {
+	uint32_t			version;	/* indexing version */
+	const char			*name;		/* filesystem name */
+	struct fscache_cookie		*primary_index;
+	struct list_head		link;		/* internal link */
+};
+
+/*
+ * slow-path functions for when there is actually caching available, and the
+ * netfs does actually have a valid token
+ * - these are not to be called directly
+ * - these are undefined symbols when FS-Cache is not configured and the
+ *   optimiser takes care of not using them
+ */
+
+/**
+ * fscache_register_netfs - Register a filesystem as desiring caching services
+ * @netfs: The description of the filesystem
+ *
+ * Register a filesystem as desiring caching services if they're available.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_register_netfs(struct fscache_netfs *netfs)
+{
+	return 0;
+}
+
+/**
+ * fscache_unregister_netfs - Indicate that a filesystem no longer desires
+ * caching services
+ * @netfs: The description of the filesystem
+ *
+ * Indicate that a filesystem no longer desires caching services for the
+ * moment.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_unregister_netfs(struct fscache_netfs *netfs)
+{
+}
+
+/**
+ * fscache_lookup_cache_tag - Look up a cache tag
+ * @name: The name of the tag to search for
+ *
+ * Acquire a specific cache referral tag that can be used to select a specific
+ * cache in which to cache an index.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+struct fscache_cache_tag *fscache_lookup_cache_tag(const char *name)
+{
+	return NULL;
+}
+
+/**
+ * fscache_release_cache_tag - Release a cache tag
+ * @tag: The tag to release
+ *
+ * Release a reference to a cache referral tag previously looked up.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_release_cache_tag(struct fscache_cache_tag *tag)
+{
+}
+
+/**
+ * fscache_acquire_cookie - Acquire a cookie to represent a cache object
+ * @parent: The cookie that's to be the parent of this one
+ * @def: A description of the cache object, including callback operations
+ * @netfs_data: An arbitrary piece of data to be kept in the cookie to
+ * represent the cache object to the netfs
+ *
+ * This function is used to inform FS-Cache about part of an index hierarchy
+ * that can be used to locate files.  This is done by requesting a cookie for
+ * each index in the path to the file.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+struct fscache_cookie *fscache_acquire_cookie(
+	struct fscache_cookie *parent,
+	const struct fscache_cookie_def *def,
+	void *netfs_data)
+{
+	return NULL;
+}
+
+/**
+ * fscache_relinquish_cookie - Return the cookie to the cache, maybe discarding
+ * it
+ * @cookie: The cookie being returned
+ * @retire: True if the cache object the cookie represents is to be discarded
+ *
+ * This function returns a cookie to the cache, forcibly discarding the
+ * associated cache object if retire is set to true.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
+{
+}
+
+/**
+ * fscache_update_cookie - Request that a cache object be updated
+ * @cookie: The cookie representing the cache object
+ *
+ * Request an update of the index data for the cache object associated with the
+ * cookie.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_update_cookie(struct fscache_cookie *cookie)
+{
+}
+
+/**
+ * fscache_pin_cookie - Pin a data-storage cache object in its cache
+ * @cookie: The cookie representing the cache object
+ *
+ * Permit data-storage cache objects to be pinned in the cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_pin_cookie(struct fscache_cookie *cookie)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_pin_cookie - Unpin a data-storage cache object in its cache
+ * @cookie: The cookie representing the cache object
+ *
+ * Permit data-storage cache objects to be unpinned from the cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_unpin_cookie(struct fscache_cookie *cookie)
+{
+}
+
+/**
+ * fscache_attr_changed - Notify cache that an object's attributes changed
+ * @cookie: The cookie representing the cache object
+ *
+ * Send a notification to the cache indicating that an object's attributes have
+ * changed.  This includes the data size.  These attributes will be obtained
+ * through the get_attr() cookie definition op.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_attr_changed(struct fscache_cookie *cookie)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_reserve_space - Reserve data space for a cached object
+ * @cookie: The cookie representing the cache object
+ * @i_size: The amount of space to be reserved
+ *
+ * Reserve an amount of space in the cache for the cache object attached to a
+ * cookie so that a write to that object within the space can always be
+ * honoured.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_reserve_space(struct fscache_cookie *cookie, loff_t size)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_read_or_alloc_page - Read a page from the cache or allocate a block
+ * in which to store it
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page to fill if possible
+ * @end_io_func: The callback to invoke when and if the page is filled
+ * @context: An arbitrary piece of data to pass on to end_io_func()
+ * @gfp: The conditions under which memory allocation should be made
+ *
+ * Read a page from the cache, or if that's not possible make a potential
+ * one-block reservation in the cache into which the page may be stored once
+ * fetched from the server.
+ *
+ * If the page is not backed by the cache object, or if it there's some reason
+ * it can't be, -ENOBUFS will be returned and nothing more will be done for
+ * that page.
+ *
+ * Else, if that page is backed by the cache, a read will be initiated directly
+ * to the netfs's page and 0 will be returned by this function.  The
+ * end_io_func() callback will be invoked when the operation terminates on a
+ * completion or failure.  Note that the callback may be invoked before the
+ * return.
+ *
+ * Else, if the page is unbacked, -ENODATA is returned and a block may have
+ * been allocated in the cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_read_or_alloc_page(struct fscache_cookie *cookie,
+			       struct page *page,
+			       fscache_rw_complete_t end_io_func,
+			       void *context,
+			       gfp_t gfp)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_read_or_alloc_pages - Read pages from the cache and/or allocate
+ * blocks in which to store them
+ * @cookie: The cookie representing the cache object
+ * @mapping: The netfs inode mapping to which the pages will be attached
+ * @pages: A list of potential netfs pages to be filled
+ * @end_io_func: The callback to invoke when and if each page is filled
+ * @context: An arbitrary piece of data to pass on to end_io_func()
+ * @gfp: The conditions under which memory allocation should be made
+ *
+ * Read a set of pages from the cache, or if that's not possible, attempt to
+ * make a potential one-block reservation for each page in the cache into which
+ * that page may be stored once fetched from the server.
+ *
+ * If some pages are not backed by the cache object, or if it there's some
+ * reason they can't be, -ENOBUFS will be returned and nothing more will be
+ * done for that pages.
+ *
+ * Else, if some of the pages are backed by the cache, a read will be initiated
+ * directly to the netfs's page and 0 will be returned by this function.  The
+ * end_io_func() callback will be invoked when the operation terminates on a
+ * completion or failure.  Note that the callback may be invoked before the
+ * return.
+ *
+ * Else, if a page is unbacked, -ENODATA is returned and a block may have
+ * been allocated in the cache.
+ *
+ * Because the function may want to return all of -ENOBUFS, -ENODATA and 0 in
+ * regard to different pages, the return values are prioritised in that order.
+ * Any pages submitted for reading are removed from the pages list.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
+				struct address_space *mapping,
+				struct list_head *pages,
+				unsigned *nr_pages,
+				fscache_rw_complete_t end_io_func,
+				void *context,
+				gfp_t gfp)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_alloc_page - Allocate a block in which to store a page
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page to allocate a page for
+ * @gfp: The conditions under which memory allocation should be made
+ *
+ * Request Allocation a block in the cache in which to store a netfs page
+ * without retrieving any contents from the cache.
+ *
+ * If the page is not backed by a file then -ENOBUFS will be returned and
+ * nothing more will be done, and no reservation will be made.
+ *
+ * Else, a block will be allocated if one wasn't already, and 0 will be
+ * returned
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_alloc_page(struct fscache_cookie *cookie,
+		       struct page *page,
+		       gfp_t gfp)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_write_page - Request storage of a page in the cache
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page to store
+ * @gfp: The conditions under which memory allocation should be made
+ *
+ * Request the contents of the netfs page be written into the cache.  This
+ * request may be ignored if no cache block is currently allocated, in which
+ * case it will return -ENOBUFS.
+ *
+ * If a cache block was already allocated, a write will be initiated and 0 will
+ * be returned.  The PG_fscache_write page bit is set immediately and will then
+ * be cleared at the completion of the write to indicate the success or failure
+ * of the operation.  Note that the completion may happen before the return.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+int fscache_write_page(struct fscache_cookie *cookie,
+		       struct page *page,
+		       gfp_t gfp)
+{
+	return -ENOBUFS;
+}
+
+/**
+ * fscache_uncache_page - Indicate that caching is no longer required on a page
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page that was being cached.
+ *
+ * Tell the cache that we no longer want a page to be cached and that it should
+ * remove any knowledge of the netfs page it may have.
+ *
+ * Note that this cannot cancel any outstanding I/O operations between this
+ * page and the cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_uncache_page(struct fscache_cookie *cookie,
+			  struct page *page)
+{
+}
+
+/**
+ * fscache_check_page_write - Ask if a page is being writing to the cache
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page that is being cached.
+ *
+ * Ask the cache if a page is being written to the cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+bool fscache_check_page_write(struct fscache_cookie *cookie,
+			      struct page *page)
+{
+	return false;
+}
+
+/**
+ * fscache_wait_on_page_write - Wait for a page to complete writing to the cache
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page that is being cached.
+ *
+ * Ask the cache to wake us up when a page is no longer being written to the
+ * cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_wait_on_page_write(struct fscache_cookie *cookie,
+				struct page *page)
+{
+}
+
+#endif /* _LINUX_FSCACHE_H */

