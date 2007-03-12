Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbXCLSmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbXCLSmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXCLSmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:42:14 -0400
Received: from delta.idt.cz ([81.0.223.58]:4488 "EHLO delta.idt.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXCLSmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:42:12 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 14:42:12 EDT
Date: Mon, 12 Mar 2007 19:57:58 +0100
From: Michal Hocko <msts@seznam.cz>
To: linux-kernel@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: mm: migrate_pages using
Message-ID: <20070312185758.GA25820@curandero.idtnet.org>
References: <20070310211631.GA29295@curandero.idtnet.org> <20070312163255.73422184.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20070312163255.73422184.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2007 at 04:32:55PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> > When I try to put_page(original) (because I don't want it for this
> > moment) I get to bad_page path and need to reboot...
> > 
> > What am I missing? Am I using migrate_pages correctly?
> > 
> 
> ==
> migrate_pages()					    | refcnt = 2,
> 	-> unmap_and_move()			    | refcnt = 2,
> 		-> try_to_unmap()		    | refcnt = 1
> 		-> move_to_lru()		    | refcnt = 1
> 			-> lru_cache_add()  	    | refcnt = 1
> 				-> page_cache_get() | refcnt = 2
> 				-> pagevec_add()    | refcnt = 2 
> 			-> page_cache_put()         | refcnt 1
> ==

Thanks for clarification. 

> see pagevec codes and release_pages() in swap.c
> per-cpu pagevec caches freed pages for a while. 
> It will be pushed back to the free list when pagevec goes full.

I am not sure about that. When I looked inside lru_cache_add, it will
call __pagevec_lru_add if per-cpu pagevec goes empty and this function
will add all pages to the zone specific inactive list.

I want to prevent that because I need to use original page for other
purposes and so it can't be in inactive list. So I have created little
change to unmap_and_move function so that original page is added back tu
LRU only if required. migrate_pages uses variant with put_lru parameter
and I am using __migrate_pfn_page which uses put_lru=0. See the attached 
patch.
What do you think about that. Is this way correct?

(Please add me to CC, because I am not list member)

Best regards
-- 
Michal Hocko

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

--- /usr/src/linux-vanilla/mm/migrate.c	2006-12-02 15:08:23.000000000 +0100
+++ /usr/src/linux/mm/migrate.c	2007-03-12 18:44:16.000000000 +0100
 
@@ -587,7 +595,7 @@ static int move_to_new_page(struct page 
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force)
+			struct page *page, int force, int put_lru)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -631,10 +639,11 @@ unlock:
  		 * A page that has been migrated has all references
  		 * removed and will be freed. A page that has not been
  		 * migrated will have kepts its references and be
- 		 * restored.
+ 		 * restored. Don't push page to LRU unless wanted.
  		 */
  		list_del(&page->lru);
- 		move_to_lru(page);
+		if(put_lru)
+			move_to_lru(page);
 	}
 
 move_newpage:
@@ -687,7 +696,7 @@ int migrate_pages(struct list_head *from
 			cond_resched();
 
 			rc = unmap_and_move(get_new_page, private,
-						page, pass > 2);
+						page, pass > 2, 1);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -717,6 +726,111 @@ out:
 	return nr_failed + retry;
 }
 
+/* target page is stored in private parameter when used from 
+ * migrate_pfn_page
+ */
+static struct page * return_target(struct page * page, unsigned long private, 
+		int ** result)
+{
+	return (struct page *)private;
+}
+
+int __migrate_pfn_page(struct page * page, new_page_t get_new_page, unsigned long private)
+{
+	int rc = 0;
+	int pass;
+	int retry = 1;
+
+	for(pass = 0; pass < 10 && retry; pass++)
+	{
+		retry = 0;
+		cond_resched();
+		rc = unmap_and_move(get_new_page, private, page, pass > 2, 0);
+		switch(rc) 
+		{
+			case -ENOMEM:
+				goto out;
+			case -EAGAIN:
+				retry = 1;
+				break;
+			case 0:
+				break;
+			default:
+				return 1;
+		}
+	}
+	if(rc)
+		move_to_lru(page);
+out:
+	return rc;
+}
+
+int migrate_pfn_page(struct page * original, struct page * target)
+{
+	LIST_HEAD(pagelist);
+	int ret;
+	int swapwrite = current->flags & PF_SWAPWRITE;
+
+	if (!swapwrite)
+		current->flags |= PF_SWAPWRITE;
+
+	/* this will fail if migration is not supported */
+	if((ret = migrate_prep()))
+		goto done;
+	get_page(original);
+	ret = isolate_lru_page(original, &pagelist);
+	put_page(original);
+	if(ret)
+		goto done;
+	ret = __migrate_pfn_page(original, return_target, (unsigned long)target);
+	if(!ret)
+		page_cache_release(original);
+done:
+	if (!swapwrite)
+		current->flags &= ~PF_SWAPWRITE;
+	return ret;
+}

--LQksG6bCIzRHxTLp--

