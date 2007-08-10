Return-Path: <linux-kernel-owner+w=401wt.eu-S940838AbXHJQKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940838AbXHJQKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940217AbXHJQGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:06:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940239AbXHJQF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/16] FS-Cache: Generic filesystem caching facility [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:05:17 +0100
Message-ID: <20070810160517.24698.54620.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch adds a generic intermediary (FS-Cache) by which filesystems
may call on local caching capabilities, and by which local caching backends may
make caches available:

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

The patch also documents the netfs interface and the cache backend
interface provided by the facility.


There are a number of reasons why I'm not using i_mapping to do this.
These have been discussed a lot on the LKML and CacheFS mailing lists,
but to summarise the basics:

 (1) Most filesystems don't do hole reportage.  Holes in files are treated as
     blocks of zeros and can't be distinguished otherwise, making it difficult
     to distinguish blocks that have been read from the network and cached from
     those that haven't.

 (2) The backing inode must be fully populated before being exposed to
     userspace through the main inode because the VM/VFS goes directly to the
     backing inode and does not interrogate the front inode on VM ops.

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


The attached patch adds a generic core to which both networking filesystems and
caches may bind.  It transfers requests from networking filesystems to
appropriate caches if possible, or else gracefully denies them.

If this facility is disabled in the kernel configuration, then all its
operations will be trivially reducible to nothing by the compiler.

FS-Cache provides the following facilities:

 (1) Caches can be added / removed at any time, even whilst in use.

 (2) Adds a facility by which tags can be used to refer to caches, even if
     they're not mounted yet.

 (3) More than one cache can be used at once.  Caches can be selected
     explicitly by use of tags.

 (4) The netfs is provided with an interface that allows either party to
     withdraw caching facilities from a file (required for (1)).

 (5) A netfs may annotate cache objects that belongs to it.

 (6) Cache objects can be pinned and reservations made.

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


FS-Cache maintains a virtual indexing tree in which all indices, files, objects
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

In the example above, you can see two netfs's being backed: NFS and AFS.  These
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

The cache backend API to FS-Cache can be found in:

	Documentation/filesystems/caching/backend-api.txt

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/backend-api.txt |  625 +++++++++++++++
 Documentation/filesystems/caching/fscache.txt     |  295 +++++++
 Documentation/filesystems/caching/netfs-api.txt   |  741 ++++++++++++++++++
 fs/Kconfig                                        |    6 
 fs/Makefile                                       |    1 
 fs/fscache/Kconfig                                |   49 +
 fs/fscache/Makefile                               |   19 
 fs/fscache/fsc-cache.c                            |  512 ++++++++++++
 fs/fscache/fsc-cookie.c                           |  494 ++++++++++++
 fs/fscache/fsc-fsdef.c                            |  111 +++
 fs/fscache/fsc-internal.h                         |  376 +++++++++
 fs/fscache/fsc-main.c                             |  127 +++
 fs/fscache/fsc-manage.c                           |  260 ++++++
 fs/fscache/fsc-object.c                           |  586 ++++++++++++++
 fs/fscache/fsc-page.c                             |  863 +++++++++++++++++++++
 fs/fscache/fsc-proc.c                             |  399 ++++++++++
 fs/fscache/fsc-stats.c                            |  103 +++
 fs/fscache/fsc-threads.c                          |  590 ++++++++++++++
 include/linux/fscache-cache.h                     |  433 +++++++++++
 include/linux/fscache.h                           |  593 ++++++++++++++
 20 files changed, 7183 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/caching/backend-api.txt b/Documentation/filesystems/caching/backend-api.txt
new file mode 100644
index 0000000..a7e58eb
--- /dev/null
+++ b/Documentation/filesystems/caching/backend-api.txt
@@ -0,0 +1,625 @@
+			  ==========================
+			  FS-CACHE CACHE BACKEND API
+			  ==========================
+
+The FS-Cache system provides an API by which actual caches can be supplied to
+FS-Cache for it to then serve out to network filesystems and other interested
+parties.
+
+This API is declared in <linux/fscache-cache.h>.
+
+
+====================================
+INITIALISING AND REGISTERING A CACHE
+====================================
+
+To start off, a cache definition must be initialised and registered for each
+cache the backend wants to make available.  For instance, CacheFS does this in
+the fill_super() operation on mounting.
+
+The cache definition (struct fscache_cache) should be initialised by calling:
+
+	void fscache_init_cache(struct fscache_cache *cache,
+				struct fscache_cache_ops *ops,
+				const char *idfmt,
+				...);
+
+Where:
+
+ (*) "cache" is a pointer to the cache definition;
+
+ (*) "ops" is a pointer to the table of operations that the backend supports on
+     this cache; and
+
+ (*) "idfmt" is a format and printf-style arguments for constructing a label
+     for the cache.
+
+
+The cache should then be registered with FS-Cache by passing a pointer to the
+previously initialised cache definition to:
+
+	int fscache_add_cache(struct fscache_cache *cache,
+			      struct fscache_object *fsdef,
+			      const char *tagname);
+
+Two extra arguments should also be supplied:
+
+ (*) "fsdef" which should point to the object representation for the FS-Cache
+     master index in this cache.  Netfs primary index entries will be created
+     here.
+
+ (*) "tagname" which, if given, should be a text string naming this cache.  If
+     this is NULL, the identifier will be used instead.  For CacheFS, the
+     identifier is set to name the underlying block device and the tag can be
+     supplied by mount.
+
+This function may return -ENOMEM if it ran out of memory or -EEXIST if the tag
+is already in use.  0 will be returned on success.
+
+
+=====================
+UNREGISTERING A CACHE
+=====================
+
+A cache can be withdrawn from the system by calling this function with a
+pointer to the cache definition:
+
+	void fscache_withdraw_cache(struct fscache_cache *cache);
+
+In CacheFS's case, this is called by put_super().
+
+
+========
+SECURITY
+========
+
+The cache methods are executed one of two contexts:
+
+ (1) that of the userspace process that issued the netfs operation that caused
+     the cache method to be invoked, or
+
+ (2) that of one of the processes in the FS-Cache thread pool.
+
+In either case, this may not be an appropriate context in which to access the
+cache.
+
+The calling process's fsuid, fsgid and SELinux security identities may need to
+be masqueraded for the duration of the cache driver's access to the cache.
+This is left to the cache to handle; FS-Cache makes no effort in this regard.
+
+
+===================================
+CONTROL AND STATISTICS PRESENTATION
+===================================
+
+The cache may present data to the outside world through FS-Cache's interfaces
+in sysfs and procfs - the former for control and the latter for statistics.
+
+A sysfs directory called /sys/fs/fscache/<cachetag>/ is created if CONFIG_SYSFS
+is enabled.  This is accessible through the kobject struct fscache_cache::kobj
+and is for use by the cache as it sees fit.
+
+The cache driver may create itself a directory named for the cache type in the
+/proc/fs/fscache/ directory.  This is available if CONFIG_FSCACHE_PROC is
+enabled and is accessible through:
+
+	struct proc_dir_entry *proc_fscache;
+
+
+========================
+RELEVANT DATA STRUCTURES
+========================
+
+ (*) Index/Data file FS-Cache representation cookie:
+
+	struct fscache_cookie {
+		struct fscache_object_def	*def;
+		struct fscache_netfs		*netfs;
+		void				*netfs_data;
+		...
+	};
+
+     The fields that might be of use to the backend describe the object
+     definition, the netfs definition and the netfs's data for this cookie.
+     The object definition contain functions supplied by the netfs for loading
+     and matching index entries; these are required to provide some of the
+     cache operations.
+
+
+ (*) In-cache object representation:
+
+	struct fscache_object {
+		int				debug_id;
+		enum {
+			FSCACHE_OBJECT_RECYCLING,
+			...
+		}				state;
+		spinlock_t			lock
+		struct fscache_cache		*cache;
+		struct fscache_cookie		*cookie;
+		...
+	};
+
+     Structures of this type should be allocated by the cache backend and
+     passed to FS-Cache when requested by the appropriate cache operation.  In
+     the case of CacheFS, they're embedded in CacheFS's internal object
+     structures.
+
+     The debug_id is a simple integer that can be used in debugging messages
+     that refer to a particular object.  In such a case it should be printed
+     using "OBJ%x" to be consistent with FS-Cache.
+
+     Each object contains a pointer to the cookie that represents the object it
+     is backing.  An object should retired when put_object() is called if it is
+     in state FSCACHE_OBJECT_RECYCLING.  The fscache_object struct should be
+     initialised by calling fscache_object_init(object).
+
+
+ (*) FS-Cache operation record:
+
+	struct fscache_operation {
+		atomic_t		usage;
+		struct fscache_object	*object;
+		unsigned long		flags;
+	#define FSCACHE_OP_EXCLUSIVE
+		void (*processor)(struct fscache_operation *op);
+		void (*release)(struct fscache_operation *op);
+		...
+	};
+
+     FS-Cache has a pool of threads that it uses to give CPU time to the
+     various asynchronous operations that need to be done as part of driving
+     the cache.  These are represented by the above structure.  The processor
+     method is called to give the op CPU time, and the release method to get
+     rid of it when its usage count reaches 0.
+
+     An operation can be made exclusive upon an object by setting the
+     appropriate flag before enqueuing it with fscache_enqueue_operation().  If
+     an operation needs more processing time, it should be enqueued again.
+
+
+ (*) FS-Cache retrieval operation record:
+
+	struct fscache_retrieval {
+		struct fscache_operation op;
+		struct address_space	*mapping;
+		struct list_head	*to_do;
+		...
+	};
+
+     A structure of this type is allocated by FS-Cache to record retrieval and
+     allocation requests made by the netfs.  This struct is then passed to the
+     backend to do the operation.  The backend may get extra refs to it by
+     calling fscache_get_retrieval() and refs may be discarded by calling
+     fscache_put_retrieval().
+
+     A retrieval operation can be used by the backend to do retrieval work.  To
+     do this, the retrieval->op.processor method pointer should be set
+     appropriately by the backend and fscache_enqueue_retrieval() called to
+     submit it to the thread pool.  CacheFiles, for example, uses this to queue
+     page examination when it detects PG_lock being cleared.
+
+     The to_do field is an empty list available for the cache backend to use as
+     it sees fit.
+
+
+ (*) FS-Cache storage operation record:
+
+	struct fscache_storage {
+		struct fscache_operation op;
+		pgoff_t			store_limit;
+		...
+	};
+
+     A structure of this type is allocated by FS-Cache to record outstanding
+     writes to be made.  FS-Cache itself enqueues this operation and invokes
+     the write_page() method on the object at appropriate times to effect
+     storage.
+
+
+================
+CACHE OPERATIONS
+================
+
+The cache backend provides FS-Cache with a table of operations that can be
+performed on the denizens of the cache.  These are held in a structure of type:
+
+	struct fscache_cache_ops
+
+ (*) Name of cache provider [mandatory]:
+
+	const char *name
+
+     This isn't strictly an operation, but should be pointed at a string naming
+     the backend.
+
+
+ (*) Allocate a new object [mandatory]:
+
+	struct fscache_object *(*alloc_object)(struct fscache_cache *cache,
+					       struct fscache_cookie *cookie)
+
+     This method is used to allocate a cache object representation to back a
+     cookie in a particular cache.  fscache_object_init() should be called on
+     the object to initialise it prior to returning.
+
+     This function may also be used to parse the index key to be used for
+     multiple lookup calls to turn it into a more convenient form.  FS-Cache
+     will call the lookup_complete() method to allow the cache to release the
+     form once lookup is complete or aborted.
+
+
+ (*) Look up and create object [mandatory]:
+
+	void (*lookup_object)(struct fscache_object *object)
+
+     This method is used to look up an object, given that the object is already
+     allocated and attached to the cookie.  This should instantiate that object
+     in the cache if it can.
+
+     The method should call fscache_object_lookup_negative() as soon as
+     possible if it determines the object doesn't exist in the cache.  If the
+     object is found to exist and the netfs indicates that it is valid then
+     fscache_obtained_object() should be called once the object is in a
+     position to have data stored in it.  Similarly, fscache_obtained_object()
+     should also be called once a non-present object has been created.
+
+     If a lookup error occurs, fscache_object_lookup_error() should be called
+     to abort the lookup of that object.
+
+
+ (*) Release lookup data [mandatory]:
+
+	void (*lookup_complete)(struct fscache_object *object)
+
+     This method is called to ask the cache to release any resources it was
+     using to perform a lookup.
+
+
+ (*) Increment object refcount [mandatory]:
+
+	struct fscache_object *(*grab_object)(struct fscache_object *object)
+
+     This method is called to increment the reference count on an object.  It
+     may fail (for instance if the cache is being withdrawn) by returning NULL.
+     It should return the object pointer if successful.
+
+
+ (*) Lock/Unlock object [mandatory]:
+
+	void (*lock_object)(struct fscache_object *object)
+	void (*unlock_object)(struct fscache_object *object)
+
+     These methods are used to exclusively lock an object.  It must be possible
+     to schedule with the lock held, so a spinlock isn't sufficient.
+
+
+ (*) Pin/Unpin object [optional]:
+
+	int (*pin_object)(struct fscache_object *object)
+	void (*unpin_object)(struct fscache_object *object)
+
+     These methods are used to pin an object into the cache.  Once pinned an
+     object cannot be reclaimed to make space.  Return -ENOSPC if there's not
+     enough space in the cache to permit this.
+
+
+ (*) Update object [mandatory]:
+
+	int (*update_object)(struct fscache_object *object)
+
+     This is called to update the index entry for the specified object.  The
+     new information should be in object->cookie->netfs_data.  This can be
+     obtained by calling object->cookie->def->get_aux()/get_attr().
+
+
+ (*) Discard object [mandatory]:
+
+	void (*drop_object)(struct fscache_object *object)
+
+     This method is called to indicate that an object has been unbound from its
+     cookie, and that the cache should release the object's resources and
+     retire it if it's in state FSCACHE_OBJECT_RECYCLING.
+
+     This method should not attempt to release any references held by the
+     caller.  The caller will invoke the put_object() method as appropriate.
+
+
+ (*) Release object reference [mandatory]:
+
+	void (*put_object)(struct fscache_object *object)
+
+     This method is used to discard a reference to an object.  The object may
+     be freed when all the references to it are released.
+
+
+ (*) Synchronise a cache [mandatory]:
+
+	void (*sync)(struct fscache_cache *cache)
+
+     This is called to ask the backend to synchronise a cache with its backing
+     device.
+
+
+ (*) Dissociate a cache [mandatory]:
+
+	void (*dissociate_pages)(struct fscache_cache *cache)
+
+     This is called to ask a cache to perform any page dissociations as part of
+     cache withdrawal.
+
+
+ (*) Notification that the attributes on a netfs file changed [mandatory]:
+
+	int (*attr_changed)(struct fscache_object *object);
+
+     This is called to indicate to the cache that certain attributes on a netfs
+     file have changed (for example the maximum size a file may reach).  The
+     cache can read these from the netfs by calling the cookie's get_attr()
+     method.
+
+     The cache may use the file size information to reserve space on the cache.
+     It should also call fscache_set_store_limit() to indicate to FS-Cache the
+     highest byte it's willing to store for an object.
+
+     This method may return -ve if an error occurred or the cache object cannot
+     be expanded.  In such a case, the object will be withdrawn from service.
+
+     This operation is run asynchronously from FS-Cache's thread pool, and
+     storage and retrieval operations from the netfs are excluded during the
+     execution of this operation.
+
+
+ (*) Reserve cache space for an object's data [optional]:
+
+	int (*reserve_space)(struct fscache_object *object, loff_t size);
+
+     This is called to request that cache space be reserved to hold the data
+     for an object and the metadata used to track it.  Zero size should be
+     taken as request to cancel a reservation.
+
+     This should return 0 if successful, -ENOSPC if there isn't enough space
+     available, or -ENOMEM or -EIO on other errors.
+
+     The reservation may exceed the current size of the object, thus permitting
+     future expansion.  If the amount of space consumed by an object would
+     exceed the reservation, it's permitted to refuse requests to allocate
+     pages, but not required.  An object may be pruned down to its reservation
+     size if larger than that already.
+
+
+ (*) Request page be read from cache [mandatory]:
+
+	int (*read_or_alloc_page)(struct fscache_retrieval *op,
+				  struct page *page,
+				  gfp_t gfp)
+
+     This is called to attempt to read a netfs page from the cache, or to
+     reserve a backing block if not.  FS-Cache will have done as much checking
+     as it can before calling, but most of the work belongs to the backend.
+
+     If there's no page in the cache, then -ENODATA should be returned if the
+     backend managed to reserve a backing block; -ENOBUFS or -ENOMEM if it
+     didn't.
+
+     If there is suitable data in the cache, then a read operation should be
+     queued and 0 returned.  When the read finishes, fscache_end_io() should be
+     called.
+
+     The fscache_mark_pages_cached() should be called for the page if any cache
+     metadata is retained.  This will indicate to the netfs that the page needs
+     explicit uncaching.  This operation takes a pagevec, thus allowing several
+     pages to be marked at once.
+
+     The retrieval record pointed to by op should be retained for each page
+     queued and released when I/O on the page has been formally ended.
+     fscache_get/put_retrieval() are available for this purpose.
+
+     The retrieval record may be used to get CPU time via the FS-Cache thread
+     pool.  If this is desired, the op->op.processor should be set to point to
+     the appropriate processing routine, and fscache_enqueue_retrieval() should
+     be called at an appropriate point to request CPU time.  For instance, the
+     retrieval routine could be enqueued upon the completion of a disk read.
+     The to_do field in the retrieval record is provided to aid in this.
+
+     If an I/O error occurs, fscache_io_error() should be called and -ENOBUFS
+     returned if possible or fscache_end_io() called with a suitable error
+     code..
+
+
+ (*) Request pages be read from cache [mandatory]:
+
+	int (*read_or_alloc_pages)(struct fscache_retrieval *op,
+				   struct list_head *pages,
+				   unsigned *nr_pages,
+				   gfp_t gfp)
+
+     This is like the read_or_alloc_page() method, except it is handed a list
+     of pages instead of one page.  Any pages on which a read operation is
+     started must be added to the page cache for the specified mapping and also
+     to the LRU.  Such pages must also be removed from the pages list and
+     *nr_pages decremented per page.
+
+     If there was an error such as -ENOMEM, then that should be returned; else
+     if one or more pages couldn't be read or allocated, then -ENOBUFS should
+     be returned; else if one or more pages couldn't be read, then -ENODATA
+     should be returned.  If all the pages are dispatched then 0 should be
+     returned.
+
+
+ (*) Request page be allocated in the cache [mandatory]:
+
+	int (*allocate_page)(struct fscache_retrieval *op,
+			     struct page *page,
+			     gfp_t gfp)
+
+     This is like the read_or_alloc_page() method, except that it shouldn't
+     read from the cache, even if there's data there that could be retrieved.
+     It should, however, set up any internal metadata required such that
+     the write_page() method can write to the cache.
+
+     If there's no backing block available, then -ENOBUFS should be returned
+     (or -ENOMEM if there were other problems).  If a block is successfully
+     allocated, then the netfs page should be marked and 0 returned.
+
+
+ (*) Request pages be allocated in the cache [mandatory]:
+
+	int (*allocate_pages)(struct fscache_retrieval *op,
+			      struct list_head *pages,
+			      unsigned *nr_pages,
+			      gfp_t gfp)
+
+     This is an multiple page version of the allocate_page() method.  pages and
+     nr_pages should be treated as for the read_or_alloc_pages() method.
+
+
+ (*) Request page be written to cache [mandatory]:
+
+	int (*write_page)(struct fscache_storage *op,
+			  struct page *page);
+
+     This is called to write from a page on which there was a previously
+     successful read_or_alloc_page() call or similar.  FS-Cache filters out
+     pages that don't have mappings.
+
+     This method is called asynchronously from the FS-Cache thread pool.  It is
+     not required to actually store anything, provided -ENODATA is then
+     returned to the next read of this page.
+
+     If an error occurred, then a negative error code should be returned,
+     otherwise zero should be returned.  FS-Cache will take appropriate action
+     in response to an error, such as withdrawing this object.
+
+     If this method returns success then FS-Cache will inform the netfs
+     appropriately.
+
+
+ (*) Discard retained per-page metadata [mandatory]:
+
+	void (*uncache_page)(struct fscache_object *object, struct page *page)
+
+     This is called when a netfs page is being evicted from the pagecache.  The
+     cache backend should tear down any internal representation or tracking it
+     maintains for this page.
+
+
+==================
+FS-CACHE UTILITIES
+==================
+
+FS-Cache provides some utilities that a cache backend may make use of:
+
+ (*) Note occurrence of an I/O error in a cache:
+
+	void fscache_io_error(struct fscache_cache *cache)
+
+     This tells FS-Cache that an I/O error occurred in the cache.  After this
+     has been called, only resource dissociation operations (object and page
+     release) will be passed from the netfs to the cache backend for the
+     specified cache.
+
+     This does not actually withdraw the cache.  That must be done separately.
+
+
+ (*) Invoke the retrieval I/O completion function:
+
+	void fscache_end_io(struct fscache_retrieval *op, struct page *page,
+			    int error);
+
+     This is called to note the end of an attempt to retrieve a page.  The
+     error value should be 0 if successful and an error otherwise.
+
+
+ (*) Set highest store limit:
+
+	void fscache_set_store_limit(struct fscache_object *object,
+				     loff_t i_size);
+
+     This sets the limit FS-Cache imposes on the highest byte it's willing to
+     try and store for a netfs.  Any page over this limit is automatically
+     rejected by fscache_read_alloc_page() and co with -ENOBUFS.
+
+
+ (*) Mark pages as being cached:
+
+	void fscache_mark_pages_cached(struct fscache_retrieval *op,
+				       struct pagevec *pagevec);
+
+     This marks a set of pages as being cached.  After this has been called,
+     the netfs must call fscache_uncache_page() to unmark the pages.
+
+
+ (*) Initialise a freshly allocated object:
+
+	void fscache_object_init(struct fscache_object *object);
+
+     This initialises all the fields in an object representation.
+
+
+ (*) Indicate negative lookup on an object:
+
+	void fscache_object_lookup_negative(struct fscache_object *object);
+
+     This is called to indicate to FS-Cache that a lookup process for an object
+     found a negative result.
+
+     This changes the state of an object to permit reads pending on lookup
+     completion to go off and start fetching data from the netfs server as it's
+     known at this point that there can't be any data in the cache.
+
+     This may be called multiple times on an object.  Only the first call is
+     significant - all subsequent calls are ignored.
+
+
+ (*) Indicate an object has been obtained:
+
+	void fscache_obtained_object(struct fscache_object *object);
+
+     This is called to indicate to FS-Cache that a lookup process for an object
+     produced a positive result, or that an object was created.  This should
+     only be called once for any particular object.
+
+     This changes the state of an object to indicate:
+
+	(1) if no call to fscache_object_lookup_negative() has been made on
+	    this object, that there may be data available, and that reads can
+	    now go and look for it; and
+
+        (2) that writes may now proceed against this object.
+
+
+ (*) Indicate that object lookup failed:
+
+	void fscache_object_lookup_error(struct fscache_object *object);
+
+     This marks an object as having encountered a fatal error (usually EIO)
+     and causes it to move into a state whereby it will be withdrawn as soon
+     as possible.
+
+
+ (*) Get and release references on a retrieval record:
+
+	void fscache_get_retrieval(struct fscache_retrieval *op);
+	void fscache_put_retrieval(struct fscache_retrieval *op);
+
+     These two functions are used to retain a retrieval record whilst doing
+     asynchronous data retrieval and block allocation.
+
+
+ (*) Enqueue a retrieval record for processing.
+
+	void fscache_enqueue_retrieval(struct fscache_retrieval *op);
+
+     This enqueues a retrieval record for processing by the FS-Cache thread
+     pool.  One of the threads in the pool will invoke the retrieval record's
+     op->op.processor callback function.  This function may be called from
+     within the callback function.
+
+
+ (*) List of object state names:
+
+	const char *fscache_object_states[];
+
+     For debugging purposes, this may be used to turn the state that an object
+     is in into a text string for display purposes.
diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
new file mode 100644
index 0000000..b28f2ca
--- /dev/null
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -0,0 +1,295 @@
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
+		bst=N	Number of objects with boosted lookup priority
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
+		req=N	Number of times async ops requeued for processing
+		rel=N	Number of times async ops released
+
+
+ (*) /proc/fs/fscache/pool
+
+     This shows the number of objects and operations each thread in the thread
+     pool has given CPU time to.
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
+	9	512	Thread pool management		Function entry trace
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
index 0000000..e8a1496
--- /dev/null
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -0,0 +1,741 @@
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
+		struct fscache_netfs_operations	*ops;
+		struct fscache_cookie		*primary_index;
+		...
+	};
+
+This first three fields should be filled in before registration, and the fourth
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
+ (3) The operations table is defined as follows:
+
+	struct fscache_netfs_operations {
+	};
+
+     Currently there aren't any functions here.
+
+ (4) The cookie representing the primary index will be allocated according to
+     another parameter passed into the registration function.
+
+For example, kAFS (linux/fs/afs/) uses the following definitions to describe
+itself:
+
+	static struct fscache_netfs_operations afs_cache_ops = {
+	};
+
+	struct fscache_netfs afs_cache_netfs = {
+		.version	= 0,
+		.name		= "afs",
+		.ops		= &afs_cache_ops,
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
+		fscache_checkaux_t (*check_aux)(void *cookie_netfs_data,
+						const void *data,
+						uint16_t datalen);
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
+     	 maintained with the get_context/put_context functions mentioned above.
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
+operation started by the read/alloc and write functions.
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
diff --git a/fs/Kconfig b/fs/Kconfig
index 58a0650..3e1c276 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -631,6 +631,12 @@ config GENERIC_ACL
 	bool
 	select FS_POSIX_ACL
 
+menu "Caches"
+
+source "fs/fscache/Kconfig"
+
+endmenu
+
 if BLOCK
 menu "CD-ROM/DVD Filesystems"
 
diff --git a/fs/Makefile b/fs/Makefile
index 720c29d..4eecc9a 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line
+obj-$(CONFIG_FSCACHE)		+= fscache/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT4DEV_FS)	+= ext4/ # Before ext2 so root fs can be ext4dev
diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
new file mode 100644
index 0000000..e68c945
--- /dev/null
+++ b/fs/fscache/Kconfig
@@ -0,0 +1,49 @@
+
+config FSCACHE
+	tristate "General filesystem local caching manager"
+	depends on EXPERIMENTAL
+	help
+	  This option enables a generic filesystem caching manager that can be
+	  used by various network and other filesystems to cache data locally.
+	  Different sorts of caches can be plugged in, depending on the
+	  resources available.
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_PROC
+	bool "Provide /proc interface for local caching statistics"
+	depends on FSCACHE && PROC_FS
+
+config FSCACHE_STATS
+	bool "Gather statistical information on local caching"
+	depends on FSCACHE_PROC
+	help
+	  This option causes statistical information to be gathered on local
+	  caching and exported through files:
+
+		/proc/fs/fscache/stats
+		/proc/fs/fscache/pool
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_HISTOGRAM
+	bool "Gather latency information on local caching"
+	depends on FSCACHE_PROC
+	help
+
+	  This option causes latency information to be gathered on local
+	  caching and exported through file:
+
+		/proc/fs/fscache/histogram
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_DEBUG
+	bool "Debug FS-Cache"
+	depends on FSCACHE
+	help
+	  This permits debugging to be dynamically enabled in the local caching
+	  management module.  If this is set, the debugging output may be
+	  enabled by setting bits in /sys/modules/fscache/parameter/debug.
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
new file mode 100644
index 0000000..e60dad3
--- /dev/null
+++ b/fs/fscache/Makefile
@@ -0,0 +1,19 @@
+#
+# Makefile for general filesystem caching code
+#
+
+fscache-y := \
+	fsc-cache.o \
+	fsc-cookie.o \
+	fsc-fsdef.o \
+	fsc-main.o \
+	fsc-manage.o \
+	fsc-object.o \
+	fsc-page.o \
+	fsc-threads.o
+
+fscache-$(CONFIG_FSCACHE_PROC) += \
+	fsc-proc.o \
+	fsc-stats.o
+
+obj-$(CONFIG_FSCACHE) := fscache.o
diff --git a/fs/fscache/fsc-cache.c b/fs/fscache/fsc-cache.c
new file mode 100644
index 0000000..1d40058
--- /dev/null
+++ b/fs/fscache/fsc-cache.c
@@ -0,0 +1,512 @@
+/* FS-Cache cache handling
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL CACHE
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "fsc-internal.h"
+
+LIST_HEAD(fscache_cache_list);
+DECLARE_RWSEM(fscache_addremove_sem);
+DECLARE_WAIT_QUEUE_HEAD(fscache_clearance_wq);
+static LIST_HEAD(fscache_cache_tag_list);
+static LIST_HEAD(fscache_netfs_list);
+
+static struct sysfs_ops fscache_cache_sysfs_ops = {
+};
+
+static struct kobj_type fscache_cache_ktype = {
+	.sysfs_ops	= &fscache_cache_sysfs_ops,
+};
+
+/*
+ * look up a cache tag
+ */
+struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
+{
+	struct fscache_cache_tag *tag, *xtag;
+
+	/* firstly check for the existence of the tag under read lock */
+	down_read(&fscache_addremove_sem);
+
+	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
+		if (strcmp(tag->name, name) == 0) {
+			atomic_inc(&tag->usage);
+			up_read(&fscache_addremove_sem);
+			return tag;
+		}
+	}
+
+	up_read(&fscache_addremove_sem);
+
+	/* the tag does not exist - create a candidate */
+	xtag = kzalloc(sizeof(*xtag) + strlen(name) + 1, GFP_KERNEL);
+	if (!xtag)
+		/* return a dummy tag if out of memory */
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&xtag->usage, 1);
+	strcpy(xtag->name, name);
+
+	/* write lock, search again and add if still not present */
+	down_write(&fscache_addremove_sem);
+
+	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
+		if (strcmp(tag->name, name) == 0) {
+			atomic_inc(&tag->usage);
+			up_write(&fscache_addremove_sem);
+			kfree(xtag);
+			return tag;
+		}
+	}
+
+	list_add_tail(&xtag->link, &fscache_cache_tag_list);
+	up_write(&fscache_addremove_sem);
+	return xtag;
+}
+
+/*
+ * release a reference to a cache tag
+ */
+void __fscache_release_cache_tag(struct fscache_cache_tag *tag)
+{
+	if (tag != ERR_PTR(-ENOMEM)) {
+		down_write(&fscache_addremove_sem);
+
+		if (atomic_dec_and_test(&tag->usage))
+			list_del_init(&tag->link);
+		else
+			tag = NULL;
+
+		up_write(&fscache_addremove_sem);
+
+		kfree(tag);
+	}
+}
+
+/*
+ * register a network filesystem for caching
+ */
+int __fscache_register_netfs(struct fscache_netfs *netfs)
+{
+	struct fscache_netfs *ptr;
+	int ret;
+
+	_enter("{%s}", netfs->name);
+
+	INIT_LIST_HEAD(&netfs->link);
+
+	/* allocate a cookie for the primary index */
+	netfs->primary_index =
+		kmem_cache_zalloc(fscache_cookie_jar, GFP_KERNEL);
+
+	if (!netfs->primary_index) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	/* initialise the primary index cookie */
+	atomic_set(&netfs->primary_index->usage, 1);
+	atomic_set(&netfs->primary_index->n_children, 0);
+
+	netfs->primary_index->def		= &fscache_fsdef_netfs_def;
+	netfs->primary_index->parent		= &fscache_fsdef_index;
+	netfs->primary_index->netfs_data	= netfs;
+
+	atomic_inc(&netfs->primary_index->parent->usage);
+	atomic_inc(&netfs->primary_index->parent->n_children);
+
+	spin_lock_init(&netfs->primary_index->lock);
+	INIT_HLIST_HEAD(&netfs->primary_index->backing_objects);
+
+	/* check the netfs type is not already present */
+	down_write(&fscache_addremove_sem);
+
+	ret = -EEXIST;
+	list_for_each_entry(ptr, &fscache_netfs_list, link) {
+		if (strcmp(ptr->name, netfs->name) == 0)
+			goto already_registered;
+	}
+
+	list_add(&netfs->link, &fscache_netfs_list);
+	ret = 0;
+
+	printk(KERN_NOTICE "FS-Cache: Netfs '%s' registered for caching\n",
+	       netfs->name);
+
+already_registered:
+	up_write(&fscache_addremove_sem);
+
+	if (ret < 0) {
+		netfs->primary_index->parent = NULL;
+		__fscache_cookie_put(netfs->primary_index);
+		netfs->primary_index = NULL;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+EXPORT_SYMBOL(__fscache_register_netfs);
+
+/*
+ * unregister a network filesystem from the cache
+ * - all cookies must have been released first
+ */
+void __fscache_unregister_netfs(struct fscache_netfs *netfs)
+{
+	_enter("{%s.%u}", netfs->name, netfs->version);
+
+	down_write(&fscache_addremove_sem);
+
+	list_del(&netfs->link);
+	fscache_relinquish_cookie(netfs->primary_index, 0);
+
+	up_write(&fscache_addremove_sem);
+
+	printk(KERN_NOTICE "FS-Cache: Netfs '%s' unregistered from caching\n",
+	       netfs->name);
+
+	_leave("");
+}
+
+EXPORT_SYMBOL(__fscache_unregister_netfs);
+
+/**
+ * fscache_init_cache - Initialise a cache record
+ * @cache: The cache record to be initialised
+ * @ops: The cache operations to be installed in that record
+ * @idfmt: Format string to define identifier
+ * @...: sprintf-style arguments
+ *
+ * Initialise a record of a cache and fill in the name.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+void fscache_init_cache(struct fscache_cache *cache,
+			const struct fscache_cache_ops *ops,
+			const char *idfmt,
+			...)
+{
+	va_list va;
+
+	memset(cache, 0, sizeof(*cache));
+
+	cache->ops = ops;
+	cache->kobj.kset = &fscache_kset;
+	cache->kobj.ktype = &fscache_cache_ktype;
+
+	va_start(va, idfmt);
+	vsnprintf(cache->identifier, sizeof(cache->identifier), idfmt, va);
+	va_end(va);
+
+	INIT_LIST_HEAD(&cache->link);
+	INIT_LIST_HEAD(&cache->object_list);
+	spin_lock_init(&cache->object_list_lock);
+}
+
+EXPORT_SYMBOL(fscache_init_cache);
+
+/**
+ * fscache_add_cache - Declare a cache as being open for business
+ * @cache: The record describing the cache
+ * @ifsdef: The record of the cache object describing the top-level index
+ * @tagname: The tag describing this cache
+ *
+ * Add a cache to the system, making it available for netfs's to use.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+int fscache_add_cache(struct fscache_cache *cache,
+		      struct fscache_object *ifsdef,
+		      const char *tagname)
+{
+	struct fscache_cache_tag *tag;
+	int ret;
+
+	BUG_ON(!cache->ops);
+	BUG_ON(!ifsdef);
+
+	/* make sure the worker threads are present */
+	down_write(&fscache_addremove_sem);
+	fscache_init_threads();
+	up_write(&fscache_addremove_sem);
+
+	cache->flags = 0;
+	ifsdef->event_mask = ULONG_MAX & ~(1 << FSCACHE_OBJECT_EV_CLEARED);
+	ifsdef->state = FSCACHE_OBJECT_ACTIVE;
+
+	if (!tagname)
+		tagname = cache->identifier;
+
+	BUG_ON(!tagname[0]);
+
+	_enter("{%s.%s},,%s", cache->ops->name, cache->identifier, tagname);
+
+	/* we use the cache tag to uniquely identify caches */
+	tag = __fscache_lookup_cache_tag(tagname);
+	if (IS_ERR(tag))
+		goto nomem;
+
+	if (test_and_set_bit(FSCACHE_TAG_RESERVED, &tag->flags))
+		goto tag_in_use;
+
+	ret = kobject_set_name(&cache->kobj, "%s", tagname);
+	if (ret < 0)
+		goto error;
+
+	ret = kobject_register(&cache->kobj);
+	if (ret < 0)
+		goto error;
+
+	if (!cache->ops->grab_object(ifsdef))
+		BUG();
+
+	ifsdef->cookie = &fscache_fsdef_index;
+	ifsdef->cache = cache;
+	cache->fsdef = ifsdef;
+
+	down_write(&fscache_addremove_sem);
+
+	tag->cache = cache;
+	cache->tag = tag;
+
+	/* add the cache to the list */
+	list_add(&cache->link, &fscache_cache_list);
+
+	/* add the cache's netfs definition index object to the cache's
+	 * list */
+	spin_lock(&cache->object_list_lock);
+	list_add_tail(&ifsdef->cache_link, &cache->object_list);
+	spin_unlock(&cache->object_list_lock);
+
+	/* add the cache's netfs definition index object to the top level index
+	 * cookie as a known backing object */
+	spin_lock(&fscache_fsdef_index.lock);
+
+	hlist_add_head(&ifsdef->cookie_link,
+		       &fscache_fsdef_index.backing_objects);
+
+	atomic_inc(&fscache_fsdef_index.usage);
+
+	/* done */
+	spin_unlock(&fscache_fsdef_index.lock);
+	up_write(&fscache_addremove_sem);
+
+	printk(KERN_NOTICE "FS-Cache: Cache \"%s\" added (type %s)\n",
+	       cache->tag->name, cache->ops->name);
+
+	_leave(" = 0 [%s]", cache->identifier);
+	return 0;
+
+tag_in_use:
+	printk(KERN_ERR "FS-Cache: Cache tag '%s' already in use\n", tagname);
+	__fscache_release_cache_tag(tag);
+	_leave(" = -EXIST");
+	return -EEXIST;
+
+error:
+	__fscache_release_cache_tag(tag);
+	_leave(" = %d", ret);
+	return ret;
+
+nomem:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+
+EXPORT_SYMBOL(fscache_add_cache);
+
+/*
+ * select a cache in which to store an object
+ * - the cache addremove semaphore must be at least read-locked by the caller
+ * - the object will never be an index
+ */
+struct fscache_cache *fscache_select_cache_for_object(
+	struct fscache_cookie *cookie)
+{
+	struct fscache_cache_tag *tag;
+	struct fscache_object *object;
+	struct fscache_cache *cache;
+
+	_enter("");
+
+	if (list_empty(&fscache_cache_list)) {
+		_leave(" = NULL [no cache]");
+		return NULL;
+	}
+
+	/* we check the parent to determine the cache to use */
+	spin_lock(&cookie->lock);
+
+	/* the first in the parent's backing list should be the preferred
+	 * cache */
+	if (!hlist_empty(&cookie->backing_objects)) {
+		object = hlist_entry(cookie->backing_objects.first,
+				     struct fscache_object, cookie_link);
+
+		cache = object->cache;
+		if (object->state >= FSCACHE_OBJECT_DYING ||
+		    test_bit(FSCACHE_IOERROR, &cache->flags))
+			cache = NULL;
+
+		spin_unlock(&cookie->lock);
+		_leave(" = %p [parent]", cache);
+		return cache;
+	}
+
+	/* the parent is unbacked */
+	if (cookie->def->type != FSCACHE_COOKIE_TYPE_INDEX) {
+		/* cookie not an index and is unbacked */
+		spin_unlock(&cookie->lock);
+		_leave(" = NULL [cookie ub,ni]");
+		return NULL;
+	}
+
+	spin_unlock(&cookie->lock);
+
+	if (!cookie->def->select_cache)
+		goto no_preference;
+
+	/* ask the netfs for its preference */
+	tag = cookie->def->select_cache(cookie->parent->netfs_data,
+					cookie->netfs_data);
+	if (!tag)
+		goto no_preference;
+
+	if (tag == ERR_PTR(-ENOMEM)) {
+		_leave(" = NULL [nomem tag]");
+		return NULL;
+	}
+
+	if (!tag->cache) {
+		_leave(" = NULL [unbacked tag]");
+		return NULL;
+	}
+
+	if (test_bit(FSCACHE_IOERROR, &tag->cache->flags))
+		return NULL;
+
+	_leave(" = %p [specific]", tag->cache);
+	return tag->cache;
+
+no_preference:
+	/* netfs has no preference - just select first cache */
+	cache = list_entry(fscache_cache_list.next,
+			   struct fscache_cache, link);
+	_leave(" = %p [first]", cache);
+	return cache;
+}
+
+/**
+ * fscache_io_error - Note a cache I/O error
+ * @cache: The record describing the cache
+ *
+ * Note that an I/O error occurred in a cache and that it should no longer be
+ * used for anything.  This also reports the error into the kernel log.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+void fscache_io_error(struct fscache_cache *cache)
+{
+	set_bit(FSCACHE_IOERROR, &cache->flags);
+
+	printk(KERN_ERR "FS-Cache: Cache %s stopped due to I/O error\n",
+	       cache->ops->name);
+}
+
+EXPORT_SYMBOL(fscache_io_error);
+
+/**
+ * fscache_withdraw_cache - Withdraw a cache from the active service
+ * @cache: The record describing the cache
+ *
+ * Withdraw a cache from service, unbinding all its cache objects from the
+ * netfs cookies they're currently representing.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+void fscache_withdraw_cache(struct fscache_cache *cache)
+{
+	struct fscache_object *object;
+	LIST_HEAD(object_list);
+
+	_enter("");
+
+	printk(KERN_NOTICE "FS-Cache: Withdrawing cache \"%s\"\n",
+	       cache->tag->name);
+
+	/* make the cache unavailable for cookie acquisition */
+	if (test_and_set_bit(FSCACHE_CACHE_WITHDRAWN, &cache->flags))
+		BUG();
+
+	down_write(&fscache_addremove_sem);
+	list_del_init(&cache->link);
+	cache->tag->cache = NULL;
+	up_write(&fscache_addremove_sem);
+
+	/* make sure all pages pinned by operations on behalf of the netfs are
+	 * written to disk */
+	cache->ops->sync_cache(cache);
+
+	/* dissociate all the netfs pages backed by this cache from the block
+	 * mappings in the cache */
+	cache->ops->dissociate_pages(cache);
+
+	/* we now have to destroy all the active objects pertaining to this
+	 * cache - which we do by passing them off to thread pool to dispose
+	 * of */
+	_debug("destroy");
+
+	spin_lock(&cache->object_list_lock);
+
+	while (!list_empty(&cache->object_list)) {
+		object = list_entry(cache->object_list.next,
+				    struct fscache_object, cache_link);
+		list_move_tail(&object->cache_link, &object_list);
+
+		_debug("withdraw %p", object->cookie);
+
+		spin_lock(&object->lock);
+		spin_unlock(&cache->object_list_lock);
+		fscache_raise_event(object, FSCACHE_OBJECT_EV_WITHDRAW);
+		spin_unlock(&object->lock);
+
+		cond_resched();
+		spin_lock(&cache->object_list_lock);
+	}
+
+	spin_unlock(&cache->object_list_lock);
+
+	/* wait for all extant objects to finish their outstanding operations
+	 * and go away */
+	_debug("wait for finish");
+	wait_event(fscache_clearance_wq,
+		   atomic_read(&cache->thread_usage) == 0);
+	_debug("wait for clearance");
+	wait_event(fscache_clearance_wq,
+		   list_empty(&cache->object_list));
+	_debug("cleared");
+
+	kobject_unregister(&cache->kobj);
+
+	clear_bit(FSCACHE_TAG_RESERVED, &cache->tag->flags);
+	fscache_release_cache_tag(cache->tag);
+	cache->tag = NULL;
+
+	_leave("");
+}
+
+EXPORT_SYMBOL(fscache_withdraw_cache);
diff --git a/fs/fscache/fsc-cookie.c b/fs/fscache/fsc-cookie.c
new file mode 100644
index 0000000..92bfc73
--- /dev/null
+++ b/fs/fscache/fsc-cookie.c
@@ -0,0 +1,494 @@
+/* netfs cookie management
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL COOKIE
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "fsc-internal.h"
+
+struct kmem_cache *fscache_cookie_jar;
+
+static atomic_t fscache_object_debug_id = ATOMIC_INIT(0);
+
+static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie);
+static int fscache_alloc_object(struct fscache_cache *cache,
+				struct fscache_cookie *cookie);
+static int fscache_attach_object(struct fscache_cookie *cookie,
+				 struct fscache_object *object);
+
+/*
+ * initialise an cookie jar slab element prior to any use
+ */
+void fscache_cookie_init_once(void *_cookie, struct kmem_cache *cachep,
+			      unsigned long flags)
+{
+	struct fscache_cookie *cookie = _cookie;
+
+	memset(cookie, 0, sizeof(*cookie));
+	spin_lock_init(&cookie->lock);
+	INIT_HLIST_HEAD(&cookie->backing_objects);
+}
+
+/*
+ * request a cookie to represent an object (index, datafile, xattr, etc)
+ * - parent specifies the parent object
+ *   - the top level index cookie for each netfs is stored in the fscache_netfs
+ *     struct upon registration
+ * - def points to the definition
+ * - the netfs_data will be passed to the functions pointed to in *def
+ * - all attached caches will be searched to see if they contain this object
+ * - index objects aren't stored on disk until there's a dependent file that
+ *   needs storing
+ * - other objects are stored in a selected cache immediately, and all the
+ *   indices forming the path to it are instantiated if necessary
+ * - we never let on to the netfs about errors
+ *   - we may set a negative cookie pointer, but that's okay
+ */
+struct fscache_cookie *__fscache_acquire_cookie(struct fscache_cookie *parent,
+						const struct fscache_cookie_def *def,
+						void *netfs_data)
+{
+	struct fscache_cookie *cookie;
+
+	BUG_ON(!def);
+
+	_enter("{%s},{%s},%p",
+	       parent ? (char *) parent->def->name : "<no-parent>",
+	       def->name, netfs_data);
+
+	fscache_stat(&fscache_n_acquires);
+
+	/* if there's no parent cookie, then we don't create one here either */
+	if (!parent) {
+		fscache_stat(&fscache_n_acquires_null);
+		_leave(" [no parent]");
+		return NULL;
+	}
+
+	/* validate the definition */
+	BUG_ON(!def->get_key);
+	BUG_ON(!def->name[0]);
+
+	BUG_ON(def->type == FSCACHE_COOKIE_TYPE_INDEX &&
+	       parent->def->type != FSCACHE_COOKIE_TYPE_INDEX);
+
+	/* allocate and initialise a cookie */
+	cookie = kmem_cache_alloc(fscache_cookie_jar, GFP_KERNEL);
+	if (!cookie) {
+		fscache_stat(&fscache_n_acquires_oom);
+		_leave(" [ENOMEM]");
+		return NULL;
+	}
+
+	atomic_set(&cookie->usage, 1);
+	atomic_set(&cookie->n_children, 0);
+
+	atomic_inc(&parent->usage);
+	atomic_inc(&parent->n_children);
+
+	cookie->def		= def;
+	cookie->parent		= parent;
+	cookie->netfs_data	= netfs_data;
+	cookie->flags		= 0;
+
+	switch (cookie->def->type) {
+	case FSCACHE_COOKIE_TYPE_INDEX:
+		fscache_stat(&fscache_n_cookie_index);
+		break;
+	case FSCACHE_COOKIE_TYPE_DATAFILE:
+		fscache_stat(&fscache_n_cookie_data);
+		break;
+	default:
+		fscache_stat(&fscache_n_cookie_special);
+		break;
+	}
+
+	/* if the object is an index then we need do nothing more here - we
+	 * create indices on disk when we need them as an index may exist in
+	 * multiple caches */
+	if (cookie->def->type != FSCACHE_COOKIE_TYPE_INDEX) {
+		if (fscache_acquire_non_index_cookie(cookie) < 0) {
+			atomic_dec(&parent->n_children);
+			__fscache_cookie_put(cookie);
+			fscache_stat(&fscache_n_acquires_nobufs);
+			_leave(" = NULL");
+			return NULL;
+		}
+	}
+
+	fscache_stat(&fscache_n_acquires_ok);
+	_leave(" = %p", cookie);
+	return cookie;
+}
+
+EXPORT_SYMBOL(__fscache_acquire_cookie);
+
+/*
+ * acquire a non-index cookie
+ * - this must make sure the index chain is instantiated and instantiate the
+ *   object representation too
+ */
+static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+	struct fscache_cache *cache;
+	loff_t i_size;
+	int ret;
+
+	_enter("");
+
+	cookie->flags = 1 << FSCACHE_COOKIE_UNAVAILABLE;
+
+	/* now we need to see whether the backing objects for this cookie yet
+	 * exist, if not there'll be nothing to search */
+	down_read(&fscache_addremove_sem);
+
+	if (list_empty(&fscache_cache_list)) {
+		up_read(&fscache_addremove_sem);
+		_leave(" = 0 [no caches]");
+		return 0;
+	}
+
+	/* select a cache in which to store the object */
+	cache = fscache_select_cache_for_object(cookie->parent);
+	if (!cache) {
+		up_read(&fscache_addremove_sem);
+		fscache_stat(&fscache_n_acquires_no_cache);
+		_leave(" = -ENOMEDIUM [no cache]");
+		return -ENOMEDIUM;
+	}
+
+	_debug("cache %s", cache->tag->name);
+
+	cookie->flags =
+		(1 << FSCACHE_COOKIE_LOOKING_UP) |
+		(1 << FSCACHE_COOKIE_CREATING) |
+		(1 << FSCACHE_COOKIE_NO_DATA_YET);
+
+	/* ask the cache to allocate objects for this cookie and its parent
+	 * chain */
+	ret = fscache_alloc_object(cache, cookie);
+	if (ret < 0) {
+		up_read(&fscache_addremove_sem);
+		_leave(" = %d", ret);
+		return ret;
+	}
+
+	/* initiate the process of looking up all the objects in the chain */
+	cookie->def->get_attr(cookie->netfs_data, &i_size);
+
+	spin_lock(&cookie->lock);
+	if (hlist_empty(&cookie->backing_objects)) {
+		spin_unlock(&cookie->lock);
+		goto unavailable;
+	}
+
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+	
+	fscache_set_store_limit(object, i_size);
+	fscache_enqueue_object(object);
+	spin_unlock(&cookie->lock);
+
+	/* we may be required to wait for lookup to complete at this point */
+	if (!fscache_defer_lookup) {
+		_debug("non-deferred lookup %p", &cookie->flags);
+		wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("complete");
+		if (test_bit(FSCACHE_COOKIE_UNAVAILABLE, &cookie->flags))
+			goto unavailable;
+	}
+
+	up_read(&fscache_addremove_sem);
+	_leave(" = 0 [deferred]");
+	return 0;
+
+unavailable:
+	up_read(&fscache_addremove_sem);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+
+/*
+ * recursively allocate cache object records for a cookie/cache combination
+ * - caller must be holding the addremove sem
+ */
+static int fscache_alloc_object(struct fscache_cache *cache,
+				struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+	struct hlist_node *_n;
+	int ret;
+
+	_enter("%p,%p{%s}", cache, cookie, cookie->def->name);
+
+	spin_lock(&cookie->lock);
+	hlist_for_each_entry(object, _n, &cookie->backing_objects,
+			     cookie_link) {
+		if (object->cache == cache)
+			goto object_already_extant;
+	}
+	spin_unlock(&cookie->lock);
+
+	/* ask the cache to allocate an object (we may end up with duplicate
+	 * objects at this stage, but we sort that out later) */
+	object = cache->ops->alloc_object(cache, cookie);
+	if (IS_ERR(object)) {
+		fscache_stat(&fscache_n_object_no_alloc);
+		ret = PTR_ERR(object);
+		goto error;
+	}
+
+	fscache_stat(&fscache_n_object_alloc);
+
+	object->debug_id = atomic_inc_return(&fscache_object_debug_id);
+
+	_debug("ALLOC OBJ%x: %s {%lx}",
+	       object->debug_id, cookie->def->name, object->events);
+
+	ret = fscache_alloc_object(cache, cookie->parent);
+	if (ret < 0)
+		goto error_put;
+
+	/* only attach if we managed to allocate all we needed, otherwise
+	 * discard the object we just allocated and instead use the one
+	 * attached to the cookie */
+	if (fscache_attach_object(cookie, object) < 0)
+		cache->ops->put_object(object);
+
+	_leave(" = 0");
+	return 0;
+
+object_already_extant:
+	ret = -ENOBUFS;
+	if (object->state >= FSCACHE_OBJECT_DYING) {
+		spin_unlock(&cookie->lock);
+		goto error;
+	}
+	spin_unlock(&cookie->lock);
+	_leave(" = 0 [found]");
+	return 0;
+
+error_put:
+	cache->ops->put_object(object);
+error:
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * attach a cache object to a cookie
+ */
+static int fscache_attach_object(struct fscache_cookie *cookie,
+				 struct fscache_object *object)
+{
+	struct fscache_object *p;
+	struct fscache_cache *cache = object->cache;
+	struct hlist_node *_n;
+	int ret;
+
+	_enter("{%s},{OBJ%x}", cookie->def->name, object->debug_id);
+
+	spin_lock(&cookie->lock);
+
+	/* there may be multiple initial creations of this object, but we only
+	 * want one */
+	ret = -EEXIST;
+	hlist_for_each_entry(p, _n, &cookie->backing_objects, cookie_link) {
+		if (p->cache == object->cache) {
+			if (p->state >= FSCACHE_OBJECT_DYING)
+				ret = -ENOBUFS;
+			goto cant_attach_object;
+		}
+	}
+
+	/* pin the parent object */
+	spin_lock_nested(&cookie->parent->lock, 1);
+	hlist_for_each_entry(p, _n, &cookie->parent->backing_objects,
+			     cookie_link) {
+		if (p->cache == object->cache) {
+			if (p->state >= FSCACHE_OBJECT_DYING) {
+				ret = -ENOBUFS;
+				spin_unlock(&cookie->parent->lock);
+				goto cant_attach_object;
+			}
+			object->parent = p;
+			spin_lock(&p->lock);
+			p->n_children++;
+			spin_unlock(&p->lock);
+			break;
+		}
+	}
+	spin_unlock(&cookie->parent->lock);
+
+	/* attach to the cache's object list */
+	if (list_empty(&object->cache_link)) {
+		spin_lock(&cache->object_list_lock);
+		list_add(&object->cache_link, &cache->object_list);
+		spin_unlock(&cache->object_list_lock);
+	}
+
+	/* attach to the cookie */
+	object->cookie = cookie;
+	atomic_inc(&cookie->usage);
+	hlist_add_head(&object->cookie_link, &cookie->backing_objects);
+	ret = 0;
+
+cant_attach_object:
+	spin_unlock(&cookie->lock);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * update the index entries backing a cookie
+ */
+void __fscache_update_cookie(struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+	struct hlist_node *_p;
+
+	fscache_stat(&fscache_n_updates);
+
+	if (!cookie) {
+		fscache_stat(&fscache_n_updates_null);
+		_leave(" [no cookie]");
+		return;
+	}
+
+	_enter("{%s}", cookie->def->name);
+
+	BUG_ON(!cookie->def->get_aux);
+
+	spin_lock(&cookie->lock);
+
+	/* update the index entry on disk in each cache backing this cookie */
+	hlist_for_each_entry(object, _p,
+			     &cookie->backing_objects, cookie_link) {
+		fscache_raise_event(object, FSCACHE_OBJECT_EV_UPDATE);
+	}
+
+	spin_unlock(&cookie->lock);
+	_leave("");
+}
+
+EXPORT_SYMBOL(__fscache_update_cookie);
+
+/*
+ * release a cookie back to the cache
+ * - the object will be marked as recyclable on disk if retire is true
+ * - all dependents of this cookie must have already been unregistered
+ *   (indices/files/pages)
+ */
+void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
+{
+	struct fscache_cache *cache;
+	struct fscache_object *object;
+	unsigned long event;
+
+	fscache_stat(&fscache_n_relinquishes);
+
+	if (!cookie) {
+		fscache_stat(&fscache_n_relinquishes_null);
+		_leave(" [no cookie]");
+		return;
+	}
+
+	_enter("%p{%s,%p},%d",
+	       cookie, cookie->def->name, cookie->netfs_data, retire);
+
+	if (atomic_read(&cookie->n_children) != 0) {
+		printk(KERN_ERR "FS-Cache: Cookie '%s' still has children\n",
+		       cookie->def->name);
+		BUG();
+	}
+
+	/* wait for the cookie to finish being instantiated (or to fail) */
+	if (test_bit(FSCACHE_COOKIE_CREATING, &cookie->flags)) {
+		fscache_stat(&fscache_n_relinquishes_waitcrt);
+		wait_on_bit(&cookie->flags, FSCACHE_COOKIE_CREATING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+	}
+
+	event = retire ? FSCACHE_OBJECT_EV_RETIRE : FSCACHE_OBJECT_EV_RELEASE;
+
+	/* detach pointers back to the netfs */
+	spin_lock(&cookie->lock);
+
+	cookie->netfs_data	= NULL;
+	cookie->def		= NULL;
+
+	/* break links with all the active objects */
+	while (!hlist_empty(&cookie->backing_objects)) {
+		object = hlist_entry(cookie->backing_objects.first,
+				     struct fscache_object,
+				     cookie_link);
+
+		_debug("RELEASE OBJ%x", object->debug_id);
+
+		/* detach each cache object from the object cookie */
+		spin_lock(&object->lock);
+		hlist_del_init(&object->cookie_link);
+
+		cache = object->cache;
+		object->cookie = NULL;
+		fscache_raise_event(object, event);
+		spin_unlock(&object->lock);
+
+		if (atomic_dec_and_test(&cookie->usage))
+			/* the cookie refcount shouldn't be reduced to 0 yet */
+			BUG();
+	}
+
+	spin_unlock(&cookie->lock);
+
+	if (cookie->parent) {
+		ASSERTCMP(atomic_read(&cookie->parent->usage), >, 0);
+		ASSERTCMP(atomic_read(&cookie->parent->n_children), >, 0);
+		atomic_dec(&cookie->parent->n_children);
+	}
+
+	/* finally dispose of the cookie */
+	ASSERTCMP(atomic_read(&cookie->usage), >, 0);
+	fscache_cookie_put(cookie);
+
+	_leave("");
+}
+
+EXPORT_SYMBOL(__fscache_relinquish_cookie);
+
+/*
+ * destroy a cookie
+ */
+void __fscache_cookie_put(struct fscache_cookie *cookie)
+{
+	struct fscache_cookie *parent;
+
+	_enter("%p", cookie);
+
+	for (;;) {
+		_debug("FREE COOKIE %p", cookie);
+		parent = cookie->parent;
+		BUG_ON(!hlist_empty(&cookie->backing_objects));
+		kmem_cache_free(fscache_cookie_jar, cookie);
+
+		if (!parent)
+			break;
+
+		cookie = parent;
+		BUG_ON(atomic_read(&cookie->usage) <= 0);
+		if (!atomic_dec_and_test(&cookie->usage))
+			break;
+	}
+
+	_leave("");
+}
diff --git a/fs/fscache/fsc-fsdef.c b/fs/fscache/fsc-fsdef.c
new file mode 100644
index 0000000..7a0d1c0
--- /dev/null
+++ b/fs/fscache/fsc-fsdef.c
@@ -0,0 +1,111 @@
+/* Filesystem index definition
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL CACHE
+#include <linux/module.h>
+#include "fsc-internal.h"
+
+static uint16_t fscache_fsdef_netfs_get_key(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax);
+
+static uint16_t fscache_fsdef_netfs_get_aux(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax);
+
+static fscache_checkaux_t fscache_fsdef_netfs_check_aux(void *cookie_netfs_data,
+							const void *data,
+							uint16_t datalen);
+
+struct fscache_cookie_def fscache_fsdef_netfs_def = {
+	.name		= "FSDEF.netfs",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= fscache_fsdef_netfs_get_key,
+	.get_aux	= fscache_fsdef_netfs_get_aux,
+	.check_aux	= fscache_fsdef_netfs_check_aux,
+};
+
+static struct fscache_cookie_def fscache_fsdef_index_def = {
+	.name		= ".FS-Cache",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+};
+
+struct fscache_cookie fscache_fsdef_index = {
+	.usage		= ATOMIC_INIT(1),
+	.lock		= SPIN_LOCK_UNLOCKED,
+	.backing_objects = HLIST_HEAD_INIT,
+	.def		= &fscache_fsdef_index_def,
+};
+
+EXPORT_SYMBOL(fscache_fsdef_index);
+
+/*
+ * get the key data for an FSDEF index record
+ */
+static uint16_t fscache_fsdef_netfs_get_key(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax)
+{
+	const struct fscache_netfs *netfs = cookie_netfs_data;
+	unsigned klen;
+
+	_enter("{%s.%u},", netfs->name, netfs->version);
+
+	klen = strlen(netfs->name);
+	if (klen > bufmax)
+		return 0;
+
+	memcpy(buffer, netfs->name, klen);
+	return klen;
+}
+
+/*
+ * get the auxilliary data for an FSDEF index record
+ */
+static uint16_t fscache_fsdef_netfs_get_aux(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax)
+{
+	const struct fscache_netfs *netfs = cookie_netfs_data;
+	unsigned dlen;
+
+	_enter("{%s.%u},", netfs->name, netfs->version);
+
+	dlen = sizeof(uint32_t);
+	if (dlen > bufmax)
+		return 0;
+
+	memcpy(buffer, &netfs->version, dlen);
+	return dlen;
+}
+
+/*
+ * check that the version stored in the auxilliary data is correct
+ */
+static fscache_checkaux_t fscache_fsdef_netfs_check_aux(void *cookie_netfs_data,
+							const void *data,
+							uint16_t datalen)
+{
+	struct fscache_netfs *netfs = cookie_netfs_data;
+	uint32_t version;
+
+	_enter("{%s},,%hu", netfs->name, datalen);
+
+	if (datalen != sizeof(version)) {
+		_leave(" = OBSOLETE [dl=%d v=%zu]", datalen, sizeof(version));
+		return FSCACHE_CHECKAUX_OBSOLETE;
+	}
+
+	memcpy(&version, data, sizeof(version));
+	if (version != netfs->version) {
+		_leave(" = OBSOLETE [ver=%x net=%x]", version, netfs->version);
+		return FSCACHE_CHECKAUX_OBSOLETE;
+	}
+
+	_leave(" = OKAY");
+	return FSCACHE_CHECKAUX_OKAY;
+}
diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
new file mode 100644
index 0000000..875b8a9
--- /dev/null
+++ b/fs/fscache/fsc-internal.h
@@ -0,0 +1,376 @@
+/* Internal definitions for FS-Cache
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * Lock order, in the order in which multiple locks should be obtained:
+ * - fscache_addremove_sem
+ * - cookie->lock
+ * - cookie->parent->lock
+ * - cache->object_list_lock
+ * - object->lock
+ * - object->parent->lock
+ * - fscache_thread_lock
+ *
+ */
+
+#include <linux/fscache-cache.h>
+#include <linux/sched.h>
+
+#define FSCACHE_MIN_THREADS	4
+#define FSCACHE_MAX_THREADS	32
+
+/*
+ * fsc-cache.c
+ */
+extern struct list_head fscache_cache_list;
+extern struct rw_semaphore fscache_addremove_sem;
+extern wait_queue_head_t fscache_clearance_wq;
+
+extern struct fscache_cache *fscache_select_cache_for_object(
+	struct fscache_cookie *);
+
+/*
+ * fsc-cookie.c
+ */
+extern struct kmem_cache *fscache_cookie_jar;
+
+extern void fscache_cookie_init_once(void *, struct kmem_cache *,
+				     unsigned long);
+extern void __fscache_cookie_put(struct fscache_cookie *);
+
+/*
+ * fsc-fsdef.c
+ */
+extern struct fscache_cookie fscache_fsdef_index;
+extern struct fscache_cookie_def fscache_fsdef_netfs_def;
+
+/*
+ * fsc-main.c
+ */
+extern unsigned fscache_defer_lookup;
+extern unsigned fscache_defer_create;
+extern unsigned fscache_debug;
+extern struct kset fscache_kset;
+
+extern int fscache_wait_bit(void *);
+extern int fscache_wait_bit_interruptible(void *);
+
+/*
+ * fsc-object.c
+ */
+extern void fscache_object_state_machine(struct fscache_object *);
+extern void fscache_withdrawing_object(struct fscache_cache *,
+				       struct fscache_object *);
+
+/*
+ * fsc-stats.c
+ */
+#ifdef CONFIG_FSCACHE_STATS
+extern atomic_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];
+extern atomic_t fscache_n_objs_processed[FSCACHE_MAX_THREADS];
+
+extern atomic_t fscache_n_op_pend;
+extern atomic_t fscache_n_op_run;
+extern atomic_t fscache_n_op_enqueue;
+extern atomic_t fscache_n_op_requeue;
+extern atomic_t fscache_n_op_release;
+
+extern atomic_t fscache_n_attr_changed;
+extern atomic_t fscache_n_attr_changed_ok;
+extern atomic_t fscache_n_attr_changed_nobufs;
+extern atomic_t fscache_n_attr_changed_nomem;
+extern atomic_t fscache_n_attr_changed_calls;
+
+extern atomic_t fscache_n_allocs;
+extern atomic_t fscache_n_allocs_ok;
+extern atomic_t fscache_n_allocs_wait;
+extern atomic_t fscache_n_allocs_nobufs;
+extern atomic_t fscache_n_alloc_ops;
+extern atomic_t fscache_n_alloc_op_waits;
+
+extern atomic_t fscache_n_retrievals;
+extern atomic_t fscache_n_retrievals_ok;
+extern atomic_t fscache_n_retrievals_wait;
+extern atomic_t fscache_n_retrievals_nodata;
+extern atomic_t fscache_n_retrievals_nobufs;
+extern atomic_t fscache_n_retrievals_intr;
+extern atomic_t fscache_n_retrievals_nomem;
+extern atomic_t fscache_n_retrieval_ops;
+extern atomic_t fscache_n_retrieval_op_waits;
+
+extern atomic_t fscache_n_stores;
+extern atomic_t fscache_n_stores_ok;
+extern atomic_t fscache_n_stores_again;
+extern atomic_t fscache_n_stores_nobufs;
+extern atomic_t fscache_n_stores_oom;
+extern atomic_t fscache_n_store_ops;
+extern atomic_t fscache_n_store_calls;
+
+extern atomic_t fscache_n_marks;
+extern atomic_t fscache_n_uncaches;
+
+extern atomic_t fscache_n_acquires;
+extern atomic_t fscache_n_acquires_null;
+extern atomic_t fscache_n_acquires_no_cache;
+extern atomic_t fscache_n_acquires_ok;
+extern atomic_t fscache_n_acquires_nobufs;
+extern atomic_t fscache_n_acquires_oom;
+
+extern atomic_t fscache_n_updates;
+extern atomic_t fscache_n_updates_null;
+extern atomic_t fscache_n_updates_run;
+
+extern atomic_t fscache_n_relinquishes;
+extern atomic_t fscache_n_relinquishes_null;
+extern atomic_t fscache_n_relinquishes_waitcrt;
+
+extern atomic_t fscache_n_cookie_index;
+extern atomic_t fscache_n_cookie_data;
+extern atomic_t fscache_n_cookie_special;
+
+extern atomic_t fscache_n_object_alloc;
+extern atomic_t fscache_n_object_no_alloc;
+extern atomic_t fscache_n_object_lookups;
+extern atomic_t fscache_n_object_lookups_negative;
+extern atomic_t fscache_n_object_lookups_positive;
+extern atomic_t fscache_n_object_created;
+extern atomic_t fscache_n_object_avail;
+extern atomic_t fscache_n_object_boosted;
+
+static inline void fscache_stat(atomic_t *stat)
+{
+	atomic_inc(stat);
+}
+#else
+
+#define fscache_stat(stat) do {} while(0)
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+extern atomic_t fscache_obj_instantiate_histogram[HZ];
+extern atomic_t fscache_objs_histogram[HZ];
+extern atomic_t fscache_ops_histogram[HZ];
+extern atomic_t fscache_retrieval_delay_histogram[HZ];
+extern atomic_t fscache_retrieval_histogram[HZ];
+
+static inline void fscache_hist(atomic_t histogram[], unsigned long start_jif)
+{
+	unsigned long jif = jiffies - start_jif;
+	if (jif >= HZ)
+		jif = HZ - 1;
+	atomic_inc(&histogram[jif]);
+}
+
+#else
+#define fscache_hist(hist, start_jif) do {} while(0)
+#endif
+
+#ifdef CONFIG_FSCACHE_PROC
+extern int __init fscache_proc_init(void);
+extern void fscache_proc_cleanup(void);
+#else
+#define fscache_proc_init()	(0)
+#define fscache_proc_cleanup()	do {} while(0)
+#endif
+
+/*
+ * fsc-threads.c
+ */
+extern void fscache_start_operations(struct fscache_object *);
+extern void fscache_enqueue_object(struct fscache_object *);
+extern void fscache_enqueue_dependents(struct fscache_object *);
+extern void fscache_dequeue_object(struct fscache_object *);
+extern void fscache_boost_object(struct fscache_object *);
+extern int fscache_init_threads(void);
+extern void fscache_kill_threads(void);
+
+/*
+ * raise an event on an object
+ * - if the event is not masked for that object, then the object is
+ *   queued for attention by the thread pool.
+ */
+static inline void fscache_raise_event(struct fscache_object *object,
+				       unsigned event)
+{
+	if (!test_and_set_bit(event, &object->events) &&
+	    test_bit(event, &object->event_mask))
+		fscache_enqueue_object(object);
+}
+
+/*
+ * drop a reference to a cookie
+ */
+static inline void fscache_cookie_put(struct fscache_cookie *cookie)
+{
+	BUG_ON(atomic_read(&cookie->usage) <= 0);
+	if (atomic_dec_and_test(&cookie->usage))
+		__fscache_cookie_put(cookie);
+}
+
+/*
+ * get an extra reference to a netfs retrieval context
+ */
+static inline
+void *fscache_get_context(struct fscache_cookie *cookie, void *context)
+{
+	if (cookie->def->get_context)
+		cookie->def->get_context(cookie->netfs_data, context);
+	return context;
+}
+
+/*
+ * release a reference to a netfs retrieval context
+ */
+static inline
+void fscache_put_context(struct fscache_cookie *cookie, void *context)
+{
+	if (cookie->def->put_context)
+		cookie->def->put_context(cookie->netfs_data, context);
+}
+
+/*****************************************************************************/
+/*
+ * debug tracing
+ */
+#define dbgprintk(FMT,...) \
+	printk("[%-6.6s] "FMT"\n", current->comm ,##__VA_ARGS__)
+
+/* make sure we maintain the format strings, even when debugging is disabled */
+static inline __attribute__((format(printf, 1, 2)))
+void _dbprintk(const char *fmt, ...)
+{
+}
+
+#define kenter(FMT, ...) dbgprintk("==> %s("FMT")", __FUNCTION__ ,##__VA_ARGS__)
+#define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __FUNCTION__ ,##__VA_ARGS__)
+#define kdebug(FMT, ...) dbgprintk(FMT ,##__VA_ARGS__)
+
+#define kjournal(FMT, ...) _dbprintk(FMT ,##__VA_ARGS__)
+
+#ifdef __KDEBUG
+#define _enter(FMT, ...) kenter(FMT ,##__VA_ARGS__)
+#define _leave(FMT, ...) kleave(FMT ,##__VA_ARGS__)
+#define _debug(FMT, ...) kdebug(FMT ,##__VA_ARGS__)
+
+#elif defined(CONFIG_FSCACHE_DEBUG)
+#define _enter(FMT, ...)			\
+do {						\
+	if (__do_kdebug(ENTER))			\
+		kenter(FMT ,##__VA_ARGS__);	\
+} while(0)
+
+#define _leave(FMT, ...)			\
+do {						\
+	if (__do_kdebug(LEAVE))			\
+		kleave(FMT ,##__VA_ARGS__);	\
+} while(0)
+
+#define _debug(FMT, ...)			\
+do {						\
+	if (__do_kdebug(DEBUG))			\
+		kdebug(FMT ,##__VA_ARGS__);	\
+} while(0)
+
+#else
+#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define _debug(FMT,...)	_dbprintk(FMT ,##__VA_ARGS__)
+#endif
+
+/*
+ * determine whether a particular optional debugging point should be logged
+ * - we need to go through three steps to persuade cpp to correctly join the
+ *   shorthand in FSCACHE_DEBUG_LEVEL with its prefix
+ */
+#define ____do_kdebug(LEVEL, POINT) \
+	unlikely((fscache_debug & (FSCACHE_POINT_##POINT << (FSCACHE_DEBUG_ ## LEVEL * 3))))
+#define ___do_kdebug(LEVEL, POINT) \
+	____do_kdebug(LEVEL, POINT)
+#define __do_kdebug(POINT) \
+	___do_kdebug(FSCACHE_DEBUG_LEVEL, POINT)
+
+#define FSCACHE_DEBUG_CACHE	0
+#define FSCACHE_DEBUG_COOKIE	1
+#define FSCACHE_DEBUG_PAGE	2
+#define FSCACHE_DEBUG_THREAD	3
+
+#define FSCACHE_POINT_ENTER	1
+#define FSCACHE_POINT_LEAVE	2
+#define FSCACHE_POINT_DEBUG	4
+
+#ifndef FSCACHE_DEBUG_LEVEL
+#define FSCACHE_DEBUG_LEVEL CACHE
+#endif
+
+/*
+ * assertions
+ */
+#if 1 // defined(__KDEBUGALL)
+
+#define ASSERT(X)							\
+do {									\
+	if (unlikely(!(X))) {						\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		BUG();							\
+	}								\
+} while(0)
+
+#define ASSERTCMP(X, OP, Y)						\
+do {									\
+	if (unlikely(!((X) OP (Y)))) {					\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		       (unsigned long)(X), (unsigned long)(Y));		\
+		BUG();							\
+	}								\
+} while(0)
+
+#define ASSERTIF(C, X)							\
+do {									\
+	if (unlikely((C) && !(X))) {					\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		BUG();							\
+	}								\
+} while(0)
+
+#define ASSERTIFCMP(C, X, OP, Y)					\
+do {									\
+	if (unlikely((C) && !((X) OP (Y)))) {				\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		       (unsigned long)(X), (unsigned long)(Y));		\
+		BUG();							\
+	}								\
+} while(0)
+
+#else
+
+#define ASSERT(X)				\
+do {						\
+} while(0)
+
+#define ASSERTCMP(X, OP, Y)			\
+do {						\
+} while(0)
+
+#define ASSERTIF(C, X)				\
+do {						\
+} while(0)
+
+#define ASSERTIFCMP(C, X, OP, Y)		\
+do {						\
+} while(0)
+
+#endif /* assert or not */
diff --git a/fs/fscache/fsc-main.c b/fs/fscache/fsc-main.c
new file mode 100644
index 0000000..fc19117
--- /dev/null
+++ b/fs/fscache/fsc-main.c
@@ -0,0 +1,127 @@
+/* General filesystem local caching manager
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL CACHE
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/slab.h>
+#include "fsc-internal.h"
+
+MODULE_DESCRIPTION("FS Cache Manager");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
+
+unsigned fscache_defer_lookup = 1;
+module_param_named(defer_lookup, fscache_defer_lookup, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_defer_lookup, "Defer cookie lookup to background thread");
+
+unsigned fscache_defer_create = 1;
+module_param_named(defer_create, fscache_defer_create, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_defer_create, "Defer cookie creation to background thread");
+
+unsigned fscache_debug;
+module_param_named(debug, fscache_debug, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_debug, "FS-Cache debugging mask");
+
+static struct sysfs_ops fscache_sysfs_ops = {
+};
+
+static struct kobj_type fscache_ktype = {
+	.sysfs_ops	= &fscache_sysfs_ops,
+};
+
+struct kset fscache_kset = {
+	.kobj.name	= "fscache",
+	.kobj.kset	= &fs_subsys,
+	.ktype		= &fscache_ktype,
+};
+
+/*
+ * initialise the fs caching module
+ */
+static int __init fscache_init(void)
+{
+	int ret;
+
+	ret = fscache_proc_init();
+	if (ret < 0)
+		goto error_proc;
+
+	ret = fscache_init_threads();
+	if (ret < 0)
+		goto error_init_threads;
+
+	fscache_cookie_jar = kmem_cache_create("fscache_cookie_jar",
+					       sizeof(struct fscache_cookie),
+					       0,
+					       0,
+					       fscache_cookie_init_once);
+	if (!fscache_cookie_jar) {
+		printk(KERN_NOTICE
+		       "FS-Cache: Failed to allocate a cookie jar\n");
+		ret = -ENOMEM;
+		goto error_cookie_jar;
+	}
+
+	ret = kset_register(&fscache_kset);
+	if (ret < 0)
+		goto error_kset;
+
+	printk(KERN_NOTICE "FS-Cache: Loaded\n");
+	return 0;
+
+error_kset:
+	kmem_cache_destroy(fscache_cookie_jar);
+error_cookie_jar:
+	fscache_kill_threads();
+error_init_threads:
+	fscache_proc_cleanup();
+error_proc:
+	return ret;
+}
+
+fs_initcall(fscache_init);
+
+/*
+ * clean up on module removal
+ */
+static void __exit fscache_exit(void)
+{
+	_enter("");
+
+	kset_unregister(&fscache_kset);
+	kmem_cache_destroy(fscache_cookie_jar);
+	fscache_kill_threads();
+	fscache_proc_cleanup();
+	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
+}
+
+module_exit(fscache_exit);
+
+/*
+ * wait_on_bit() sleep function for uninterruptible waiting
+ */
+int fscache_wait_bit(void *flags)
+{
+	schedule();
+	return 0;
+}
+
+/*
+ * wait_on_bit() sleep function for interruptible waiting
+ */
+int fscache_wait_bit_interruptible(void *flags)
+{
+	schedule();
+	return signal_pending(current);
+}
diff --git a/fs/fscache/fsc-manage.c b/fs/fscache/fsc-manage.c
new file mode 100644
index 0000000..42fef97
--- /dev/null
+++ b/fs/fscache/fsc-manage.c
@@ -0,0 +1,260 @@
+/* Manage cache objects
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL PAGE
+#include <linux/module.h>
+#include <linux/fscache-cache.h>
+#include <linux/buffer_head.h>
+#include <linux/pagevec.h>
+#include "fsc-internal.h"
+
+/*
+ * wait for a slow operation to float to the front of the op queue, then
+ * effectively suspend processing on this object till the calling process
+ * context has completed the operation
+ * - this prevents kfscached being hogged by a really slow op
+ */
+#if 0
+static int fscache_slow_op(struct fscache_object *object,
+			   struct fscache_operation *op)
+{
+	int ret;
+
+	kenter("");
+
+	if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
+		wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
+
+	if (test_bit(FSCACHE_OP_IN_PROGRESS, &op->flags))
+		ret = -EINPROGRESS;
+	else
+		ret = 0;
+
+	kleave(" = %d", ret);
+	return ret;
+}
+#endif
+
+/*
+ * reserve space for an object
+ */
+int __fscache_reserve_space(struct fscache_cookie *cookie, loff_t size)
+{
+#if 0
+	struct fscache_operation *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%llu,", cookie, size);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+
+	op = kzalloc(sizeof(*op), GFP_KERNEL);
+	if (!op) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	op->processor = fscache_slow_op;
+	__set_bit(FSCACHE_OP_WAITING, &op->flags);
+	__set_bit(FSCACHE_OP_IN_PROGRESS, &op->flags);
+
+	spin_lock(&cookie->lock);
+
+	ret = -ENOBUFS;
+	if (hlist_empty(&cookie->backing_objects))
+		goto error;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+	if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
+		goto error;
+
+	ret = -EOPNOTSUPP;
+	if (!object->cache->ops->reserve_space)
+		goto error;
+
+	/* prevent the file from being uncached whilst we access it and exclude
+	 * write attempts on pages
+	 */
+	ret = -ENOBUFS;
+	if (!object->cache->ops->grab_object(object))
+		goto error;
+	list_add_tail(&op->link, &object->operations);
+
+	if (!test_and_set_bit(FSCACHE_OBJECT_BUSY, &object->flags))
+		queue_work(fscache_workqueue, &object->work);
+
+	spin_unlock(&cookie->lock);
+
+	/* wait for the operation queue to be whittled down */
+	if (wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
+			fscache_wait_bit_interruptible, TASK_INTERRUPTIBLE
+			) < 0) {
+		/* we were interrupted */
+		spin_lock(&cookie->lock);
+		if (!test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
+			queue_work(fscache_workqueue, &object->work);
+		if (!test_and_clear_bit(FSCACHE_OP_IN_PROGRESS, &op->flags))
+			BUG();
+		ret = -ERESTARTSYS;
+		goto out_locked;
+	}
+
+	/* okay - we're now in a position to make a reservation */
+	ret = -ENOBUFS;
+	if (test_bit(FSCACHE_OBJECT_ABORTED, &object->flags) ||
+	    test_bit(FSCACHE_IOERROR, &object->cache->flags))
+		goto out;
+
+	ret = -ERESTARTSYS;
+	if (signal_pending(current))
+		goto out;
+
+	/* ask the cache to honour the operation */
+	ret = object->cache->ops->reserve_space(object, size);
+
+out:
+	spin_lock(&cookie->lock);
+out_locked:
+	if (!test_and_clear_bit(FSCACHE_OP_IN_PROGRESS, &op->flags))
+		BUG();
+	queue_work(fscache_workqueue, &object->work);
+	spin_unlock(&cookie->lock);
+
+	kleave(" = %d", ret);
+	return ret;
+
+error:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+	kleave(" = %d", ret);
+	return ret;
+#endif
+	kleave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+
+EXPORT_SYMBOL(__fscache_reserve_space);
+
+#if 0
+/*
+ * pin an object into the cache
+ */
+int __fscache_pin_cookie(struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p", cookie);
+
+	if (hlist_empty(&cookie->backing_objects)) {
+		_leave(" = -ENOBUFS");
+		return -ENOBUFS;
+	}
+
+	/* not supposed to use this for indexes */
+	BUG_ON(cookie->def->type == FSCACHE_COOKIE_TYPE_INDEX);
+
+	/* prevent the file from being uncached whilst we access it and exclude
+	 * read and write attempts on pages
+	 */
+	down_write(&cookie->sem);
+
+	ret = -ENOBUFS;
+	if (!hlist_empty(&cookie->backing_objects)) {
+		/* get and pin the backing object */
+		object = hlist_entry(cookie->backing_objects.first,
+				     struct fscache_object, cookie_link);
+
+		if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
+			goto out;
+
+		if (!object->cache->ops->pin_object) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
+		/* prevent the cache from being withdrawn */
+		if (fscache_operation_lock(object)) {
+			if (object->cache->ops->grab_object(object)) {
+				/* ask the cache to honour the operation */
+				ret = object->cache->ops->pin_object(object);
+
+				object->cache->ops->put_object(object);
+			}
+
+			fscache_operation_unlock(object);
+		}
+	}
+
+out:
+	up_write(&cookie->sem);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+EXPORT_SYMBOL(__fscache_pin_cookie);
+
+/*
+ * unpin an object into the cache
+ */
+void __fscache_unpin_cookie(struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p", cookie);
+
+	if (hlist_empty(&cookie->backing_objects)) {
+		_leave(" [no obj]");
+		return;
+	}
+
+	/* not supposed to use this for indexes */
+	BUG_ON(cookie->def->type == FSCACHE_COOKIE_TYPE_INDEX);
+
+	/* prevent the file from being uncached whilst we access it and exclude
+	 * read and write attempts on pages
+	 */
+	down_write(&cookie->sem);
+
+	ret = -ENOBUFS;
+	if (!hlist_empty(&cookie->backing_objects)) {
+		/* get and unpin the backing object */
+		object = hlist_entry(cookie->backing_objects.first,
+				     struct fscache_object, cookie_link);
+
+		if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
+			goto out;
+
+		if (!object->cache->ops->unpin_object)
+			goto out;
+
+		/* prevent the cache from being withdrawn */
+		if (fscache_operation_lock(object)) {
+			if (object->cache->ops->grab_object(object)) {
+				/* ask the cache to honour the operation */
+				object->cache->ops->unpin_object(object);
+
+				object->cache->ops->put_object(object);
+			}
+
+			fscache_operation_unlock(object);
+		}
+	}
+
+out:
+	up_write(&cookie->sem);
+	_leave("");
+}
+
+EXPORT_SYMBOL(__fscache_unpin_cookie);
+#endif
diff --git a/fs/fscache/fsc-object.c b/fs/fscache/fsc-object.c
new file mode 100644
index 0000000..e25d377
--- /dev/null
+++ b/fs/fscache/fsc-object.c
@@ -0,0 +1,586 @@
+/* FS-Cache object state machine handler
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL COOKIE
+#include <linux/module.h>
+#include "fsc-internal.h"
+
+const char *fscache_object_states[] = {
+	[FSCACHE_OBJECT_INIT]		= "OBJECT_INIT",
+	[FSCACHE_OBJECT_LOOKING_UP]	= "OBJECT_LOOKING_UP",
+	[FSCACHE_OBJECT_CREATING]	= "OBJECT_CREATING",
+	[FSCACHE_OBJECT_AVAILABLE]	= "OBJECT_AVAILABLE",
+	[FSCACHE_OBJECT_ACTIVE]		= "OBJECT_ACTIVE",
+	[FSCACHE_OBJECT_UPDATING]	= "OBJECT_UPDATING",
+	[FSCACHE_OBJECT_DYING]		= "OBJECT_DYING",
+	[FSCACHE_OBJECT_LC_DYING]	= "OBJECT_LC_DYING",
+	[FSCACHE_OBJECT_ABORT_INIT]	= "OBJECT_ABORT_INIT",
+	[FSCACHE_OBJECT_RELEASING]	= "OBJECT_RELEASING",
+	[FSCACHE_OBJECT_RECYCLING]	= "OBJECT_RECYCLING",
+	[FSCACHE_OBJECT_WITHDRAWING]	= "OBJECT_WITHDRAWING",
+	[FSCACHE_OBJECT_DEAD]		= "OBJECT_DEAD",
+};
+
+EXPORT_SYMBOL(fscache_object_states);
+
+static void fscache_check_object_parent(struct fscache_object *);
+static void fscache_lookup_object(struct fscache_object *);
+static void fscache_object_available(struct fscache_object *);
+static void fscache_release_object(struct fscache_object *);
+static void fscache_withdraw_object(struct fscache_object *);
+
+/*
+ * object state machine processor
+ * - initiates parent lookup
+ * - does object lookup
+ * - does object creation
+ * - does object recycling and retirement
+ * - does object withdrawal
+ */
+void fscache_object_state_machine(struct fscache_object *object)
+{
+	ASSERT(object != NULL);
+
+	_enter("{OBJ%x,%s,%lx}",
+	       object->debug_id, fscache_object_states[object->state],
+	       object->events);
+
+	switch (object->state) {
+	case FSCACHE_OBJECT_INIT:
+		object->event_mask =
+			ULONG_MAX & ~(1 << FSCACHE_OBJECT_EV_CLEARED);
+		fscache_check_object_parent(object);
+		goto done;
+
+	case FSCACHE_OBJECT_LOOKING_UP:
+		fscache_lookup_object(object);
+		goto lookup_transit;
+
+	case FSCACHE_OBJECT_CREATING:
+		fscache_lookup_object(object);
+		goto lookup_transit;
+
+	case FSCACHE_OBJECT_AVAILABLE:
+		fscache_object_available(object);
+		goto active_transit;
+
+	case FSCACHE_OBJECT_ACTIVE:
+		goto active_transit;
+
+	case FSCACHE_OBJECT_UPDATING:
+		clear_bit(FSCACHE_OBJECT_EV_UPDATE, &object->events);
+		fscache_stat(&fscache_n_updates_run);
+		object->cache->ops->update_object(object);
+		goto active_transit;
+
+		/* object started dying during lookup */
+	case FSCACHE_OBJECT_LC_DYING:
+		object->event_mask &= ~(1 << FSCACHE_OBJECT_EV_UPDATE);
+		object->cache->ops->lookup_complete(object);
+
+		object->state = FSCACHE_OBJECT_DYING;
+		spin_lock(&object->lock);
+		if (test_and_clear_bit(FSCACHE_COOKIE_CREATING,
+				       &object->cookie->flags))
+			wake_up_bit(&object->cookie->flags,
+				    FSCACHE_COOKIE_CREATING);
+		spin_unlock(&object->lock);
+
+		/* wait for completion of active accessors */
+	case FSCACHE_OBJECT_DYING:
+	dying:
+		clear_bit(FSCACHE_OBJECT_EV_CLEARED, &object->events);
+		spin_lock(&object->lock);
+		_debug("dying OBJ%x {%d,%d}",
+		       object->debug_id, object->n_ops, object->n_children);
+		if (object->n_ops == 0 && object->n_children == 0) {
+			object->event_mask &=
+				~(1 << FSCACHE_OBJECT_EV_CLEARED);
+			object->event_mask |=
+				(1 << FSCACHE_OBJECT_EV_WITHDRAW) |
+				(1 << FSCACHE_OBJECT_EV_RETIRE) |
+				(1 << FSCACHE_OBJECT_EV_RELEASE) |
+				(1 << FSCACHE_OBJECT_EV_ERROR);
+		} else {
+			object->event_mask &=
+				~((1 << FSCACHE_OBJECT_EV_WITHDRAW) |
+				  (1 << FSCACHE_OBJECT_EV_RETIRE) |
+				  (1 << FSCACHE_OBJECT_EV_RELEASE) |
+				  (1 << FSCACHE_OBJECT_EV_ERROR));
+			object->event_mask |=
+				1 << FSCACHE_OBJECT_EV_CLEARED;
+		}
+		spin_unlock(&object->lock);
+		fscache_enqueue_dependents(object);
+		goto terminal_transit;
+
+		/* handle an abort during the init state */
+	case FSCACHE_OBJECT_ABORT_INIT:
+		_debug("handle abort init %lx", object->events);
+		object->event_mask &= ~(1 << FSCACHE_OBJECT_EV_UPDATE);
+		fscache_dequeue_object(object);
+
+		object->state = FSCACHE_OBJECT_DYING;
+		spin_lock(&object->lock);
+		if (test_and_clear_bit(FSCACHE_COOKIE_CREATING,
+				       &object->cookie->flags))
+			wake_up_bit(&object->cookie->flags,
+				    FSCACHE_COOKIE_CREATING);
+		spin_unlock(&object->lock);
+		goto dying;
+
+	case FSCACHE_OBJECT_RELEASING:
+	case FSCACHE_OBJECT_RECYCLING:
+		object->event_mask &=
+			~((1 << FSCACHE_OBJECT_EV_WITHDRAW) |
+			  (1 << FSCACHE_OBJECT_EV_RETIRE) |
+			  (1 << FSCACHE_OBJECT_EV_RELEASE) |
+			  (1 << FSCACHE_OBJECT_EV_ERROR));
+		fscache_release_object(object);
+		object->state = FSCACHE_OBJECT_DEAD;
+		goto terminal_transit;
+
+	case FSCACHE_OBJECT_WITHDRAWING:
+		object->event_mask &=
+			~((1 << FSCACHE_OBJECT_EV_WITHDRAW) |
+			  (1 << FSCACHE_OBJECT_EV_RETIRE) |
+			  (1 << FSCACHE_OBJECT_EV_RELEASE) |
+			  (1 << FSCACHE_OBJECT_EV_ERROR));
+		fscache_withdraw_object(object);
+		object->state = FSCACHE_OBJECT_DEAD;
+		goto terminal_transit;
+
+	case FSCACHE_OBJECT_DEAD:
+		printk(KERN_ERR "FS-Cache:"
+		       " Unexpected event in dead state %lx\n",
+		       object->events & object->event_mask);
+		BUG();
+
+	default:
+		printk(KERN_ERR "FS-Cache: Unknown object state %u\n",
+		       object->state);
+		BUG();
+	}
+
+	/* determine the transition from a lookup state */
+lookup_transit:
+	switch (fls(object->events & object->event_mask) - 1) {
+	case FSCACHE_OBJECT_EV_WITHDRAW:
+	case FSCACHE_OBJECT_EV_RETIRE:
+	case FSCACHE_OBJECT_EV_RELEASE:
+	case FSCACHE_OBJECT_EV_ERROR:
+		object->state = FSCACHE_OBJECT_LC_DYING;
+		break;
+	case FSCACHE_OBJECT_EV_REQUEUE:
+		break;
+	case -1:
+		break; /* sleep until event */
+	default:
+		goto unsupported_event;
+	}
+	goto done;
+
+	/* determine the transition from an active state */
+active_transit:
+	switch (fls(object->events & object->event_mask) - 1) {
+	case FSCACHE_OBJECT_EV_WITHDRAW:
+	case FSCACHE_OBJECT_EV_RETIRE:
+	case FSCACHE_OBJECT_EV_RELEASE:
+	case FSCACHE_OBJECT_EV_ERROR:
+		object->state = FSCACHE_OBJECT_DYING;
+		break;
+	case FSCACHE_OBJECT_EV_UPDATE:
+		object->state = FSCACHE_OBJECT_UPDATING;
+		break;
+	case -1:
+		object->state = FSCACHE_OBJECT_ACTIVE;
+		break; /* sleep until event */
+	default:
+		goto unsupported_event;
+	}
+	goto done;
+
+	/* determine the transition from a terminal state */
+terminal_transit:
+	switch (fls(object->events & object->event_mask) - 1) {
+	case FSCACHE_OBJECT_EV_WITHDRAW:
+		object->state = FSCACHE_OBJECT_WITHDRAWING;
+		break;
+	case FSCACHE_OBJECT_EV_RETIRE:
+		object->state = FSCACHE_OBJECT_RECYCLING;
+		break;
+	case FSCACHE_OBJECT_EV_RELEASE:
+		object->state = FSCACHE_OBJECT_RELEASING;
+		break;
+	case FSCACHE_OBJECT_EV_ERROR:
+		object->state = FSCACHE_OBJECT_WITHDRAWING;
+		break;
+	case FSCACHE_OBJECT_EV_CLEARED:
+		object->state = FSCACHE_OBJECT_DYING;
+		break;
+	case -1:
+		break; /* sleep until event */
+	default:
+		goto unsupported_event;
+	}
+
+done:
+	_leave(" [->%s]", fscache_object_states[object->state]);
+	return;
+
+unsupported_event:
+	printk(KERN_ERR "FS-Cache:"
+	       " Unsupported event %lx [mask %lx] in state %s\n",
+	       object->events, object->event_mask,
+	       fscache_object_states[object->state]);
+	BUG();
+}
+
+/*
+ * check the specified object's parent to see if we can make use of it
+ * immediately to do a creation
+ * - we may need to start the process of creating a parent and we need to wait
+ *   for the parent's lookup and creation to complete if it's not there yet
+ * - an object's cookie is pinned until we clear FSCACHE_COOKIE_CREATING on the
+ *   leaf-most cookies of the object and all its children
+ */
+static void fscache_check_object_parent(struct fscache_object *object)
+{
+	struct fscache_object *parent;
+
+	_enter("");
+	ASSERT(object->cookie != NULL);
+	ASSERT(object->cookie->parent != NULL);
+	ASSERT(list_empty(&object->work_link));
+
+	if (object->events & ((1 << FSCACHE_OBJECT_EV_ERROR) |
+			      (1 << FSCACHE_OBJECT_EV_RELEASE) |
+			      (1 << FSCACHE_OBJECT_EV_RETIRE) |
+			      (1 << FSCACHE_OBJECT_EV_WITHDRAW))) {
+		_debug("abort init %lx", object->events);
+		object->state = FSCACHE_OBJECT_ABORT_INIT;
+		return;
+	}
+
+	spin_lock(&object->cookie->lock);
+	spin_lock_nested(&object->cookie->parent->lock, 1);
+
+	parent = object->parent;
+	if (!parent) {
+		_debug("no parent");
+		set_bit(FSCACHE_OBJECT_EV_WITHDRAW, &object->events);
+	} else {
+		spin_lock_nested(&parent->lock, 1);
+		_debug("parent %s", fscache_object_states[parent->state]);
+
+		if (parent->state >= FSCACHE_OBJECT_DYING) {
+			_debug("bad parent");
+			set_bit(FSCACHE_OBJECT_EV_WITHDRAW, &object->events);
+		} else if (parent->state < FSCACHE_OBJECT_AVAILABLE) {
+			_debug("wait");
+			object->cache->ops->grab_object(object);
+			set_bit(FSCACHE_OBJECT_WAITING, &object->flags);
+			list_add(&object->work_link, &parent->dependents);
+			atomic_inc(&object->cache->thread_usage);
+			if (parent->state == FSCACHE_OBJECT_INIT)
+				fscache_enqueue_object(parent);
+		} else {
+			_debug("go");
+			parent->n_ops++;
+			object->lookup_jif = jiffies;
+			object->state = FSCACHE_OBJECT_LOOKING_UP;
+			set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+		}
+
+		spin_unlock(&parent->lock);
+	}
+
+	spin_unlock(&object->cookie->parent->lock);
+	spin_unlock(&object->cookie->lock);
+	_leave("");
+}
+
+/*
+ * look up an object in its cache
+ * - we hold an "access lock" on the parent object, so the parent object cannot
+ *   be withdrawn by either party till we've finished
+ * - an object's cookie is pinned until we clear FSCACHE_COOKIE_CREATING on the
+ *   leaf-most cookies of the object and all its children
+ */
+static void fscache_lookup_object(struct fscache_object *object)
+{
+	struct fscache_cookie *cookie = object->cookie;
+	struct fscache_object *parent;
+
+	_enter("");
+
+	parent = object->parent;
+	ASSERT(parent != NULL);
+	ASSERTCMP(parent->n_ops, >, 0);
+
+	/* make sure the parent is still available */
+	ASSERTCMP(parent->state, >=, FSCACHE_OBJECT_AVAILABLE);
+
+	if (parent->state >= FSCACHE_OBJECT_DYING ||
+	    test_bit(FSCACHE_IOERROR, &object->cache->flags)) {
+		_debug("unavailable");
+		set_bit(FSCACHE_OBJECT_EV_WITHDRAW, &object->events);
+		_leave("");
+		return;
+	}
+
+	_debug("LOOKUP \"%s/%s\" in \"%s\"",
+	       parent->cookie->def->name, cookie->def->name,
+	       object->cache->tag->name);
+
+	fscache_stat(&fscache_n_object_lookups);
+	object->cache->ops->lookup_object(object);
+
+	if (test_bit(FSCACHE_OBJECT_EV_ERROR, &object->events))
+		set_bit(FSCACHE_COOKIE_UNAVAILABLE, &cookie->flags);
+
+	_leave("");
+}
+
+/**
+ * fscache_object_lookup_negative - Note negative cookie lookup
+ * @object: Object pointing to cookie to mark
+ *
+ * Note negative lookup, permitting those waiting to read data from an already
+ * existing backing object to continue as there's no data for them to read.
+ */
+void fscache_object_lookup_negative(struct fscache_object *object)
+{
+	struct fscache_cookie *cookie = object->cookie;
+
+	_enter("{OBJ%x,%s}",
+	       object->debug_id, fscache_object_states[object->state]);
+
+	if (object->state == FSCACHE_OBJECT_LOOKING_UP) {
+		fscache_stat(&fscache_n_object_lookups_negative);
+
+		/* transit here to allow write requests to begin stacking up
+		 * and read requests to begin returning ENODATA */
+		object->state = FSCACHE_OBJECT_CREATING;
+
+		set_bit(FSCACHE_COOKIE_PENDING_FILL, &cookie->flags);
+		set_bit(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
+
+		_debug("wake up lookup %p", &cookie->flags);
+		smp_mb__before_clear_bit();
+		clear_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
+		clear_bit(FSCACHE_OBJECT_SYNC, &object->flags);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	} else {
+		ASSERTCMP(object->state, ==, FSCACHE_OBJECT_CREATING);
+	}
+
+	_leave("");
+}
+
+EXPORT_SYMBOL(fscache_object_lookup_negative);
+
+/**
+ * fscache_obtained_object - Note successful object lookup or creation
+ * @object: Object pointing to cookie to mark
+ *
+ * Note successful lookup and/or creation, permitting those waiting to write
+ * data to a backing object to continue.
+ *
+ * Note that after calling this, an object's cookie may be relinquished by the
+ * netfs, and so must be accessed with object lock held.
+ */
+void fscache_obtained_object(struct fscache_object *object)
+{
+	struct fscache_cookie *cookie = object->cookie;
+
+	_enter("{OBJ%x,%s}",
+	       object->debug_id, fscache_object_states[object->state]);
+
+	/* if we were still looking up, then we must have a positive lookup
+	 * result, in which case there may be data available */
+	if (object->state == FSCACHE_OBJECT_LOOKING_UP) {
+		fscache_stat(&fscache_n_object_lookups_positive);
+
+		clear_bit(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
+
+		object->state = FSCACHE_OBJECT_AVAILABLE;
+
+		smp_mb__before_clear_bit();
+		clear_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
+		clear_bit(FSCACHE_OBJECT_SYNC, &object->flags);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	} else {
+		ASSERTCMP(object->state, ==, FSCACHE_OBJECT_CREATING);
+		fscache_stat(&fscache_n_object_created);
+
+		object->state = FSCACHE_OBJECT_AVAILABLE;
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+		smp_wmb();
+	}
+
+	if (test_and_clear_bit(FSCACHE_COOKIE_CREATING, &cookie->flags))
+		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_CREATING);
+
+	_leave("");
+}
+
+EXPORT_SYMBOL(fscache_obtained_object);
+
+/*
+ * handle an object that has just become available
+ */
+static void fscache_object_available(struct fscache_object *object)
+{
+	_enter("{OBJ%x}", object->debug_id);
+
+	spin_lock(&object->lock);
+	if (test_and_clear_bit(FSCACHE_COOKIE_CREATING, &object->cookie->flags))
+		wake_up_bit(&object->cookie->flags, FSCACHE_COOKIE_CREATING);
+
+	spin_lock_nested(&object->parent->lock, 1);
+	object->parent->n_ops--;
+	if (object->parent->n_ops == 0)
+		fscache_raise_event(object->parent, FSCACHE_OBJECT_EV_CLEARED);
+	spin_unlock(&object->parent->lock);
+
+	if (object->n_ops > 0)
+		fscache_start_operations(object);
+	spin_unlock(&object->lock);
+
+	object->cache->ops->lookup_complete(object);
+	fscache_enqueue_dependents(object);
+
+	if (test_bit(FSCACHE_OBJECT_BOOSTED, &object->flags))
+		fscache_hist(fscache_obj_instantiate_histogram,
+			     object->lookup_jif);
+	fscache_stat(&fscache_n_object_avail);
+
+	_leave("");
+}
+
+/*
+ * drop an object's attachments
+ */
+static void fscache_drop_object(struct fscache_object *object)
+{
+	struct fscache_object *parent = object->parent;
+	struct fscache_cache *cache = object->cache;
+
+	_enter("{OBJ%x,%d}", object->debug_id, object->n_children);
+
+	spin_lock(&cache->object_list_lock);
+	list_del_init(&object->cache_link);
+	spin_unlock(&cache->object_list_lock);
+
+	cache->ops->drop_object(object);
+
+	if (parent) {
+		_debug("release parent OBJ%x {%d}",
+		       parent->debug_id, parent->n_children);
+
+		spin_lock(&parent->lock);
+		parent->n_children--;
+		if (parent->n_children == 0)
+			fscache_raise_event(parent, FSCACHE_OBJECT_EV_CLEARED);
+		spin_unlock(&parent->lock);
+		object->parent = NULL;
+	}
+
+	/* this just shifts the object release to the fscache thread pool */
+	object->cache->ops->put_object(object);
+}
+
+/*
+ * release or recycle an object
+ */
+static void fscache_release_object(struct fscache_object *object)
+{
+	_enter("");
+
+	fscache_drop_object(object);
+
+	_leave("");
+}
+
+/*
+ * withdraw an object from active service
+ */
+static void fscache_withdraw_object(struct fscache_object *object)
+{
+	struct fscache_cookie *cookie;
+	bool detached;
+
+	_enter("");
+
+	spin_lock(&object->lock);
+	cookie = object->cookie;
+	if (cookie) {
+		/* need to get the cookie lock before the object lock, starting
+		 * from the object pointer */
+		atomic_inc(&cookie->usage);
+		spin_unlock(&object->lock);
+
+		detached = false;
+		spin_lock(&cookie->lock);
+		spin_lock(&object->lock);
+
+		if (object->cookie == cookie) {
+			hlist_del_init(&object->cookie_link);
+			object->cookie = NULL;
+			detached = true;
+		}
+		spin_unlock(&cookie->lock);
+		fscache_cookie_put(cookie);
+		if (detached)
+			fscache_cookie_put(cookie);
+	}
+
+	spin_unlock(&object->lock);
+
+	fscache_drop_object(object);
+
+	_leave("");
+}
+
+/*
+ * withdraw an object from active service at the behest of the cache
+ * - need break the links to a cached object cookie
+ * - called under two situations:
+ *   (1) recycler decides to reclaim an in-use object
+ *   (2) a cache is unmounted
+ * - have to take care as the cookie can be being relinquished by the netfs
+ *   simultaneously
+ * - the object is pinned by the caller holding a refcount on it
+ */
+void fscache_withdrawing_object(struct fscache_cache *cache,
+				struct fscache_object *object)
+{
+	bool enqueue = false;
+
+	_enter(",OBJ%x", object->debug_id);
+
+	spin_lock(&object->lock);
+	if (object->state < FSCACHE_OBJECT_WITHDRAWING) {
+		object->state = FSCACHE_OBJECT_WITHDRAWING;
+		enqueue = true;
+	}
+	spin_unlock(&object->lock);
+
+	if (enqueue)
+		fscache_enqueue_object(object);
+
+	_leave("");
+}
diff --git a/fs/fscache/fsc-page.c b/fs/fscache/fsc-page.c
new file mode 100644
index 0000000..481e55a
--- /dev/null
+++ b/fs/fscache/fsc-page.c
@@ -0,0 +1,863 @@
+/* Cache page management and data I/O routines
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL PAGE
+#include <linux/module.h>
+#include <linux/fscache-cache.h>
+#include <linux/buffer_head.h>
+#include <linux/pagevec.h>
+#include "fsc-internal.h"
+
+/*
+ * start an op running
+ */
+static void fscache_run_op(struct fscache_object *object,
+			   struct fscache_operation *op)
+{
+	object->n_in_progress++;
+	clear_bit(FSCACHE_OP_WAITING, &op->flags);
+	if (op->processor)
+		fscache_enqueue_operation(op);
+	fscache_stat(&fscache_n_op_run);
+}
+
+/*
+ * submit an exclusive operation for an object
+ * - other ops are excluded from running simultaneously with this one
+ */
+static int fscache_submit_exclusive_op(struct fscache_object *object,
+				       struct fscache_operation *op)
+{
+	int ret;
+
+	spin_lock(&object->lock);
+	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
+	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
+
+	ret = -ENOBUFS;
+	if (fscache_object_is_active(object)) {
+		op->object = object;
+		object->n_ops++;
+		object->n_exclusive++;	/* reads and writes must wait */
+
+		if (object->n_ops > 0) {
+			list_add_tail(&op->work_link, &object->pending_ops);
+			fscache_stat(&fscache_n_op_pend);
+		} else {
+			ASSERTCMP(object->n_in_progress, ==, 0);
+			fscache_run_op(object, op);
+		}
+
+		/* need to issue a new write op after this */
+		clear_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags);
+		ret = 0;
+	} else if (object->state == FSCACHE_OBJECT_CREATING) {
+		op->object = object;
+		object->n_ops++;
+		object->n_exclusive++;	/* reads and writes must wait */
+		list_add_tail(&op->work_link, &object->pending_ops);
+		fscache_stat(&fscache_n_op_pend);
+		ret = 0;
+	} else {
+		/* not allowed to submit ops in any other state */
+		BUG();
+	}
+
+	spin_unlock(&object->lock);
+	return ret;
+}
+
+/*
+ * submit an operation for an object
+ */
+static int fscache_submit_op(struct fscache_object *object,
+			     struct fscache_operation *op)
+{
+	int ret;
+
+	spin_lock(&object->lock);
+	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
+	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
+
+	if (fscache_object_is_active(object)) {
+		op->object = object;
+		object->n_ops++;
+
+		if (object->n_exclusive > 0) {
+			ASSERTCMP(object->n_in_progress, >, 0);
+			list_add_tail(&op->work_link, &object->pending_ops);
+			fscache_stat(&fscache_n_op_pend);
+		} else {
+			ASSERT(list_empty(&object->pending_ops));
+			ASSERTCMP(object->n_exclusive, ==, 0);
+			fscache_run_op(object, op);
+		}
+		ret = 0;
+	} else if (object->state == FSCACHE_OBJECT_CREATING) {
+		op->object = object;
+		object->n_ops++;
+		list_add_tail(&op->work_link, &object->pending_ops);
+		fscache_stat(&fscache_n_op_pend);
+		ret = 0;
+	} else if (!test_bit(FSCACHE_IOERROR, &object->cache->flags)) {
+		static bool once_only;
+		if (!once_only) {
+			once_only = true;
+			kdebug("no submit [OBJ%x %s]",
+			       object->debug_id,
+			       fscache_object_states[object->state]);
+			dump_stack();
+		}
+		ret = -ENOBUFS;
+	} else {
+		ret = -ENOBUFS;
+	}
+
+	spin_unlock(&object->lock);
+	return ret;
+}
+
+/*
+ * queue an object for withdrawal on error, aborting all following asynchronous
+ * operations
+ */
+static void fscache_abort_object(struct fscache_object *object)
+{
+	fscache_raise_event(object, FSCACHE_OBJECT_EV_ERROR);
+}
+
+/*
+ * actually apply the changed attributes to a cache object
+ */
+static void fscache_attr_changed_op(struct fscache_operation *op)
+{
+	struct fscache_object *object = op->object;
+
+	_enter("{OBJ%x}", object->debug_id);
+
+	fscache_stat(&fscache_n_attr_changed_calls);
+
+	if (fscache_object_is_active(object) &&
+	    object->cache->ops->attr_changed(object) < 0)
+		fscache_abort_object(object);
+
+	_leave("");
+}
+
+/*
+ * notification that the attributes on an object have changed
+ */
+int __fscache_attr_changed(struct fscache_cookie *cookie)
+{
+	struct fscache_operation *op;
+	struct fscache_object *object;
+
+	_enter("%p", cookie);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+
+	fscache_stat(&fscache_n_attr_changed);
+
+	op = kzalloc(sizeof(*op), GFP_KERNEL);
+	if (!op) {
+		fscache_stat(&fscache_n_attr_changed_nomem);
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	op->flags |= 1 << FSCACHE_OP_EXCLUSIVE;
+	op->processor = fscache_attr_changed_op;
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	if (fscache_submit_exclusive_op(object, op) < 0)
+		goto nobufs;
+	spin_unlock(&cookie->lock);
+	fscache_stat(&fscache_n_attr_changed_ok);
+	_leave(" = 0");
+	return 0;
+
+nobufs:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+	fscache_stat(&fscache_n_attr_changed_nobufs);
+	_leave(" = %d", -ENOBUFS);
+	return -ENOBUFS;
+}
+
+EXPORT_SYMBOL(__fscache_attr_changed);
+
+/*
+ * release a retrieval op reference
+ */
+static void fscache_release_retrieval_op(struct fscache_operation *_op)
+{
+	struct fscache_retrieval *op =
+		container_of(_op, struct fscache_retrieval, op);
+
+	_enter("");
+
+	fscache_hist(fscache_retrieval_histogram, op->start_time);
+	if (op->context)
+		fscache_put_context(op->op.object->cookie, op->context);
+
+	_leave("");
+}
+
+/*
+ * allocate a retrieval op
+ */
+static struct fscache_retrieval *fscache_alloc_retrieval(
+	struct address_space *mapping,
+	fscache_rw_complete_t end_io_func,
+	void *context)
+{
+	struct fscache_retrieval *op;
+
+	/* allocate a retrieval operation and attempt to submit it */
+	op = kzalloc(sizeof(*op), GFP_NOIO);
+	if (!op) {
+		fscache_stat(&fscache_n_retrievals_nomem);
+		return NULL;
+	}
+
+	atomic_set(&op->op.usage, 1);
+	op->op.flags	= (1 << FSCACHE_OP_WAITING) | (1 << FSCACHE_OP_SYNC);
+	op->op.release	= fscache_release_retrieval_op;
+	op->mapping	= mapping;
+	op->end_io_func	= end_io_func;
+	op->context	= context;
+	op->start_time	= jiffies;
+	INIT_LIST_HEAD(&op->op.work_link);
+	INIT_LIST_HEAD(&op->to_do);
+	return op;
+}
+
+/*
+ * wait for a deferred lookup to complete
+ */
+static int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+	unsigned long jif;
+
+	if (!test_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags))
+		return 0;
+
+	fscache_stat(&fscache_n_retrievals_wait);
+
+	/* tell the cookie dispatcher that this cookie is now being waited
+	 * upon for lookup completion */
+	spin_lock(&cookie->lock);
+	if (!hlist_empty(&cookie->backing_objects)) {
+		object = hlist_entry(cookie->backing_objects.first,
+				     struct fscache_object, cookie_link);
+		if (!test_and_set_bit(FSCACHE_OBJECT_SYNC, &object->flags))
+			fscache_boost_object(object);
+	}
+	spin_unlock(&cookie->lock);
+
+	jif = jiffies;
+	if (wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
+			fscache_wait_bit_interruptible,
+			TASK_INTERRUPTIBLE) != 0) {
+		fscache_stat(&fscache_n_retrievals_intr);
+		return -ERESTARTSYS;
+	}
+
+	ASSERT(!test_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags));
+
+	smp_rmb();
+	fscache_hist(fscache_retrieval_delay_histogram, jif);
+	return 0;
+}
+
+/*
+ * read a page from the cache or allocate a block in which to store it
+ * - we return:
+ *   -ENOMEM	- out of memory, nothing done
+ *   -ERESTARTSYS - interrupted
+ *   -ENOBUFS	- no backing object available in which to cache the block
+ *   -ENODATA	- no data available in the backing object for this block
+ *   0		- dispatched a read - it'll call end_io_func() when finished
+ */
+int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
+				 struct page *page,
+				 fscache_rw_complete_t end_io_func,
+				 void *context,
+				 gfp_t gfp)
+{
+	struct fscache_retrieval *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%p,,,", cookie, page);
+
+	fscache_stat(&fscache_n_retrievals);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(page, !=, NULL);
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	op = fscache_alloc_retrieval(page->mapping, end_io_func, context);
+	if (!op) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	ASSERTCMP(object->state, >, FSCACHE_COOKIE_LOOKING_UP);
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto nobufs_unlock;
+	spin_unlock(&cookie->lock);
+
+	fscache_stat(&fscache_n_retrieval_ops);
+
+	/* pin the netfs read context in case we need to do the actual netfs
+	 * read because we've encountered a cache read failure */
+	fscache_get_context(object->cookie, op->context);
+
+	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
+		_debug(">>> WT");
+		fscache_stat(&fscache_n_retrieval_op_waits);
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("<<< GO");
+	}
+
+	/* ask the cache to honour the operation */
+	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
+		ret = object->cache->ops->allocate_page(op, page, gfp);
+		if (ret == 0)
+			ret = -ENODATA;
+	} else {
+		ret = object->cache->ops->read_or_alloc_page(op, page, gfp);
+	}
+
+	if (ret == -ENOMEM)
+		fscache_stat(&fscache_n_retrievals_nomem);
+	else if (ret == -ERESTARTSYS)
+		fscache_stat(&fscache_n_retrievals_intr);
+	else if (ret == -ENODATA)
+		fscache_stat(&fscache_n_retrievals_nodata);
+	else if (ret < 0)
+		fscache_stat(&fscache_n_retrievals_nobufs);
+	else
+		fscache_stat(&fscache_n_retrievals_ok);
+
+	fscache_put_retrieval(op);
+	_leave(" = %d", ret);
+	return ret;
+
+nobufs_unlock:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+nobufs:
+	fscache_stat(&fscache_n_retrievals_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+
+EXPORT_SYMBOL(__fscache_read_or_alloc_page);
+
+/*
+ * read a list of page from the cache or allocate a block in which to store
+ * them
+ * - we return:
+ *   -ENOMEM	- out of memory, some pages may be being read
+ *   -ERESTARTSYS - interrupted, some pages may be being read
+ *   -ENOBUFS	- no backing object or space available in which to cache any
+ *                pages not being read
+ *   -ENODATA	- no data available in the backing object for some or all of
+ *                the pages
+ *   0		- dispatched a read on all pages
+ *
+ * end_io_func() will be called for each page read from the cache as it is
+ * finishes being read
+ *
+ * any pages for which a read is dispatched will be removed from pages and
+ * nr_pages
+ */
+int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
+				  struct address_space *mapping,
+				  struct list_head *pages,
+				  unsigned *nr_pages,
+				  fscache_rw_complete_t end_io_func,
+				  void *context,
+				  gfp_t gfp)
+{
+	fscache_pages_retrieval_func_t func;
+	struct fscache_retrieval *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,,%d,,,", cookie, *nr_pages);
+
+	fscache_stat(&fscache_n_retrievals);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(*nr_pages, >, 0);
+	ASSERT(!list_empty(pages));
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	op = fscache_alloc_retrieval(mapping, end_io_func, context);
+	if (!op)
+		return -ENOMEM;
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto nobufs_unlock;
+	spin_unlock(&cookie->lock);
+
+	fscache_stat(&fscache_n_retrieval_ops);
+
+	/* pin the netfs read context in case we need to do the actual netfs
+	 * read because we've encountered a cache read failure */
+	fscache_get_context(object->cookie, op->context);
+
+	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
+		_debug(">>> WT");
+		fscache_stat(&fscache_n_retrieval_op_waits);
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("<<< GO");
+	}
+
+	/* ask the cache to honour the operation */
+	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags))
+		func = object->cache->ops->allocate_pages;
+	else
+		func = object->cache->ops->read_or_alloc_pages;
+	ret = func(op, pages, nr_pages, gfp);
+
+	if (ret == -ENOMEM)
+		fscache_stat(&fscache_n_retrievals_nomem);
+	else if (ret == -ERESTARTSYS)
+		fscache_stat(&fscache_n_retrievals_intr);
+	else if (ret == -ENODATA)
+		fscache_stat(&fscache_n_retrievals_nodata);
+	else if (ret < 0)
+		fscache_stat(&fscache_n_retrievals_nobufs);
+	else
+		fscache_stat(&fscache_n_retrievals_ok);
+
+	fscache_put_retrieval(op);
+	_leave(" = %d", ret);
+	return ret;
+
+nobufs_unlock:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+nobufs:
+	fscache_stat(&fscache_n_retrievals_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+
+EXPORT_SYMBOL(__fscache_read_or_alloc_pages);
+
+/*
+ * allocate a block in the cache on which to store a page
+ * - we return:
+ *   -ENOMEM	- out of memory, nothing done
+ *   -ERESTARTSYS - interrupted
+ *   -ENOBUFS	- no backing object available in which to cache the block
+ *   0		- block allocated
+ */
+int __fscache_alloc_page(struct fscache_cookie *cookie,
+			 struct page *page,
+			 gfp_t gfp)
+{
+	struct fscache_retrieval *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%p,,,", cookie, page);
+
+	fscache_stat(&fscache_n_allocs);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(page, !=, NULL);
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	op = fscache_alloc_retrieval(page->mapping, NULL, NULL);
+	if (!op)
+		return -ENOMEM;
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto nobufs_unlock;
+	spin_unlock(&cookie->lock);
+
+	fscache_stat(&fscache_n_alloc_ops);
+
+	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
+		_debug(">>> WT");
+		fscache_stat(&fscache_n_alloc_op_waits);
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("<<< GO");
+	}
+
+	/* ask the cache to honour the operation */
+	ret = object->cache->ops->allocate_page(op, page, gfp);
+
+	if (ret < 0)
+		fscache_stat(&fscache_n_allocs_nobufs);
+	else
+		fscache_stat(&fscache_n_allocs_ok);
+
+	fscache_put_retrieval(op);
+	_leave(" = %d", ret);
+	return ret;
+
+nobufs_unlock:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+nobufs:
+	fscache_stat(&fscache_n_allocs_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+
+EXPORT_SYMBOL(__fscache_alloc_page);
+
+/*
+ * store a page in the cache in the background
+ */
+static void fscache_write_op(struct fscache_operation *_op)
+{
+	struct fscache_storage *op =
+		container_of(_op, struct fscache_storage, op);
+	struct fscache_object *object = op->op.object;
+	struct page *page;
+	unsigned n;
+	void *results[1];
+	int ret;
+
+	_enter("");
+
+	if (!fscache_object_is_active(object)) {
+		fscache_put_operation(&op->op);
+		_leave("");
+		return;
+	}
+
+	fscache_stat(&fscache_n_store_calls);
+
+	/* find a page to store */
+	spin_lock(&object->lock);
+
+	page = NULL;
+	n = radix_tree_gang_lookup(&object->stores, results, 0, 1);
+	if (n == 1) {
+		page = results[0];
+		_debug("gang %d [%lx]", n, page->index);
+		if (page->index <= op->store_limit)
+			radix_tree_delete(&object->stores, page->index);
+		else
+			goto superseded;
+	} else {
+		goto superseded;
+	}
+
+	spin_unlock(&object->lock);
+
+	if (page) {
+		ret = object->cache->ops->write_page(op, page);
+		end_page_fscache_write(page);
+		page_cache_release(page);
+		if (ret < 0) {
+			fscache_abort_object(object);
+			fscache_put_operation(&op->op);
+		} else {
+			fscache_enqueue_operation(&op->op);
+		}
+	}
+
+	_leave("");
+	return;
+
+superseded:
+	/* this writer is going away and there aren't any more things to
+	 * write */
+	_debug("cease");
+	clear_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags);
+	spin_unlock(&object->lock);
+	_leave("");
+}
+
+/*
+ * request a page be stored in the cache
+ * - returns:
+ *   -ENOMEM	- out of memory, nothing done
+ *   -ENOBUFS	- no backing object available in which to cache the page
+ *   0		- dispatched a write - it'll call end_io_func() when finished
+ *
+ * if the cookie still has a backing object at this point, that object can be
+ * in one of a few states with respect to storage processing:
+ *
+ *  (1) negative lookup, object not yet created (FSCACHE_COOKIE_CREATING is
+ *      set)
+ *
+ *	(a) no writes yet (set FSCACHE_COOKIE_PENDING_FILL and queue deferred
+ *	    fill op)
+ *
+ *	(b) writes deferred till post-creation (mark page for writing and
+ *	    return immediately)
+ *
+ *  (2) negative lookup, object created, initial fill being made from netfs
+ *      (FSCACHE_COOKIE_INITIAL_FILL is set)
+ *
+ *	(a) fill point not yet reached this page (mark page for writing and
+ *          return)
+ *
+ *	(b) fill point passed this page (queue op to store this page)
+ *
+ *  (3) object extant (queue op to store this page)
+ *
+ * any other state is invalid
+ */
+int __fscache_write_page(struct fscache_cookie *cookie,
+			 struct page *page,
+			 gfp_t gfp)
+{
+	struct fscache_storage *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%x,", cookie, (u32) page->flags);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERT(PageFsCache(page));
+
+	fscache_stat(&fscache_n_stores);
+
+	op = kzalloc(sizeof(*op), GFP_NOIO);
+	if (!op) {
+		fscache_stat(&fscache_n_stores_oom);
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
+	if (ret < 0) {
+		kfree(op);
+		fscache_stat(&fscache_n_stores_oom);
+		_leave(" = %d", ret);
+		return ret;
+	}
+
+	ret = -ENOBUFS;
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+	if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
+		goto nobufs;
+
+	/* add the page to the pending-storage radix tree on the backing
+	 * object */
+	spin_lock(&object->lock);
+
+	_debug("store limit %llx", (unsigned long long) object->store_limit);
+
+	ret = radix_tree_insert(&object->stores, page->index, page);
+	if (ret < 0) {
+		if (ret == -EEXIST)
+			goto already_queued;
+		_debug("insert failed %d", ret);
+		ret = -ENOBUFS;
+		goto nobufs_unlock;
+	}
+
+	page_cache_get(page);
+	if (TestSetPageFsCacheWrite(page))
+		BUG();
+
+	/* we only want one writer at a time, but we do need to queue new
+	 * writers after exclusive ops */
+	if (test_and_set_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags))
+		goto already_pending;
+
+	spin_unlock(&object->lock);
+
+	op->op.processor = fscache_write_op;
+	op->store_limit = object->store_limit;
+	INIT_LIST_HEAD(&op->op.work_link);
+
+	if (fscache_submit_op(object, &op->op) < 0) {
+		radix_tree_delete(&object->stores, page->index);
+		end_page_fscache_write(page);
+		page_cache_release(page);
+		ret = -ENOBUFS;
+		goto nobufs;
+	}
+
+	spin_unlock(&cookie->lock);
+	radix_tree_preload_end();
+	fscache_stat(&fscache_n_store_ops);
+	fscache_stat(&fscache_n_stores_ok);
+	_leave(" = 0");
+	return 0;
+
+already_queued:
+	fscache_stat(&fscache_n_stores_again);
+already_pending:
+	spin_unlock(&object->lock);
+	spin_unlock(&cookie->lock);
+	radix_tree_preload_end();
+	kfree(op);
+	fscache_stat(&fscache_n_stores_ok);
+	_leave(" = 0");
+	return 0;
+
+nobufs_unlock:
+	spin_unlock(&object->lock);
+nobufs:
+	spin_unlock(&cookie->lock);
+	radix_tree_preload_end();
+	kfree(op);
+	fscache_stat(&fscache_n_stores_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+
+EXPORT_SYMBOL(__fscache_write_page);
+
+/*
+ * remove a page from the cache
+ */
+void __fscache_uncache_page(struct fscache_cookie *cookie, struct page *page)
+{
+	struct fscache_object *object;
+
+	_enter(",%p", page);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(page, !=, NULL);
+
+	fscache_stat(&fscache_n_uncaches);
+
+	/* cache withdrawal may beat us to it */
+	if (!PageFsCache(page))
+		goto done;
+
+	/* get the object */
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto done_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	/* there might now be stuff on disk we could read */
+	clear_bit(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
+
+	/* only invoke the cache backend if we managed to mark the page
+	 * uncached here; this deals with synchronisation vs withdrawal */
+	if (TestClearPageFsCache(page) &&
+	    object->cache->ops->uncache_page) {
+		/* the cache backend releases the cookie lock */
+		object->cache->ops->uncache_page(object, page);
+		goto done;
+	}
+
+done_unlock:
+	spin_unlock(&cookie->lock);
+done:
+	_leave("");
+}
+
+EXPORT_SYMBOL(__fscache_uncache_page);
+
+/**
+ * fscache_mark_pages_cached - Mark pages as being cached
+ * @op: The retrieval op pages are being marked for
+ * @pagevec: The pages to be marked
+ *
+ * Mark a bunch of netfs pages as being cached.  After this is called,
+ * the netfs must call fscache_uncache_page() to remove the mark.
+ */
+void fscache_mark_pages_cached(struct fscache_retrieval *op,
+			       struct pagevec *pagevec)
+{
+	struct fscache_cookie *cookie = op->op.object->cookie;
+	unsigned long loop;
+
+#ifdef CONFIG_FSCACHE_STATS
+	atomic_add(pagevec->nr, &fscache_n_marks);
+#endif
+
+	for (loop = 0; loop < pagevec->nr; loop++) {
+		struct page *page = pagevec->pages[loop];
+
+		_debug("- mark %p{%lx}", page, page->index);
+		if (TestSetPageFsCache(page)) {
+			static bool once_only = false;
+			if (!once_only) {
+				once_only = true;
+				printk(KERN_WARNING "FS-Cache:"
+				       " Cookie type %s marked page %lx"
+				       " multiple times\n",
+				       cookie->def->name, page->index);
+			}
+		}
+	}
+
+	if (cookie->def->mark_pages_cached)
+		cookie->def->mark_pages_cached(cookie->netfs_data,
+					       op->mapping, pagevec);
+	pagevec_reinit(pagevec);
+}
+
+EXPORT_SYMBOL(fscache_mark_pages_cached);
diff --git a/fs/fscache/fsc-proc.c b/fs/fscache/fsc-proc.c
new file mode 100644
index 0000000..1ac9d5d
--- /dev/null
+++ b/fs/fscache/fsc-proc.c
@@ -0,0 +1,399 @@
+/* FS-Cache statistics viewing interface
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL THREAD
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "fsc-internal.h"
+
+struct fscache_proc {
+	unsigned			nlines;
+	const struct seq_operations	*ops;
+};
+
+struct proc_dir_entry *proc_fscache;
+
+EXPORT_SYMBOL(proc_fscache);
+
+static int fscache_proc_open(struct inode *inode, struct file *file);
+static void *fscache_proc_start(struct seq_file *m, loff_t *pos);
+static void fscache_proc_stop(struct seq_file *m, void *v);
+static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos);
+
+static const struct file_operations fscache_proc_fops = {
+	.open		= fscache_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+#ifdef CONFIG_FSCACHE_STATS
+static int fscache_stats_show(struct seq_file *m, void *v);
+static int fscache_pool_show(struct seq_file *m, void *v);
+
+static const struct seq_operations fscache_stats_ops = {
+	.start		= fscache_proc_start,
+	.stop		= fscache_proc_stop,
+	.next		= fscache_proc_next,
+	.show		= fscache_stats_show,
+};
+
+static const struct fscache_proc fscache_stats = {
+	.nlines		= 16,
+	.ops		= &fscache_stats_ops,
+};
+
+static const struct seq_operations fscache_pool_ops = {
+	.start		= fscache_proc_start,
+	.stop		= fscache_proc_stop,
+	.next		= fscache_proc_next,
+	.show		= fscache_pool_show,
+};
+
+static const struct fscache_proc fscache_pool = {
+	.nlines		= FSCACHE_MAX_THREADS + 2,
+	.ops		= &fscache_pool_ops,
+};
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+static int fscache_histogram_show(struct seq_file *m, void *v);
+
+static const struct seq_operations fscache_histogram_ops = {
+	.start		= fscache_proc_start,
+	.stop		= fscache_proc_stop,
+	.next		= fscache_proc_next,
+	.show		= fscache_histogram_show,
+};
+
+static const struct fscache_proc fscache_histogram = {
+	.nlines		= HZ + 1,
+	.ops		= &fscache_histogram_ops,
+};
+#endif
+
+#define FSC_DESC(SELECT, N) ((void *) (unsigned long) (((SELECT) << 16) | (N)))
+
+/*
+ * initialise the /proc/fs/fscache/ directory
+ */
+int __init fscache_proc_init(void)
+{
+	struct proc_dir_entry *p;
+
+	_enter("");
+
+	proc_fscache = proc_mkdir("fs/fscache", NULL);
+	if (!proc_fscache)
+		goto error_dir;
+	proc_fscache->owner = THIS_MODULE;
+
+#ifdef CONFIG_FSCACHE_STATS
+	p = create_proc_entry("stats", 0, proc_fscache);
+	if (!p)
+		goto error_stats;
+	p->proc_fops = &fscache_proc_fops;
+	p->owner = THIS_MODULE;
+	p->data = (void *) &fscache_stats;
+
+	p = create_proc_entry("pool", 0, proc_fscache);
+	if (!p)
+		goto error_pool;
+	p->proc_fops = &fscache_proc_fops;
+	p->owner = THIS_MODULE;
+	p->data = (void *) &fscache_pool;
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+	p = create_proc_entry("histogram", 0, proc_fscache);
+	if (!p)
+		goto error_histogram;
+	p->proc_fops = &fscache_proc_fops;
+	p->owner = THIS_MODULE;
+	p->data = (void *) &fscache_histogram;
+#endif
+
+	_leave(" = 0");
+	return 0;
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+error_histogram:
+#endif
+#ifdef CONFIG_FSCACHE_STATS
+	remove_proc_entry("pool", proc_fscache);
+error_pool:
+	remove_proc_entry("stats", proc_fscache);
+error_stats:
+#endif
+	remove_proc_entry("fs/fscache", NULL);
+error_dir:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+
+/*
+ * clean up the /proc/fs/fscache/ directory
+ */
+void fscache_proc_cleanup(void)
+{
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+	remove_proc_entry("histogram", proc_fscache);
+#endif
+#ifdef CONFIG_FSCACHE_STATS
+	remove_proc_entry("pool", proc_fscache);
+	remove_proc_entry("stats", proc_fscache);
+#endif
+	remove_proc_entry("fs/fscache", NULL);
+}
+
+/*
+ * open "/proc/fs/fscache/XXX" which provide statistics summaries
+ */
+static int fscache_proc_open(struct inode *inode, struct file *file)
+{
+	const struct fscache_proc *proc = PDE(inode)->data;
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, proc->ops);
+	if (ret == 0) {
+		m = file->private_data;
+		m->private = (void *) proc;
+	}
+	return ret;
+}
+
+/*
+ * set up the iterator to start reading from the first line
+ */
+static void *fscache_proc_start(struct seq_file *m, loff_t *_pos)
+{
+	if (*_pos == 0)
+		*_pos = 1;
+	return (void *)(unsigned long) *_pos;
+}
+
+/*
+ * move to the next line
+ */
+static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	const struct fscache_proc *proc = m->private;
+
+	(*pos)++;
+	return *pos > proc->nlines ? NULL : (void *)(unsigned long) *pos;
+}
+
+/*
+ * clean up after reading
+ */
+static void fscache_proc_stop(struct seq_file *m, void *v)
+{
+}
+
+#ifdef CONFIG_FSCACHE_STATS
+/*
+ * display the general statistics
+ */
+static int fscache_stats_show(struct seq_file *m, void *v)
+{
+	unsigned long line = (unsigned long) v;
+
+	switch (line) {
+	case 1:
+		seq_puts(m, "FS-Cache statistics\n");
+		break;
+
+	case 2:
+		seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
+			   atomic_read(&fscache_n_cookie_index),
+			   atomic_read(&fscache_n_cookie_data),
+			   atomic_read(&fscache_n_cookie_special));
+		break;
+
+	case 3:
+		seq_printf(m, "Objects: alc=%u nal=%u avl=%u\n",
+			   atomic_read(&fscache_n_object_alloc),
+			   atomic_read(&fscache_n_object_no_alloc),
+			   atomic_read(&fscache_n_object_avail));
+		break;
+
+	case 4:
+		seq_printf(m, "Pages  : mrk=%u unc=%u\n",
+			   atomic_read(&fscache_n_marks),
+			   atomic_read(&fscache_n_uncaches));
+		break;
+
+	case 5:
+		seq_printf(m, "Acquire: n=%u nul=%u noc=%u ok=%u nbf=%u"
+			   " oom=%u\n",
+			   atomic_read(&fscache_n_acquires),
+			   atomic_read(&fscache_n_acquires_null),
+			   atomic_read(&fscache_n_acquires_no_cache),
+			   atomic_read(&fscache_n_acquires_ok),
+			   atomic_read(&fscache_n_acquires_nobufs),
+			   atomic_read(&fscache_n_acquires_oom));
+		break;
+
+	case 6:
+		seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u bst=%u\n",
+			   atomic_read(&fscache_n_object_lookups),
+			   atomic_read(&fscache_n_object_lookups_negative),
+			   atomic_read(&fscache_n_object_lookups_positive),
+			   atomic_read(&fscache_n_object_created),
+			   atomic_read(&fscache_n_object_boosted));
+		break;
+
+	case 7:
+		seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
+			   atomic_read(&fscache_n_updates),
+			   atomic_read(&fscache_n_updates_null),
+			   atomic_read(&fscache_n_updates_run));
+		break;
+
+	case 8:
+		seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u\n",
+			   atomic_read(&fscache_n_relinquishes),
+			   atomic_read(&fscache_n_relinquishes_null),
+			   atomic_read(&fscache_n_relinquishes_waitcrt));
+		break;
+
+	case 9:
+		seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
+			   atomic_read(&fscache_n_attr_changed),
+			   atomic_read(&fscache_n_attr_changed_ok),
+			   atomic_read(&fscache_n_attr_changed_nobufs),
+			   atomic_read(&fscache_n_attr_changed_nomem),
+			   atomic_read(&fscache_n_attr_changed_calls));
+		break;
+
+	case 10:
+		seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u\n",
+			   atomic_read(&fscache_n_allocs),
+			   atomic_read(&fscache_n_allocs_ok),
+			   atomic_read(&fscache_n_allocs_wait),
+			   atomic_read(&fscache_n_allocs_nobufs));
+		break;
+	case 11:
+		seq_printf(m, "Allocs : ops=%u owt=%u\n",
+			   atomic_read(&fscache_n_alloc_ops),
+			   atomic_read(&fscache_n_alloc_op_waits));
+		break;
+
+	case 12:
+		seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
+			   " int=%u oom=%u\n",
+			   atomic_read(&fscache_n_retrievals),
+			   atomic_read(&fscache_n_retrievals_ok),
+			   atomic_read(&fscache_n_retrievals_wait),
+			   atomic_read(&fscache_n_retrievals_nodata),
+			   atomic_read(&fscache_n_retrievals_nobufs),
+			   atomic_read(&fscache_n_retrievals_intr),
+			   atomic_read(&fscache_n_retrievals_nomem));
+		break;
+	case 13:
+		seq_printf(m, "Retrvls: ops=%u owt=%u\n",
+			   atomic_read(&fscache_n_retrieval_ops),
+			   atomic_read(&fscache_n_retrieval_op_waits));
+		break;
+
+	case 14:
+		seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
+			   atomic_read(&fscache_n_stores),
+			   atomic_read(&fscache_n_stores_ok),
+			   atomic_read(&fscache_n_stores_again),
+			   atomic_read(&fscache_n_stores_nobufs),
+			   atomic_read(&fscache_n_stores_oom));
+		break;
+	case 15:
+		seq_printf(m, "Stores : ops=%u run=%u\n",
+			   atomic_read(&fscache_n_store_ops),
+			   atomic_read(&fscache_n_store_calls));
+		break;
+
+	case 16:
+		seq_printf(m, "Ops    : pend=%u run=%u enq=%u req=%u rel=%u\n",
+			   atomic_read(&fscache_n_op_pend),
+			   atomic_read(&fscache_n_op_run),
+			   atomic_read(&fscache_n_op_enqueue),
+			   atomic_read(&fscache_n_op_requeue),
+			   atomic_read(&fscache_n_op_release));
+		break;
+
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * display the per-pool-thread statistics
+ */
+static int fscache_pool_show(struct seq_file *m, void *v)
+{
+	unsigned line = (unsigned long) v;
+	unsigned x, y;
+
+	switch (line) {
+	case 1:
+		seq_puts(m, "THREAD  OPERS RUN OBJS RUN\n");
+		return 0;
+	case 2:
+		seq_puts(m, "======= ========= =========\n");
+		return 0;
+	case 3 ... FSCACHE_MAX_THREADS + 2:
+		x = atomic_read(&fscache_n_ops_processed[line - 3]);
+		y = atomic_read(&fscache_n_objs_processed[line - 3]);
+		if (x != 0 || y != 0)
+			seq_printf(m, "kfsc%02ud %9u %9u\n", line - 3, x, y);
+	default:
+		return 0;
+	}
+}
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+/*
+ * display the time-taken histogram
+ */
+static int fscache_histogram_show(struct seq_file *m, void *v)
+{
+	unsigned long index;
+	unsigned n[5], t;
+
+	switch ((unsigned long) v) {
+	case 1:
+		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS "
+			 " RETRV DLY RETRIEVLS\n");
+		return 0;
+	case 2:
+		seq_puts(m, "===== ===== ========= ========= ========="
+			 " ========= =========\n");
+		return 0;
+	default:
+		index = (unsigned long) v - 3;
+		n[0] = atomic_read(&fscache_obj_instantiate_histogram[index]);
+		n[1] = atomic_read(&fscache_ops_histogram[index]);
+		n[2] = atomic_read(&fscache_objs_histogram[index]);
+		n[3] = atomic_read(&fscache_retrieval_delay_histogram[index]);
+		n[4] = atomic_read(&fscache_retrieval_histogram[index]);
+		if (!(n[0] | n[1] | n[2] | n[3] | n[4]))
+			return 0;
+
+		t = (index * 1000) / HZ;
+
+		seq_printf(m, "%4lu  0.%03u %9u %9u %9u %9u %9u\n",
+			   index, t, n[0], n[1], n[2], n[3], n[4]);
+		return 0;
+	}
+}
+#endif
diff --git a/fs/fscache/fsc-stats.c b/fs/fscache/fsc-stats.c
new file mode 100644
index 0000000..15adbda
--- /dev/null
+++ b/fs/fscache/fsc-stats.c
@@ -0,0 +1,103 @@
+/* FS-Cache statistics
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL THREAD
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "fsc-internal.h"
+
+/*
+ * operation counters
+ */
+#ifdef CONFIG_FSCACHE_STATS
+atomic_t fscache_n_op_pend;
+atomic_t fscache_n_op_run;
+atomic_t fscache_n_op_enqueue;
+atomic_t fscache_n_op_requeue;
+atomic_t fscache_n_op_release;
+
+atomic_t fscache_n_attr_changed;
+atomic_t fscache_n_attr_changed_ok;
+atomic_t fscache_n_attr_changed_nobufs;
+atomic_t fscache_n_attr_changed_nomem;
+atomic_t fscache_n_attr_changed_calls;
+
+atomic_t fscache_n_allocs;
+atomic_t fscache_n_allocs_ok;
+atomic_t fscache_n_allocs_wait;
+atomic_t fscache_n_allocs_nobufs;
+atomic_t fscache_n_alloc_ops;
+atomic_t fscache_n_alloc_op_waits;
+
+atomic_t fscache_n_retrievals;
+atomic_t fscache_n_retrievals_ok;
+atomic_t fscache_n_retrievals_wait;
+atomic_t fscache_n_retrievals_nodata;
+atomic_t fscache_n_retrievals_nobufs;
+atomic_t fscache_n_retrievals_intr;
+atomic_t fscache_n_retrievals_nomem;
+atomic_t fscache_n_retrieval_ops;
+atomic_t fscache_n_retrieval_op_waits;
+
+atomic_t fscache_n_stores;
+atomic_t fscache_n_stores_ok;
+atomic_t fscache_n_stores_again;
+atomic_t fscache_n_stores_nobufs;
+atomic_t fscache_n_stores_oom;
+atomic_t fscache_n_store_ops;
+atomic_t fscache_n_store_calls;
+
+atomic_t fscache_n_marks;
+atomic_t fscache_n_uncaches;
+
+atomic_t fscache_n_acquires;
+atomic_t fscache_n_acquires_null;
+atomic_t fscache_n_acquires_no_cache;
+atomic_t fscache_n_acquires_ok;
+atomic_t fscache_n_acquires_nobufs;
+atomic_t fscache_n_acquires_oom;
+
+atomic_t fscache_n_updates;
+atomic_t fscache_n_updates_null;
+atomic_t fscache_n_updates_run;
+
+atomic_t fscache_n_relinquishes;
+atomic_t fscache_n_relinquishes_null;
+atomic_t fscache_n_relinquishes_waitcrt;
+
+atomic_t fscache_n_cookie_index;
+atomic_t fscache_n_cookie_data;
+atomic_t fscache_n_cookie_special;
+
+atomic_t fscache_n_object_alloc;
+atomic_t fscache_n_object_no_alloc;
+atomic_t fscache_n_object_lookups;
+atomic_t fscache_n_object_lookups_negative;
+atomic_t fscache_n_object_lookups_positive;
+atomic_t fscache_n_object_created;
+atomic_t fscache_n_object_avail;
+atomic_t fscache_n_object_boosted;
+
+/*
+ * the number of operations and objects processed by each thread in the pool
+ */
+atomic_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];
+atomic_t fscache_n_objs_processed[FSCACHE_MAX_THREADS];
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+atomic_t fscache_obj_instantiate_histogram[HZ];
+atomic_t fscache_objs_histogram[HZ];
+atomic_t fscache_ops_histogram[HZ];
+atomic_t fscache_retrieval_delay_histogram[HZ];
+atomic_t fscache_retrieval_histogram[HZ];
+#endif
diff --git a/fs/fscache/fsc-threads.c b/fs/fscache/fsc-threads.c
new file mode 100644
index 0000000..ff20598
--- /dev/null
+++ b/fs/fscache/fsc-threads.c
@@ -0,0 +1,590 @@
+/* FS-Cache worker thread pool manager
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL THREAD
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include "fsc-internal.h"
+
+static LIST_HEAD(fscache_object_fifo);
+static LIST_HEAD(fscache_sync_object_fifo);
+static LIST_HEAD(fscache_op_fifo);
+static LIST_HEAD(fscache_sync_op_fifo);
+
+static struct task_struct *fscache_threads[FSCACHE_MAX_THREADS];
+
+static unsigned fscache_n_threads = 21;
+module_param_named(n_threads, fscache_n_threads, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_n_threads, "FS-Cache thread pool size");
+
+static DEFINE_SPINLOCK(fscache_object_lock);
+static DEFINE_SPINLOCK(fscache_operation_lock);
+static DEFINE_MUTEX(fscache_thread_mutex);
+static DECLARE_WAIT_QUEUE_HEAD(fscache_fast_threads);
+static DECLARE_WAIT_QUEUE_HEAD(fscache_slow_threads);
+
+/**
+ * fscache_enqueue_operation - Enqueue an operation for processing
+ * @op: The operation to enqueue
+ *
+ * Enqueue an operation for processing by the FS-Cache thread pool.
+ */
+void fscache_enqueue_operation(struct fscache_operation *op)
+{
+	unsigned long flags;
+	bool added = false;
+
+	_enter("{OBJ%x}", op->object->debug_id);
+
+	ASSERT(op->processor != NULL);
+	ASSERTCMP(op->object->state, >=, FSCACHE_OBJECT_AVAILABLE);
+
+	spin_lock_irqsave(&fscache_operation_lock, flags);
+
+	if (list_empty(&op->work_link) &&
+	    !test_bit(FSCACHE_OP_REQUEUE, &op->flags)) {
+		if (!test_bit(FSCACHE_OP_LOCK, &op->flags)) {
+			atomic_inc(&op->usage);
+			if (test_bit(FSCACHE_OP_SYNC, &op->flags))
+				list_add_tail(&op->work_link,
+					      &fscache_sync_op_fifo);
+			else
+				list_add_tail(&op->work_link,
+					      &fscache_op_fifo);
+			added = true;
+			fscache_stat(&fscache_n_op_enqueue);
+		} else {
+			set_bit(FSCACHE_OP_REQUEUE, &op->flags);
+			fscache_stat(&fscache_n_op_requeue);
+		}
+	}
+
+	spin_unlock_irqrestore(&fscache_operation_lock, flags);
+	if (added)
+		wake_up(&fscache_fast_threads);
+}
+
+EXPORT_SYMBOL(fscache_enqueue_operation);
+
+/*
+ * jump start the operation processing on an object
+ * - caller must hold object->lock
+ */
+void fscache_start_operations(struct fscache_object *object)
+{
+	struct fscache_operation *op;
+	bool stop = false;
+
+	while (!list_empty(&object->pending_ops) && !stop) {
+		op = list_entry(object->pending_ops.next,
+				struct fscache_operation, work_link);
+
+		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags)) {
+			if (object->n_in_progress > 0)
+				break;
+			stop = true;
+		}
+		list_del_init(&op->work_link);
+		object->n_in_progress++;
+
+		if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
+			wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
+		if (op->processor)
+			fscache_enqueue_operation(op);
+	}
+
+	ASSERTCMP(object->n_in_progress, <=, object->n_ops);
+
+	_debug("woke %d ops on OBJ%x",
+	       object->n_in_progress, object->debug_id);
+}
+
+/*
+ * release an operation
+ * - queues pending ops if this is the last in-progress op
+ */
+void fscache_put_operation(struct fscache_operation *op)
+{
+	struct fscache_object *object;
+
+	_enter("{%d}", atomic_read(&op->usage));
+
+	ASSERTCMP(atomic_read(&op->usage), >, 0);
+
+	if (!atomic_dec_and_test(&op->usage))
+		return;
+
+	_debug("PUT OP");
+	fscache_stat(&fscache_n_op_release);
+
+	if (op->release)
+		op->release(op);
+
+	object = op->object;
+	spin_lock(&object->lock);
+	if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags)) {
+		ASSERTCMP(object->n_exclusive, >, 0);
+		object->n_exclusive--;
+	}
+
+	ASSERTCMP(object->n_in_progress, >, 0);
+	object->n_in_progress--;
+	if (object->n_in_progress == 0)
+		fscache_start_operations(object);
+
+	ASSERTCMP(object->n_ops, >, 0);
+	object->n_ops--;
+	if (object->n_ops == 0)
+		fscache_raise_event(object, FSCACHE_OBJECT_EV_CLEARED);
+
+	spin_unlock(&object->lock);
+	_leave("");
+}
+
+EXPORT_SYMBOL(fscache_put_operation);
+
+/*
+ * add object to queue
+ * - caller must hold fscache_thread_lock
+ */
+static void __fscache_enqueue_object(struct fscache_object *object)
+{
+	if (test_bit(FSCACHE_OBJECT_SYNC, &object->flags))
+		list_add_tail(&object->work_link, &fscache_sync_object_fifo);
+	else
+		list_add_tail(&object->work_link, &fscache_object_fifo);
+}
+
+/*
+ * enqueue an object for metadata-type processing
+ */
+void fscache_enqueue_object(struct fscache_object *object)
+{
+	struct fscache_cache *cache;
+	bool added;
+
+	_enter("{OBJ%x}", object->debug_id);
+
+	if (list_empty(&object->work_link) &&
+	    !test_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events)) {
+		added = false;
+		spin_lock_irq(&fscache_object_lock);
+		if (!test_bit(FSCACHE_OBJECT_LOCK, &object->flags)) {
+			if (list_empty(&object->work_link)) {
+				_debug("add");
+				cache = object->cache;
+				atomic_inc(&cache->thread_usage);
+				cache->ops->grab_object(object);
+				__fscache_enqueue_object(object);
+				added = true;
+			}
+		} else {
+			_debug("defer");
+			set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+		}
+		spin_unlock_irq(&fscache_object_lock);
+		if (added) {
+			_debug("wake");
+			wake_up(&fscache_slow_threads);
+		}
+	}
+}
+
+/*
+ * enqueue the dependents of an object for metadata-type processing
+ * - the caller must hold the object's lock
+ * - this may cause an already locked object to wind up being processed again
+ */
+void fscache_enqueue_dependents(struct fscache_object *object)
+{
+	struct fscache_object *dep;
+
+	_enter("{%p}", object);
+
+	if (list_empty(&object->dependents))
+		return;
+
+	spin_lock_irq(&fscache_object_lock);
+
+	while (!list_empty(&object->dependents)) {
+		dep = list_entry(object->dependents.next,
+				 struct fscache_object, work_link);
+		list_del(&dep->work_link);
+
+		clear_bit(FSCACHE_OBJECT_WAITING, &object->flags);
+
+		/* sort onto appropriate lists */
+		__fscache_enqueue_object(dep);
+
+		if (!list_empty(&object->dependents) && need_resched()) {
+			spin_unlock_irq(&fscache_object_lock);
+			cond_resched();
+			spin_lock_irq(&fscache_object_lock);
+		}
+	}
+
+	spin_unlock_irq(&fscache_object_lock);
+	wake_up(&fscache_slow_threads);
+}
+
+/*
+ * remove an object from whatever queue it's waiting on
+ */
+void fscache_dequeue_object(struct fscache_object *object)
+{
+	_enter("{OBJ%x}", object->debug_id);
+
+	if (!list_empty(&object->dependents)) {
+		spin_lock_irq(&fscache_object_lock);
+		list_del_init(&object->work_link);
+		spin_unlock_irq(&fscache_object_lock);
+	}
+	_leave("");
+}
+
+/*
+ * boost an object that's being waited upon by moving it to the priority queue
+ */
+void fscache_boost_object(struct fscache_object *object)
+{
+	set_bit(FSCACHE_OBJECT_BOOSTED, &object->flags);
+	if (!test_bit(FSCACHE_OBJECT_WAITING, &object->flags)) {
+		fscache_stat(&fscache_n_object_boosted);
+		spin_lock_irq(&fscache_object_lock);
+		if (!list_empty(&object->work_link))
+			list_move_tail(&object->work_link,
+				       &fscache_sync_object_fifo);
+		spin_unlock_irq(&fscache_object_lock);
+	}
+}
+
+/*
+ * object dispatcher
+ * - slow threads take from the object FIFO by preference
+ * - called with fscache_thread_lock locked, which it drops
+ */
+static void fscache_dispatch_object(unsigned thread)
+{
+	struct fscache_object *object;
+	struct fscache_cache *cache = NULL;
+	unsigned long start;
+	bool sync;
+
+	spin_lock_irq(&fscache_object_lock);
+
+	if (list_empty(&fscache_object_fifo) &&
+	    list_empty(&fscache_sync_object_fifo)) {
+		spin_unlock_irq(&fscache_object_lock);
+		return;
+	}
+
+	fscache_stat(&fscache_n_objs_processed[thread]);
+
+	sync = !list_empty(&fscache_sync_object_fifo);
+	if (sync) {
+		object = list_entry(fscache_sync_object_fifo.next,
+				    struct fscache_object, work_link);
+		set_user_nice(current, -1);
+	} else {
+		object = list_entry(fscache_object_fifo.next,
+				    struct fscache_object, work_link);
+		set_user_nice(current, 1);
+	}
+
+	/* lock the object so that it's only processed by one thread at
+	 * once */
+	_debug("LK OBJ%x", object->debug_id);
+	list_del_init(&object->work_link);
+	if (test_and_set_bit(FSCACHE_OBJECT_LOCK, &object->flags)) {
+		_debug("OBJ%x already locked {%s,%lx}\n",
+		       object->debug_id,
+		       fscache_object_states[object->state],
+		       object->events & object->event_mask);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+		spin_unlock_irq(&fscache_object_lock);
+		return;
+	}
+	do {
+		spin_unlock_irq(&fscache_object_lock);
+
+		do {
+			clear_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+			start = jiffies;
+			fscache_object_state_machine(object);
+			fscache_hist(fscache_objs_histogram, start);
+		} while (object->events & object->event_mask);
+
+		spin_lock_irq(&fscache_object_lock);
+	} while (object->events & object->event_mask);
+
+	/* unlock the object */
+	_debug("UN OBJ%x", object->debug_id);
+	if (!test_and_clear_bit(FSCACHE_OBJECT_LOCK, &object->flags))
+		BUG();
+
+	spin_unlock_irq(&fscache_object_lock);
+
+	if (object) {
+		/* must do the wake up outside the thread pool lock to avoid a
+		 * circular lock dependency against a __wake_up() lock in
+		 * CacheFiles */
+		wake_up_bit(&object->lock, FSCACHE_OBJECT_LOCK);
+		cache = object->cache;
+		cache->ops->put_object(object);
+		_debug("%d REMAIN", atomic_read(&cache->thread_usage));
+		if (atomic_dec_and_test(&cache->thread_usage)) {
+			_debug("ALL GONE");
+			wake_up_all(&fscache_clearance_wq);
+		}
+	}
+}
+
+/*
+ * operation dispatcher
+ * - all threads can take from the fast FIFO
+ * - called with fscache_thread_lock locked, which it drops
+ */
+static void fscache_dispatch_operation(unsigned thread, struct list_head *queue)
+{
+	struct fscache_operation *op;
+	unsigned long start;
+
+	spin_lock_irq(&fscache_operation_lock);
+
+	if (list_empty(queue)) {
+		spin_unlock_irq(&fscache_operation_lock);
+		return;
+	}
+
+	fscache_stat(&fscache_n_ops_processed[thread]);
+
+	op = list_entry(queue->next, struct fscache_operation, work_link);
+
+	/* lock the operation so that it's only processed by one thread
+	 * at once */
+	_debug("LK OP OBJ%x", op->object->debug_id);
+	if (test_and_set_bit(FSCACHE_OP_LOCK, &op->flags)) {
+		printk(KERN_ERR "FS-Cache: OP on OBJ%x already locked\n",
+		       op->object->debug_id);
+		BUG();
+	}
+	list_del_init(&op->work_link);
+	spin_unlock_irq(&fscache_operation_lock);
+
+	ASSERT(op->processor != NULL);
+	start = jiffies;
+	op->processor(op);
+	fscache_hist(fscache_ops_histogram, start);
+
+	/* unlock the op and requeue if requested */
+	spin_lock_irq(&fscache_operation_lock);
+	_debug("UN OP OBJ%x", op->object->debug_id);
+	clear_bit(FSCACHE_OP_LOCK, &op->flags);
+
+	if (test_and_clear_bit(FSCACHE_OP_REQUEUE, &op->flags)) {
+		list_add(&op->work_link, queue);
+		op = NULL;
+	}
+
+	spin_unlock_irq(&fscache_operation_lock);
+
+	if (op)
+		fscache_put_operation(op);
+}
+
+/*
+ * thread dispatcher
+ */
+static void fscache_dispatch(unsigned thread)
+{
+	_enter("");
+
+	switch (thread % 3) {
+	case 2:
+		/* threads 2, 5, 8, 11, ... do objects, async ops then sync
+		 * ops */
+		if (!list_empty(&fscache_object_fifo) ||
+		    !list_empty(&fscache_sync_object_fifo)) {
+			fscache_dispatch_object(thread);
+			break;
+		}
+	case 1:
+		/* threads 1, 4, 7, 10, ... do async ops then sync ops */
+		if (!list_empty(&fscache_op_fifo)) {
+			fscache_dispatch_operation(thread, &fscache_op_fifo);
+			break;
+		}
+		if (!list_empty(&fscache_sync_op_fifo)) {
+			fscache_dispatch_operation(thread,
+						   &fscache_sync_op_fifo);
+			break;
+		}
+		break;
+	default:
+		/* threads 0, 3, 6, 9, ... do sync ops then async ops */
+		if (!list_empty(&fscache_sync_op_fifo)) {
+			fscache_dispatch_operation(thread,
+						   &fscache_sync_op_fifo);
+			break;
+		}
+		break;
+	}
+
+	_leave("");
+}
+
+/*
+ * operation dispatcher thread dedicated to doing fast ops
+ */
+static int kfscached_fast(unsigned thread)
+{
+	DECLARE_WAITQUEUE(myself, current);
+
+	do {
+		while (!list_empty(&fscache_op_fifo) ||
+		       !list_empty(&fscache_sync_op_fifo)) {
+			fscache_dispatch(thread);
+			cond_resched();
+		}
+
+		add_wait_queue(&fscache_fast_threads, &myself);
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (list_empty(&fscache_op_fifo) &&
+		    list_empty(&fscache_sync_op_fifo) &&
+		    !kthread_should_stop())
+			schedule();
+		remove_wait_queue(&fscache_fast_threads, &myself);
+		__set_current_state(TASK_RUNNING);
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/*
+ * operation dispatcher thread for preferentially doing slow metadata ops (but
+ * can also do fast ops if bored)
+ */
+static int kfscached(void *_thread)
+{
+	unsigned thread = (unsigned long) _thread;
+
+	DECLARE_WAITQUEUE(myself_fast, current);
+	DECLARE_WAITQUEUE(myself_slow, current);
+
+	if (thread % 3 != 2) {
+		//if (thread % 3 == 1)
+		//set_user_nice(current, -4);
+		return kfscached_fast(thread);
+	}
+
+	set_user_nice(current, 1);
+
+	do {
+		while (!list_empty(&fscache_object_fifo) ||
+		       !list_empty(&fscache_sync_object_fifo) ||
+		       !list_empty(&fscache_op_fifo) ||
+		       !list_empty(&fscache_sync_op_fifo)) {
+			fscache_dispatch(thread);
+			cond_resched();
+		}
+
+		add_wait_queue(&fscache_slow_threads, &myself_slow);
+		add_wait_queue_tail(&fscache_fast_threads, &myself_fast);
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (list_empty(&fscache_object_fifo) &&
+		    list_empty(&fscache_sync_object_fifo) &&
+		    list_empty(&fscache_op_fifo) &&
+		    list_empty(&fscache_sync_op_fifo) &&
+		    !kthread_should_stop())
+			schedule();
+		remove_wait_queue(&fscache_fast_threads, &myself_fast);
+		remove_wait_queue(&fscache_slow_threads, &myself_slow);
+		__set_current_state(TASK_RUNNING);
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/*
+ * initialise the worker thread pool
+ */
+int fscache_init_threads(void)
+{
+	static bool inited = false;
+	struct task_struct *t;
+	unsigned long loop, max;
+	int ret;
+
+	_enter("");
+
+	mutex_lock(&fscache_thread_mutex);
+
+	if (!inited) {
+		max = fscache_n_threads;
+		if (max < FSCACHE_MIN_THREADS)
+			max = FSCACHE_MIN_THREADS;
+		else if (max > FSCACHE_MAX_THREADS)
+			max = FSCACHE_MAX_THREADS;
+
+		for (loop = 0; loop < max; loop++) {
+			t = kthread_create(kfscached, (void *) loop,
+					   "kfsc%02ud", loop);
+			if (IS_ERR(t))
+				goto failed;
+			fscache_threads[loop] = t;
+			wake_up_process(t);
+		}
+
+		inited = true;
+	}
+	mutex_unlock(&fscache_thread_mutex);
+	_leave(" = 0");
+	return 0;
+
+failed:
+	ret = PTR_ERR(t);
+	printk(KERN_ERR "FS-Cache: Unable to create kfscached threads (%d)\n",
+	       ret);
+
+	while (loop-- > 0) {
+		if (fscache_threads[loop]) {
+			kthread_stop(fscache_threads[loop]);
+			fscache_threads[loop] = NULL;
+		}
+	}
+
+	mutex_unlock(&fscache_thread_mutex);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * kill the pool of running threads
+ */
+void fscache_kill_threads(void)
+{
+	unsigned int loop;
+
+	_enter("");
+	mutex_lock(&fscache_thread_mutex);
+
+	for (loop = 0; loop < FSCACHE_MAX_THREADS; loop++)
+		if (fscache_threads[loop])
+			kthread_stop(fscache_threads[loop]);
+
+	BUG_ON(!list_empty(&fscache_object_fifo));
+	BUG_ON(!list_empty(&fscache_sync_object_fifo));
+	BUG_ON(!list_empty(&fscache_op_fifo));
+	BUG_ON(!list_empty(&fscache_sync_op_fifo));
+
+	mutex_unlock(&fscache_thread_mutex);
+	_leave("");
+}
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
new file mode 100644
index 0000000..176797f
--- /dev/null
+++ b/include/linux/fscache-cache.h
@@ -0,0 +1,433 @@
+/* General filesystem caching backing cache interface
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
+ *	Documentation/filesystems/caching/backend-api.txt
+ *
+ * for a description of the cache backend interface declared here.
+ */
+
+#ifndef _LINUX_FSCACHE_CACHE_H
+#define _LINUX_FSCACHE_CACHE_H
+
+#include <linux/fscache.h>
+
+#define NR_MAXCACHES BITS_PER_LONG
+
+struct fscache_cache;
+struct fscache_cache_ops;
+struct fscache_object;
+
+#ifdef CONFIG_FSCACHE_PROC
+extern struct proc_dir_entry *proc_fscache;
+#endif
+
+/*
+ * cache tag definition
+ */
+struct fscache_cache_tag {
+	struct list_head	link;
+	struct fscache_cache	*cache;		/* cache referred to by this tag */
+	unsigned long		flags;
+#define FSCACHE_TAG_RESERVED	0		/* T if tag is reserved for a cache */
+	atomic_t		usage;
+	char			name[0];	/* tag name */
+};
+
+/*
+ * cache definition
+ */
+struct fscache_cache {
+	const struct fscache_cache_ops *ops;
+	struct fscache_cache_tag *tag;		/* tag representing this cache */
+	struct kobject		kobj;		/* system representation of this cache */
+	struct list_head	link;		/* link in list of caches */
+	size_t			max_index_size;	/* maximum size of index data */
+	char			identifier[32];	/* cache label */
+
+	/* node management */
+	struct list_head	object_list;	/* list of data/index objects */
+	spinlock_t		object_list_lock;
+	atomic_t		thread_usage;	/* no. of threads working this cache */
+	struct fscache_object	*fsdef;		/* object for the fsdef index */
+	unsigned long		flags;
+#define FSCACHE_IOERROR		0	/* cache stopped on I/O error */
+#define FSCACHE_CACHE_WITHDRAWN	1	/* cache has been withdrawn */
+};
+
+/*
+ * asynchronous operation being applied to or waiting to be applied to a cache
+ * object
+ * - slow operations are done in the context of the process that issued them,
+ *   not in the context of kfscached
+ */
+struct fscache_operation {
+	struct list_head	work_link;	/* link in worker thread FIFO or
+						 * link in object->pending_ops */
+	struct fscache_object	*object;	/* object to be operated upon */
+
+	unsigned long		flags;
+#define FSCACHE_OP_WAITING	0	/* cleared when op is woken */
+#define FSCACHE_OP_SYNC		1	/* synchronous operation */
+#define FSCACHE_OP_EXCLUSIVE	2	/* exclusive op, other ops must wait */
+#define FSCACHE_OP_LOCK		3	/* thread pool processing lock */
+#define FSCACHE_OP_REQUEUE	4	/* op needs more processing */
+
+	atomic_t		usage;
+
+	/* operation processor callback
+	 * - can be NULL if FSCACHE_OP_WAITING is going to be used to perform
+	 *   the op in a non-pool thread */
+	void (*processor)(struct fscache_operation *op);
+
+	/* operation releaser */
+	void (*release)(struct fscache_operation *op);
+};
+
+extern void fscache_enqueue_operation(struct fscache_operation *);
+extern void fscache_put_operation(struct fscache_operation *);
+
+/*
+ * data read operation
+ */
+struct fscache_retrieval {
+	struct fscache_operation op;
+	struct address_space	*mapping;	/* netfs pages */
+	fscache_rw_complete_t	end_io_func;	/* function to call on I/O completion */
+	void			*context;	/* netfs read context (pinned) */
+	struct list_head	to_do;		/* list of things to be done by the backend */
+	unsigned long		start_time;	/* time at which retrieval started */
+};
+
+typedef int (*fscache_page_retrieval_func_t)(struct fscache_retrieval *op,
+					     struct page *page,
+					     gfp_t gfp);
+
+typedef int (*fscache_pages_retrieval_func_t)(struct fscache_retrieval *op,
+					      struct list_head *pages,
+					      unsigned *nr_pages,
+					      gfp_t gfp);
+
+/**
+ * fscache_get_retrieval - Get an extra reference on a retrieval operation
+ * @op: The retrieval operation to get a reference on
+ *
+ * Get an extra reference on a retrieval operation.
+ */
+static inline
+struct fscache_retrieval *fscache_get_retrieval(struct fscache_retrieval *op)
+{
+	atomic_inc(&op->op.usage);
+	return op;
+}
+
+/**
+ * fscache_enqueue_retrieval - Enqueue a retrieval operation for processing
+ * @op: The retrieval operation affected
+ *
+ * Enqueue a retrieval operation for processing by the FS-Cache thread pool.
+ */
+static inline void fscache_enqueue_retrieval(struct fscache_retrieval *op)
+{
+	fscache_enqueue_operation(&op->op);
+}
+
+/**
+ * fscache_put_retrieval - Drop a reference to a retrieval operation
+ * @op: The retrieval operation affected
+ *
+ * Drop a reference to a retrieval operation.
+ */
+static inline void fscache_put_retrieval(struct fscache_retrieval *op)
+{
+	fscache_put_operation(&op->op);
+}
+
+/*
+ * cached page storage work item
+ * - used to do three things:
+ *   - batch writes to the cache
+ *   - do cache writes asynchronously
+ *   - defer writes until cache object lookup completion
+ */
+struct fscache_storage {
+	struct fscache_operation op;
+	pgoff_t			store_limit;	/* don't write more than this */
+};
+
+/*
+ * cache operations
+ */
+struct fscache_cache_ops {
+	/* name of cache provider */
+	const char *name;
+
+	/* allocate an object record for a cookie */
+	struct fscache_object *(*alloc_object)(struct fscache_cache *cache,
+					       struct fscache_cookie *cookie);
+
+	/* look up the object for a cookie */
+	void (*lookup_object)(struct fscache_object *object);
+
+	/* finished looking up */
+	void (*lookup_complete)(struct fscache_object *object);
+
+	/* increment the usage count on this object (may fail if unmounting) */
+	struct fscache_object *(*grab_object)(struct fscache_object *object);
+
+	/* pin an object in the cache */
+	int (*pin_object)(struct fscache_object *object);
+
+	/* unpin an object in the cache */
+	void (*unpin_object)(struct fscache_object *object);
+
+	/* store the updated auxilliary data on an object */
+	void (*update_object)(struct fscache_object *object);
+
+	/* discard the resources pinned by an object and effect retirement if
+	 * necessary */
+	void (*drop_object)(struct fscache_object *object);
+
+	/* dispose of a reference to an object */
+	void (*put_object)(struct fscache_object *object);
+
+	/* sync a cache */
+	void (*sync_cache)(struct fscache_cache *cache);
+
+	/* notification that the attributes of a non-index object (such as
+	 * i_size) have changed */
+	int (*attr_changed)(struct fscache_object *object);
+
+	/* reserve space for an object's data and associated metadata */
+	int (*reserve_space)(struct fscache_object *object, loff_t i_size);
+
+	/* request a backing block for a page be read or allocated in the
+	 * cache */
+	fscache_page_retrieval_func_t read_or_alloc_page;
+
+	/* request backing blocks for a list of pages be read or allocated in
+	 * the cache */
+	fscache_pages_retrieval_func_t read_or_alloc_pages;
+
+	/* request a backing block for a page be allocated in the cache so that
+	 * it can be written directly */
+	fscache_page_retrieval_func_t allocate_page;
+
+	/* request backing blocks for pages be allocated in the cache so that
+	 * they can be written directly */
+	fscache_pages_retrieval_func_t allocate_pages;
+
+	/* write a page to its backing block in the cache */
+	int (*write_page)(struct fscache_storage *op, struct page *page);
+
+	/* detach backing block from a page (optional)
+	 * - must release the cookie lock before returning
+	 * - may sleep
+	 */
+	void (*uncache_page)(struct fscache_object *object,
+			     struct page *page);
+
+	/* dissociate a cache from all the pages it was backing */
+	void (*dissociate_pages)(struct fscache_cache *cache);
+};
+
+/*
+ * data file or index object cookie
+ * - a file will only appear in one cache
+ * - a request to cache a file may or may not be honoured, subject to
+ *   constraints such as disk space
+ * - indices are created on disk just-in-time
+ */
+struct fscache_cookie {
+	atomic_t			usage;		/* number of users of this cookie */
+	atomic_t			n_children;	/* number of children of this cookie */
+	spinlock_t			lock;
+	struct hlist_head		backing_objects; /* object(s) backing this file/index */
+	const struct fscache_cookie_def	*def;		/* definition */
+	struct fscache_cookie		*parent;	/* parent of this entry */
+	void				*netfs_data;	/* back pointer to netfs */
+	unsigned long			flags;
+#define FSCACHE_COOKIE_LOOKING_UP	0	/* T if non-index cookie being looked up still */
+#define FSCACHE_COOKIE_CREATING		1	/* T if non-index object being created still */
+#define FSCACHE_COOKIE_NO_DATA_YET	2	/* T if new object with no cached data yet */
+#define FSCACHE_COOKIE_PENDING_FILL	3	/* T if pending initial fill on object */
+#define FSCACHE_COOKIE_FILLING		4	/* T if filling object incrementally */
+#define FSCACHE_COOKIE_UNAVAILABLE	5	/* T if cookie is unavailable (error, etc) */
+};
+
+extern struct fscache_cookie fscache_fsdef_index;
+
+/*
+ * on-disk cache file or index handle
+ */
+struct fscache_object {
+	enum {
+		FSCACHE_OBJECT_INIT,		/* object in initial unbound state */
+		FSCACHE_OBJECT_LOOKING_UP,	/* looking up object */
+		FSCACHE_OBJECT_CREATING,	/* creating object */
+
+		/* active states */
+		FSCACHE_OBJECT_AVAILABLE,	/* cleaning up object after creation */
+		FSCACHE_OBJECT_ACTIVE,		/* object is usable */
+		FSCACHE_OBJECT_UPDATING,	/* object is updating */
+
+		/* terminal states */
+		FSCACHE_OBJECT_DYING,		/* object waiting for accessors to finish */
+		FSCACHE_OBJECT_LC_DYING,	/* object cleaning up after lookup/create */
+		FSCACHE_OBJECT_ABORT_INIT,	/* abort the init state */
+		FSCACHE_OBJECT_RELEASING,	/* releasing object */
+		FSCACHE_OBJECT_RECYCLING,	/* retiring object */
+		FSCACHE_OBJECT_WITHDRAWING,	/* withdrawing object */
+		FSCACHE_OBJECT_DEAD,		/* object is now dead */
+	} state;
+
+	int			debug_id;	/* debugging ID */
+	int			n_children;	/* number of child objects */
+	int			n_ops;		/* number of ops outstanding on object */
+	int			n_in_progress;	/* number of ops in progress */
+	int			n_exclusive;	/* number of exclusive ops queued */
+	spinlock_t		lock;		/* state and operations lock */
+
+	unsigned long		lookup_jif;	/* time at which lookup started */
+	unsigned long		event_mask;	/* events this object is interested in */
+	unsigned long		events;		/* events to be processed by this object
+						 * (order is important - using fls) */
+#define FSCACHE_OBJECT_EV_REQUEUE	0	/* T if object should be requeued */
+#define FSCACHE_OBJECT_EV_UPDATE	1	/* T if object should be updated */
+#define FSCACHE_OBJECT_EV_CLEARED	2	/* T if accessors all gone */
+#define FSCACHE_OBJECT_EV_ERROR		3	/* T if fatal error occurred during processing */
+#define FSCACHE_OBJECT_EV_RELEASE	4	/* T if netfs requested object release */
+#define FSCACHE_OBJECT_EV_RETIRE	5	/* T if netfs requested object retirement */
+#define FSCACHE_OBJECT_EV_WITHDRAW	6	/* T if cache requested object withdrawal */
+
+	unsigned long		flags;
+#define FSCACHE_OBJECT_LOCK		0	/* T if object is busy being processed */
+#define FSCACHE_OBJECT_SYNC		1	/* T if object is has waiters */
+#define FSCACHE_OBJECT_PENDING_WRITE	2	/* T if object has pending write */
+#define FSCACHE_OBJECT_WAITING		3	/* T if object is waiting on its parent */
+#define FSCACHE_OBJECT_BOOSTED		4	/* T if object was boosted to priority queue */
+
+	struct list_head	cache_link;	/* link in cache->object_list */
+	struct hlist_node	cookie_link;	/* link in cookie->backing_objects */
+	struct fscache_cache	*cache;		/* cache that supplied this object */
+	struct fscache_cookie	*cookie;	/* netfs's file/index object */
+	struct fscache_object	*parent;	/* parent object */
+	struct list_head	work_link;	/* link in worker thread FIFO */
+	struct list_head	dependents;	/* FIFO of dependent objects */
+	struct list_head	pending_ops;	/* unstarted operations on this object */
+	struct radix_tree_root	stores;		/* data to be stored */
+	pgoff_t			store_limit;	/* current storage limit */
+};
+
+extern const char *fscache_object_states[];
+
+#define fscache_object_is_active(obj)			      \
+	(!test_bit(FSCACHE_IOERROR, &(obj)->cache->flags) &&  \
+	 (obj)->state >= FSCACHE_OBJECT_AVAILABLE &&	      \
+	 (obj)->state < FSCACHE_OBJECT_DYING)
+
+/**
+ * fscache_object_init - Initialise a cache object description
+ * @object: Object description
+ *
+ * Initialise a cache object description to its basic values.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_object_init(struct fscache_object *object)
+{
+	object->state = FSCACHE_OBJECT_INIT;
+	spin_lock_init(&object->lock);
+	INIT_LIST_HEAD(&object->cache_link);
+	INIT_HLIST_NODE(&object->cookie_link);
+	INIT_LIST_HEAD(&object->work_link);
+	INIT_LIST_HEAD(&object->dependents);
+	INIT_LIST_HEAD(&object->pending_ops);
+	INIT_RADIX_TREE(&object->stores, GFP_NOFS);
+	object->n_children = 0;
+	object->n_ops = object->n_in_progress = object->n_exclusive = 0;
+	object->events = object->event_mask = 0;
+	object->flags = 0;
+	object->store_limit = 0;
+	object->cache = NULL;
+	object->cookie = NULL;
+}
+
+extern void fscache_object_lookup_negative(struct fscache_object *object);
+extern void fscache_obtained_object(struct fscache_object *object);
+
+/**
+ * fscache_object_lookup_error - Note an object encountered an error
+ * @object: The object on which the error was encountered
+ *
+ * Note that an object encountered a fatal error (usually an I/O error) and
+ * that it should be withdrawn as soon as possible.
+ */
+static inline void fscache_object_lookup_error(struct fscache_object *object)
+{
+	set_bit(FSCACHE_OBJECT_EV_ERROR, &object->events);
+}
+
+/**
+ * fscache_set_store_limit - Set the maximum size to be stored in an object
+ * @object: The object to set the maximum on
+ * @i_size: The limit to set in bytes
+ *
+ * Set the maximum size an object is permitted to reach, implying the highest
+ * byte that may be written.  Intended to be called by the attr_changed() op.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_set_store_limit(struct fscache_object *object, loff_t i_size)
+{
+	object->store_limit = i_size >> PAGE_SHIFT;
+	if (i_size & ~PAGE_MASK)
+		object->store_limit++;
+}
+
+/**
+ * fscache_end_io - End a retrieval operation on a page
+ * @op: The FS-Cache operation covering the retrieval
+ * @page: The page that was to be fetched
+ * @error: The error code (0 if successful)
+ *
+ * Note the end of an operation to retrieve a page, as covered by a particular
+ * operation record.
+ */
+static inline void fscache_end_io(struct fscache_retrieval *op,
+				  struct page *page, int error)
+{
+	op->end_io_func(page, op->context, error);
+}
+
+/*
+ * out-of-line cache backend functions
+ */
+extern void fscache_init_cache(struct fscache_cache *cache,
+			       const struct fscache_cache_ops *ops,
+			       const char *idfmt,
+			       ...) __attribute__ ((format (printf, 3, 4)));
+
+extern int fscache_add_cache(struct fscache_cache *cache,
+			     struct fscache_object *fsdef,
+			     const char *tagname);
+extern void fscache_withdraw_cache(struct fscache_cache *cache);
+
+extern void fscache_io_error(struct fscache_cache *cache);
+
+extern void fscache_mark_pages_cached(struct fscache_retrieval *op,
+				      struct pagevec *pagevec);
+
+#endif /* _LINUX_FSCACHE_CACHE_H */
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
new file mode 100644
index 0000000..f9a074b
--- /dev/null
+++ b/include/linux/fscache.h
@@ -0,0 +1,593 @@
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
+/* pattern used to fill dead space in an index entry */
+#define FSCACHE_INDEX_DEADFILL_PATTERN 0x79
+
+struct pagevec;
+struct fscache_cache_tag;
+struct fscache_cookie;
+struct fscache_netfs;
+struct fscache_netfs_operations;
+
+typedef void (*fscache_rw_complete_t)(struct page *page,
+				      void *context,
+				      int error);
+
+/* result of index entry consultation */
+typedef enum {
+	FSCACHE_CHECKAUX_OKAY,		/* entry okay as is */
+	FSCACHE_CHECKAUX_NEEDS_UPDATE,	/* entry requires update */
+	FSCACHE_CHECKAUX_OBSOLETE,	/* entry requires deletion */
+} fscache_checkaux_t;
+
+/*
+ * fscache cookie definition
+ */
+struct fscache_cookie_def
+{
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
+	struct fscache_cache_tag *(*select_cache)(const void *parent_netfs_data,
+						  const void *cookie_netfs_data);
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
+	fscache_checkaux_t (*check_aux)(void *cookie_netfs_data,
+					const void *data,
+					uint16_t datalen);
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
+ * netfs operations pointer (currently there aren't any ops)
+ */
+struct fscache_netfs_operations
+{
+};
+
+/*
+ * fscache cached network filesystem type
+ * - name, version and ops must be filled in before registration
+ * - all other fields will be set during registration
+ */
+struct fscache_netfs
+{
+	uint32_t			version;	/* indexing version */
+	const char			*name;		/* filesystem name */
+	struct fscache_cookie		*primary_index;
+	const struct fscache_netfs_operations *ops;
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
+extern int __fscache_register_netfs(struct fscache_netfs *);
+extern void __fscache_unregister_netfs(struct fscache_netfs *);
+extern struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *);
+extern void __fscache_release_cache_tag(struct fscache_cache_tag *);
+extern struct fscache_cookie *__fscache_acquire_cookie(struct fscache_cookie *,
+						       const struct fscache_cookie_def *,
+						       void *);
+extern void __fscache_relinquish_cookie(struct fscache_cookie *, int);
+extern void __fscache_update_cookie(struct fscache_cookie *);
+extern int __fscache_pin_cookie(struct fscache_cookie *);
+extern void __fscache_unpin_cookie(struct fscache_cookie *);
+extern int __fscache_attr_changed(struct fscache_cookie *);
+extern int __fscache_reserve_space(struct fscache_cookie *, loff_t);
+extern int __fscache_read_or_alloc_page(struct fscache_cookie *,
+					struct page *,
+					fscache_rw_complete_t,
+					void *,
+					gfp_t);
+extern int __fscache_read_or_alloc_pages(struct fscache_cookie *,
+					 struct address_space *,
+					 struct list_head *,
+					 unsigned *,
+					 fscache_rw_complete_t,
+					 void *,
+					 gfp_t);
+extern int __fscache_alloc_page(struct fscache_cookie *, struct page *, gfp_t);
+extern int __fscache_write_page(struct fscache_cookie *, struct page *, gfp_t);
+
+extern int __fscache_write_pages(struct fscache_cookie *,
+				 struct pagevec *,
+				 fscache_rw_complete_t,
+				 void *,
+				 gfp_t);
+extern void __fscache_uncache_page(struct fscache_cookie *, struct page *);
+extern void __fscache_uncache_pages(struct fscache_cookie *, struct pagevec *);
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
+	if (fscache_available())
+		return __fscache_register_netfs(netfs);
+	else
+		return 0;
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
+	if (fscache_available())
+		__fscache_unregister_netfs(netfs);
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
+	if (fscache_available())
+		return __fscache_lookup_cache_tag(name);
+	else
+		return NULL;
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
+	if (fscache_available())
+		__fscache_release_cache_tag(tag);
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
+struct fscache_cookie *fscache_acquire_cookie(struct fscache_cookie *parent,
+					      const struct fscache_cookie_def *def,
+					      void *netfs_data)
+{
+	if (fscache_cookie_valid(parent))
+		return __fscache_acquire_cookie(parent, def, netfs_data);
+	else
+		return NULL;
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
+	if (fscache_cookie_valid(cookie))
+		__fscache_relinquish_cookie(cookie, retire);
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
+	if (fscache_cookie_valid(cookie))
+		__fscache_update_cookie(cookie);
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_pin_cookie(cookie);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		__fscache_unpin_cookie(cookie);
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_attr_changed(cookie);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_reserve_space(cookie, size);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_read_or_alloc_page(cookie, page, end_io_func,
+						    context, gfp);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_read_or_alloc_pages(cookie, mapping, pages,
+						     nr_pages, end_io_func,
+						     context, gfp);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_alloc_page(cookie, page, gfp);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		return __fscache_write_page(cookie, page, gfp);
+	else
+		return -ENOBUFS;
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
+	if (fscache_cookie_valid(cookie))
+		__fscache_uncache_page(cookie, page);
+}
+
+#endif /* _LINUX_FSCACHE_H */

