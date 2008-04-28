Return-Path: <linux-kernel-owner+w=401wt.eu-S934671AbYD1OLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671AbYD1OLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765642AbYD1OLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:11:31 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:20859 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763151AbYD1OLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:11:30 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-6.tower-164.messagelabs.com!1209391885!6539425!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Mon, 28 Apr 2008 16:11:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
Message-ID: <20080428141116.GB9048@digi.com>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 28 Apr 2008 14:11:17.0104 (UTC) FILETIME=[B988CF00:01C8A939]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15876.007
X-TM-AS-Result: No--14.837000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Gleixner wrote:
> On Mon, 28 Apr 2008, Uwe Kleine-König wrote:
> > Consider two devices A and B sharing an irq and B already asserts the irq on
> > a booting machine.
> > If the driver for A is loaded first the irq starts triggering and gets
> > disabled after some time by note_interrupt().  Later when the driver for B
> > is loaded the interrupt should be reenabled---other wise both A and B don't
> > work properly.
> 
> Oh no. There is lots of code in drivers, which does:
> 
>    disable_irq();
>    do_some_protected_stuff();
>    enable_irq();
> 
> So when the second driver is loaded on another CPU it would see the
> IRQ_DISABLED bit set and unconditionally reenable the interrupt. 
> 
> This unprotects the protected operation and definitely triggers the
> WARN_ON() in enable_irq() where we check for desc->depth == 0.
mmpf.

It's not nice to use disable_irq()/enable_irq() in a driver, is it?
 
> I can see the rationale for your patch, as we have no way to silence
> stupid hardware or hardware which was left in that state by the BIOS
> other than disabling the interrupt line completely.
> 
> Waht kind of scenario/devices do you have which trigger this ?
It's a ns9215 SoC.  The rtc component has a clock flag that I need to
set before accessing the address space.  After enabling the clock flag
I get an irq if the rtc is up.  The rtc itself uses the same irq.  As I
want to handle the clk enabling in platform code and the actual rtc in a
driver I need a shared irq.
Now the problem is that the rtc remembers its alarm flags over
reboots[1] and starts asserting the irq when the platform code has
requested the irq.

I currently see two ways to handle that:
 1) find an alternative patch similar to the one I sent that don't break
    driver code; or
 2) let the platform code disable the rtc's irqs.

for 1) you need to remember the reason for disabling the irq (or fix all
drivers not to use disable_irq()).  And 2) is ugly because I have to
ioremap then.

Best regards
Uwe

[1] not entirely sure, but I had the rtc in a state in which the rtc
component asserted an irq directly after a reset.

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
