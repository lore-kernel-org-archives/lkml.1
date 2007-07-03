Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbXGCXi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbXGCXi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXGCXiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:38:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:34952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbXGCXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:38:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: Re: 2.6.22-rc7: known regressions with patches
Date: Wed, 4 Jul 2007 01:38:13 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@hpl.hp.com>
References: <468A7D24.3040004@googlemail.com> <alpine.LFD.0.98.0707031441480.9434@woody.linux-foundation.org> <20070703221210.GA29959@atjola.homenet>
In-Reply-To: <20070703221210.GA29959@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707040138.13538.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 00:12:10 Björn Steinbrink wrote:
> On 2007.07.03 14:42:25 -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 3 Jul 2007, Bj?rn Steinbrink wrote:
> > > Andi said that one of the regression fixes wasn't critical for .22 and
> > > that he wants to do a stopgap for the other regression (my patch
> > > sucked), reverting the code to the .21 version. So you can drop the
> > > patches and/or me here.
> > 
> > Can you say which patch should be reverted. This thing really shouldn't 
> > have gone on this long, I would have hopef we had the oprofile thing 
> > sorted out already..
> 
> That would be commit 09198e68501a7e34737cd9264d266f42429abcdc, for which
> there are already a few fixes in your tree. Andi, did you intent to
> fully revert that, or just certain parts of it?

Just two functions, but in a different file. Here's the patch.

Linus, also what about the revert of the HPET reservation? That would
fix a clear regression too.

-Andi

Revert perfctr reservation to 2.6.21 state

With this change it works again when the nmi watchdog is disabled.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -55,14 +55,45 @@ static DEFINE_PER_CPU(struct nmi_watchdo
 /* converts an msr to an appropriate reservation bit */
 static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
 {
-	return wd_ops ? msr - wd_ops->perfctr : 0;
+	/* returns the bit offset of the performance counter register */
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		return (msr - MSR_K7_PERFCTR0);
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+			return (msr - MSR_ARCH_PERFMON_PERFCTR0);
+
+		switch (boot_cpu_data.x86) {
+		case 6:
+			return (msr - MSR_P6_PERFCTR0);
+		case 15:
+			return (msr - MSR_P4_BPU_PERFCTR0);
+		}
+	}
+	return 0;
 }
 
 /* converts an msr to an appropriate reservation bit */
 /* returns the bit offset of the event selection register */
 static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
 {
-	return wd_ops ? msr - wd_ops->evntsel : 0;
+	/* returns the bit offset of the event selection register */
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		return (msr - MSR_K7_EVNTSEL0);
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+			return (msr - MSR_ARCH_PERFMON_EVENTSEL0);
+
+		switch (boot_cpu_data.x86) {
+		case 6:
+			return (msr - MSR_P6_EVNTSEL0);
+		case 15:
+			return (msr - MSR_P4_BSU_ESCR0);
+		}
+	}
+	return 0;
+
 }
 
 /* checks for a bit availability (hack for oprofile) */
