Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYICOhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYICOhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYICOgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:36:53 -0400
Received: from www.tglx.de ([62.245.132.106]:43827 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYICOgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:36:53 -0400
Date: Wed, 3 Sep 2008 16:36:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080903104132.7a736282@doriath.conectiva>
Message-ID: <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
 <20080903104132.7a736282@doriath.conectiva>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Luiz Fernando N. Capitulino wrote:

> Em Wed, 3 Sep 2008 12:04:58 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> escreveu:
> 
> | On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
> | > """
> | > PCI: Using ACPI for IRQ routing
> | > DMAR:parse DMAR table failure.
> | > """
> | > 
> | >  Also, after about 10 minutes I get the same backtrace as reported in
> | > the ticket above... It's the same bug then.
> | 
> | Venki found a nasty bug in the clock events code which might be
> | related to this. I found one as well. Can you please apply the combo
> | of those fixes to current mainline and test it ?
> 
>  Same problem, with or without CONFIG_HPET enabled.
> 
>  You think the problem you are discussing with Linus - the TSC
> calibration issue - may have anything to do with this?

Dont think so. Your dmesg outputs do not show any sign of that
disease.

Can you try the patch below please ?

Thanks,
	tglx
---
 kernel/time/tick-broadcast.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -501,9 +501,12 @@ static void tick_broadcast_clear_oneshot
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
-	bc->event_handler = tick_handle_oneshot_broadcast;
-	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-	bc->next_event.tv64 = KTIME_MAX;
+	/* Set it up only once ! */
+	if (bc->event_handler != tick_handle_oneshot_broadcast) {
+		bc->event_handler = tick_handle_oneshot_broadcast;
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+		bc->next_event.tv64 = KTIME_MAX;
+	}
 }
 
 /*


