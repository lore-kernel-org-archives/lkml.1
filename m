Return-Path: <linux-kernel-owner+w=401wt.eu-S938763AbXGSKdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938763AbXGSKdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938307AbXGSKWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:22:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:37695 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S938256AbXGSKWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:22:12 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19y1qN5Da1ybnQCSwVGwVDKj6UusHDiycxb5bfqE5
	UtVo9iklI/rDiu
Date: Thu, 19 Jul 2007 12:21:45 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [21/58] i386: Reserve the right performance counter
	for the Intel PerfMon NMI watchdog
Message-ID: <20070719102145.GA6581@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095506.52E3214E06@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070719095506.52E3214E06@wotan.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.19 11:55:06 +0200, Andi Kleen wrote:
> 
> From: [** iso-8859-1 charset **] BjörnSteinbrink <B.Steinbrink@gmx.de>
> 
> The Intel PerfMon NMI watchdog was using the generic reservation
> function which always reserves the first performance counter. But the
> watchdog actually uses the second performance counter, thus we need a
> specialised function.

Ah, almost forgot about that patch. Actually, thanks to your fix that
basically reverted the msr->offset conversation to its 2.6.21
implementation, single_msr_reserve has sane semantics now and does just
what the name suggests (before, the wd_ops entries had to store the
"base" msrs, so it was really a first_msr_reserve).

With wd_ops->perfctr no longer needed to be the base msr, we can just
fix that value for the arch perfmon watchdog. (And maybe we should
remove the values for those implementations that don't employ the
single_msr_reserve() stuff?)

Thanks,
Björn

----

From: Björn Steinbrink <B.Steinbrink@gmx.de>

The Intel PerfMon NMI watchdog reserves the first performance counter,
but uses the second one. Make it correctly reserve the second one.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 4d26d51..30b5e48 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -599,8 +599,8 @@ static struct wd_ops intel_arch_wd_ops = {
 	.setup = setup_intel_arch_watchdog,
 	.rearm = p6_rearm,
 	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR1,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
 static void probe_nmi_watchdog(void)
