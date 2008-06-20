Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbYFTQTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbYFTQTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYFTQTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:19:25 -0400
Received: from bu3sch.de ([62.75.166.246]:59529 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYFTQTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:19:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Date: Fri, 20 Jun 2008 18:18:34 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
References: <1213739834.3803.137.camel@johannes.berg> <20080620155541.GC6656@elte.hu> <200806201801.09858.mb@bu3sch.de>
In-Reply-To: <200806201801.09858.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201818.34904.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2008 18:01:09 Michael Buesch wrote:
> On Friday 20 June 2008 17:55:41 Ingo Molnar wrote:
> > 
> > * Michael Buesch <mb@bu3sch.de> wrote:
> > 
> > > On Friday 20 June 2008 17:27:48 Ingo Molnar wrote:
> > > >  [<c012b361>] local_bh_enable_ip+0xd1/0xe0
> > > >  [<c08d9f9f>] _spin_unlock_bh+0x2f/0x40
> > > >  [<c0471b92>] vortex_timer+0xe2/0x3e0
> > > 
> > > > real bug or false positive?
> > > 
> > > Well, a timer runs with IRQs disabled, no? So this would be a bug.
> > 
> > indeed - agreed :) [no time for me to fix it, but can test any rfc patch.]
> 
> A quick workaround always is to convert the lock into an _irqsafe lock.
> Although it introduces higher overhead (interrupt-wise), it prevents the bug.
> A real fix would require to understand the locking in the driver, which I
> don't, as I never looked at the driver. :)


However, looking at the driver I think the fix actually is trivial:

Index: wireless-testing/drivers/net/3c59x.c
===================================================================
--- wireless-testing.orig/drivers/net/3c59x.c	2008-05-16 00:26:29.000000000 +0200
+++ wireless-testing/drivers/net/3c59x.c	2008-06-20 18:16:55.000000000 +0200
@@ -1768,9 +1768,10 @@ vortex_timer(unsigned long data)
 	case XCVR_MII: case XCVR_NWAY:
 		{
 			ok = 1;
-			spin_lock_bh(&vp->lock);
+			/* Interrupts are already disabled */
+			spin_lock(&vp->lock);
 			vortex_check_media(dev, 0);
-			spin_unlock_bh(&vp->lock);
+			spin_unlock(&vp->lock);
 		}
 		break;
 	  default:					/* Other media types handled by Tx timeouts. */


vp->lock is also taken in hardware IRQ context, so we _have_ to always
use irqsafe locking. As we run in a timer with IRQs disabled,
we can simply use spin_lock.

-- 
Greetings Michael.
