Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZJBJvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZJBJvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZJBJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:51:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:45966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbZJBJvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:51:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,493,1249282800"; 
   d="scan'208";a="194343126"
Date: Fri, 2 Oct 2009 17:50:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Steve French <sfrench@samba.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       David Howells <dhowells@redhat.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [RFC] writeback: abort writeback of the inode on wrap-around
Message-ID: <20091002095050.GA12750@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When past EOF, abort the writeback of the current inode, which will
instruct writeback_single_inode() to redirty_tail() it. 

This is the right behavior for
- sync writeback (is already so with range_whole)
  we have scanned the inode address space, and don't care any more newly
  dirtied pages. So shall update its i_dirtied_when and exclude it from
  the todo list.
- periodic writeback
  any more newly dirtied pages should be associated with a new expire
  time. This also prevents pointless IO for busy overwriters.
- background writeback (irrelevant)
  it generally don't care the dirty timestamp.

That should get rid of one inefficient IO pattern of .range_cyclic when
writeback_index wraps, in which the submitted pages may be consisted of
two distant ranges: submit [10000-10100], (wrap), submit [0-100].

The new .stop_on_wrap is a quick hack to show the basic idea. Ideal
would be to just convert the existing .range_cyclic to new behavior.
This should simplify a lot of code.

Since this involves many filesystems. I'd like to ask if any of them
in fact _desire_ the current .range_cyclic semantics to wrap?

Thanks,
Fengguang
---
 fs/fs-writeback.c         |    1 +
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-10-02 16:46:36.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-02 17:01:27.000000000 +0800
@@ -810,6 +810,7 @@ static long wb_writeback(struct bdi_writ
 		.for_kupdate		= args->for_kupdate,
 		.for_background		= args->for_background,
 		.range_cyclic		= args->range_cyclic,
+		.stop_on_wrap		= 1,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
--- linux.orig/include/linux/writeback.h	2009-10-02 16:46:36.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-02 16:57:13.000000000 +0800
@@ -57,6 +57,7 @@ struct writeback_control {
 	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned stop_on_wrap:1;	/* stop when write index is to wrap */
 	unsigned more_io:1;		/* more io to be dispatched */
 	/*
 	 * write_cache_pages() won't update wbc->nr_to_write and
--- linux.orig/mm/page-writeback.c	2009-10-02 16:46:36.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-02 16:57:13.000000000 +0800
@@ -913,7 +913,9 @@ continue_unlock:
 			break;
 		}
 	}
-	if (!cycled && !done) {
+	if (wbc->stop_on_wrap)
+		done_index = 0;
+	else if (!cycled && !done) {
 		/*
 		 * range_cyclic:
 		 * We hit the last page and there is more work to be done: wrap
