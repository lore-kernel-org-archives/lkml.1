Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZDBQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZDBQuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764136AbZDBQso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:48:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283AbZDBQsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:48:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030315.03606.nickpiggin@yahoo.com.au>
References: <200904030315.03606.nickpiggin@yahoo.com.au> <200904030225.16372.nickpiggin@yahoo.com.au> <5198.1238682972@redhat.com> <6362.1238687462@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: What I mean by a 'netfs' when dealing with FS-Cache
Date: Thu, 02 Apr 2009 17:48:38 +0100
Message-ID: <7008.1238690918@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think I see the problem.  I think you're misunderstanding what I mean by
netfs.

Note that when I say 'netfs' I don't necessarily _mean_ it has to be a network
fs.  It could be NFS, AFS, CIFS, but it might also be ISO9660.  Look at these
two diagrams (taken from the docs added by patch 07):

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

NFS, AFS and ISOFS in this diagram all fill the roll of 'netfs'.  CacheFS
(cache on blockdev) and CacheFiles (cache on filesystem) fill the roll of
'backingfs'.

And:

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


FS-Cache tracks pages from the 'netfs' because it may want to keep metadata on
them (such as where in the backingfs the pages are to be stored).  In many
ways, PG_fscache is equivalent of PG_mappedtodisk.  You could think of it as
PG_mappedtocache if you like.

The procedure for the netfs to use the cache on a page is that it calls one
of:

	fscache_read_or_alloc_page()
	fscache_read_or_alloc_pages()
	fscache_alloc_page()

to either read pages from the cache or reserve space in the cache into which
the page can be written.

Then, the netfs calls:

	fscache_write_page()

to write pages back to the cache as often as it likes.  This may only be
called if read/alloc has been called first, and is permitted, inside the
caching backend (eg CacheFiles), to cache metadata about the read/alloc.

Finally, to polish off, the netfs calls:

	fscache_uncache_page()

to tell FS-Cache to release any metadata it might hold on that page.

As I've been saying, I want to be able to make iso9660 be a client of FS-Cache
- ie: fill the roll of a netfs.

David
