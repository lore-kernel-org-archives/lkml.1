Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbZCYRrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbZCYRrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763757AbZCYRr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:47:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:14629 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493AbZCYRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:47:27 -0400
X-IronPort-AV: E=Sophos;i="4.38,420,1233550800"; 
   d="scan'208";a="45126374"
Subject: Re: [PATCH] clockevent: on resume program the next oneshot tick
	with the next actual event
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "Alex.Zeffertt" <Alex.Zeffertt@citrix.com>,
       stable@kernel.org
In-Reply-To: <49CA678A.30606@goop.org>
References: <1237988429-26474-1-git-send-email-Ian.Campbell@citrix.com>
	 <49CA678A.30606@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Wed, 25 Mar 2009 17:46:42 +0000
Message-Id: <1238003202.3691.174.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 17:47:24.0409 (UTC) FILETIME=[C161C690:01C9AD71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 10:19 -0700, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > When resuming a Xen domU we were seeing an issue where the timer ticks never
> > seemed to start up again. This was with CONFIG_NO_HZ=y, the Xen clocksource
> > has CLOCK_EVT_FEAT_ONESHOT but not CLOCK_EVT_FEAT_PERIODIC.
> >
> > The issue is that on resume tick_resume_oneshot() tries to program an event for
> > "now", e.g.
> > 	tick_program_event(ktime_get(), 1);
> >
> > However further down the call chain tick_dev_program_event() then compares that
> >   
> Where's that?  Do you mean in clockevents_program_event():
> 
> 	delta = ktime_to_ns(ktime_sub(expires, now));
> 
> 	if (delta <= 0)
> 		return -ETIME;
> 
> 
> ?

Yes that's the one.

> > With this fix I can successfully resume a Xen domain.
> >   
> 
> That's good, but I think there's more going on here.

Hmm, yes I think so too. I misread tick_dev_program_event(), it seems
like it Does The Right Thing and I do see the Xen set_next_event hook
get called which I thought wasn't getting called earlier.

Turns out the virtual timer IRQ isn't getting reinitialised before
tick_oneshot_resume runs so we are just missing the interrupt, doh!

---

Subject: xen: resume interrupts before system devices.

otherwise the first timer interrupt after resume is missed and we never
get another.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 0489ea2..5269bb4 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -68,15 +68,15 @@ static int xen_suspend(void *data)
 	gnttab_resume();
 	xen_mm_unpin_all();
 
-	sysdev_resume();
-	device_power_up(PMSG_RESUME);
-
 	if (!*cancelled) {
 		xen_irq_resume();
 		xen_console_resume();
 		xen_timer_resume();
 	}
 
+	sysdev_resume();
+	device_power_up(PMSG_RESUME);
+
 	return 0;
 }
 

Ian.



> 
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

