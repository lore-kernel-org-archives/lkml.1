Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZARTom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZARTom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZARTob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:44:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZARTob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:44:31 -0500
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in
 hres_timers_resume
From: Peter Zijlstra <peterz@infradead.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200901182232.57186.arvidjaar@mail.ru>
References: <200901181642.00886.arvidjaar@mail.ru>
	 <1232293169.5204.14.camel@laptop> <20090118172511.GA22624@elte.hu>
	 <200901182232.57186.arvidjaar@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jan 2009 20:44:20 +0100
Message-Id: <1232307860.5204.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 22:32 +0300, Andrey Borzenkov wrote:
> On 18 января 2009 20:25:11 Ingo Molnar wrote:
> 
> > Rafael, can you think of anything in the s2ram code that would have
> >
> > changed the irqs-off status of hres_timers_resume() in this codepath:
> > > > [17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
> > > > [17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
> > > > [17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
> > > > [17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
> > > > [17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
> > > > [17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
> > > > [17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
> > > > [17854.688347]  [<c0150614>] enter_state+0xf4/0x140
> > > > [17854.688347]  [<c01506dd>] state_store+0x7d/0xc0
> >
> > ?
> >
> 
> As far as I can tell, timekeeping_resume is called via class ->resume 
> method; and according to comments in sysdev_resume() and 
> device_power_up(), they are called with interrupts disabled.
> 
> Looking at suspend_enter, irqs *are* disabled at this point.
> 
> So it actually looks like something (may be some driver) unconditionally 
> enabled irqs in resume path.
> 
> I believe the patch should be hold back until this is clarified.

Something like so then?

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..53868b8 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -341,13 +341,17 @@ static void __sysdev_resume(struct sys_device *dev)
 	struct sysdev_driver *drv;
 
 	/* First, call the class-specific one */
-	if (cls->resume)
+	if (cls->resume) {
 		cls->resume(dev);
+		WARN(!irqs_disabled(), "%Fp enabled IRQs\n", cls->resume);
+	}
 
 	/* Call auxillary drivers next. */
 	list_for_each_entry(drv, &cls->drivers, entry) {
-		if (drv->resume)
+		if (drv->resume) {
 			drv->resume(dev);
+			WARN(!irqs_disabled(), "%Fp enabled IRQs\n", drv->resume);
+		}
 	}
 }
 


