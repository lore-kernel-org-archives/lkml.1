Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbXLNSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbXLNSbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXLNSbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:31:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:5025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbXLNSbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:31:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="241865031"
Date: Fri, 14 Dec 2007 10:31:12 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andi Kleen <ak@muc.de>
Cc: venkatesh.pallipadi@intel.com, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071214183112.GA2057@linux-os.sc.intel.com>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <20071214004212.GA2735@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214004212.GA2735@muc.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 01:42:12AM +0100, Andi Kleen wrote:
> > +void __cpuinit pat_init(void)
> > +{
> > +	/* Set PWT+PCD to Write-Combining. All other bits stay the same */
> > +	if (cpu_has_pat) {
> 
> All the old CPUs (PPro etc.) with known PAT bugs need to clear this flag 
> now in their CPU init functions. It is fine to be aggressive there
> because these old systems have lived so long without PAT they can do 
> so forever. So perhaps it's best to just white list it only for newer
> CPUs on the Intel side at least.

Yes. Enabling this only on relatively newer CPUs is safer. Will do that in next iteration of the patches.
 
> Another problem is that there are some popular modules (ATI, Nvidia for once)
> who reprogram the PAT registers on their own, likely different. Need some way to detect
> that case I guess, otherwise lots of users will see strange malfunctions.
> Maybe recheck after module load?

Yes. We can check that at load time. But they can still do bad things at runt ime, like say when 3D gets enabled etc??

 
> > +                   |||
> > +		   000 WB         default
> > +		   010 UC_MINUS   _PAGE_PCD
> > +		   011 WC         _PAGE_WC
> > +		   PAT bit unused */
> > +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,UC_MINUS) | PAT(3,WC) |
> > +		      PAT(4,WB) | PAT(5,WT) | PAT(6,UC_MINUS) | PAT(7,WC);
> > +		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> > +		wrmsrl(MSR_IA32_CR_PAT, pat);
> > +		__flush_tlb_all();
> > +		asm volatile("wbinvd");
> 
> Have you double checked this is the full procedure from the manual? iirc there
> were some steps missing.


Checking the manual for this. You are right, we had missed some steps here.
Actually, manual says on MP, PAT MSR on all CPUs must be consistent (even when they are not really using it in their page tables.
So, this will change the init and shutdown parts significantly and there may be some challenges with CPU offline and KEXEC. We will redo this part in next iteration.

Thanks,
Venki
