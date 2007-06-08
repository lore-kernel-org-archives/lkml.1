Return-Path: <linux-kernel-owner+w=401wt.eu-S1031705AbXFHSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031705AbXFHSu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937576AbXFHSuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:50:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:50123 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756433AbXFHSuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:50:16 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+eMHUVyOmeCOLJqfHVJspbKlTsj0ixCT5YRs/GDu
	s1aM5vAMxkh/GL
Date: Fri, 8 Jun 2007 20:50:12 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH 2/2] i386: Use the right wrapper to disable the NMI watchdog
Message-ID: <20070608185012.GC2204@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, ak@suse.de
References: <465C2225.2000100@googlemail.com> <20070603150246.5151dda6@laptop.hypervisor.org> <20070608060244.GA2369@atjola.homenet> <20070607234153.09c32b49.akpm@linux-foundation.org> <20070608105808.GA10190@elte.hu> <20070608184422.GA2204@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070608184422.GA2204@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When disabled through /proc/sys/kernel/nmi_watchdog, the NMI watchdog
uses the stop() method directly, which does not decrement the activity
counter, leading to a BUG(). Use the wrapper function instead to fix
that.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 2b04c8f..f0b6763 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -28,7 +28,7 @@ struct wd_ops {
 	void (*unreserve)(void);
 	int (*setup)(unsigned nmi_hz);
 	void (*rearm)(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz);
-	void (*stop)(void *);
+	void (*stop)(void);
 	unsigned perfctr;
 	unsigned evntsel;
 	u64 checkbit;
@@ -142,7 +142,7 @@ void disable_lapic_nmi_watchdog(void)
 	if (atomic_read(&nmi_active) <= 0)
 		return;
 
-	on_each_cpu(wd_ops->stop, NULL, 0, 1);
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
 	wd_ops->unreserve();
 
 	BUG_ON(atomic_read(&nmi_active) != 0);
@@ -255,7 +255,7 @@ static int setup_k7_watchdog(unsigned nmi_hz)
 	return 1;
 }
 
-static void single_msr_stop_watchdog(void *arg)
+static void single_msr_stop_watchdog(void)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
@@ -442,7 +442,7 @@ static int setup_p4_watchdog(unsigned nmi_hz)
 	return 1;
 }
 
-static void stop_p4_watchdog(void *arg)
+static void stop_p4_watchdog(void)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 	wrmsr(wd->cccr_msr, 0, 0);
@@ -628,7 +634,7 @@ int lapic_watchdog_init(unsigned nmi_hz)
 void lapic_watchdog_stop(void)
 {
 	if (wd_ops)
-		wd_ops->stop(NULL);
+		wd_ops->stop();
 }
 
 unsigned lapic_adjust_nmi_hz(unsigned hz)
