Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYJCWZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYJCWZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYJCWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:25:04 -0400
Received: from www.tglx.de ([62.245.132.106]:46542 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYJCWZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:25:02 -0400
Date: Sat, 4 Oct 2008 00:24:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Dave Hansen <dave@sr71.net>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0810040018200.4404@apollo>
References: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Alan Stern wrote:
> On Fri, 3 Oct 2008, Dave Hansen wrote:
> There are a number of other places in the trace where delays are
> shorter than they should be.  This is out of my area of expertise, so 
> I'm CC'ing Thomas Gleixner.  With luck he'll be able to help.
> 
> Thomas, the background for this problem is available here:
> 
> 	http://marc.info/?l=linux-kernel&m=122305738430115&w=2

Is NOHZ and HIGHRES disabled on those kernels? Hugh spotted a typo in
that code today. Fix is below. It causes jiffies to increment too fast
which explains your short delays.

Thanks,

	tglx
---
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bd70345..cb01cd8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -235,7 +235,8 @@ static void tick_do_broadcast_on_off(void *why)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
-			if (bc->mode == TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode ==
+			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -245,7 +246,8 @@ static void tick_do_broadcast_on_off(void *why)
 		if (!tick_broadcast_force &&
 		    cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
-			if (bc->mode == TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode ==
+			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;


