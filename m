Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXCFIaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXCFIaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbXCFIaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:30:23 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:47750 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbXCFIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:30:20 -0500
Message-ID: <45ED2619.4000709@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2007 13:58:09 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, devel@openvz.org, xemul@sw.ru,
       Paul Menage <menage@google.com>, Christoph Lameter <clameter@sgi.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3][RFC] Containers: Pagecache controller accounting
References: <45ED251C.2010400@linux.vnet.ibm.com>
In-Reply-To: <45ED251C.2010400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The accounting framework works by adding a container pointer in
address_space structure.  Each page in pagecache belongs to a
radix tree within the address_space structure corresponding to the inode.

In order to charge the container for pagecache usage, the corresponding
address_space is obtained from struct page which holds the container pointer.
This framework avoids any additional pointers in struct page.

additions and deletions from pagecache are hooked to charge and uncharge
the corresponding container.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---
 include/linux/fs.h |    4 ++++
 mm/filemap.c       |    8 ++++++++
 2 files changed, 12 insertions(+)

--- linux-2.6.20.orig/include/linux/fs.h
+++ linux-2.6.20/include/linux/fs.h
@@ -447,6 +447,10 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+#ifdef CONFIG_CONTAINER_PAGECACHE_ACCT
+	struct container *container; 	/* Charge page to the right container
+					   using page->mapping */
+#endif
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
--- linux-2.6.20.orig/mm/filemap.c
+++ linux-2.6.20/mm/filemap.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/cpuset.h>
+#include <linux/pagecache_acct.h>
 #include "filemap.h"
 #include "internal.h"

@@ -117,6 +118,8 @@ void __remove_from_page_cache(struct pag
 	struct address_space *mapping = page->mapping;

 	radix_tree_delete(&mapping->page_tree, page->index);
+	/* Uncharge before the mapping is gone */
+	pagecache_acct_uncharge(page);
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
@@ -451,6 +454,11 @@ int add_to_page_cache(struct page *page,
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 		}
 		write_unlock_irq(&mapping->tree_lock);
+		/* Unlock before charge, because we may reclaim this inline */
+		if (!error) {
+			pagecache_acct_init_page_ptr(page);
+			pagecache_acct_charge(page);
+		}
 		radix_tree_preload_end();
 	}
 	return error;
