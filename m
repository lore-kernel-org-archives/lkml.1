Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYFQWSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYFQWSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbYFQWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:18:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704AbYFQWSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:18:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Wed, 18 Jun 2008 00:19:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <alpine.LFD.1.10.0806170905221.3395@apollo.tec.linutronix.de> <200806172244.24026.rjw@sisk.pl>
In-Reply-To: <200806172244.24026.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806180019.49628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 of June 2008, Rafael J. Wysocki wrote:
> On Tuesday, 17 of June 2008, Thomas Gleixner wrote:
> > On Tue, 17 Jun 2008, Rafael J. Wysocki wrote:
> > > 
> > > BTW, with the C1E patches reverted I don't get the
> > > WARNING: at /home/rafael/src/linux-next/kernel/smp.c:215 smp_call_function_single+0x3d/0xa2
> > > in the log.  Thomas?
> > 
> > Yeah, my bad. Fix below.
> 
> Thanks, it eliminates the WARNING, but still the box doesn't work with
> the "x86: add C1E aware idle function" patch applied, even with 'highres=off'.
> 
> The main symptom is that CPU loads are computed incorrectly (I got X using 126%
> of CPU time from 'top', for example).  Apart from this, some processes (like
> gkrellm) seem to be 'frozen' and only change their state in 'jumps', as though
> they only got CPU from time to time at random.
> 
> Reverting the above-mentioned patch fixes those problems.

Ah.  If your fix is replaced with the appended one, the system happily works
with C1E and highres.

Thanks,
Rafael


---
 arch/x86/kernel/process.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: linux-next/arch/x86/kernel/process.c
===================================================================
--- linux-next.orig/arch/x86/kernel/process.c
+++ linux-next/arch/x86/kernel/process.c
@@ -265,16 +265,30 @@ static void c1e_idle(void)
 	if (c1e_detected) {
 		int cpu = smp_processor_id();
 
+		local_irq_enable();
+
 		if (!cpu_isset(cpu, c1e_mask)) {
 			cpu_set(cpu, c1e_mask);
-			/* Force broadcast so ACPI can not interfere */
+			/*
+			 * Force broadcast so ACPI can not interfere. Needs
+			 * to run with interrupts enabled as it uses
+			 * smp_function_call.
+			 */
 			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 					   &cpu);
 			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
 			       cpu);
 		}
+		local_irq_disable();
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		local_irq_enable();
+
 		default_idle();
+
+		/*
+		 * The switch back from broadcast mode needs to be
+		 * called with interrupts disabled.
+		 */
 		local_irq_disable();
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
 		local_irq_enable();
