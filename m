Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbYLYN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbYLYN0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYLYN0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:26:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYLYN0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:26:12 -0500
Date: Thu, 25 Dec 2008 14:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [git pull] core kernel updates for v2.6.29
Message-ID: <20081225132556.GA7840@elte.hu>
References: <20081225132115.GA27170@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225132115.GA27170@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [ Note, this tree will generate conflicts if pulled after the x86,
>   tracing and scheduler trees - i'll follow up with this mail with
>   a conflict resolution commit. ]

the conflict resolutions i have cached for this are attached below - all 
the conflicts are contextual.

( Have not found a Git way to export this resolution in plain patch format
  that could be applied in a raw form when the conflicts come up after the
  pull - git-show uses the git-diff-tree --cc interdiff format. )

	Ingo

------------->
commit 75c8fc6a491d5bbf20be8ce3fb140d0daa2b32dc
Merge: 65890e7... 6638101...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Dec 25 14:11:46 2008 +0100

    Merge branch 'core-for-linus' into tmp.tmp
    
    Conflicts:
    	arch/x86/kernel/Makefile
    	arch/x86/mm/init_32.c
    	include/linux/hardirq.h

diff --cc arch/x86/kernel/Makefile
index 88dd768,a9c656f..e9a6bc0
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@@ -107,8 -105,8 +107,10 @@@ microcode-$(CONFIG_MICROCODE_INTEL)	+= 
  microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
  obj-$(CONFIG_MICROCODE)			+= microcode.o
  
+ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_64.o # NB rename without _64
+ 
 +obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 +
  ###
  # 64 bit specific files
  ifeq ($(CONFIG_X86_64),y)
diff --cc arch/x86/mm/init_32.c
index 800e1d9,2b4b14f..8655b5b
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@@ -967,6 -970,10 +968,8 @@@ void __init mem_init(void
  	int codesize, reservedpages, datasize, initsize;
  	int tmp;
  
 -	start_periodic_check_for_corruption();
 -
+ 	pci_iommu_alloc();
+ 
  #ifdef CONFIG_FLATMEM
  	BUG_ON(!mem_map);
  #endif
diff --cc include/linux/hardirq.h
index 89a56d7,9b70b92..f832883
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@@ -162,17 -163,7 +164,20 @@@ extern void irq_enter(void)
   */
  extern void irq_exit(void);
  
 -#define nmi_enter()		do { lockdep_off(); rcu_nmi_enter(); __irq_enter(); } while (0)
 -#define nmi_exit()		do { __irq_exit(); rcu_nmi_exit(); lockdep_on(); } while (0)
 +#define nmi_enter()				\
 +	do {					\
 +		ftrace_nmi_enter();		\
 +		lockdep_off();			\
++		rcu_nmi_enter();		\
 +		__irq_enter();			\
 +	} while (0)
++
 +#define nmi_exit()				\
 +	do {					\
 +		__irq_exit();			\
++		rcu_nmi_exit();			\
 +		lockdep_on();			\
 +		ftrace_nmi_exit();		\
 +	} while (0)
  
  #endif /* LINUX_HARDIRQ_H */
