Return-Path: <linux-kernel-owner+w=401wt.eu-S935462AbXLNAtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935462AbXLNAtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbXLNAs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:48:56 -0500
Received: from colin.muc.de ([193.149.48.1]:3378 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbXLNAsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:48:55 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 19:48:54 EST
Date: 14 Dec 2007 01:42:12 +0100
Date: Fri, 14 Dec 2007 01:42:12 +0100
From: Andi Kleen <ak@muc.de>
To: venkatesh.pallipadi@intel.com
Cc: ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071214004212.GA2735@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213235711.464325000@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void __cpuinit pat_init(void)
> +{
> +	/* Set PWT+PCD to Write-Combining. All other bits stay the same */
> +	if (cpu_has_pat) {

All the old CPUs (PPro etc.) with known PAT bugs need to clear this flag 
now in their CPU init functions. It is fine to be aggressive there
because these old systems have lived so long without PAT they can do 
so forever. So perhaps it's best to just white list it only for newer
CPUs on the Intel side at least.

Another problem is that there are some popular modules (ATI, Nvidia for once)
who reprogram the PAT registers on their own, likely different. Need some way to detect
that case I guess, otherwise lots of users will see strange malfunctions.
Maybe recheck after module load?

> +                   |||
> +		   000 WB         default
> +		   010 UC_MINUS   _PAGE_PCD
> +		   011 WC         _PAGE_WC
> +		   PAT bit unused */
> +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,UC_MINUS) | PAT(3,WC) |
> +		      PAT(4,WB) | PAT(5,WT) | PAT(6,UC_MINUS) | PAT(7,WC);
> +		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> +		wrmsrl(MSR_IA32_CR_PAT, pat);
> +		__flush_tlb_all();
> +		asm volatile("wbinvd");

Have you double checked this is the full procedure from the manual? iirc there
were some steps missing.

-Andi

