Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYJOXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYJOXtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYJOXtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:49:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYJOXtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:49:07 -0400
Date: Thu, 16 Oct 2008 01:48:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bob Montgomery <bob.montgomery@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       vojtech@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>,
       chandru@in.ibm.com, Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] disable CPU side GART accesses
Message-ID: <20081015234842.GA10999@elte.hu>
References: <1224107317.2215.238.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224107317.2215.238.camel@amd.troyhebe>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed the GART folks.)

* Bob Montgomery <bob.montgomery@hp.com> wrote:

> This patch prevents improper access of the GART aperture from kdump 
> kernels running on AMD systems.
> 
> Symptoms of the problem include hangs, spurious restarts, and MCE 
> (Machine Check Exception) panics in some AMD Opteron systems that 
> enable the GART IOMMU and access /proc/vmcore or /dev/oldmem from a 
> kdump kernel.  Note that the GART IOMMU will not be enabled on systems 
> with less than 4 GB of RAM, so symptoms will not appear.  This problem 
> has been reproduced on Family 10H Quad-Core AMD Opteron systems.
> 
> This patch changes the initialization of the GART to set the 
> DISGARTCPU bit in the GART Aperture Control Register 
> (AMD64_GARTAPERTURECTL). Setting the bit prevents requests from the 
> CPUs from accessing the GART.  In other words, CPU memory accesses to 
> the aperture address range will not cause the GART to perform an 
> address translation. The aperture area is currently being unmapped at 
> the kernel level with set_memory_np() in gart_iommu_init to prevent 
> accesses from the CPU, but that kernel level unmapping is not in 
> effect in the kexec'd kdump kernel.  By disabling the CPU-side 
> accesses within the GART, which does persist through the kexec of the 
> kdump kernel, the kdump kernel is prevented from interacting with the 
> GART during accesses to the dump memory areas which include the 
> address range of the GART aperture.  Although the patch can be applied 
> to the kdump kernel, it is not exercised there because the kdump 
> kernel doesn't attempt to initialize the GART, since it typically runs 
> in less than 4 GB of memory.
> 
> Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
> 
> 
> --- linux-2.6.27/include/asm-x86/gart.h	2008-10-13 16:36:34.000000000 -0600
> +++ linux-2.6.27-fix/include/asm-x86/gart.h	2008-10-14 10:37:32.000000000 -0600
> @@ -44,7 +44,8 @@ static inline void enable_gart_translati
>          /* Enable GART translation for this hammer. */
>          pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
>          ctl |= GARTEN;
> -        ctl &= ~(DISGARTCPU | DISGARTIO);
> +        ctl |= DISGARTCPU;
> +        ctl &= ~(DISGARTIO);
>          pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
