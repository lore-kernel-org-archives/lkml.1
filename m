Return-Path: <linux-kernel-owner+w=401wt.eu-S1764156AbZEADOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764156AbZEADOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760372AbZEADN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:13:56 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49974 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115AbZEADN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:13:56 -0400
Date: Thu, 30 Apr 2009 22:13:20 -0500
From: David Fries <david@fries.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>
Subject: Re: TSC marked unstable on suspend and resume
Message-ID: <20090501031320.GA4300@spacedout.fries.net>
References: <20090221023943.GA4894@spacedout.fries.net> <1f1b08da0904290945j79e1b578ye415fe4ced259b15@mail.gmail.com> <20090429232523.GO2862@spacedout.fries.net> <1241062653.7270.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1241062653.7270.44.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Thu, 30 Apr 2009 22:13:24 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 29, 2009 at 08:37:33PM -0700, john stultz wrote:
> On Wed, 2009-04-29 at 18:25 -0500, David Fries wrote:
> > On Wed, Apr 29, 2009 at 09:45:40AM -0700, john stultz wrote:
> > > On Fri, Feb 20, 2009 at 7:39 PM, David Fries <david@fries.net> wrote:
> > > > I'm getting TSC marked as unsable on hibernate to disk with
> > > > 2.6.29-rc3. ?The last kernel I ran 2.6.24.4 ran 300+ days without a
> > > > problem and does not loose TSC on hibernate.
> > > >
> > > > I'm hibernating with `echo disk > /sys/power/state`.
> > > > These look like the relavant messages,
> > > >
> > > > CPU 0 irqstacks, hard=c0379000 soft=c0378000
> > > > PID hash table entries: 1024 (order: 10, 4096 bytes)
> > > > Fast TSC calibration using PIT
> > > > Detected 300.705 MHz processor.
> > > > Calibrating delay loop (skipped), value calculated using timer frequency.. 601.41 BogoMIPS (lpj=300705)
> > > > hibernate to disk,
> > > > Restarting tasks ... done.
> > > > Clocksource tsc unstable (delta = 499883531 ns)
> > > 
> > > Hmm. Seems like the clocksource watchdog is having some problem
> > > handling state around hibernate.
> 
> Yea. This seems to be the case here. There's watchdog code and variables
> to handle resume properly, but there isn't a corresponding suspend hook,
> so the resume path doesn't actually change anything.
> 
> Here's a patch you can try, I only had time to compile test it today, so
> its untested. Hopefully I didn't miss anything obvious.
> 
> Thomas, I suspect you intended to have something like the following?
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

I added my own patch to verify your changes were being called, no
dice.  I do wonder, is it too late when the clocksource_suspend is
called after Suspending consoles?  Any theories why this is the only
system I have that is showing the problem?  It is an older system.

In the attached dmesg dump I suspended without a swap file, so it
never hibernated or rebooted.

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7575f23..387fed4 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -261,6 +261,7 @@ void clocksource_suspend(void)
 	spin_lock_irqsave(&clocksource_lock, flags);
 	clocksource_suspend_watchdog();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+	printk("Calling %s\n", __func__);
 }
 
 /**

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--WIyZ46R2i8wDzkSu
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="clocksource_suspend.txt.bz2"
Content-Transfer-Encoding: base64

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
hXpHttzQzYl/+LuSKcKEg1Q7jEA=

--WIyZ46R2i8wDzkSu--
