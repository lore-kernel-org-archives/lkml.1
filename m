Return-Path: <linux-kernel-owner+w=401wt.eu-S935688AbZDCQD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935688AbZDCQD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934777AbZDCP4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:56:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934352AbZDCP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:56:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/41] FS-Cache: Object management state machine [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:56:04 +0100
Message-ID: <20090403155603.28714.24870.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the cache object management state machine.

The following documentation is added to illuminate the working of this state
machine.  It will also be added as:

	Documentation/filesystems/caching/object.txt

	     ====================================================
	     IN-KERNEL CACHE OBJECT REPRESENTATION AND MANAGEMENT
	     ====================================================

==============
REPRESENTATION
==============

FS-Cache maintains an in-kernel representation of each object that a netfs is
currently interested in.  Such objects are represented by the fscache_cookie
struct and are referred to as cookies.

FS-Cache also maintains a separate in-kernel representation of the objects that
a cache backend is currently actively caching.  Such objects are represented by
the fscache_object struct.  The cache backends allocate these upon request, and
are expected to embed them in their own representations.  These are referred to
as objects.

There is a 1:N relationship between cookies and objects.  A cookie may be
represented by multiple objects - an index may exist in more than one cache -
or even by no objects (it may not be cached).

Furthermore, both cookies and objects are hierarchical.  The two hierarchies
correspond, but the cookies tree is a superset of the union of the object trees
of multiple caches:

	    NETFS INDEX TREE               :      CACHE 1     :      CACHE 2
	                                   :                  :
	                                   :   +-----------+  :
	                          +----------->|  IObject  |  :
	      +-----------+       |        :   +-----------+  :
	      |  ICookie  |-------+        :         |        :
	      +-----------+       |        :         |        :   +-----------+
	            |             +------------------------------>|  IObject  |
	            |                      :         |        :   +-----------+
	            |                      :         V        :         |
	            |                      :   +-----------+  :         |
	            V             +----------->|  IObject  |  :         |
	      +-----------+       |        :   +-----------+  :         |
	      |  ICookie  |-------+        :         |        :         V
	      +-----------+       |        :         |        :   +-----------+
	            |             +------------------------------>|  IObject  |
	      +-----+-----+                :         |        :   +-----------+
	      |           |                :         |        :         |
	      V           |                :         V        :         |
	+-----------+     |                :   +-----------+  :         |
	|  ICookie  |------------------------->|  IObject  |  :         |
	+-----------+     |                :   +-----------+  :         |
	      |           V                :         |        :         V
	      |     +-----------+          :         |        :   +-----------+
	      |     |  ICookie  |-------------------------------->|  IObject  |
	      |     +-----------+          :         |        :   +-----------+
	      V           |                :         V        :         |
	+-----------+     |                :   +-----------+  :         |
	|  DCookie  |------------------------->|  DObject  |  :         |
	+-----------+     |                :   +-----------+  :         |
	                  |                :                  :         |
	          +-------+-------+        :                  :         |
	          |               |        :                  :         |
	          V               V        :                  :         V
	    +-----------+   +-----------+  :                  :   +-----------+
	    |  DCookie  |   |  DCookie  |------------------------>|  DObject  |
	    +-----------+   +-----------+  :                  :   +-----------+
	                                   :                  :

In the above illustration, ICookie and IObject represent indices and DCookie
and DObject represent data storage objects.  Indices may have representation in
multiple caches, but currently, non-index objects may not.  Objects of any type
may also be entirely unrepresented.

As far as the netfs API goes, the netfs is only actually permitted to see
pointers to the cookies.  The cookies themselves and any objects attached to
those cookies are hidden from it.


===============================
OBJECT MANAGEMENT STATE MACHINE
===============================

Within FS-Cache, each active object is managed by its own individual state
machine.  The state for an object is kept in the fscache_object struct, in
object->state.  A cookie may point to a set of objects that are in different
states.

Each state has an action associated with it that is invoked when the machine
wakes up in that state.  There are four logical sets of states:

 (1) Preparation: states that wait for the parent objects to become ready.  The
     representations are hierarchical, and it is expected that an object must
     be created or accessed with respect to its parent object.

 (2) Initialisation: states that perform lookups in the cache and validate
     what's found and that create on disk any missing metadata.

 (3) Normal running: states that allow netfs operations on objects to proceed
     and that update the state of objects.

 (4) Termination: states that detach objects from their netfs cookies, that
     delete objects from disk, that handle disk and system errors and that free
     up in-memory resources.


In most cases, transitioning between states is in response to signalled events.
When a state has finished processing, it will usually set the mask of events in
which it is interested (object->event_mask) and relinquish the worker thread.
Then when an event is raised (by calling fscache_raise_event()), if the event
is not masked, the object will be queued for processing (by calling
fscache_enqueue_object()).


PROVISION OF CPU TIME
---------------------

The work to be done by the various states is given CPU time by the threads of
the slow work facility (see Documentation/slow-work.txt).  This is used in
preference to the workqueue facility because:

 (1) Threads may be completely occupied for very long periods of time by a
     particular work item.  These state actions may be doing sequences of
     synchronous, journalled disk accesses (lookup, mkdir, create, setxattr,
     getxattr, truncate, unlink, rmdir, rename).

 (2) Threads may do little actual work, but may rather spend a lot of time
     sleeping on I/O.  This means that single-threaded and 1-per-CPU-threaded
     workqueues don't necessarily have the right numbers of threads.


LOCKING SIMPLIFICATION
----------------------

Because only one worker thread may be operating on any particular object's
state machine at once, this simplifies the locking, particularly with respect
to disconnecting the netfs's representation of a cache object (fscache_cookie)
from the cache backend's representation (fscache_object) - which may be
requested from either end.


=================
THE SET OF STATES
=================

The object state machine has a set of states that it can be in.  There are
preparation states in which the object sets itself up and waits for its parent
object to transit to a state that allows access to its children:

 (1) State FSCACHE_OBJECT_INIT.

     Initialise the object and wait for the parent object to become active.  In
     the cache, it is expected that it will not be possible to look an object
     up from the parent object, until that parent object itself has been looked
     up.

There are initialisation states in which the object sets itself up and accesses
disk for the object metadata:

 (2) State FSCACHE_OBJECT_LOOKING_UP.

     Look up the object on disk, using the parent as a starting point.
     FS-Cache expects the cache backend to probe the cache to see whether this
     object is represented there, and if it is, to see if it's valid (coherency
     management).

     The cache should call fscache_object_lookup_negative() to indicate lookup
     failure for whatever reason, and should call fscache_obtained_object() to
     indicate success.

     At the completion of lookup, FS-Cache will let the netfs go ahead with
     read operations, no matter whether the file is yet cached.  If not yet
     cached, read operations will be immediately rejected with ENODATA until
     the first known page is uncached - as to that point there can be no data
     to be read out of the cache for that file that isn't currently also held
     in the pagecache.

 (3) State FSCACHE_OBJECT_CREATING.

     Create an object on disk, using the parent as a starting point.  This
     happens if the lookup failed to find the object, or if the object's
     coherency data indicated what's on disk is out of date.  In this state,
     FS-Cache expects the cache to create

     The cache should call fscache_obtained_object() if creation completes
     successfully, fscache_object_lookup_negative() otherwise.

     At the completion of creation, FS-Cache will start processing write
     operations the netfs has queued for an object.  If creation failed, the
     write ops will be transparently discarded, and nothing recorded in the
     cache.

