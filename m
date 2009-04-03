Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbZDCP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbZDCP7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933793AbZDCPzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56525 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbZDCPzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/41] FS-Cache: Add the FS-Cache cache backend API and
	documentation [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:17 +0100
Message-ID: <20090403155517.28714.11708.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the API for a generic facility (FS-Cache) by which caches may declare them
selves open for business, and may obtain work to be done from network
filesystems.  The header file is included by:

	#include <linux/fscache-cache.h>

Documentation for the API is also added to:

	Documentation/filesystems/caching/backend-api.txt

This API is not usable without the implementation of the utility functions
which will be added in further patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 Documentation/filesystems/caching/backend-api.txt |  664 +++++++++++++++++++++
 include/linux/fscache-cache.h                     |  509 ++++++++++++++++
 2 files changed, 1173 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/caching/backend-api.txt
 create mode 100644 include/linux/fscache-cache.h


diff --git a/Documentation/filesystems/caching/backend-api.txt b/Documentation/filesystems/caching/backend-api.txt
new file mode 100644
index 0000000..1772305
--- /dev/null
+++ b/Documentation/filesystems/caching/backend-api.txt
@@ -0,0 +1,664 @@
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
+     here.  FS-Cache keeps the caller's reference to the index object if
+     successful and will release it upon withdrawal of the cache.
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
+ (*) Perform coherency check on an object:
+
+	enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
+						const void *data,
+						uint16_t datalen);
+
+     This asks the netfs to perform a coherency check on an object that has
+     just been looked up.  The cookie attached to the object will determine the
+     netfs to use.  data and datalen should specify where the auxiliary data
+     retrieved from the cache can be found.
+
+     One of three values will be returned:
+
+	(*) FSCACHE_CHECKAUX_OKAY
+
+	    The coherency data indicates the object is valid as is.
+
+	(*) FSCACHE_CHECKAUX_NEEDS_UPDATE
+
+	    The coherency data needs updating, but otherwise the object is
+	    valid.
+
+	(*) FSCACHE_CHECKAUX_OBSOLETE
+
+	    The coherency data indicates that the object is obsolete and should
+	    be discarded.
+
+
+ (*) Initialise a freshly allocated object:
+
+	void fscache_object_init(struct fscache_object *object);
+
+     This initialises all the fields in an object representation.
+
+
+ (*) Indicate the destruction of an object:
+
+	void fscache_object_destroyed(struct fscache_cache *cache);
+
+     This must be called to inform FS-Cache that an object that belonged to a
+     cache has been destroyed and deallocated.  This will allow continuation
+     of the cache withdrawal process when it is stopped pending destruction of
+     all the objects.
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
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
new file mode 100644
index 0000000..b2a9a48
--- /dev/null
+++ b/include/linux/fscache-cache.h
@@ -0,0 +1,509 @@
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
+#include <linux/sched.h>
+#include <linux/slow-work.h>
+
+#define NR_MAXCACHES BITS_PER_LONG
+
+struct fscache_cache;
+struct fscache_cache_ops;
+struct fscache_object;
+struct fscache_operation;
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
+	struct kobject		*kobj;		/* system representation of this cache */
+	struct list_head	link;		/* link in list of caches */
+	size_t			max_index_size;	/* maximum size of index data */
+	char			identifier[36];	/* cache label */
+
+	/* node management */
+	struct work_struct	op_gc;		/* operation garbage collector */
+	struct list_head	object_list;	/* list of data/index objects */
+	struct list_head	op_gc_list;	/* list of ops to be deleted */
+	spinlock_t		object_list_lock;
+	spinlock_t		op_gc_list_lock;
+	atomic_t		object_count;	/* no. of live objects in this cache */
+	struct fscache_object	*fsdef;		/* object for the fsdef index */
+	unsigned long		flags;
+#define FSCACHE_IOERROR		0	/* cache stopped on I/O error */
+#define FSCACHE_CACHE_WITHDRAWN	1	/* cache has been withdrawn */
+};
+
+extern wait_queue_head_t fscache_cache_cleared_wq;
+
+/*
+ * operation to be applied to a cache object
+ * - retrieval initiation operations are done in the context of the process
+ *   that issued them, and not in an async thread pool
+ */
+typedef void (*fscache_operation_release_t)(struct fscache_operation *op);
+typedef void (*fscache_operation_processor_t)(struct fscache_operation *op);
+
+struct fscache_operation {
+	union {
+		struct work_struct fast_work;	/* record for fast ops */
+		struct slow_work slow_work;	/* record for (very) slow ops */
+	};
+	struct list_head	pend_link;	/* link in object->pending_ops */
+	struct fscache_object	*object;	/* object to be operated upon */
+
+	unsigned long		flags;
+#define FSCACHE_OP_TYPE		0x000f	/* operation type */
+#define FSCACHE_OP_FAST		0x0001	/* - fast op, processor may not sleep for disk */
+#define FSCACHE_OP_SLOW		0x0002	/* - (very) slow op, processor may sleep for disk */
+#define FSCACHE_OP_MYTHREAD	0x0003	/* - processing is done be issuing thread, not pool */
+#define FSCACHE_OP_WAITING	4	/* cleared when op is woken */
+#define FSCACHE_OP_EXCLUSIVE	5	/* exclusive op, other ops must wait */
+#define FSCACHE_OP_DEAD		6	/* op is now dead */
+
+	atomic_t		usage;
+	unsigned		debug_id;	/* debugging ID */
+
+	/* operation processor callback
+	 * - can be NULL if FSCACHE_OP_WAITING is going to be used to perform
+	 *   the op in a non-pool thread */
+	fscache_operation_processor_t processor;
+
+	/* operation releaser */
+	fscache_operation_release_t release;
+};
+
+extern atomic_t fscache_op_debug_id;
+extern const struct slow_work_ops fscache_op_slow_work_ops;
+
+extern void fscache_enqueue_operation(struct fscache_operation *);
+extern void fscache_put_operation(struct fscache_operation *);
+
+/**
+ * fscache_operation_init - Do basic initialisation of an operation
+ * @op: The operation to initialise
+ * @release: The release function to assign
+ *
+ * Do basic initialisation of an operation.  The caller must still set flags,
+ * object, either fast_work or slow_work if necessary, and processor if needed.
+ */
+static inline void fscache_operation_init(struct fscache_operation *op,
+					  fscache_operation_release_t release)
+{
+	atomic_set(&op->usage, 1);
+	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+	op->release = release;
+	INIT_LIST_HEAD(&op->pend_link);
+}
+
+/**
+ * fscache_operation_init_slow - Do additional initialisation of a slow op
+ * @op: The operation to initialise
+ * @processor: The processor function to assign
+ *
+ * Do additional initialisation of an operation as required for slow work.
+ */
+static inline
+void fscache_operation_init_slow(struct fscache_operation *op,
+				 fscache_operation_processor_t processor)
+{
+	op->processor = processor;
+	slow_work_init(&op->slow_work, &fscache_op_slow_work_ops);
+}
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
+	struct radix_tree_root		stores;		/* pages to be stored on this cookie */
+#define FSCACHE_COOKIE_PENDING_TAG	0		/* pages tag: pending write to cache */
+
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
+	enum fscache_object_state {
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
+	int			n_obj_ops;	/* number of object ops outstanding on object */
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
+#define FSCACHE_OBJECT_PENDING_WRITE	1	/* T if object has pending write */
+#define FSCACHE_OBJECT_WAITING		2	/* T if object is waiting on its parent */
+
+	struct list_head	cache_link;	/* link in cache->object_list */
+	struct hlist_node	cookie_link;	/* link in cookie->backing_objects */
+	struct fscache_cache	*cache;		/* cache that supplied this object */
+	struct fscache_cookie	*cookie;	/* netfs's file/index object */
+	struct fscache_object	*parent;	/* parent object */
+	struct slow_work	work;		/* attention scheduling record */
+	struct list_head	dependents;	/* FIFO of dependent objects */
+	struct list_head	dep_link;	/* link in parent's dependents list */
+	struct list_head	pending_ops;	/* unstarted operations on this object */
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
+extern const struct slow_work_ops fscache_object_slow_work_ops;
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
+void fscache_object_init(struct fscache_object *object,
+			 struct fscache_cookie *cookie,
+			 struct fscache_cache *cache)
+{
+	atomic_inc(&cache->object_count);
+
+	object->state = FSCACHE_OBJECT_INIT;
+	spin_lock_init(&object->lock);
+	INIT_LIST_HEAD(&object->cache_link);
+	INIT_HLIST_NODE(&object->cookie_link);
+	vslow_work_init(&object->work, &fscache_object_slow_work_ops);
+	INIT_LIST_HEAD(&object->dependents);
+	INIT_LIST_HEAD(&object->dep_link);
+	INIT_LIST_HEAD(&object->pending_ops);
+	object->n_children = 0;
+	object->n_ops = object->n_in_progress = object->n_exclusive = 0;
+	object->events = object->event_mask = 0;
+	object->flags = 0;
+	object->store_limit = 0;
+	object->cache = cache;
+	object->cookie = cookie;
+	object->parent = NULL;
+}
+
+extern void fscache_object_lookup_negative(struct fscache_object *object);
+extern void fscache_obtained_object(struct fscache_object *object);
+
+/**
+ * fscache_object_destroyed - Note destruction of an object in a cache
+ * @cache: The cache from which the object came
+ *
+ * Note the destruction and deallocation of an object record in a cache.
+ */
+static inline void fscache_object_destroyed(struct fscache_cache *cache)
+{
+	if (atomic_dec_and_test(&cache->object_count))
+		wake_up_all(&fscache_cache_cleared_wq);
+}
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
+extern enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
+					       const void *data,
+					       uint16_t datalen);
+
+#endif /* _LINUX_FSCACHE_CACHE_H */

