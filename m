Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYHNKMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYHNKMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 06:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYHNKMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 06:12:07 -0400
Received: from www.tglx.de ([62.245.132.106]:60152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYHNKMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 06:12:06 -0400
Date: Thu, 14 Aug 2008 12:11:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: crane cai <crane.cai@amd.com>
cc: vojtech@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
 platform
In-Reply-To: <1218683616.20466.13.camel@crane-laptop>
Message-ID: <alpine.LFD.1.10.0808141206130.3243@apollo.tec.linutronix.de>
References: <1218683616.20466.13.camel@crane-laptop>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, crane cai wrote:
> >From 9bd2f534f986768f1944e626e37af1c323e47dbb Mon Sep 17 00:00:00 2001
> From: Crane Cai <crane.cai@amd.com>
> Date: Thu, 14 Aug 2008 10:31:01 +0800
> Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform
> 
> On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when its
> spread-spectrum frequency modulation feature is enabled, the base frequency
> used by the HPET will not be running on average slower than nominal 14.318
> MHz.
> Since there is no provision in the OS for HPET to work with properly with
> slower frequency, the BIOS on this platform uses SMM to emulate accesses to
> the HPET config register to supply a corrected base frequency to compensate
> for it.
> However, due to the implementation of the SMM BIOS code, there is a time
> window after the first access to the HPET, which triggers initialization of
> the SMM code, in which the HPET isn't available. Thus it's necessary to wait
> until the HPET emulation is ready, and this is what the patch does on the
> affected machines.

Crane,

thanks for debugging this. I think we don't need a quirk for this
workaround. Checking the config register value for 0xffffffff is safe
on all machines. I simplified your patch to the one below and added a
printk in case the check times out.

One thing I'm a bit wary about is the readout of the HPET_PERIOD
register. Is the value correct even _before_ the SMM machinery is
started ?

Thanks,

	tglx
-----
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad2b15a..59fd3b6 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -359,6 +359,7 @@ static int hpet_clocksource_register(void)
 int __init hpet_enable(void)
 {
 	unsigned long id;
+	int i;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -369,6 +370,29 @@ int __init hpet_enable(void)
 	 * Read the period and check for a sane value:
 	 */
 	hpet_period = hpet_readl(HPET_PERIOD);
+
+	/*
+	 * AMD SB700 based systems with spread spectrum enabled use a
+	 * SMM based HPET emulation to provide proper frequency
+	 * setting. The SMM code is initialized with the first HPET
+	 * register access and takes some time to complete. During
+	 * this time the config register reads 0xffffffff. We check
+	 * for max. 1000 loops whether the config register reads a non
+	 * 0xffffffff value to make sure that HPET is up and running
+	 * before we go further. A counting loop is safe, as the HPET
+	 * access takes thousands of CPU cycles. On non SB700 based
+	 * machines this check is only done once and has no side
+	 * effects.
+	 */
+	for (i = 0; hpet_readl(HPET_CFG) == 0xFFFFFFFF; i++) {
+		if (i == 1000) {
+			printk(KERN_WARNING
+			       "HPET config register value = 0xFFFFFFFF. "
+			       "Disabling HPET\n");
+			goto out_nohpet;
+		}
+	}
+
 	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
 		goto out_nohpet;
 

 
