Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZGPFe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZGPFe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZGPFe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:34:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51911 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbZGPFe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:34:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: + mm-vmstat-add-isolate-pages.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, fengguang.wu@intel.com,
       minchan.kim@gmail.com, riel@redhat.com
In-Reply-To: <20090716142903.0c7f8a92.kamezawa.hiroyu@jp.fujitsu.com>
References: <200907160321.n6G3LaFZ028244@imap1.linux-foundation.org> <20090716142903.0c7f8a92.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090716143311.9D3A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 14:34:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 15 Jul 2009 20:21:36 -0700
> akpm@linux-foundation.org wrote:
> > ------------------------------------------------------
> > Subject: mm: vmstat: add isolate pages
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> 
> Hi, Kosaki,
> 
> > If the system is running a heavy load of processes then concurrent reclaim
> > can isolate a large number of pages from the LRU. /proc/meminfo and the
> > output generated for an OOM do not show how many pages were isolated.
> > 
> <snip>
>  
> > @@ -742,6 +746,13 @@ int migrate_pages(struct list_head *from
> >  	struct page *page2;
> >  	int swapwrite = current->flags & PF_SWAPWRITE;
> >  	int rc;
> > +	int flags;
> 
> unsigned long.

Grr. yes my fault.


> > +
> > +	local_irq_save(flags);
> > +	list_for_each_entry(page, from, lru)
> > +		__inc_zone_page_state(page, NR_ISOLATED_ANON +
> > +				      !!page_is_file_cache(page));
> > +	local_irq_restore(flags);

Fixing patch is here ;-)


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/migrate.c
===================================================================
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -744,7 +744,7 @@ int migrate_pages(struct list_head *from
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc;
-	int flags;
+	unsigned long flags;
 
 	local_irq_save(flags);
 	list_for_each_entry(page, from, lru)