There are some normal running states in which the object spends its time
servicing netfs requests:

 (4) State FSCACHE_OBJECT_AVAILABLE.

     A transient state in which pending operations are started, child objects
     are permitted to advance from FSCACHE_OBJECT_INIT state, and temporary
     lookup data is freed.

 (5) State FSCACHE_OBJECT_ACTIVE.

     The normal running state.  In this state, requests the netfs makes will be
     passed on to the cache.

 (6) State FSCACHE_OBJECT_UPDATING.

     The state machine comes here to update the object in the cache from the
     netfs's records.  This involves updating the auxiliary data that is used
     to maintain coherency.

And there are terminal states in which an object cleans itself up, deallocates
memory and potentially deletes stuff from disk:

 (7) State FSCACHE_OBJECT_LC_DYING.

     The object comes here if it is dying because of a lookup or creation
     error.  This would be due to a disk error or system error of some sort.
     Temporary data is cleaned up, and the parent is released.

 (8) State FSCACHE_OBJECT_DYING.

     The object comes here if it is dying due to an error, because its parent
     cookie has been relinquished by the netfs or because the cache is being
     withdrawn.

     Any child objects waiting on this one are given CPU time so that they too
     can destroy themselves.  This object waits for all its children to go away
     before advancing to the next state.

 (9) State FSCACHE_OBJECT_ABORT_INIT.

     The object comes to this state if it was waiting on its parent in
     FSCACHE_OBJECT_INIT, but its parent died.  The object will destroy itself
     so that the parent may proceed from the FSCACHE_OBJECT_DYING state.

(10) State FSCACHE_OBJECT_RELEASING.
(11) State FSCACHE_OBJECT_RECYCLING.

     The object comes to one of these two states when dying once it is rid of
     all its children, if it is dying because the netfs relinquished its
     cookie.  In the first state, the cached data is expected to persist, and
     in the second it will be deleted.

(12) State FSCACHE_OBJECT_WITHDRAWING.

     The object transits to this state if the cache decides it wants to
     withdraw the object from service, perhaps to make space, but also due to
     error or just because the whole cache is being withdrawn.

(13) State FSCACHE_OBJECT_DEAD.

     The object transits to this state when the in-memory object record is
     ready to be deleted.  The object processor shouldn't ever see an object in
     this state.


THE SET OF EVENTS
-----------------

There are a number of events that can be raised to an object state machine:

 (*) FSCACHE_OBJECT_EV_UPDATE

     The netfs requested that an object be updated.  The state machine will ask
     the cache backend to update the object, and the cache backend will ask the
     netfs for details of the change through its cookie definition ops.

 (*) FSCACHE_OBJECT_EV_CLEARED

     This is signalled in two circumstances:

     (a) when an object's last child object is dropped and

     (b) when the last operation outstanding on an object is completed.

     This is used to proceed from the dying state.

 (*) FSCACHE_OBJECT_EV_ERROR

     This is signalled when an I/O error occurs during the processing of some
     object.

 (*) FSCACHE_OBJECT_EV_RELEASE
 (*) FSCACHE_OBJECT_EV_RETIRE

     These are signalled when the netfs relinquishes a cookie it was using.
     The event selected depends on whether the netfs asks for the backing
     object to be retired (deleted) or retained.

 (*) FSCACHE_OBJECT_EV_WITHDRAW

     This is signalled when the cache backend wants to withdraw an object.
     This means that the object will have to be detached from the netfs's
     cookie.

