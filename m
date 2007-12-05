Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXLERL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXLERL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXLERLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:11:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXLERLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:11:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
cc: dhowells@redhat.com, Steve Dickson <SteveD@redhat.com>,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: How to manage shared persistent local caching (FS-Cache) with NFS?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 05 Dec 2007 17:11:00 +0000
Message-ID: <6306.1196874660@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay...  I'm getting to the point where I want to release my local caching
patches again and have NFS work with them.  This means making NFS mounts share
or not share appropriately - something that's engendered a fair bit of
argument.

So I'd like to solicit advice on how best to deal with this problem.

Let me explain the problem in more detail.


================
CURRENT PRACTICE
================

As the kernel currently stands, coherency is ignored for mounts that have
slightly different combinations of parameters, even if these parameters just
affect the properties of network "connection" used or just mark a superblock
as being read-only.

Consider the case of a file remotely available by NFS.  Imagine the client sees
three different views of this file (they could be by three overlapping mounts,
or by three hardlinks or some combination thereof).

This is how NFS currently operates without any superblock sharing:

				+---------+
    Object on server --->	|	  |
				|  inode  |
				|	  |
				+---------+
				    /|\
				   / | \
				  /  |	\
				 /   |	 \
				/    |	  \
			       /     |	   \
			      /	     |	    \
			     /	     |	     \
			    /	     |	      \
			   /	     |	       \
			  /	     |		\
			 |	     |		 |
			 |	     |		 |
 :::::::::::::NFS::::::::|:::::::::::|:::::::::::|:::::::::::::::::::::::::::::
			 |	     |		 |
			 |	     |		 |
			 |	     |		 |
   +---------+	    +---------+	     |		 |
   |	     |	    |	      |	     |		 |
   | mount 1 |----->| super 1 |	     |		 |
   |	     |	    |	      |	     |		 |
   +---------+	    +---------+	     |		 |
				     |		 |
				     |		 |
   +---------+			+---------+	 |
   |	     |			|	  |	 |
   | mount 2 |----------------->| super 2 |	 |
   |	     |			|	  |	 |
   +---------+			+---------+	 |
						 |
						 |
   +---------+				    +---------+
   |	     |				    |	      |
   | mount 3 |----------------------------->| super 3 |
   |	     |				    |	      |
   +---------+				    +---------+

Each view of the file on the client winds up with a separate inode in a
separate superblock and with a separate pagecache.  As far as the client kernel
is concerned, they *are* three different files.  Any incoherency effects are
ignored by the kernel and if they cause a userspace application a problem,
that's just too bad.

Generally, however, this is not a problem because:

  (a) an application is unlikely to be attempting to manipulate multiple views
      of a file simultaneously and

  (b) cross-view hard links haven't been and aren't used that much.


=============================
POSSIBLE FS-CACHE SCENARIO #1
=============================

However, now we're introducing persistent local caching into the mix.  That
means we can no longer ignore such remote possibilities - they are possible,
therefore we have to deal with them, whether we like it or not.

The seemingly simplest way to support this is to give each copy of the remote
file its own cache:

				+---------+
    Object on server --->	|	  |
				|  inode  |
				|	  |
				+---------+
				    /|\
				   / | \
				  /  |	\
				 /   |	 \
				/    |	  \
			       /     |	   \
			      /	     |	    \
			     /	     |	     \
			    /	     |	      \
			   /	     |	       \
			  /	     |		\
			 |	     |		 |
			 |	     |		 |
 :::::::::::::NFS::::::::|:::::::::::|:::::::::::|:::::::::::::::::::::::::::::
			 |	     |		 |	       :
			 |	     |		 |	       : FS-Cache
			 |	     |		 |	       :
   +---------+	    +---------+	     |		 |	       :    +---------+
   |	     |	    |	      |	     |		 |	       :    |	      |
   | mount 1 |----->| super 1 |------|-----------|----------------->| cache 1 |
   |	     |	    |	      |	     |		 |	       :    |	      |
   +---------+	    +---------+	     |		 |	       :    +---------+
				     |		 |	       :
				     |		 |	       :
   +---------+			+---------+	 |	       :    +---------+
   |	     |			|	  |	 |	       :    |	      |
   | mount 2 |----------------->| super 2 |------|----------------->| cache 2 |
   |	     |			|	  |	 |	       :    |	      |
   +---------+			+---------+	 |	       :    +---------+
						 |	       :
						 |	       :
   +---------+				    +---------+	       :    +---------+
   |	     |				    |	      |	       :    |	      |
   | mount 3 |----------------------------->| super 3 |------------>| cache 3 |
   |	     |				    |	      |	       :    |	      |
   +---------+				    +---------+	       :    +---------+

This has one immediately obvious problem: it stores redundant data in the
cache.  We end up with three copies of the same data stored in the cache,
reducing the cache efficiency.

There's a further problem that is less obvious: the cache is persistent - and
so the links from the client inodes into the cache must be reformed for
subsequent mounts.  This is not possible purely from the NFS attributes of the
server file, since each client file corresponds to the same server file.

To get around that, we'd have to add some of the purely client knowledge into
the key, such as root filehandle of a mount or local mount point.  However,
neither of these is sufficient:

 (*) The root filehandle may be mounted multiple times with different NFS
     connection parameters, so all of these must be included too.

 (*) The local mount point depends on the namespace in which it is made, and
     that is anonymous and can't contribute to the key.

Alternatively, we could require user intervention to map the files to their
respective caches (probably at the mount level), but that is in itself a
problem.

Furthermore, should disconnected operation be implemented, we then have the
problems of (a) how to synchronise changes made to the same file through
separate views, and (b) how to propagate changes between views without being
able to use the server as an intermediary.


