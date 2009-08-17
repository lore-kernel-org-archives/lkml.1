Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZHQLaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZHQLaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbZHQLaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:30:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741AbZHQLaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:30:23 -0400
Date: Mon, 17 Aug 2009 13:29:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       ak@linux.intel.com, tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86, mce: Don't initialize MCEs on unknown CPUs
Message-ID: <20090817112938.GA22794@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A891E17.1090901@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Old mce codes doesn't take bootlog.
> 
> One possibility is: if the BIOS doesn't clear status in banks, new 
> mce codes will try to log such junks. If the junk is totally junk 
> but can be decoded as a valid log with MISCV or ADDRV bit, and if 
> the cpu try to access register which is not implemented (e.g. 
> IA32_MCi_MISC/ADDR), then such access might cause a general 
> protection exception. (ref. ASDM 3A 15.3.2.3)
> 
> I'm just guessing...

btw., i found the bug - it's due to:

  # CONFIG_CPU_SUP_INTEL is not set

which is in essence disabling the MCE quirks in mce_cpu_quirks(). 
Quirk handlers like this, if they see an 'unknown' CPU should assume 
the worst and go for the maximum amount of quirks - or disable MCE.

I went for the second option as it's the safer one - see the fix 
below.

	Ingo

---------------------->
>From e412cd257e0d51e0ecbb89f50953835b5a0681b2 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Aug 2009 10:19:00 +0200
Subject: [PATCH] x86, mce: Don't initialize MCEs on unknown CPUs

An older test-box started hanging at the following point during
bootup:

 [    0.022996] Mount-cache hash table entries: 512
 [    0.024996] Initializing cgroup subsys debug
 [    0.025996] Initializing cgroup subsys cpuacct
 [    0.026995] Initializing cgroup subsys devices
 [    0.027995] Initializing cgroup subsys freezer
 [    0.028995] mce: CPU supports 5 MCE banks

I've bisected it down to commit 4efc0670 ("x86, mce: use 64bit
machine check code on 32bit"), which utilizes the MCE code on
32-bit systems too.

The problem is caused by this detail in my config:

  # CONFIG_CPU_SUP_INTEL is not set

This disables the quirks in mce_cpu_quirks() but still enables
MCE support - which then hangs due to the missing quirk
workaround needed on this CPU:

	if (c->x86 == 6 && c->x86_model < 0x1A && banks > 0)
		mce_banks[0].init = 0;

The safe solution is to not initialize MCEs if we dont know on
what CPU we are running (or if that CPU's support code got
disabled in the config).

Also be a bit more defensive on 32-bit systems: dont do a
boot-time dump of pending MCEs not just on the specific system
that we found a problem with (Pentium-M), but earlier ones as
well.

Now this problem is probably not common and disabling CPU
support is rare - but still being more defensive in something
we turned on for a wide range of CPUs is prudent.

Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
LKML-Reference: Message-ID: <4A88E3E4.40506@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a0c2910..0121304 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1226,8 +1226,13 @@ static void mce_init(void)
 }
 
 /* Add per CPU specific workarounds here */
-static void mce_cpu_quirks(struct cpuinfo_x86 *c)
+static int mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
+	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
+		pr_info("MCE: unknown CPU type - not enabling MCE support.\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
 		if (c->x86 == 15 && banks > 4) {
@@ -1274,14 +1279,19 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 			monarch_timeout < 0)
 			monarch_timeout = USEC_PER_SEC;
 
-		/* There are also broken BIOSes on some Pentium M systems. */
-		if (c->x86 == 6 && c->x86_model == 13 && mce_bootlog < 0)
+		/*
+		 * There are also broken BIOSes on some Pentium M and
+		 * earlier systems:
+		 */
+		if (c->x86 == 6 && c->x86_model <= 13 && mce_bootlog < 0)
 			mce_bootlog = 0;
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
 	if (mce_bootlog != 0)
 		mce_panic_timeout = 30;
+
+	return 0;
 }
 
 static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
@@ -1342,11 +1352,10 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	if (!mce_available(c))
 		return;
 
-	if (mce_cap_init() < 0) {
+	if (mce_cap_init() < 0 || mce_cpu_quirks(c) < 0) {
 		mce_disabled = 1;
 		return;
 	}
-	mce_cpu_quirks(c);
 
 	machine_check_vector = do_machine_check;
 