Because the withdrawing releasing/retiring events are all handled by the object
state machine, it doesn't matter if there's a collision with both ends trying
to sever the connection at the same time.  The state machine can just pick
which one it wants to honour, and that effects the other.


Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 Documentation/filesystems/caching/fscache.txt |    5 
 Documentation/filesystems/caching/object.txt  |  313 ++++++++++
 fs/fscache/Makefile                           |    3 
 fs/fscache/internal.h                         |   26 +
 fs/fscache/object.c                           |  810 +++++++++++++++++++++++++
 5 files changed, 1155 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/caching/object.txt
 create mode 100644 fs/fscache/object.c


diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 0a751f3..9e94b94 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -188,6 +188,11 @@ The cache backend API to FS-Cache can be found in:
 
 	Documentation/filesystems/caching/backend-api.txt
 
+A description of the internal representations and object state machine can be
+found in:
+
+	Documentation/filesystems/caching/object.txt
+
 
 =======================
 STATISTICAL INFORMATION
diff --git a/Documentation/filesystems/caching/object.txt b/Documentation/filesystems/caching/object.txt
new file mode 100644
index 0000000..e8b0a35
--- /dev/null
+++ b/Documentation/filesystems/caching/object.txt
@@ -0,0 +1,313 @@
+	     ====================================================
+	     IN-KERNEL CACHE OBJECT REPRESENTATION AND MANAGEMENT
+	     ====================================================
+
+By: David Howells <dhowells@redhat.com>
+
+Contents:
+
+ (*) Representation
+
+ (*) Object management state machine.
+
+     - Provision of cpu time.
+     - Locking simplification.
+
+ (*) The set of states.
+
+ (*) The set of events.
+
+
+==============
+REPRESENTATION
+==============
+
+FS-Cache maintains an in-kernel representation of each object that a netfs is
+currently interested in.  Such objects are represented by the fscache_cookie
+struct and are referred to as cookies.
+
+FS-Cache also maintains a separate in-kernel representation of the objects that
+a cache backend is currently actively caching.  Such objects are represented by
+the fscache_object struct.  The cache backends allocate these upon request, and
+are expected to embed them in their own representations.  These are referred to
+as objects.
+
+There is a 1:N relationship between cookies and objects.  A cookie may be
+represented by multiple objects - an index may exist in more than one cache -
+or even by no objects (it may not be cached).
+
+Furthermore, both cookies and objects are hierarchical.  The two hierarchies
+correspond, but the cookies tree is a superset of the union of the object trees
+of multiple caches:
+
+	    NETFS INDEX TREE               :      CACHE 1     :      CACHE 2
+	                                   :                  :
+	                                   :   +-----------+  :
+	                          +----------->|  IObject  |  :
+	      +-----------+       |        :   +-----------+  :
+	      |  ICookie  |-------+        :         |        :
+	      +-----------+       |        :         |        :   +-----------+
+	            |             +------------------------------>|  IObject  |
+	            |                      :         |        :   +-----------+
+	            |                      :         V        :         |
+	            |                      :   +-----------+  :         |
+	            V             +----------->|  IObject  |  :         |
+	      +-----------+       |        :   +-----------+  :         |
+	      |  ICookie  |-------+        :         |        :         V
+	      +-----------+       |        :         |        :   +-----------+
+	            |             +------------------------------>|  IObject  |
+	      +-----+-----+                :         |        :   +-----------+
+	      |           |                :         |        :         |
+	      V           |                :         V        :         |
+	+-----------+     |                :   +-----------+  :         |
+	|  ICookie  |------------------------->|  IObject  |  :         |
+	+-----------+     |                :   +-----------+  :         |
+	      |           V                :         |        :         V
+	      |     +-----------+          :         |        :   +-----------+
+	      |     |  ICookie  |-------------------------------->|  IObject  |
+	      |     +-----------+          :         |        :   +-----------+
+	      V           |                :         V        :         |
+	+-----------+     |                :   +-----------+  :         |
+	|  DCookie  |------------------------->|  DObject  |  :         |
+	+-----------+     |                :   +-----------+  :         |
+	                  |                :                  :         |
+	          +-------+-------+        :                  :         |
+	          |               |        :                  :         |
+	          V               V        :                  :         V
+	    +-----------+   +-----------+  :                  :   +-----------+
+	    |  DCookie  |   |  DCookie  |------------------------>|  DObject  |
+	    +-----------+   +-----------+  :                  :   +-----------+
+	                                   :                  :
+
+In the above illustration, ICookie and IObject represent indices and DCookie
+and DObject represent data storage objects.  Indices may have representation in
+multiple caches, but currently, non-index objects may not.  Objects of any type
+may also be entirely unrepresented.
+
+As far as the netfs API goes, the netfs is only actually permitted to see
+pointers to the cookies.  The cookies themselves and any objects attached to
+those cookies are hidden from it.
+
+
+===============================
+OBJECT MANAGEMENT STATE MACHINE
+===============================
+
+Within FS-Cache, each active object is managed by its own individual state
+machine.  The state for an object is kept in the fscache_object struct, in
+object->state.  A cookie may point to a set of objects that are in different
+states.
+
+Each state has an action associated with it that is invoked when the machine
+wakes up in that state.  There are four logical sets of states:
+
+ (1) Preparation: states that wait for the parent objects to become ready.  The
+     representations are hierarchical, and it is expected that an object must
+     be created or accessed with respect to its parent object.
+
+ (2) Initialisation: states that perform lookups in the cache and validate
+     what's found and that create on disk any missing metadata.
+
+ (3) Normal running: states that allow netfs operations on objects to proceed
+     and that update the state of objects.
+
+ (4) Termination: states that detach objects from their netfs cookies, that
+     delete objects from disk, that handle disk and system errors and that free
+     up in-memory resources.
+
+
+In most cases, transitioning between states is in response to signalled events.
+When a state has finished processing, it will usually set the mask of events in
+which it is interested (object->event_mask) and relinquish the worker thread.
+Then when an event is raised (by calling fscache_raise_event()), if the event
+is not masked, the object will be queued for processing (by calling
+fscache_enqueue_object()).
+
+
+PROVISION OF CPU TIME
+---------------------
+
+The work to be done by the various states is given CPU time by the threads of
+the slow work facility (see Documentation/slow-work.txt).  This is used in
+preference to the workqueue facility because:
+
+ (1) Threads may be completely occupied for very long periods of time by a
+     particular work item.  These state actions may be doing sequences of
+     synchronous, journalled disk accesses (lookup, mkdir, create, setxattr,
+     getxattr, truncate, unlink, rmdir, rename).
+
+ (2) Threads may do little actual work, but may rather spend a lot of time
+     sleeping on I/O.  This means that single-threaded and 1-per-CPU-threaded
+     workqueues don't necessarily have the right numbers of threads.
+
+
+LOCKING SIMPLIFICATION
+----------------------
+
+Because only one worker thread may be operating on any particular object's
+state machine at once, this simplifies the locking, particularly with respect
+to disconnecting the netfs's representation of a cache object (fscache_cookie)
+from the cache backend's representation (fscache_object) - which may be
+requested from either end.
+
+
+=================
+THE SET OF STATES
+=================
+
+The object state machine has a set of states that it can be in.  There are
+preparation states in which the object sets itself up and waits for its parent
+object to transit to a state that allows access to its children:
+
+ (1) State FSCACHE_OBJECT_INIT.
+
+     Initialise the object and wait for the parent object to become active.  In
+     the cache, it is expected that it will not be possible to look an object
+     up from the parent object, until that parent object itself has been looked
+     up.
+
+There are initialisation states in which the object sets itself up and accesses
+disk for the object metadata:
+
+ (2) State FSCACHE_OBJECT_LOOKING_UP.
+
+     Look up the object on disk, using the parent as a starting point.
+     FS-Cache expects the cache backend to probe the cache to see whether this
+     object is represented there, and if it is, to see if it's valid (coherency
+     management).
+
+     The cache should call fscache_object_lookup_negative() to indicate lookup
+     failure for whatever reason, and should call fscache_obtained_object() to
+     indicate success.
+
+     At the completion of lookup, FS-Cache will let the netfs go ahead with
+     read operations, no matter whether the file is yet cached.  If not yet
+     cached, read operations will be immediately rejected with ENODATA until
+     the first known page is uncached - as to that point there can be no data
+     to be read out of the cache for that file that isn't currently also held
+     in the pagecache.
+
+ (3) State FSCACHE_OBJECT_CREATING.
+
+     Create an object on disk, using the parent as a starting point.  This
+     happens if the lookup failed to find the object, or if the object's
+     coherency data indicated what's on disk is out of date.  In this state,
+     FS-Cache expects the cache to create
+
+     The cache should call fscache_obtained_object() if creation completes
+     successfully, fscache_object_lookup_negative() otherwise.
+
+     At the completion of creation, FS-Cache will start processing write
+     operations the netfs has queued for an object.  If creation failed, the
+     write ops will be transparently discarded, and nothing recorded in the
+     cache.
+
+There are some normal running states in which the object spends its time
+servicing netfs requests:
+
+ (4) State FSCACHE_OBJECT_AVAILABLE.
+
+     A transient state in which pending operations are started, child objects
+     are permitted to advance from FSCACHE_OBJECT_INIT state, and temporary
+     lookup data is freed.
+
+ (5) State FSCACHE_OBJECT_ACTIVE.
+
+     The normal running state.  In this state, requests the netfs makes will be
+     passed on to the cache.
+
+ (6) State FSCACHE_OBJECT_UPDATING.
+
+     The state machine comes here to update the object in the cache from the
+     netfs's records.  This involves updating the auxiliary data that is used
+     to maintain coherency.
+
+And there are terminal states in which an object cleans itself up, deallocates
+memory and potentially deletes stuff from disk:
+
+ (7) State FSCACHE_OBJECT_LC_DYING.
+
+     The object comes here if it is dying because of a lookup or creation
+     error.  This would be due to a disk error or system error of some sort.
+     Temporary data is cleaned up, and the parent is released.
+
+ (8) State FSCACHE_OBJECT_DYING.
+
+     The object comes here if it is dying due to an error, because its parent
+     cookie has been relinquished by the netfs or because the cache is being
+     withdrawn.
+
+     Any child objects waiting on this one are given CPU time so that they too
+     can destroy themselves.  This object waits for all its children to go away
+     before advancing to the next state.
+
+ (9) State FSCACHE_OBJECT_ABORT_INIT.
+
+     The object comes to this state if it was waiting on its parent in
+     FSCACHE_OBJECT_INIT, but its parent died.  The object will destroy itself
+     so that the parent may proceed from the FSCACHE_OBJECT_DYING state.
+
+(10) State FSCACHE_OBJECT_RELEASING.
+(11) State FSCACHE_OBJECT_RECYCLING.
+
+     The object comes to one of these two states when dying once it is rid of
+     all its children, if it is dying because the netfs relinquished its
+     cookie.  In the first state, the cached data is expected to persist, and
+     in the second it will be deleted.
+
+(12) State FSCACHE_OBJECT_WITHDRAWING.
+
+     The object transits to this state if the cache decides it wants to
+     withdraw the object from service, perhaps to make space, but also due to
+     error or just because the whole cache is being withdrawn.
+
+(13) State FSCACHE_OBJECT_DEAD.
+
+     The object transits to this state when the in-memory object record is
+     ready to be deleted.  The object processor shouldn't ever see an object in
+     this state.
+
+
+THE SET OF EVENTS
+-----------------
+
+There are a number of events that can be raised to an object state machine:
+
+ (*) FSCACHE_OBJECT_EV_UPDATE
+
+     The netfs requested that an object be updated.  The state machine will ask
+     the cache backend to update the object, and the cache backend will ask the
+     netfs for details of the change through its cookie definition ops.
+
+ (*) FSCACHE_OBJECT_EV_CLEARED
+
+     This is signalled in two circumstances:
+
+     (a) when an object's last child object is dropped and
+
+     (b) when the last operation outstanding on an object is completed.
+
+     This is used to proceed from the dying state.
+
+ (*) FSCACHE_OBJECT_EV_ERROR
+
+     This is signalled when an I/O error occurs during the processing of some
+     object.
+
+ (*) FSCACHE_OBJECT_EV_RELEASE
+ (*) FSCACHE_OBJECT_EV_RETIRE
+
+     These are signalled when the netfs relinquishes a cookie it was using.
+     The event selected depends on whether the netfs asks for the backing
+     object to be retired (deleted) or retained.
+
+ (*) FSCACHE_OBJECT_EV_WITHDRAW
+
+     This is signalled when the cache backend wants to withdraw an object.
+     This means that the object will have to be detached from the netfs's
+     cookie.
+
+Because the withdrawing releasing/retiring events are all handled by the object
+state machine, it doesn't matter if there's a collision with both ends trying
+to sever the connection at the same time.  The state machine can just pick
+which one it wants to honour, and that effects the other.
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index ecf6946..4420ac6 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -7,7 +7,8 @@ fscache-y := \
 	cookie.o \
 	fsdef.o \
 	main.o \
