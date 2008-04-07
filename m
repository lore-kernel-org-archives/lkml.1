Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYDGWzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYDGWzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYDGWzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:55:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbYDGWzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:55:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Date: Tue, 8 Apr 2008 00:54:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Kosina <jkosina@suse.cz>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <200804080029.31102.rjw@sisk.pl> <20080407223540.GI16647@one.firstfloor.org>
In-Reply-To: <20080407223540.GI16647@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080054.28575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of April 2008, Andi Kleen wrote:
> On Tue, Apr 08, 2008 at 12:29:30AM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 8 of April 2008, Andi Kleen wrote:
> > > On Tue, Apr 08, 2008 at 12:11:17AM +0200, Jiri Kosina wrote:
> > > > On Tue, 8 Apr 2008, Andi Kleen wrote:
> > > > 
> > > > > > I know. However preempt_count is a little bit inconsistent in such cases 
> > > > > > though.
> > > > > And? interrupts off beats preempt count anyways. Why did you write the 
> > > > > patch? Was there a (incorrect) warning triggered?
> > > > 
> > > > Reported at http://lkml.org/lkml/2008/4/7/130
> > > > 
> > > > BTW is also mce_init() (called from mce_resume()) guaranteed to run with 
> > > > IRQs off?
> > > 
> > > [cc rafael]
> > > 
> > > The mce resume is a sysdev.
> > > 
> > > sysdevs were always supposed to run completely with interrupts off. If they 
> > > don't anymore that's some kind of higher level resume code bug which you need 
> > > to fix there, not hack around in the low level code.
> > 
> > They are executed with interrupts disabled, on one CPU.
> 
> Well then someone enables them incorrectly, see the report above.

Hm, well.  I really don't think that ACPI or the core does it, but anyway
Zdenek, could you please apply the appended patch and see if it
produces any additional warnings?

If it doesn't, then probably one of the sysdevs does it in its ->resume()
routine, which also will be easy to check against.

> > 
> > > If it does that it likely broke more code too.
> > > 
> > > Obviously turning on preemption anywhere around the machine check is
> > > fatal because it touches CPU state and if you reschedule you could
> > > switch to another CPU and change or access the wrong CPU's state.
> > 
> > FWIW, at the point when sysdevs are resumed we are single-threaded.
> 
> You mean single CPUed? Even a single thread could switch to another CPU.

Signle CPUed too.

Thanks,
Rafael

---
---
 drivers/acpi/sleep/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -141,9 +141,13 @@ static int acpi_pm_enter(suspend_state_t
 		break;
 	}
 
+	WARN_ON(!irqs_disabled());
+
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
+	WARN_ON(!irqs_disabled());
+
 	/* ACPI 3.0 specs (P62) says that it's the responsibility
 	 * of the OSPM to clear the status bit [ implying that the
 	 * POWER_BUTTON event should not reach userspace ]
@@ -158,6 +162,8 @@ static int acpi_pm_enter(suspend_state_t
 	 */
 	acpi_hw_disable_all_gpes();
 
+	WARN_ON(!irqs_disabled());
+
 	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
 
@@ -165,6 +171,8 @@ static int acpi_pm_enter(suspend_state_t
 	if (acpi_state == ACPI_STATE_S3)
 		acpi_restore_state_mem();
 
+	WARN_ON(!irqs_disabled());
+
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
