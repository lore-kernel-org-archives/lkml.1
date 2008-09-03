Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYICPQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYICPQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYICPQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:16:00 -0400
Received: from www.tglx.de ([62.245.132.106]:50072 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYICPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:16:00 -0400
Date: Wed, 3 Sep 2008 17:15:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva>
 <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Thomas Gleixner wrote:
> Dont think so. Your dmesg outputs do not show any sign of that
> disease.
> 
> Can you try the patch below please ?

I found another instance of possible double init/shutdown. Please add
the patch below on top of the other 2 as well.

Thanks,

	tglx
---
 kernel/time/tick-broadcast.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -210,7 +210,7 @@ static void tick_do_broadcast_on_off(voi
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags, *reason = why;
-	int cpu;
+	int cpu, bc_stopped;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -228,6 +228,8 @@ static void tick_do_broadcast_on_off(voi
 	if (!tick_device_is_functional(dev))
 		goto out;
 
+	bc_stoppped = cpus_empty(tick_broadcast_mask);
+
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
@@ -250,9 +252,10 @@ static void tick_do_broadcast_on_off(voi
 		break;
 	}
 
-	if (cpus_empty(tick_broadcast_mask))
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	else {
+	if (cpus_empty(tick_broadcast_mask)) {
+		if (!bc_stopped)
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	} else if (bc_stopped) {
 		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 			tick_broadcast_start_periodic(bc);
 		else
