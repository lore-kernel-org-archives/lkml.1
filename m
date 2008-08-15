Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYHOMgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYHOMgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYHOMg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:36:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbYHOMg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:36:26 -0400
Date: Fri, 15 Aug 2008 08:36:14 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jvillalo@redhat.com
Subject: [PATCH] NMI: fix watchdog failure message
Message-ID: <20080815123610.GU7154@redhat.com>
References: <20080814203133.GS7154@redhat.com> <20080815115928.GD32726@elte.hu> <20080815121614.GT7154@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815121614.GT7154@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it just won't work at boot time - the second logic unit will be stuck:
> 
> Booting processor 1/2 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 5586.12 BogoMIPS (lpj=2793063)
> CPU: Trace cache: 12K uops, L1 D cache: 16K
> CPU: L2 cache: 1024K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU1: Thermal monitoring enabled (TM1)
>               Intel(R) Pentium(R) D CPU 2.80GHz stepping 04
> Brought up 2 CPUs
> testing NMI watchdog ... <4>WARNING: CPU#1: NMI appears to be stuck (0->0)!
while at it...

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 arch/x86/kernel/nmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linus-2.6.orig/arch/x86/kernel/nmi.c	2008-08-12 11:13:35.000000000 -0400
+++ linus-2.6/arch/x86/kernel/nmi.c	2008-08-15 08:33:57.000000000 -0400
@@ -142,11 +142,15 @@ int __init check_nmi_watchdog(void)
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
+			printk("\n");
 			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
 				"appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
 				get_nmi_count(cpu));
+			printk(KERN_WARNING "Please report this to "
+			       "linux-kernel@vger.kernel.org and attach "
+			       "the output of 'dmesg' command.\n");
 			per_cpu(wd_enabled, cpu) = 0;
 			atomic_dec(&nmi_active);
 		}
