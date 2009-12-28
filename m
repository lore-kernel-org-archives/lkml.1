Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZL1IKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZL1IKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZL1IKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:10:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37704 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZL1IKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:10:41 -0500
Date: Mon, 28 Dec 2009 09:10:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>, Dave Jones <davej@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc2
Message-ID: <20091228081021.GD28652@elte.hu>
References: <200912271719.39306.mitov@issp.bas.bg>
 <20091228153704Z.fujita.tomonori@lab.ntt.co.jp>
 <200912280918.36067.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912280918.36067.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marin Mitov <mitov@issp.bas.bg> wrote:

> On Monday 28 December 2009 08:37:33 am FUJITA Tomonori wrote:
> > On Sun, 27 Dec 2009 17:19:39 +0200
> > Marin Mitov <mitov@issp.bas.bg> wrote:
> > 
> > > Hi all,
> > > 
> > > Recently (2.6.33-rc2 kernel, x86_64, 4GB RAM) I found (in dmesg):
> > > 
> > > [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> > > 
> > > and there is no /dev/agpgart device on the machine while all is OK 
> > > if booting 2.6.32.2. 
> > > 
> > > In both kernels I have:
> > > 
> > > CONFIG_AGP=y
> > > CONFIG_AGP_AMD64=y
> > > 
> > > CONFIG_GART_IOMMU=y
> > > 
> > > but nevertheless dmesg shows:
> > > 
> > > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > > 
> > > due to quirks in via K8T800Pro host bridge.
> > > 
> > > Looking for the reason I found that agp_amd64_init() appears in:
> > > 
> > > #ifndef CONFIG_GART_IOMMU
> > > module_init(agp_amd64_init);
> > > module_exit(agp_amd64_cleanup);
> > > #endif
> > > 
> > >  /*  so it is not invoked here due to CONFIG_GART_IOMMU=y   */
> > > 
> > > and also appears in:
> > >  
> > > arch/x86/kernel/pci-gart_64.c, function: gart_iommu_init()
> > > 
> > > The last one is part of the struct x86_init_ops(struct x86_init_iommu, as a function pointer) 
> > > only if gart-iommu is successfully detected, which is not the case here due to the quirk, 
> > > so agp_amd64_init() is not invoked here neither. 
> > > 
> > > Sure, configuring the kernel without CONFIG_GART_IOMMU=y (which is not user selectable)
> > > 
> > > should solve the problem, but usually users do not know about quirks, so it should
> > > work even as set here (and it works up to 2.6.32.2). I believe the bug is introduced
> > > with the changes in the order iommu detect/init works for 2.6.33.
> > > 
> > > I am here for additional info/tests.
> > 
> > Sorry about the regression. Does this works?
> 
> Yes, it works for me, thank you.

Great! Fujita-san, mind sending a fully changelogged version of the patch with 
Tested-by and your Signed-off-by?

Dave, do you want to push this fix to Linus, or should we do it via 
x86/urgent?

Thanks,

	Ingo
