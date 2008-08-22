Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYHVTId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYHVTId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYHVTIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:08:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:49104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbYHVTIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,253,1217833200"; 
   d="scan'208";a="608960144"
Date: Fri, 22 Aug 2008 12:08:17 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.
Message-ID: <20080822190817.GA17381@linux-os.sc.intel.com>
References: <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822041544.GF30284@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 09:15:44PM -0700, Ingo Molnar wrote:
> 
> * Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
> > Actually, might as well simply reconstruct the memtype list at free
> > time I guess. How is this for a coalescing version of the array
> > functions?
> 
> impressive! Rarely do we get this much bang for such a low linecount :-)
> 
> > NOTE: I am posting this because I'm going to bed but haven't stared
> > comfortably long at this and might be buggy. Compiles, boots and
> > provides me with:
> >
> > root@7ixe4:~# wc -l /debug/x86/pat_memtype_list
> > 53 /debug/x86/pat_memtype_list
> >
> > otherwise (down from 16384+).
> >
> > <snore>
> 
> cool!
> 
> I'd do this in v2.6.27 but i forced myself to be reasonable and applied
> your patches to tip/x86/pat instead, for tentative v2.6.28 merging
> (assuming it all passes testing, etc.):
> 
>  # 9a79f4f: x86: {reverve,free}_memtype() take a physical address
>  # c5e147c: x86: have set_memory_array_{uc,wb} coalesce memtypes.
>  # 5f310b6: agp: enable optimized agp_alloc_pages methods
> 
> ( note that i flipped them around a bit and have put your
>   enable-agp_alloc_pages()-widely patch last, so that we get better
>   bisection behavior. )
> 
> The frontside cache itself is in x86/urgent:
> 
>  # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT
> 
> ... and should at least solve the symptom that you've hit in practice
> (the slowdown), without changing the underlying PAT machinery. (which
> would be way too dangerous for v2.6.27)
> 
> And it's all merged up in tip/master, you might want to test that too to
> check whether all the pieces fit together nicely.
> 
> Tens of thousands of page granular memtypes was Not Nice.
> 
> Venki, Suresh, Shaohua, Dave, Arjan - any observations about this line
> of action?

The concern I have here is that the coalescing is not guaranteed to work.
We may still end up having horrible worst case latency, even though this
improves the normal case (boot the system, start X, exit X, reboot the system).
It depends on how pages are allocated and how much memory is there in the
system and what else is running etc.

Here on my test system, without this coalescing change I see

[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
19528

With the coalescing change I see
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
135

quit and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
985
quit and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
1468
quit and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
1749
quit and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
1916
quit and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
2085

untar a kernel tar.bz2 and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
2737

compile the kernel and restart X
[root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
3089


I think this as a good workaround for now. But, for long run we still need to
look at other ways of eliminating this overhead (like using page struct
that Suresh mentioned in the other thread).


Also, there seems to be a bug in the error path of the patch. Below should
fix it.

Thanks,
Venki

Fix the start addr for free_memtype calls in the error path.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: t/arch/x86/mm/pageattr.c
===================================================================
--- t.orig/arch/x86/mm/pageattr.c	2008-08-22 10:38:35.000000000 -0700
+++ t/arch/x86/mm/pageattr.c	2008-08-22 11:27:27.000000000 -0700
@@ -967,7 +967,7 @@ out:
 
 		if (tmp == start)
 			break;
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
 			if (end != __pa(addr[i + 1]))
 				break;
 			i++;
