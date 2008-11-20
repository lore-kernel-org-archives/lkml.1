Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYKTOn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYKTOn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYKTOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:42:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40976 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbYKTOmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:42:00 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/45] Permit filesystem local caching [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:41:39 +0000
Message-ID: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add local caching for network filesystems such as NFS and AFS.
These patches are also available in tarball format here:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-41.tar.bz2


To give a really quick overview of the way the facility works:

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

  (*) 01-slow-work.diff
  (*) 02-slow-work-dynamic.diff
  (*) 03-slow-work-config.diff
  (*) 04-slow-work-doc.diff

      A thread pool for (very) slow work items, such as batches of lookup,
      mkdir, create and [sg]etxattr calls.

      It doesn't make sense to use an ordinary work queue because I want more
      than one thread, but I don't want to be limited to 1 thread per CPU.
      The work items in question take a long time, most of which is spent
      sleeping on I/O.  For the duration the worker thread is unable to do
      anything else.

      These four patches add the basic facility, make it dynamic, make it
      configurable and document it.


  (*) 05-release-page.diff

      Call the page release function after a failed readahead.

  (*) 06-fscache-page-flags.diff

      Add two extra page flags that FS-Cache then uses to keep track of two
      bits of per-cached-page information:

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

  (*) 07-add_wait_queue_tail.diff

      Make it possible to add an item to the back of a waitqueue instead of the
      front


  (*) 08-fscache-netfs-api.diff
  (*) 09-fscache-backend-api.diff
  (*) 10-fscache-kconfig.diff
  (*) 11-fscache-proc.diff
  (*) 12-fscache-fsdef.diff
  (*) 13-fscache-tag-handling.diff
  (*) 14-fscache-cache-handling.diff
  (*) 15-fscache-cookie-jar.diff
  (*) 16-fscache-netfs-reg.diff
  (*) 17-fscache-bits.diff
  (*) 18-fscache-object.diff
  (*) 19-fscache-cookie.diff
  (*) 20-fscache-operation.diff
  (*) 21-fscache-io.diff

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

      Five documents in text file format that describe the FS-Cache interface
      are added by these patches:

      Documentation/filesystems/caching/fscache.txt gives an overview of the
      facility and describes the statistical data it makes available.

      Documentation/filesystems/caching/netfs-api.txt describes the API by
      which a network filesystem would make use of the FS-Cache facility.

      Documentation/filesystems/caching/backend-api.txt describes the API that
      a cache backend must implement to provide caching services through
      FS-Cache.

      Documentation/filesystems/caching/object.txt describes the object
      management state machine used.

      Documentation/filesystems/caching/operations.txt describes the operation
      scheduling facility provided and used by FS-Cache that can also be used
      by cache backend modules.

      The patches provide the following components of the FS-Cache facility:

      (08) The netfs API header file and documentation.  A netfs can actually
      	   be built and run against just this patch.  It won't actually do
      	   anything without the later patches, though, but it will compile.

      (09) The cache backend API header file and documentation.

      (10) The main selector configuration option, the main module load/unload
      	   hooks and the debugging code declarations.  With this patch applied,
      	   it is possible to enable caching in a client netfs, though it won't
      	   actually do anything.

      (11) The /proc files for statistics presentation, plus the internal
      	   interfaces for driving it.

      (12) The top level index definition.

      (13) Cache reference tag handling.

      (14) Cache (un)registration and error handling.

      (15) Cookie (de)allocator and initialisation.

      (16) Netfs (un)registration handling.  This is partly usable.  Without a
      	   later patch, however, a cookie will be leaked from unregistration.

      (17) Bit waiting utility functions.

      (18) The object management state machine implementation and
      	   documentation.

      (19) Implementation of the cookie management part of the netfs API.  With
      	   this, it's possible for netfs's to actually be granted cookies and
      	   to release them without error.

      (20) Cache I/O operation scheduler and documentation.

      (21) Implementation of the data I/O part of the netfs API.


  (*) 22-cachefiles-ia64.diff
  (*) 23-cachefiles-ext3-f_mapping.diff
  (*) 24-cachefiles-write.diff
  (*) 25-cachefiles-monitor.diff
  (*) 26-cachefiles-export.diff
  (*) 27-cachefiles.diff

      Patches to provide a local cache in a directory of an already mounted
      filesystem.

      The latter patch adds a document in text file format that describes the
      CacheFiles cache backend and gives instructions on how it is set up and
      used.  This will be Documentation/filesystems/caching/cachefiles.txt when
      the patch is applied.

  (*) 28-afs-fscache.diff

      Patches to provide AFS with local caching.

  (*) 29-nfs-comment.diff
  (*) 30-nfs-fscache-option.diff
  (*) 31-nfs-fscache-kconfig.diff
  (*) 32-nfs-fscache-top-index.diff
  (*) 33-nfs-fscache-server-obj.diff
  (*) 34-nfs-fscache-super-obj.diff
  (*) 35-nfs-fscache-inode-obj.diff
  (*) 36-nfs-fscache-use-inode.diff
  (*) 37-nfs-fscache-invalidate-pages.diff
  (*) 38-nfs-fscache-iostats.diff
  (*) 39-nfs-fscache-page-management.diff
  (*) 40-nfs-fscache-read-context.diff
  (*) 41-nfs-fscache-read-fallback.diff
  (*) 42-nfs-fscache-read-from-cache.diff
  (*) 43-nfs-fscache-store-to-cache.diff
  (*) 44-nfs-fscache-display.diff
  (*) 45-nfs-fscache-mount.diff

      Patches to provide NFS with local caching.


The requisite security patches are now resident in James Morris's security
testing tree (branch next) and linux-next.

I've been testing these patches by throwing batches of eight parallel "tar cf"
commands across three different 350MB NFS-based kernel trees (3 tars on first
tree, 3 on second, 2 on third), sometimes with one or more of the trees
preloaded into the cache.  The complete working data set does not fit into the
RAM of my test machine, so even three tars that can be entirely satisfied from
the cache, the cache may have to reread everything from disk.

I've also occasionally stopped the cache and restarted it whilst the tars were
using it, whilst both loading it up and reading it back.

I've also been running tars against AFS mounted kernel trees.

--
These patches should be built on top of:

	http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git

branch 'next'.


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
