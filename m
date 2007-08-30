Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXH3VGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXH3VGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXH3VGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:06:39 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:64892 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbXH3VGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:06:35 -0400
Date: Thu, 30 Aug 2007 14:05:55 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: B.Steinbrink@gmx.de, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070830210555.GA6635@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070827225555.GI784@frankl.hpl.hp.com> <1188256074.2435.272.camel@dhcp193.mvista.com> <20070828091217.GA1645@frankl.hpl.hp.com> <1188311684.2435.288.camel@dhcp193.mvista.com> <20070828170556.GI1645@frankl.hpl.hp.com> <1188325835.2435.317.camel@dhcp193.mvista.com> <20070828194636.GB2814@frankl.hpl.hp.com> <1188332024.2435.328.camel@dhcp193.mvista.com> <20070829212451.GC4810@frankl.hpl.hp.com> <1188436919.26038.27.camel@dhcp193.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1188436919.26038.27.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Daniel,

On Wed, Aug 29, 2007 at 06:21:59PM -0700, Daniel Walker wrote:
> On Wed, 2007-08-29 at 14:24 -0700, Stephane Eranian wrote:
> 
> 
> > Now on Core Duo, there is no PEBS anyway, so it is okay to use counter 0
> > for NMI. The problem is that the detection code in perfctr-watchdog.c
> > treats a Core Duo and a Core 2 Duo the same way as they both have the
> > X86_FEATURE_ARCH_PERFMON bit set.
> > 
> > I have attached a patch with handle the case of the Core Duo. Unfortunately,
> > I do not own one so I cannot test it. I would appreciate if you could
> > try re-applying my counter 0 -> 1 patch + this new one to see if you
> > have the problem with the NMI getting stuck.
> 
> I tested your patch .. The system doesn't hang, but the NMI seems to
> disappear .. The check_nmi_watchdog() is not called, and the NMI never
> actually starts firing .. Is that what you had intended?
> 
Yes, I realized I missed a small detail in the switch statement.
Could you try the new version?

Thanks.

-- 
-Stephane

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="coreduo.diff"

diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 9b5d6af..3a945f0 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -613,6 +613,17 @@ static struct wd_ops intel_arch_wd_ops = {
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
+/*
+ * Check for Intel Core Duo because it has a bug with PERFEVTSEL1
+ * (see Spefication Update bug AE49) and must use PERFEVTSEL0. We cannot
+ * use this counter on other processors supporting X86_FEATURE_ARCH_PERFMON
+ * because PEBS requires it.
+ */
+static inline int is_coreduo(void)
+{
+	return boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14;
+}
+
 static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -623,13 +634,14 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)
+		    && !is_coreduo()) {
 			wd_ops = &intel_arch_wd_ops;
 			break;
 		}
 		switch (boot_cpu_data.x86) {
 		case 6:
-			if (boot_cpu_data.x86_model > 0xd)
+			if (boot_cpu_data.x86_model > 0xe)
 				return;
 
 			wd_ops = &p6_wd_ops;

--EeQfGwPcQSOJBaQU--
