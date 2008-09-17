Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYIQGai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYIQGai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 02:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYIQGa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 02:30:29 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61786 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYIQGa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 02:30:29 -0400
Date: Wed, 17 Sep 2008 15:19:51 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org
Subject: Re: [PATCH -mm] memcg: fix handling of shmem migration
Message-Id: <20080917151951.9a181e7d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080917145003.fb4d0b95.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080917133149.b012a1c2.nishimura@mxp.nes.nec.co.jp>
	<20080917144659.2e363edc.kamezawa.hiroyu@jp.fujitsu.com>
	<20080917145003.fb4d0b95.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 14:50:03 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 17 Sep 2008 14:46:59 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Wed, 17 Sep 2008 13:31:49 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > PG_swapbacked flag of newpage should be set(if needed) before
> > > mem_cgroup_prepare_migration, because mem_cgroup_charge_common
> > > checks the flag and determines whether it sets PAGE_CGROUP_FLAG_FILE or not.
> > > 
> > > Before this patch, if migrating shmem/tmpfs pages, newpage would be
> > > charged with PAGE_CGROUP_FLAG_FILE set, while oldpage has been charged
> > > without the flag.
> > > 
> > Nice catch !
> > Thank you. 
> > 
> > Hmm, should I add MEM_CGROUP_CHARGE_TYPE_SHMEM rather than
> > setting flag to newpage ?
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> I acked but.. can't this change moved into memcontrol.c ?
> 

Hmm, something like this?

---
@@ -734,6 +734,9 @@ int mem_cgroup_prepare_migration(struct page *page, struct page *newpa
        if (mem_cgroup_subsys.disabled)
                return 0;

+       if (PageSwapBacked(page))
+               SetPageSwapBacked(newpage);
+
        lock_page_cgroup(page);
        pc = page_get_page_cgroup(page);
        if (pc) {
---

Or, adding MEM_CGROUP_CHARGE_TYPE_SHMEM and

---
@@ -740,7 +740,10 @@ int mem_cgroup_prepare_migration(struct page *page, struct page *newp
                mem = pc->mem_cgroup;
                css_get(&mem->css);
                if (pc->flags & PAGE_CGROUP_FLAG_CACHE)
-                       ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+                       if (page_is_file_cache(page))
+                               ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+                       else
+                               ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
        }
        unlock_page_cgroup(page);
        if (mem) {
---
(Of course, mem_cgroup_charge_common should be modified too.)


Thanks,
Daisuke Nishimura.
