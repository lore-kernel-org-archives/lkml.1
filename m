Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYHONgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYHONgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYHONgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:36:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbYHONgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:36:41 -0400
Date: Fri, 15 Aug 2008 15:36:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-kernel@vger.kernel.org, jvillalo@redhat.com
Subject: Re: [PATCH] NMI: fix watchdog failure message
Message-ID: <20080815133628.GA9243@elte.hu>
References: <20080814203133.GS7154@redhat.com> <20080815115928.GD32726@elte.hu> <20080815121614.GT7154@redhat.com> <20080815123610.GU7154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815123610.GU7154@redhat.com>
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


* Aristeu Rozanski <arozansk@redhat.com> wrote:

> > it just won't work at boot time - the second logic unit will be stuck:
> > 
> > Booting processor 1/2 APIC 0x1
> > Initializing CPU#1
> > Calibrating delay using timer specific routine.. 5586.12 BogoMIPS (lpj=2793063)
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 1024K
> > CPU: Physical Processor ID: 0
> > CPU: Processor Core ID: 1
> > CPU1: Thermal monitoring enabled (TM1)
> >               Intel(R) Pentium(R) D CPU 2.80GHz stepping 04
> > Brought up 2 CPUs
> > testing NMI watchdog ... <4>WARNING: CPU#1: NMI appears to be stuck (0->0)!
> while at it...
> 
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

applied to tip/x86/urgent, thanks Aristeu.

I've also done the cleanup below - those ugly linebreaks are gone this 
way as well.

	Ingo

---------------------->
>From 8bb851900f5d0a79d3fddac808cc670d9894ef67 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 15 Aug 2008 15:34:32 +0200
Subject: [PATCH] x86, nmi: clean UP NMI watchdog failure message

clean up the failure message - and redirect people to bugzilla
instead of lkml.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/nmi.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 919473a..abb78a2 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -114,6 +114,23 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
+static void report_broken_nmi(int cpu, int *prev_nmi_count)
+{
+	printk(KERN_CONT "\n");
+
+	printk(KERN_WARNING
+		"WARNING: CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+			cpu, prev_nmi_count[cpu], get_nmi_count(cpu));
+
+	printk(KERN_WARNING
+		"Please report this to bugzilla.kernel.org,\n");
+	printk(KERN_WARNING
+		"and attach the output of the 'dmesg' command.\n");
+
+	per_cpu(wd_enabled, cpu) = 0;
+	atomic_dec(&nmi_active);
+}
+
 int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -141,19 +158,8 @@ int __init check_nmi_watchdog(void)
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
-			printk("\n");
-			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
-				"appears to be stuck (%d->%d)!\n",
-				cpu,
-				prev_nmi_count[cpu],
-				get_nmi_count(cpu));
-			printk(KERN_WARNING "Please report this to "
-			       "linux-kernel@vger.kernel.org and attach "
-			       "the output of 'dmesg' command.\n");
-			per_cpu(wd_enabled, cpu) = 0;
-			atomic_dec(&nmi_active);
-		}
+		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5)
+			report_broken_nmi(cpu, prev_nmi_count);
 	}
 	endflag = 1;
 	if (!atomic_read(&nmi_active)) {