=============================
POSSIBLE FS-CACHE SCENARIO #2
=============================

So, ideally, what we want to do is to share the local cache.  We could do this
by mapping each of the multiple client views to a single local cache object:

				+---------+
    Object on server --->	|	  |
				|  inode  |
				|	  |
				+---------+
				    /|\
				   / | \
				  /  |	\
				 /   |	 \
				/    |	  \
			       /     |	   \
			      /	     |	    \
			     /	     |	     \
			    /	     |	      \
			   /	     |	       \
			  /	     |		\
			 |	     |		 |
			 |	     |		 |
 :::::::::::::NFS::::::::|:::::::::::|:::::::::::|:::::::::::::::::::::::::::::
			 |	     |		 |	       :
			 |	     |		 |	       : FS-Cache
			 |	     |		 |	       :
   +---------+	    +---------+	     |		 |	       :
   |	     |	    |	      |	     |		 |	       :
   | mount 1 |----->| super 1 |------|-----------|------       :
   |	     |	    |	      |	     |		 |	\      :
   +---------+	    +---------+	     |		 |	 \     :
				     |		 |	  \    :
				     |		 |	   \   :
   +---------+			+---------+	 |	    \  :    +---------+
   |	     |			|	  |	 |	     \ :    |	      |
   | mount 2 |----------------->| super 2 |------|----------------->|  cache  |
   |	     |			|	  |	 |	     / :    |	      |
   +---------+			+---------+	 |	    /  :    +---------+
						 |	   /   :
						 |	  /    :
   +---------+				    +---------+	 /     :
   |	     |				    |	      | /      :
   | mount 3 |----------------------------->| super 3 |-       :
   |	     |				    |	      |	       :
   +---------+				    +---------+	       :

However, this means the kernel now has to deal with coherency maintenance
because it no longer treats the three views of the server file as being
completely separate, but on the other hand, the persistent-store matching
problem is no longer present.

The coherency problems arise from a number of facets:

 (1) Even if all three mounts are read-only, the client views may be updated at
     different times when the server file changes.  However, when one view sees
     a change, the on-disk cache must be flushed, but all the other views must
     notified that the mappings between extant pages and the cache are now
     broken.  This could, perhaps, be rendered down to a change perceived by
     one view causing all the pagecache on the other views being zapped.

 (2) How do we update the cache when writes are made to two or more client
     views?  We could require the changes to a view to be written back to the
     server before any other views are changed, but what about disconnected
     operation?

Basically, we end up treating the inodes that back multiple views of a single
server file as being the same inode - and maintain coherency manually.

Furthermore, we also require the infrastructure to support all of this, and
that requires more memory and processing time to maintain, not to mention the
introduction of cross-inode deadlock potential.


=============================
POSSIBLE FS-CACHE SCENARIO #3
=============================

In fact, the ideal solution is to share client superblocks, inodes and
pagecache content too:

				+---------+
    Object on server --->	|	  |
				|  inode  |
				|	  |
				+---------+
				     |
				     |
				     |
				     |
				     |
				     |
				     |
				     |
				     |
				     |
				     |
				     |
				     |
 :::::::::::::NFS::::::::::::::::::::|:::::::::::::::::::::::::::::::::::::::::
				     |			       :
				     |			       : FS-Cache
				     |			       :
   +---------+			     |			       :
   |	     |			     |			       :
   | mount 1 |----------	     |			       :
   |	     |		\	     |			       :
   +---------+		 \	     |			       :
			  \	     |			       :
			   \	     |			       :
   +---------+		    \	+---------+		       :    +---------+
   |	     |		     \	|	  |		       :    |	      |
   | mount 2 |----------------->|  super  |------------------------>|  cache  |
   |	     |		     /	|	  |		       :    |	      |
   +---------+		    /	+---------+		       :    +---------+
			   /				       :
			  /				       :
   +---------+		 /				       :
   |	     |		/				       :
   | mount 3 |----------				       :
   |	     |						       :
   +---------+						       :

This renders both the intraclient coherency problem and the cache object
reconnection problem nonexistent within the client simply by virtue of only
having one client inode represent *all* the views requested of the server file.

There are other coherency problems, but largely we can't deal with those within
NFS because they involve multiple clients and the NFS protocol doesn't provide
us with the tools.

The downside of this is that each shared superblock only has one NFS connection
to the server, and so only one set of connection parameters can be used.
However, since persistent local caching is novel to Linux, I think that it is
entirely reasonable to overrule the attempts to make mounts with different
parameters if they are to be shared and cached.



====

Okay...  So that's the problem.  Anyone got any suggestions?

My preferred solution is to take any NFS superblock which has fscaching enabled
and forcibly share it with any potentially overlapping superblock that also has
fscaching enabled.  That means the parameters of subsequent mounts are
discarded in favour of retaining the parameters of the first mount in an
fscached set.

The R/O mount flag can be dealt with by moving readonlyness into the vfsmount
rather than having it a property of the superblock.  The superblock would then
be read-only only if all its vfsmounts are also read-only.


There's one other thing to consider:

I've been asked to make the granularity of caching controllable at a directory
or file level.  However, this goes against passing the parameter in the mount
command.  There is an advantage, though: if your NFS mounts are dictated by
automounter, then enabling fscache in the mount options is not necessarily what
you want to do.

Would it be reasonable to have an outside way of setting directory options?
For instance, if there was a table like this:

	FS	SERVER	VOLUME	DIR		OPTIONS
	=======	=======	=======	===============	=========================
	nfs	home0	-	/home/*		fscache
	afs	redhat	data	/data/*		fscache

This could then be loaded into the kernel as a set of rules which directory
lookup by the filesystem involved could attempt to match and apply.

Davod
