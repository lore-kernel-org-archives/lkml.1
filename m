Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZBLSC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZBLSC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZBLSCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:02:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:48408 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbZBLSCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:02:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,198,1233561600"; 
   d="scan'208";a="430513656"
Subject: Re: [PATCH] [2/4] x86: MCE: Implement dynamic machine check banks
 support v5
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090212124321.8A98B3E666D@basil.firstfloor.org>
References: <20090212143.515129156@firstfloor.org>
	 <20090212124321.8A98B3E666D@basil.firstfloor.org>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 10:03:05 -0800
Message-Id: <1234461785.4286.1918.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-02-12 at 04:43 -0800, Andi Kleen wrote:
> Impact: cleanup; making code future proof; memory saving on small systems
> 
> This patch replaces the hardcoded max number of machine check banks with 
> dynamic allocation depending on what the CPU reports. The sysfs
> data structures and the banks array are dynamically allocated.
> 
> There is still a hard bank limit (128) because the mcelog protocol uses
> banks >= 128 as pseudo banks to escape other events. But we expect
> that 128 banks is beyond any reasonable CPU for now.
> 
> This supersedes an earlier patch by Venki, but it solves the problem
> more completely by making the limit fully dynamic (upto the 128 boundary)
> 
> This saves some memory on machines with less than 6 banks because
> they won't need sysdevs for unused ones and also allows to 
> use sysfs to control these banks on possible future CPUs with
> more than 6 banks.
> 
> v2: Fix typo in initialization
> v3: Fold fix banks message fix into this one.
> v4: Fix cap init ordering
> v5: Forward port to new patch order
> 
> Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce_64.c |  139 +++++++++++++++++++++++++++---------
>  1 file changed, 107 insertions(+), 32 deletions(-)
> 
> Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
> +++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:19.000000000 +0100
> @@ -24,6 +24,8 @@
>  #include <linux/ctype.h>
>  #include <linux/kmod.h>
>  #include <linux/kdebug.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
>  #include <asm/processor.h>
>  #include <asm/msr.h>
>  #include <asm/mce.h>
> @@ -32,7 +34,12 @@
>  #include <asm/idle.h>
>  
>  #define MISC_MCELOG_MINOR 227
> -#define NR_SYSFS_BANKS 6
> +
> +/*
> + * To support more than 128 would need to escape the predefined
> + * Linux defined extended banks first.
> + */
> +#define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
>  
>  atomic_t mce_entry;
>  
> @@ -47,7 +54,7 @@
>   */
>  static int tolerant = 1;
>  static int banks;
> -static unsigned long bank[NR_SYSFS_BANKS] = { [0 ... NR_SYSFS_BANKS-1] = ~0UL };
> +static u64 *bank;
>  static unsigned long notify_user;
>  static int rip_msr;
>  static int mce_bootlog = -1;
> @@ -212,7 +219,7 @@
>  	barrier();
>  
>  	for (i = 0; i < banks; i++) {
> -		if (i < NR_SYSFS_BANKS && !bank[i])
> +		if (!bank[i])
>  			continue;
>  
>  		m.misc = 0;
> @@ -446,21 +453,36 @@
>  /*
>   * Initialize Machine Checks for a CPU.
>   */
> -static void mce_init(void *dummy)
> +static void mce_cap_init(void)
>  {
>  	u64 cap;
> -	int i;
>  
>  	rdmsrl(MSR_IA32_MCG_CAP, cap);
> -	banks = cap & 0xff;
> -	if (banks > MCE_EXTENDED_BANK) {
> -		banks = MCE_EXTENDED_BANK;
> -		printk(KERN_INFO "MCE: warning: using only %d banks\n",
> -		       MCE_EXTENDED_BANK);
> +	/* Handle the unlikely case of one CPU having less banks than others */
> +	if (banks == 0 || banks > (cap & 0xff))
> +		banks = cap & 0xff;

Do we need a per cpu count of # of banks to handle one CPU having less
banks than others case?
Specifically, I am thinking of sequence:
- CPU 0 has n banks
- CPU 0 does below
	for (i = 0; i < banks; i++) {
		err = sysdev_create_file(&per_cpu(device_mce, cpu),
					&bank_attrs[i]);
- CPU 1, which comes online later, has say n-2 banks. So, banks now becomes n-2.
- Now whenever CPU 0 does sysdev_remove_file loop below, it will do it only for n-2 banks.


Thanks,
Venki

