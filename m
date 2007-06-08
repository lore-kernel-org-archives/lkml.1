Return-Path: <linux-kernel-owner+w=401wt.eu-S1031398AbXFHU6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031398AbXFHU6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031293AbXFHU54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:57:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031054AbXFHU5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:57:54 -0400
Date: Fri, 8 Jun 2007 13:57:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: Ingo Molnar <mingo@elte.hu>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH 0/2] i386: Fix two more NMI watchdog bugs
Message-Id: <20070608135727.d956166d.akpm@linux-foundation.org>
In-Reply-To: <20070608224911.3ff6bd18@laptop.hypervisor.org>
References: <465C2225.2000100@googlemail.com>
	<20070603150246.5151dda6@laptop.hypervisor.org>
	<20070608060244.GA2369@atjola.homenet>
	<20070607234153.09c32b49.akpm@linux-foundation.org>
	<20070608105808.GA10190@elte.hu>
	<20070608184422.GA2204@atjola.homenet>
	<20070608204324.GA25392@elte.hu>
	<20070608224911.3ff6bd18@laptop.hypervisor.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 22:49:11 +0200
"Udo A. Steinberg" <us15@os.inf.tu-dresden.de> wrote:

> On Fri, 8 Jun 2007 22:43:25 +0200 Ingo Molnar (IM) wrote:
> 
> IM> 
> IM> * Bj?rn Steinbrink <B.Steinbrink@gmx.de> wrote:
> IM> 
> IM> > Anyway, both are bugs and should be fixed. Maybe we're even lucky and 
> IM> > it fixes your hang. *fingers crossed*
> IM> 
> IM> just to make it clear: the NMI watchdog was working perfectly fine on 
> IM> that box (in v2.6.21 and in dozens of kernel releases before that, for 
> IM> multiple years) before Andi's cleanup patch. So lets find that bug first 
> IM> or revert the cleanups.
> IM> 
> IM> 	Ingo
> 
> None of the patches posted by Bj__rn fix the kernel BUG at
> arch/i386/kernel/cpu/perfctr-watchdog.c:126! that occurs when doing
> echo 0 > /proc/sys/kernel/nmi_watchdog
> 
> Call Trace:
>  [<c010c429>] single_msr_unreserve+0xd/0x1a
>  [<c010c668>] disable_lapic_nmi_watchdog+0x27/0x35
>  [<c0110ac6>] proc_nmi_enabled+0xa0/0xbd
>  [<c018550c>] proc_sys_write+0x6f/0x8c
>  [<c018549d>] proc_sys_write+0x0/0x8c
>  [<c0156e5b>] vfs_write+0x8a/0x10c
>  [<c0157317>] sys_write+0x41/0x67
>  [<c0103c30>] syscall_call+0x7/0xb
> 
> Andi, did you have a patch for that?
> 

This?


From: Bjorn Steinbrink <B.Steinbrink@gmx.de>

Fix oops triggered during: echo 0 > /proc/sys/kernel/nmi_watchdog

The culprit seems to be 09198e68501a7e34737cd9264d266f42429abcdc:
[PATCH] i386: Clean up NMI watchdog code

In two places, the parameters to release_{evntsel,perfctr}_nmi
got interchanged during the cleanup.

Fix interchanged parameters to release_{evntsel,perfctr}_nmi.

Signed-off-by: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~fix-interchanged-parameters-to-release_evntselperfctr_nmi arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~fix-interchanged-parameters-to-release_evntselperfctr_nmi
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -276,8 +276,8 @@ static int single_msr_reserve(void)
 
 static void single_msr_unreserve(void)
 {
-	release_evntsel_nmi(wd_ops->perfctr);
-	release_perfctr_nmi(wd_ops->evntsel);
+	release_evntsel_nmi(wd_ops->evntsel);
+	release_perfctr_nmi(wd_ops->perfctr);
 }
 
 static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
@@ -475,10 +475,10 @@ static void p4_unreserve(void)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings > 1)
-		release_evntsel_nmi(MSR_P4_IQ_PERFCTR1);
+		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
 #endif
-	release_evntsel_nmi(MSR_P4_IQ_PERFCTR0);
-	release_perfctr_nmi(MSR_P4_CRU_ESCR0);
+	release_evntsel_nmi(MSR_P4_CRU_ESCR0);
+	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
 }
 
 static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
_

