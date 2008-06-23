Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYFWLNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYFWLNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYFWLNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:13:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYFWLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:13:09 -0400
Date: Mon, 23 Jun 2008 13:12:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Bisecting tip/auto-x86-next?
Message-ID: <20080623111238.GA7485@elte.hu>
References: <20080620153626.GE17373@elte.hu> <485C4484.3080706@gmail.com> <86802c440806201714p271b7b3fx68183c5f48208bee@mail.gmail.com> <485CD12C.9080404@gmail.com> <86802c440806210318p23fc61bo709c0965254de72@mail.gmail.com> <d1af83620806210323j6b55db5ar61a45a4cd416a319@mail.gmail.com> <86802c440806210330r25529b93u9c57734ad4fce58d@mail.gmail.com> <485CDA6A.103@gmail.com> <86802c440806210350y2f05999fme0eba7ca6aca201a@mail.gmail.com> <485CEAD9.10401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485CEAD9.10401@gmail.com>
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



* Kevin Winchester <kjwinchester@gmail.com> wrote:

>> please try attached patch...
>
> Thanks for the patch. it fixes the problem for me.  tip/master was 
> indeed showing the problem as well, but it does not once your patch is 
> applied.
>
> So you can add a:
>
> Tested-by: Kevin Winchester <kjwinchester@gmail.com>
>
> to the patch if you want.

applied to tip/x86/gart - thanks a lot Kevin for bisecting this. I have 
attached the commit below.

	Ingo

----------------->
commit 0754557d72c1fbfc5fcfd5235e7c23ae6f77248c
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Jun 21 03:50:47 2008 -0700

    x86: change early_gart_iommu_check() back to any_mapped
    
    Kevin Winchester reported a GART related direct rendering failure against
    linux-next-20080611, which shows up via these log entries:
    
     PCI: Using ACPI for IRQ routing
     PCI: Cannot allocate resource region 0 of device 0000:00:00.0
     agpgart: Detected AGP bridge 0
     agpgart: Aperture conflicts with PCI mapping.
     agpgart: Aperture from AGP @ e0000000 size 128 MB
     agpgart: Aperture conflicts with PCI mapping.
     agpgart: No usable aperture found.
     agpgart: Consider rebooting with iommu=memaper=2 to get a good aperture.
    
    instead of the expected:
    
     PCI: Using ACPI for IRQ routing
     agpgart: Detected AGP bridge 0
     agpgart: Aperture from AGP @ e0000000 size 128 MB
    
    Kevin bisected it down to this change in tip/x86/gart:
    "x86: checking aperture size order".
    
    agp check is using request_mem_region(), and could fail if e820 is reserved...
    
    change it back to e820_any_mapped().
    
    Reported-and-bisected-by: "Kevin Winchester" <kjwinchester@gmail.com>
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Tested-by: Kevin Winchester <kjwinchester@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3409abb..e819362 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -324,8 +324,8 @@ void __init early_gart_iommu_check(void)
 		fix = 1;
 
 	if (gart_fix_e820 && !fix && aper_enabled) {
-		if (!e820_all_mapped(aper_base, aper_base + aper_size,
-				    E820_RESERVED)) {
+		if (e820_any_mapped(aper_base, aper_base + aper_size,
+				    E820_RAM)) {
 			/* reserve it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
 			add_memory_region(aper_base, aper_size, E820_RESERVED);
