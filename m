Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZJ2BH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZJ2BH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZJ2BH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:07:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41669 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbZJ2BH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:07:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Oct 2009 10:05:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Lee.Schermerhorn@hp.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg: fix wrong pointer initialization at page
 migration when memcg is disabled.
Message-Id: <20091029100530.c8bafc53.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091029095051.7812e5ad.nishimura@mxp.nes.nec.co.jp>
References: <20091029093013.cd58f3a5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091029095051.7812e5ad.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 09:50:51 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > Index: linux-2.6.32-rc5/mm/memcontrol.c
> > ===================================================================
> > --- linux-2.6.32-rc5.orig/mm/memcontrol.c
> > +++ linux-2.6.32-rc5/mm/memcontrol.c
> > @@ -1990,7 +1990,8 @@ int mem_cgroup_prepare_migration(struct 
> >  	struct page_cgroup *pc;
> >  	struct mem_cgroup *mem = NULL;
> >  	int ret = 0;
> > -
> > +	/* this pointer will be checked at end_migration */
> > +	*ptr = NULL;
> >  	if (mem_cgroup_disabled())
> >  		return 0;
> >  
> > 
> I thought unmap_and_move() itself initializes "mem" to NULL, but it doesn't...
> I personaly prefer initializing "mem" to NULL in unmap_and_move(), but anyway
> I think this patch is also correct.
> 
> 	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
Ok, here
> And I think we should send a fix for this bug to -stable too.
I think so, too.


==
Lee Schermerhorn reported that he saw bad pointer dereference
in mem_cgroup_end_migration() when he disabled memcg by boot option.

memcg's page migration logic works as

	mem_cgroup_prepare_migration(page, &ptr);
	do page migration
	mem_cgroup_end_migration(page, ptr);

Now, ptr is not initialized when memcg is disabled by boot option.
This patch fixes it.

Changelog: 2009/10/29
 - modified "fix" from memcontrol.c to migrate.c


Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.32-rc5/mm/migrate.c
===================================================================
--- linux-2.6.32-rc5.orig/mm/migrate.c
+++ linux-2.6.32-rc5/mm/migrate.c
@@ -602,7 +602,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
 	int charge = 0;
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 
 	if (!newpage)
 		return -ENOMEM;

