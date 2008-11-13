Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYKMXPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYKMXPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbYKMXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:15:34 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50851 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752849AbYKMXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:15:33 -0500
Date: Fri, 14 Nov 2008 08:15:32 +0900 (JST)
Message-Id: <20081114.081532.16574084.taka@valinux.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org, fernando@oss.ntt.co.jp,
       xemul@openvz.org
Subject: Re: [dm-devel] Re: [PATCH 0/8] I/O bandwidth controller and BIO
 tracking
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <491C53CF.3010208@linux.vnet.ibm.com>
References: <20081113153019.cc50d42c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081113.162623.74628639.taka@valinux.co.jp>
	<491C53CF.3010208@linux.vnet.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Balbir,

> Hirokazu Takahashi wrote:
> > Hi, Kamezawa-san,
> > 
> > This patch makes the page_cgroup framework be able to be used even if
> > the compile option of the cgroup memory controller is off.
> > So bio-cgroup can use this framework without the memory controller.
> > 
> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> > 
> > diff -dupr linux-2.6.28-rc2.bc0/include/linux/memcontrol.h linux-2.6.28-rc2/include/linux/memcontrol.h
> > --- linux-2.6.28-rc2.bc0/include/linux/memcontrol.h	2008-11-10 18:31:34.000000000 +0900
> > +++ linux-2.6.28-rc2/include/linux/memcontrol.h	2008-11-11 13:51:42.000000000 +0900
> > @@ -27,6 +27,9 @@ struct mm_struct;
> > 
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > 
> > +extern void __init_mem_page_cgroup(struct page_cgroup *pc);
> > +#define  mem_cgroup_disabled() mem_cgroup_subsys.disabled
> > +
> >  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
> >  				gfp_t gfp_mask);
> >  /* for swap handling */
> > @@ -81,6 +84,15 @@ extern long mem_cgroup_calc_reclaim(stru
> >  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
> >  struct mem_cgroup;
> > 
> > +static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
> > +{
> > +}
> > +
> > +static inline int mem_cgroup_disabled(void)
> > +{
> > +	return 1;
> > +}
> > +
> 
> With CONFIG_CGROUP_MEM_RES_CTLR not defined, page_cgroup init routines will just
> return, is that what bio page_cgroup needs?
> 
> -- 
> 	Balbir

One of the other patches includes the following code, which calls 
__init_bio_page_cgroup() to initialize bio-cgroup thing.

+++ linux-2.6.28-rc2/mm/page_cgroup.c	2008-11-12 11:20:33.000000000 +0900
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/memcontrol.h>
+#include <linux/biotrack.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -16,6 +17,7 @@ __init_page_cgroup(struct page_cgroup *p
 	pc->flags = 0;
 	pc->page = pfn_to_page(pfn);
 	__init_mem_page_cgroup(pc);
+	__init_bio_page_cgroup(pc);
 }
 static unsigned long total_usage;
