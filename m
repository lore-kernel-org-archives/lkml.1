Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbXKUWOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbXKUWOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXKUWOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:14:14 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:40601 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXKUWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:14:13 -0500
Message-ID: <4744ADA9.7040905@cosmosbay.com>
Date: Wed, 21 Nov 2007 23:14:01 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jie Chen <chen@jlab.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible bug from kernel 2.6.22 and above
References: <4744966C.900@jlab.org>
In-Reply-To: <4744966C.900@jlab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 21 Nov 2007 23:14:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jie Chen a écrit :
> Hi, there:
> 
>     We have a simple pthread program that measures the synchronization 
> overheads for various synchronization mechanisms such as spin locks, 
> barriers (the barrier is implemented using queue-based barrier 
> algorithm) and so on. We have dual quad-core AMD opterons (barcelona) 
> clusters running 2.6.23.8 kernel at this moment using Fedora Core 7 
> distribution. Before we moved to this kernel, we had kernel 2.6.21. 
> These two kernels are configured identical and compiled with the same 
> gcc 4.1.2 compiler. Under the old kernel, we observed that the 
> performance of these overheads increases as the number of threads 
> increases from 2 to 8. The following are the values of total time and 
> overhead for all threads acquiring a pthread spin lock and all threads 
> executing a barrier synchronization call.

Could you post the source of your test program ?

spinlock are ... spining and should not call linux scheduler, so I have no 
idea why a kernel change could modify your results.

Also I suspect you'll have better results with Fedora Core 8 (since glibc was 
updated to use private futexes in v 2.7), at least for the barrier ops.


> 
> Kernel 2.6.21
> Number of Threads              2          4           6         8
> SpinLock (Time micro second)   10.5618    10.58538    10.5915   10.643
>                   (Overhead)   0.073      0.05746     0.102805 0.154563
> Barrier (Time micro second)    11.020410  11.678125   11.9889   12.38002
>                  (Overhead)    0.531660   1.1502      1.500112 1.891617
> 
> Each thread is bound to a particular core using pthread_setaffinity_np.
> 
> Kernel 2.6.23.8
> Number of Threads              2          4           6         8
> SpinLock (Time micro second)   14.849915  17.117603   14.4496   10.5990
>                  (Overhead)    4.345417   6.617207    3.949435  0.110985
> Barrier (Time micro second)    19.462255  20.285117   16.19395  12.37662
>                  (Overhead)    8.957755   9.784722    5.699590  1.869518
> 
> It is clearly that the synchronization overhead increases as the number 
> of threads increases in the kernel 2.6.21. But the synchronization 
> overhead actually decreases as the number of threads increases in the 
> kernel 2.6.23.8 (We observed the same behavior on kernel 2.6.22 as 
> well). This certainly is not a correct behavior. The kernels are 
> configured with CONFIG_SMP, CONFIG_NUMA, CONFIG_SCHED_MC, 
> CONFIG_PREEMPT_NONE, CONFIG_DISCONTIGMEM set. The complete kernel 
> configuration file is in the attachment of this e-mail.
> 
>  From what we have read, there was a new scheduler (CFS) appeared from 
> 2.6.22. We are not sure whether the above behavior is caused by the new 
> scheduler.
> 
> Finally, our machine cpu information is listed in the following:
> 
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 2
> model name      : Quad-Core AMD Opteron(tm) Processor 2347
> stepping        : 10
> cpu MHz         : 1909.801
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
> mca cmov
> pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
> pdpe1gb rdtscp
>  lm 3dnowext 3dnow constant_tsc rep_good pni cx16 popcnt lahf_lm 
> cmp_legacy svm
> extapic cr8_legacy altmovcr8 abm sse4a misalignsse 3dnowprefetch osvw
> bogomips        : 3822.95
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> In addition, we have schedstat and sched_debug files in the /proc 
> directory.
> 
> Thank you for all your help to solve this puzzle. If you need more 
> information, please let us know.
> 
> 
> P.S. I like to be cc'ed on the discussions related to this problem.
> 
> 
> ###############################################
> Jie Chen
> Scientific Computing Group
> Thomas Jefferson National Accelerator Facility
> 12000, Jefferson Ave.
> Newport News, VA 23606
> 
> (757)269-5046 (office) (757)269-6248 (fax)
> chen@jlab.org
> ###############################################
> 

