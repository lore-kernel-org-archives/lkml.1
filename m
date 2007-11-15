Return-Path: <linux-kernel-owner+w=401wt.eu-S1764139AbXKOSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764139AbXKOSUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXKOSUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:20:09 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46504 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbXKOSUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:20:07 -0500
Date: Thu, 15 Nov 2007 19:19:46 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071115181945.GS4250@stusta.de>
References: <20071115161703.GR4250@stusta.de> <20071115180436.GA23517@uranus.ravnborg.org> <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 07:07:11PM +0100, Thomas Gleixner wrote:
> On Thu, 15 Nov 2007, Sam Ravnborg wrote:
> 
> > On Thu, Nov 15, 2007 at 05:17:03PM +0100, Adrian Bunk wrote:
> > > The x86 unification resulted in CONFIG_X86_HT no longer being
> > > set if (X86_32 && MK8).
> > Yup - my bad. I wrongly assumed MK8 was an X86_64 thing.
> > 
> > Thanks for fixing this.
> > > 
> > > After grep'ing through the tree I think the problem is that different 
> > > places have different assumptions about the semantics of CONFIG_X86_HT,
> > > either:
> > > - hyperthreading or
> > > - multicore
> > > and the SCHED_SMT and SCHED_MC dependencies are just one of the 
> > > symptoms.
> > > 
> > > This should be sorted out properly, but until then we should keep the 
> > > 2.6.23 status quo.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > I assume Thomas & Co will forward the patch.
> 
> After looking what does what and fixing it. 
> 
> Right now this patch is not a 1:1 replacement of the .23 status quo,
> as it now makes SCHED_SMT and SCHED_HT depend on !MK8 for 64bit.

*searches brown paperbag*

Thanks for spotting, fixed patch below.

>      tglx

cu
Adrian


<--  snip  -->


The x86 unification resulted in CONFIG_X86_HT no longer being
set if (X86_32 && MK8).

After grep'ing through the tree I think the problem is that different
places have different assumptions about the semantics of CONFIG_X86_HT,
either
- hyperthreading or
- multicore

This should be sorted out properly, but until then we should keep the
2.6.23 status quo.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
480a5ae48036f6825a5a111db87da05e298327d6 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index af1b1ca..5871b44 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -148,7 +148,8 @@ config X86_SMP
 
 config X86_HT
 	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER || MK8)
+	depends on SMP
+	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || (X86_64 && !MK8)
 	default y
 
 config X86_BIOS_REBOOT

