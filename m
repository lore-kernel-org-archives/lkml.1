Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZGAVZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZGAVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZGAVZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:25:17 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:62652 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZGAVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:25:15 -0400
X-IronPort-AV: E=Sophos;i="4.42,328,1243828800"; 
   d="scan'208";a="3325993"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC v2] kernel/printk.c - handling more than one CON_BOOT
Date: Wed, 1 Jul 2009 17:28:10 -0400
User-Agent: KMail/1.9.5
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       vapier.adi@gmail.com, lethal@linux-sh.org
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <200907011650.19173.rgetz@blackfin.uclinux.org> <20090701140128.7924f3c4.akpm@linux-foundation.org>
In-Reply-To: <20090701140128.7924f3c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907011728.10610.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jul 2009 21:24:52.0007 (UTC) FILETIME=[5ED6BB70:01C9FA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 1 Jul 2009 17:01, Andrew Morton pondered:
> > > > diff -puN
> > > kernel/printk.c~kernel-printkc-handling-more-than-one-con_boot
> > > kernel/printk.c
> > > > ---
> a/kernel/printk.c~kernel-printkc-handling-more-than-one-con_boot
> > > > +++ a/kernel/printk.c
> > > > @@ -37,6 +37,12 @@
> > > >  #include <asm/uaccess.h>
> > > >  
> > > >  /*
> > > > + * for_each_console() allows you to iterate on each console
> > > > + */
> > > > +#define for_each_console(con) \
> > > > +	for (con = console_drivers; con != NULL; con = con->next)
> > > 
> > > hum.  Fair enough.
> > 
> > Was there an issue with this? (Or you just want me to split that up
> > into a  separate patch?)
> 
> Just a general allergy to fancypants macros, especially those which
> hide control flow. But this one is straightforward enough.
> 
> Formally one should parenthesize `con' here, but if that change is ever
> actually necessary then we have other problems, and the macro was
> probably a bad idea anyway.

Ingo complained that the first version (without the macro) looked crappy 
(my word) because of the 80 col limit...

I borrowed this concept from the other files in ./kernel/ to make things
a little nicer looking.

kernel/kexec.c:613:#define for_each_kimage_entry(image, ptr, entry) \
kernel/kexec.c-614-     for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
kernel/kexec.c-615-             ptr = (entry & IND_INDIRECTION)? \

kernel/sched.c:688:#define for_each_domain(cpu, __sd) \
kernel/sched.c-689-     for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)

kernel/sched.c:1743:#define for_each_class(class) \
kernel/sched.c-1744-   for (class = sched_class_highest; class; class = class->next)

kernel/sched.c:4437:#define for_each_flag_domain(cpu, sd, flag) \
kernel/sched.c-4438-    for (sd = lowest_flag_domain(cpu, flag); \
kernel/sched.c-4439-            (sd && (sd->flags & flag)); sd = sd->parent)

kernel/sched_cpupri.c:49:#define for_each_cpupri_active(array, idx)                    \
kernel/sched_cpupri.c-50-  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
kernel/sched_cpupri.c-51-       idx < CPUPRI_NR_PRIORITIES;                            \

kernel/sched_fair.c:99:#define for_each_sched_entity(se) \
kernel/sched_fair.c-100-                for (; se; se = se->parent)

kernel/sched_fair.c:128:#define for_each_leaf_cfs_rq(rq, cfs_rq) \
kernel/sched_fair.c-129-        list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)

kernel/sched_fair.c:198:#define for_each_sched_entity(se) \
kernel/sched_fair.c-199-                for (; se; se = NULL)

kernel/sched_fair.c:225:#define for_each_leaf_cfs_rq(rq, cfs_rq) \
kernel/sched_fair.c-226-                for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)

kernel/sched_rt.c:157:#define for_each_leaf_rt_rq(rt_rq, rq) \
kernel/sched_rt.c-158-  list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)

kernel/sched_rt.c:160:#define for_each_sched_rt_entity(rt_se) \
kernel/sched_rt.c-161-  for (; rt_se; rt_se = rt_se->parent)

kernel/sched_rt.c:244:#define for_each_leaf_rt_rq(rt_rq, rq) \
kernel/sched_rt.c-245-  for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)

kernel/sched_rt.c:247:#define for_each_sched_rt_entity(rt_se) \
kernel/sched_rt.c-248-  for (; rt_se; rt_se = NULL)

I thought it was the "prefered" way to do things. 

Guess I was wrong. :)


