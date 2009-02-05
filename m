Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbZBEJfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbZBEJfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZBEJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:35:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44617 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZBEJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:35:24 -0500
Date: Thu, 5 Feb 2009 18:34:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: mel@csn.ul.ie, heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-Id: <20090205183409.1a12c23b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090205.012123.141238531.davem@davemloft.net>
References: <20090204.222651.26527737.davem@davemloft.net>
	<20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090205.012123.141238531.davem@davemloft.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Feb 2009 01:21:23 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 5 Feb 2009 18:06:17 +0900
> 
> > @@ -2632,7 +2633,8 @@ void __meminit memmap_init_zone(unsigned
> >  		if (context == MEMMAP_EARLY) {
> >  			if (!early_pfn_valid(pfn))
> >  				continue;
> > -			if (!early_pfn_in_nid(pfn, nid))
> > +			tmp = early_pfn_in_nid(pfn, nid);
> > +			if (tmp > -1 && tmp != nid)
> 
> early_pfn_in_nid() returns true or false, not the found nid
> 
> I think you meant to change this to call early_pfn_to_nid()
> 
sorry..

> I'll make that correction and test your patch.
> 
> BTW, if you make that conversion there is no need for
> early_pfn_in_nid() since there will be no other users.
> 

Thanks, maybe the patch will be like this.
-Kame
==
If a pfn is not in early_node_map[], memmap for it is not initialized.
By this, PG_reserved is not set and the invalid memmap may sneak into buddy
allocator.

To avoid that, initialize it with give nid if no early_node_map[] for pfn
exists. PG_reserved will make this page unused.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mmzone.h |    6 ------
 mm/page_alloc.c        |    7 +++++--
 2 files changed, 5 insertions(+), 8 deletions(-)

Index: mmotm-2.6.29-Feb03/mm/page_alloc.c
===================================================================
--- mmotm-2.6.29-Feb03.orig/mm/page_alloc.c
+++ mmotm-2.6.29-Feb03/mm/page_alloc.c
@@ -2618,6 +2618,7 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
 	struct zone *z;
+	int tmp;
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
@@ -2632,7 +2633,8 @@ void __meminit memmap_init_zone(unsigned
 		if (context == MEMMAP_EARLY) {
 			if (!early_pfn_valid(pfn))
 				continue;
-			if (!early_pfn_in_nid(pfn, nid))
+			tmp = early_pfn_to_nid(pfn);
+			if (tmp > -1 && tmp != nid)
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -2999,8 +3001,9 @@ int __meminit early_pfn_to_nid(unsigned 
 			return early_node_map[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
+
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 /* Basic iterator support to walk early_node_map[] */
Index: mmotm-2.6.29-Feb03/include/linux/mmzone.h
===================================================================
--- mmotm-2.6.29-Feb03.orig/include/linux/mmzone.h
+++ mmotm-2.6.29-Feb03/include/linux/mmzone.h
@@ -1070,12 +1070,6 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
-#else
-#define early_pfn_in_nid(pfn, nid)	(1)
-#endif
-
 #ifndef early_pfn_valid
 #define early_pfn_valid(pfn)	(1)
 #endif

