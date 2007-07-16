Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXGPRqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXGPRqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXGPRqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:46:10 -0400
Received: from vena.lwn.net ([206.168.112.25]:36950 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbXGPRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:46:10 -0400
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 16 Jul 2007 17:43:22 +0200."
             <Pine.LNX.4.64.0707161654130.1817@scrub.home> 
Date: Mon, 16 Jul 2007 11:46:09 -0600
Message-ID: <28799.1184607969@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> wrote:

> > That's a possibility, I admit I haven't benchmarked it.  I will say that
> > I don't think it will be enough to matter - msleep() is not a hot-path
> > sort of function.  Once the system is up and running it almost never
> > gets called at all - at least, on my setup.
> 
> That's a bit my problem - we have to consider other setups as well.
> Is it worth converting all msleep users behind their back or should we 
> just a provide a separate function for those who care?

Any additional overhead is clearly small - enough not to disrupt a *high
resolution* timer, after all.  And msleep() is used mostly during
initialization time.  My box had a few hundred calls, almost all during
boot.  Any cost will be bounded by the fact that, well, it sleeps for
milliseconds on every call.

I could run a million-msleep profile if you really want, but I just
can't imagine it's going to have a measurable effect on any real-world
situation.  Is there a specific setup you're worried about?

I'm not *that* attached to this patch; if it causes heartburn we can
just forget it.  But I had thought it might be useful...

> Which driver is this? I'd like to look at this, in case there's some other 
> hidden problem. 

drivers/media/video/cafe_ccic.c, and cafe_smbus_write_data() in
particular.  The "hidden problem," though, is that the hardware has
periods where reading the status registers will send it off into its
room where it will hide under its bed and never come out.

I have an alternative which avoids the sleep at the cost of a small,
relatively harmless race; it may be my real solution in the end, we'll
see.

> > Except that then, with the current implementation, you're paying for the
> > higher HZ whenever the CPU is busy.  I bet that doesn't take long to
> > overwhelm any added overhead in the hrtimer msleep().
> 
> Actually if that's the case I'd consider this a bug, where is that extra 
> cost coming from?

My understanding is that the current dyntick code only turns off the
tick during idle periods; while things are running it's business as
usual.  Perhaps I misunderstood?

jon
