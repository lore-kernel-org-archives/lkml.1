Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbZDJF3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbZDJF3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZDJF3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:29:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbZDJF3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:29:06 -0400
Date: Thu, 9 Apr 2009 22:25:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg remove warning at DEBUG_VM=off
Message-Id: <20090409222512.bd026a40.akpm@linux-foundation.org>
In-Reply-To: <20090408052715.GX7082@balbir.in.ibm.com>
References: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408052715.GX7082@balbir.in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 10:57:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 14:20:42]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > This is against 2.6.30-rc1. (maybe no problem against mmotm.)
> > 
> > ==
> > Fix warning as
> > 
> >   CC      mm/memcontrol.o
> > mm/memcontrol.c:318: warning: ?$B!Fmem_cgroup_is_obsolete?$B!G defined but not used
> > 
> > This is called only from VM_BUG_ON().
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> > Index: linux-2.6.30-rc1/mm/memcontrol.c
> > ===================================================================
> > --- linux-2.6.30-rc1.orig/mm/memcontrol.c
> > +++ linux-2.6.30-rc1/mm/memcontrol.c
> > @@ -314,13 +314,14 @@ static struct mem_cgroup *try_get_mem_cg
> >  	return mem;
> >  }
> > 
> > +#ifdef CONFIG_DEBUG_VM
> >  static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> >  {
> >  	if (!mem)
> >  		return true;
> >  	return css_is_removed(&mem->css);
> >  }
> > -
> > +#endif
> 
> Can we change the code to use
> 
>         VM_BUG_ON(!mem || css_is_removed(&mem->css));
> 

yup.

--- a/mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n-fix
+++ a/mm/memcontrol.c
@@ -314,14 +314,13 @@ static struct mem_cgroup *try_get_mem_cg
 	return mem;
 }
 
-#ifdef CONFIG_DEBUG_VM
 static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
 {
 	if (!mem)
 		return true;
 	return css_is_removed(&mem->css);
 }
-#endif
+
 
 /*
  * Call callback function against all cgroup under hierarchy tree.
@@ -933,7 +932,7 @@ static int __mem_cgroup_try_charge(struc
 	if (unlikely(!mem))
 		return 0;
 
-	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
+	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
 
 	while (1) {
 		int ret;
_

Although it really should be

	VM_BUG_ON(!mem);
	VM_BUG_ON(mem_cgroup_is_obsolete(mem));

because if that BUG triggers, you'll be wondering which case caused it.


