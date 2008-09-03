Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYICRGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYICRGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYICRGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:06:02 -0400
Received: from www.tglx.de ([62.245.132.106]:60704 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYICRGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:06:00 -0400
Date: Wed, 3 Sep 2008 19:05:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Nezhevenko <dion@inhex.net>
cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080903164415.GA24442@laptop.local>
Message-ID: <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva>
 <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Dmitry Nezhevenko wrote:
> On Wed, Sep 03, 2008 at 05:15:40PM +0200, Thomas Gleixner wrote:
> > On Wed, 3 Sep 2008, Thomas Gleixner wrote:
> > > Dont think so. Your dmesg outputs do not show any sign of that
> > > disease.
> > > 
> > > Can you try the patch below please ?
> 
> I'm not original problem reporter. However I'm experiencing possible same
> problem with MSI M673 laptop. Here is link to bugzilla report (with
> dmesgs and other info):
> http://bugzilla.kernel.org/show_bug.cgi?id=11101
> 
> 2.6.27-rc4 on this machine freezes with exactly same messages:
> 
> hpet0: at MMIO 0xfed00000, IRQ 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> ACPI: RTC can wake from S4
> 
> This patch do not help me
> 
> > @@ -228,6 +228,8 @@ static void tick_do_broadcast_on_off(voi
> >  	if (!tick_device_is_functional(dev))
> >  		goto out;
> >  
> > +	bc_stoppped = cpus_empty(tick_broadcast_mask);
> 
> btw little type here, should be "bc_stopped"

Yeah, noticed already. Sorry.

Find a debug patch below, which looks at the two functions which might
loop forver under certain conditions. Does one of the checks hit ?

Thanks,

	tglx
---
 kernel/time/tick-broadcast.c |   17 +++++++++++++++--
 kernel/time/tick-oneshot.c   |   13 +++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -373,14 +373,27 @@ static int tick_broadcast_set_event(ktim
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 	ktime_t now = ktime_get();
-	int res;
+	static int once = 0;
+	int res, i;
 
-	for(;;) {
+	for(i = 0; ; i++) {
 		res = clockevents_program_event(bc, expires, now);
 		if (!res || !force)
 			return res;
 		now = ktime_get();
 		expires = ktime_add(now, ktime_set(0, bc->min_delta_ns));
+		if (i++ > 4) {
+			if (!once) {
+				printk(KERN_WARNING
+				       "tick_broadcast_set_event is "
+				       "stuck %llx %llx\n",
+				       now.tv64, expires.tv64);
+				WARN_ON(1);
+			}
+			/* Enforce it */
+			now = ktime_get();
+			expires = ktime_add_ns(now, bc->min_delta_ns << i);
+		}
 	}
 }
 
Index: linux-2.6/kernel/time/tick-oneshot.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-oneshot.c
+++ linux-2.6/kernel/time/tick-oneshot.c
@@ -29,6 +29,8 @@ static int __tick_program_event(struct c
 				ktime_t expires, int force)
 {
 	ktime_t now = ktime_get();
+	static int once = 0;
+	int i = 0;
 
 	while (1) {
 		int ret = clockevents_program_event(dev, expires, now);
@@ -37,6 +39,17 @@ static int __tick_program_event(struct c
 			return ret;
 		now = ktime_get();
 		expires = ktime_add(now, ktime_set(0, dev->min_delta_ns));
+		if (i++ > 4) {
+			if (!once) {
+				printk(KERN_WARNING "__tick_program_event is "
+				       "stuck %llx %llx\n",
+				       now.tv64, expires.tv64);
+				WARN_ON(1);
+			}
+			/* Enforce it */
+			now = ktime_get();
+			expires = ktime_add_ns(now, dev->min_delta_ns << i);
+		}
 	}
 }
 