-	netfs.o
+	netfs.o \
+	object.o
 
 fscache-$(CONFIG_PROC_FS) += proc.o
 fscache-$(CONFIG_FSCACHE_STATS) += stats.o
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 1638994..529f4de 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -86,6 +86,18 @@ extern int fscache_wait_bit(void *);
 extern int fscache_wait_bit_interruptible(void *);
 
 /*
+ * fsc-object.c
+ */
+extern void fscache_withdrawing_object(struct fscache_cache *,
+				       struct fscache_object *);
+extern void fscache_enqueue_object(struct fscache_object *);
+
+/*
+ * fsc-operation.c
+ */
+#define fscache_start_operations(obj) BUG()
+
+/*
  * fsc-proc.c
  */
 #ifdef CONFIG_PROC_FS
@@ -196,7 +208,19 @@ extern const struct file_operations fscache_stats_fops;
 static inline void fscache_raise_event(struct fscache_object *object,
 				       unsigned event)
 {
-	BUG();  // TODO
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
 }
 
 /*****************************************************************************/
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
new file mode 100644
index 0000000..392a41b
--- /dev/null
+++ b/fs/fscache/object.c
@@ -0,0 +1,810 @@
+/* FS-Cache object state machine handler
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * See Documentation/filesystems/caching/object.txt for a description of the
+ * object state machine and the in-kernel representations.
+ */
+
+#define FSCACHE_DEBUG_LEVEL COOKIE
+#include <linux/module.h>
+#include "internal.h"
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
+EXPORT_SYMBOL(fscache_object_states);
+
+static void fscache_object_slow_work_put_ref(struct slow_work *);
+static int  fscache_object_slow_work_get_ref(struct slow_work *);
+static void fscache_object_slow_work_execute(struct slow_work *);
+static void fscache_initialise_object(struct fscache_object *);
+static void fscache_lookup_object(struct fscache_object *);
+static void fscache_object_available(struct fscache_object *);
+static void fscache_release_object(struct fscache_object *);
+static void fscache_withdraw_object(struct fscache_object *);
+static void fscache_enqueue_dependents(struct fscache_object *);
+static void fscache_dequeue_object(struct fscache_object *);
+
+const struct slow_work_ops fscache_object_slow_work_ops = {
+	.get_ref	= fscache_object_slow_work_get_ref,
+	.put_ref	= fscache_object_slow_work_put_ref,
+	.execute	= fscache_object_slow_work_execute,
+};
+EXPORT_SYMBOL(fscache_object_slow_work_ops);
+
+/*
+ * we need to notify the parent when an op completes that we had outstanding
+ * upon it
+ */
+static inline void fscache_done_parent_op(struct fscache_object *object)
+{
+	struct fscache_object *parent = object->parent;
+
+	_enter("OBJ%x {OBJ%x,%x}",
+	       object->debug_id, parent->debug_id, parent->n_ops);
+
+	spin_lock_nested(&parent->lock, 1);
+	parent->n_ops--;
+	parent->n_obj_ops--;
+	if (parent->n_ops == 0)
+		fscache_raise_event(parent, FSCACHE_OBJECT_EV_CLEARED);
+	spin_unlock(&parent->lock);
+}
+
+/*
+ * process events that have been sent to an object's state machine
+ * - initiates parent lookup
+ * - does object lookup
+ * - does object creation
+ * - does object recycling and retirement
+ * - does object withdrawal
+ */
+static void fscache_object_state_machine(struct fscache_object *object)
+{
+	enum fscache_object_state new_state;
+
+	ASSERT(object != NULL);
+
+	_enter("{OBJ%x,%s,%lx}",
+	       object->debug_id, fscache_object_states[object->state],
+	       object->events);
+
+	switch (object->state) {
+		/* wait for the parent object to become ready */
+	case FSCACHE_OBJECT_INIT:
+		object->event_mask =
+			ULONG_MAX & ~(1 << FSCACHE_OBJECT_EV_CLEARED);
+		fscache_initialise_object(object);
+		goto done;
+
+		/* look up the object metadata on disk */
+	case FSCACHE_OBJECT_LOOKING_UP:
+		fscache_lookup_object(object);
+		goto lookup_transit;
+
+		/* create the object metadata on disk */
+	case FSCACHE_OBJECT_CREATING:
+		fscache_lookup_object(object);
+		goto lookup_transit;
+
+		/* handle an object becoming available; start pending
+		 * operations and queue dependent operations for processing */
+	case FSCACHE_OBJECT_AVAILABLE:
+		fscache_object_available(object);
+		goto active_transit;
+
+		/* normal running state */
+	case FSCACHE_OBJECT_ACTIVE:
+		goto active_transit;
+
+		/* update the object metadata on disk */
+	case FSCACHE_OBJECT_UPDATING:
+		clear_bit(FSCACHE_OBJECT_EV_UPDATE, &object->events);
+		fscache_stat(&fscache_n_updates_run);
+		object->cache->ops->update_object(object);
+		goto active_transit;
+
+		/* handle an object dying during lookup or creation */
+	case FSCACHE_OBJECT_LC_DYING:
+		object->event_mask &= ~(1 << FSCACHE_OBJECT_EV_UPDATE);
+		object->cache->ops->lookup_complete(object);
+
+		spin_lock(&object->lock);
+		object->state = FSCACHE_OBJECT_DYING;
+		if (test_and_clear_bit(FSCACHE_COOKIE_CREATING,
+				       &object->cookie->flags))
+			wake_up_bit(&object->cookie->flags,
+				    FSCACHE_COOKIE_CREATING);
+		spin_unlock(&object->lock);
+
+		fscache_done_parent_op(object);
+
+		/* wait for completion of all active operations on this object
+		 * and the death of all child objects of this object */
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
+		/* handle an abort during initialisation */
+	case FSCACHE_OBJECT_ABORT_INIT:
+		_debug("handle abort init %lx", object->events);
+		object->event_mask &= ~(1 << FSCACHE_OBJECT_EV_UPDATE);
+
+		spin_lock(&object->lock);
+		fscache_dequeue_object(object);
+
+		object->state = FSCACHE_OBJECT_DYING;
+		if (test_and_clear_bit(FSCACHE_COOKIE_CREATING,
+				       &object->cookie->flags))
+			wake_up_bit(&object->cookie->flags,
+				    FSCACHE_COOKIE_CREATING);
+		spin_unlock(&object->lock);
+		goto dying;
+
+		/* handle the netfs releasing an object and possibly marking it
+		 * obsolete too */
+	case FSCACHE_OBJECT_RELEASING:
+	case FSCACHE_OBJECT_RECYCLING:
+		object->event_mask &=
+			~((1 << FSCACHE_OBJECT_EV_WITHDRAW) |
+			  (1 << FSCACHE_OBJECT_EV_RETIRE) |
+			  (1 << FSCACHE_OBJECT_EV_RELEASE) |
+			  (1 << FSCACHE_OBJECT_EV_ERROR));
+		fscache_release_object(object);
+		spin_lock(&object->lock);
+		object->state = FSCACHE_OBJECT_DEAD;
+		spin_unlock(&object->lock);
+		fscache_stat(&fscache_n_object_dead);
+		goto terminal_transit;
+
+		/* handle the parent cache of this object being withdrawn from
+		 * active service */
+	case FSCACHE_OBJECT_WITHDRAWING:
+		object->event_mask &=
+			~((1 << FSCACHE_OBJECT_EV_WITHDRAW) |
+			  (1 << FSCACHE_OBJECT_EV_RETIRE) |
+			  (1 << FSCACHE_OBJECT_EV_RELEASE) |
+			  (1 << FSCACHE_OBJECT_EV_ERROR));
+		fscache_withdraw_object(object);
+		spin_lock(&object->lock);
+		object->state = FSCACHE_OBJECT_DEAD;
+		spin_unlock(&object->lock);
+		fscache_stat(&fscache_n_object_dead);
+		goto terminal_transit;
+
+		/* complain about the object being woken up once it is
+		 * deceased */
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
+		new_state = FSCACHE_OBJECT_LC_DYING;
+		goto change_state;
+	case FSCACHE_OBJECT_EV_REQUEUE:
+		goto done;
+	case -1:
+		goto done; /* sleep until event */
+	default:
+		goto unsupported_event;
+	}
+
+	/* determine the transition from an active state */
+active_transit:
+	switch (fls(object->events & object->event_mask) - 1) {
+	case FSCACHE_OBJECT_EV_WITHDRAW:
+	case FSCACHE_OBJECT_EV_RETIRE:
+	case FSCACHE_OBJECT_EV_RELEASE:
+	case FSCACHE_OBJECT_EV_ERROR:
+		new_state = FSCACHE_OBJECT_DYING;
+		goto change_state;
+	case FSCACHE_OBJECT_EV_UPDATE:
+		new_state = FSCACHE_OBJECT_UPDATING;
+		goto change_state;
+	case -1:
+		new_state = FSCACHE_OBJECT_ACTIVE;
+		goto change_state; /* sleep until event */
+	default:
+		goto unsupported_event;
+	}
+
+	/* determine the transition from a terminal state */
+terminal_transit:
+	switch (fls(object->events & object->event_mask) - 1) {
+	case FSCACHE_OBJECT_EV_WITHDRAW:
+		new_state = FSCACHE_OBJECT_WITHDRAWING;
+		goto change_state;
+	case FSCACHE_OBJECT_EV_RETIRE:
+		new_state = FSCACHE_OBJECT_RECYCLING;
+		goto change_state;
+	case FSCACHE_OBJECT_EV_RELEASE:
+		new_state = FSCACHE_OBJECT_RELEASING;
+		goto change_state;
+	case FSCACHE_OBJECT_EV_ERROR:
+		new_state = FSCACHE_OBJECT_WITHDRAWING;
+		goto change_state;
+	case FSCACHE_OBJECT_EV_CLEARED:
+		new_state = FSCACHE_OBJECT_DYING;
+		goto change_state;
+	case -1:
+		goto done; /* sleep until event */
+	default:
+		goto unsupported_event;
+	}
+
+change_state:
+	spin_lock(&object->lock);
+	object->state = new_state;
+	spin_unlock(&object->lock);
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
+ * execute an object
+ */
+static void fscache_object_slow_work_execute(struct slow_work *work)
+{
+	struct fscache_object *object =
+		container_of(work, struct fscache_object, work);
+	unsigned long start;
+
+	_enter("{OBJ%x}", object->debug_id);
+
+	clear_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+
+	start = jiffies;
+	fscache_object_state_machine(object);
+	fscache_hist(fscache_objs_histogram, start);
+	if (object->events & object->event_mask)
+		fscache_enqueue_object(object);
+}
+
+/*
+ * initialise an object
+ * - check the specified object's parent to see if we can make use of it
+ *   immediately to do a creation
+ * - we may need to start the process of creating a parent and we need to wait
+ *   for the parent's lookup and creation to complete if it's not there yet
+ * - an object's cookie is pinned until we clear FSCACHE_COOKIE_CREATING on the
+ *   leaf-most cookies of the object and all its children
+ */
+static void fscache_initialise_object(struct fscache_object *object)
+{
+	struct fscache_object *parent;
+
+	_enter("");
+	ASSERT(object->cookie != NULL);
+	ASSERT(object->cookie->parent != NULL);
+	ASSERT(list_empty(&object->work.link));
+
+	if (object->events & ((1 << FSCACHE_OBJECT_EV_ERROR) |
+			      (1 << FSCACHE_OBJECT_EV_RELEASE) |
+			      (1 << FSCACHE_OBJECT_EV_RETIRE) |
+			      (1 << FSCACHE_OBJECT_EV_WITHDRAW))) {
+		_debug("abort init %lx", object->events);
+		spin_lock(&object->lock);
+		object->state = FSCACHE_OBJECT_ABORT_INIT;
+		spin_unlock(&object->lock);
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
+		spin_lock(&object->lock);
+		spin_lock_nested(&parent->lock, 1);
+		_debug("parent %s", fscache_object_states[parent->state]);
+
+		if (parent->state >= FSCACHE_OBJECT_DYING) {
+			_debug("bad parent");
+			set_bit(FSCACHE_OBJECT_EV_WITHDRAW, &object->events);
+		} else if (parent->state < FSCACHE_OBJECT_AVAILABLE) {
+			_debug("wait");
+
+			/* we may get woken up in this state by child objects
+			 * binding on to us, so we need to make sure we don't
+			 * add ourself to the list multiple times */
+			if (list_empty(&object->dep_link)) {
+				object->cache->ops->grab_object(object);
+				list_add(&object->dep_link,
+					 &parent->dependents);
+
+				/* fscache_acquire_non_index_cookie() uses this
+				 * to wake the chain up */
+				if (parent->state == FSCACHE_OBJECT_INIT)
+					fscache_enqueue_object(parent);
+			}
+		} else {
+			_debug("go");
+			parent->n_ops++;
+			parent->n_obj_ops++;
+			object->lookup_jif = jiffies;
+			object->state = FSCACHE_OBJECT_LOOKING_UP;
+			set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+		}
+
+		spin_unlock(&parent->lock);
+		spin_unlock(&object->lock);
+	}
+
+	spin_unlock(&object->cookie->parent->lock);
+	spin_unlock(&object->cookie->lock);
+	_leave("");
+}
+
+/*
+ * look an object up in the cache from which it was allocated
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
+	ASSERTCMP(parent->n_obj_ops, >, 0);
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
+	spin_lock(&object->lock);
+	if (object->state == FSCACHE_OBJECT_LOOKING_UP) {
+		fscache_stat(&fscache_n_object_lookups_negative);
+
+		/* transit here to allow write requests to begin stacking up
+		 * and read requests to begin returning ENODATA */
+		object->state = FSCACHE_OBJECT_CREATING;
+		spin_unlock(&object->lock);
+
+		set_bit(FSCACHE_COOKIE_PENDING_FILL, &cookie->flags);
+		set_bit(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
+
+		_debug("wake up lookup %p", &cookie->flags);
+		smp_mb__before_clear_bit();
+		clear_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	} else {
+		ASSERTCMP(object->state, ==, FSCACHE_OBJECT_CREATING);
+		spin_unlock(&object->lock);
+	}
+
+	_leave("");
+}
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
+	spin_lock(&object->lock);
+	if (object->state == FSCACHE_OBJECT_LOOKING_UP) {
+		fscache_stat(&fscache_n_object_lookups_positive);
+
+		clear_bit(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
+
+		object->state = FSCACHE_OBJECT_AVAILABLE;
+		spin_unlock(&object->lock);
+
+		smp_mb__before_clear_bit();
+		clear_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	} else {
+		ASSERTCMP(object->state, ==, FSCACHE_OBJECT_CREATING);
+		fscache_stat(&fscache_n_object_created);
+
+		object->state = FSCACHE_OBJECT_AVAILABLE;
+		spin_unlock(&object->lock);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+		smp_wmb();
+	}
+
+	if (test_and_clear_bit(FSCACHE_COOKIE_CREATING, &cookie->flags))
+		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_CREATING);
+
+	_leave("");
+}
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
+
+	if (test_and_clear_bit(FSCACHE_COOKIE_CREATING, &object->cookie->flags))
+		wake_up_bit(&object->cookie->flags, FSCACHE_COOKIE_CREATING);
+
+	fscache_done_parent_op(object);
+	if (object->n_in_progress == 0) {
+		if (object->n_ops > 0) {
+			ASSERTCMP(object->n_ops, >=, object->n_obj_ops);
+			ASSERTIF(object->n_ops > object->n_obj_ops,
+				 !list_empty(&object->pending_ops));
+			fscache_start_operations(object);
+		} else {
+			ASSERT(list_empty(&object->pending_ops));
+		}
+	}
+	spin_unlock(&object->lock);
+
+	object->cache->ops->lookup_complete(object);
+	fscache_enqueue_dependents(object);
+
+	fscache_hist(fscache_obj_instantiate_histogram, object->lookup_jif);
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
+	/* this just shifts the object release to the slow work processor */
+	object->cache->ops->put_object(object);
+
+	_leave("");
+}
+
+/*
+ * release or recycle an object that the netfs has discarded
+ */
+static void fscache_release_object(struct fscache_object *object)
+{
+	_enter("");
+
+	fscache_drop_object(object);
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
+
+/*
+ * allow the slow work item processor to get a ref on an object
+ */
+static int fscache_object_slow_work_get_ref(struct slow_work *work)
+{
+	struct fscache_object *object =
+		container_of(work, struct fscache_object, work);
+
+	return object->cache->ops->grab_object(object) ? 0 : -EAGAIN;
+}
+
+/*
+ * allow the slow work item processor to discard a ref on a work item
+ */
+static void fscache_object_slow_work_put_ref(struct slow_work *work)
+{
+	struct fscache_object *object =
+		container_of(work, struct fscache_object, work);
+
+	return object->cache->ops->put_object(object);
+}
+
+/*
+ * enqueue an object for metadata-type processing
+ */
+void fscache_enqueue_object(struct fscache_object *object)
+{
+	_enter("{OBJ%x}", object->debug_id);
+
+	slow_work_enqueue(&object->work);
+}
+
+/*
+ * enqueue the dependents of an object for metadata-type processing
+ * - the caller must hold the object's lock
+ * - this may cause an already locked object to wind up being processed again
+ */
+static void fscache_enqueue_dependents(struct fscache_object *object)
+{
+	struct fscache_object *dep;
+
+	_enter("{OBJ%x}", object->debug_id);
+
+	if (list_empty(&object->dependents))
+		return;
+
+	spin_lock(&object->lock);
+
+	while (!list_empty(&object->dependents)) {
+		dep = list_entry(object->dependents.next,
+				 struct fscache_object, dep_link);
+		list_del_init(&dep->dep_link);
+
+
+		/* sort onto appropriate lists */
+		fscache_enqueue_object(dep);
+		dep->cache->ops->put_object(dep);
+
+		if (!list_empty(&object->dependents))
+			cond_resched_lock(&object->lock);
+	}
+
+	spin_unlock(&object->lock);
+}
+
+/*
+ * remove an object from whatever queue it's waiting on
+ * - the caller must hold object->lock
+ */
+void fscache_dequeue_object(struct fscache_object *object)
+{
+	_enter("{OBJ%x}", object->debug_id);
+
+	if (!list_empty(&object->dep_link)) {
+		spin_lock(&object->parent->lock);
+		list_del_init(&object->dep_link);
+		spin_unlock(&object->parent->lock);
+	}
+
+	_leave("");
+}
+
+/**
+ * fscache_check_aux - Ask the netfs whether an object on disk is still valid
+ * @object: The object to ask about
+ * @data: The auxiliary data for the object
+ * @datalen: The size of the auxiliary data
+ *
+ * This function consults the netfs about the coherency state of an object
+ */
+enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
+					const void *data, uint16_t datalen)
+{
+	enum fscache_checkaux result;
+
+	if (!object->cookie->def->check_aux) {
+		fscache_stat(&fscache_n_checkaux_none);
+		return FSCACHE_CHECKAUX_OKAY;
+	}
+
+	result = object->cookie->def->check_aux(object->cookie->netfs_data,
+						data, datalen);
+	switch (result) {
+		/* entry okay as is */
+	case FSCACHE_CHECKAUX_OKAY:
+		fscache_stat(&fscache_n_checkaux_okay);
+		break;
+
+		/* entry requires update */
+	case FSCACHE_CHECKAUX_NEEDS_UPDATE:
+		fscache_stat(&fscache_n_checkaux_update);
+		break;
+
+		/* entry requires deletion */
+	case FSCACHE_CHECKAUX_OBSOLETE:
+		fscache_stat(&fscache_n_checkaux_obsolete);
+		break;
+
+	default:
+		BUG();
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(fscache_check_aux);

