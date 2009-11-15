Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbZKOIII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbZKOIII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZKOIIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:08:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbZKOIIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:08:05 -0500
Date: Sun, 15 Nov 2009 09:07:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: resume crashes in intel_init_thermal [was: mmotm
 2009-11-13-19-59 uploaded]
Message-ID: <20091115080718.GB15432@elte.hu>
References: <200911140403.nAE43CN1016851@imap1.linux-foundation.org>
 <4AFEB060.80007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFEB060.80007@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/14/2009 05:03 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-11-13-19-59 has been uploaded to
> 
> Hi, resume from ram dies in intel_init_thermal in that kernel:
> http://www.fi.muni.cz/~xslaby/sklad/mce_oops.png
> 
> The code is cc cc cc cc ... KGDB and KPROBES are off, I don't know where
> the pattern may come from.
> 
> Does it ring a bell? Any ideas? mmotm 2009-11-01-10-01 was OK.

This is a known bug - see the fix below.

	Ingo

-------------->
>From cffd377e5879ea58522224a785a083f201afd80e Mon Sep 17 00:00:00 2001
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Thu, 12 Nov 2009 15:52:40 +0900
Subject: [PATCH] x86, mce: Fix __init annotations

The intel_init_thermal() is called from resume path, so it
cannot be marked as __init.

OTOH mce_banks_init() is only called from
__mcheck_cpu_cap_init() which is marked as __cpuinit, so it can
be also marked as __cpuinit.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Yong Wang <yong.y.wang@linux.intel.com>
LKML-Reference: <4AFBB0B8.2070501@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c         |    4 ++--
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0d41020..5f277ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1201,7 +1201,7 @@ int mce_notify_irq(void)
 }
 EXPORT_SYMBOL_GPL(mce_notify_irq);
 
-static int mce_banks_init(void)
+static int __cpuinit __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
 
@@ -1242,7 +1242,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	WARN_ON(banks != 0 && b != banks);
 	banks = b;
 	if (!mce_banks) {
-		int err = mce_banks_init();
+		int err = __mcheck_cpu_mce_banks_init();
 
 		if (err)
 			return err;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 8a73d5c..4fef985 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -268,7 +268,7 @@ void __init mcheck_intel_therm_init(void)
 		lvtthmr_init = apic_read(APIC_LVTTHMR);
 }
 
-void __init intel_init_thermal(struct cpuinfo_x86 *c)
+void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
