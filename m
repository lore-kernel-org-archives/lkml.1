Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZCKPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZCKPcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZCKPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:32:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34006 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbZCKPco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:32:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get
	wrongly discarded
To: torvalds@osdl.org, akpm@linux-foundation.org, peterz@infradead.org
Cc: Enrik.Berkhan@ge.com, dhowells@redhat.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Date: Wed, 11 Mar 2009 15:30:35 +0000
Message-ID: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Enrik Berkhan <Enrik.Berkhan@ge.com>

The pages attached to a ramfs inode's pagecache by truncation from nothing - as
done by SYSV SHM for example - may get discarded under memory pressure.

The problem is that the pages are not marked dirty.  Anything that creates data
in an MMU-based ramfs will cause the pages holding that data will cause the
set_page_dirty() aop to be called.

For the NOMMU-based mmap, set_page_dirty() may be called by write(), but it
won't be called by page-writing faults on writable mmaps, and it isn't called
by ramfs_nommu_expand_for_mapping() when a file is being truncated from nothing
to allocate a contiguous run.

The solution is to mark the pages dirty at the point of allocation by
the truncation code.

Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/file-nommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index b9b567a..90d72be 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -114,6 +114,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add_file(&lru_pvec);
 
+		/* prevent the page from being discarded on memory pressure */
+		SetPageDirty(page);
+
 		unlock_page(page);
 	}
 

