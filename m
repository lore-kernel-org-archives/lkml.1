Return-Path: <linux-kernel-owner+w=401wt.eu-S933958AbXKOWSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbXKOWSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbXKOWRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:17:52 -0500
Received: from www.tglx.de ([62.245.132.106]:60888 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbXKOWRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:17:51 -0500
Date: Thu, 15 Nov 2007 23:17:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "David P. Reed" <dpreed@reed.com>
cc: linux-kernel@vger.kernel.org, Allessandro Zummo <a.zummo@towertech.it>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] x86: on x86_64, correct reading of PC RTC when update
 in progress in time_64.c
In-Reply-To: <473CACA9.2090702@reed.com>
Message-ID: <alpine.LFD.0.9999.0711152247160.3112@localhost.localdomain>
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com>
 <1184274754.12353.254.camel@chaos> <473B9D8A.5000006@reed.com> <alpine.LFD.0.9999.0711152021270.3112@localhost.localdomain> <473CACA9.2090702@reed.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, David P. Reed wrote:

> There are a couple of things I don't understand on this one.  And I presume
> you thought the other two bug fixing patches I sent before this were OK to go,
> since on my system

I had to fix up all of them.

> Thomas Gleixner wrote:
> 
> > Still whitespace wreckage in your patches. I guess the kernel tree you
> > made your patches against is already white space wrecked.
> > 
> > I fixed that up manually, but please be more careful about that next
> > time.
> 
> Um ... I fixed the whitespaces I detected from the first round with
> checkpatch.pl.  Then for good measure
> I ran checkpatch.pl on the patches, then pasted the files directly into the
> emails.  No problems detected.

Never paste patches into mail. Also I should have checked your mail
client earlier. Thunderbird is famous for this :)
Documentation/email-clients.txt has some info on that.

> And I also just tried checkpatch.pl on the "sent" folder copy.  No problems
> detected there.

Try to apply your own patches right from the sent folder copy. They
will reject.

> Where was the whitespace?  Was it in the patches? Would you mind showing me
> the output so I can do a better job in the future?

Well the output was a simple reject when applying the patch.

Whitespace damage was for example here:

	   unsigned long flags;
20 20 09 75 6e 73  69 67 6e 65 64 20 6c 6f 6e 67 20 66 6c 61 67 73 3b 0a

where the correct patch should read:

20 09 75 6e 73  69 67 6e 65 64 20 6c 6f 6e 67 20 66 6c 61 67 73 3b 0a

Your mailer or the paste added a second blank (0x20) at the beginning
of the line.

> > > Correct potentially unstable PC RTC time register reading in time_64.c
> > > 
> > > Stop the use of an incorrect technique for reading the standard PC RTC
> > > timer, which is documented to "disconnect" time registers from the bus
> > > while updates are in progress.  The use of UIP flag while interrupts
> > > are disabled to protect a 244 microsecond window is one of the
> > > Motorola spec sheet's documented ways to read the RTC time registers
> > > reliably.
> > > 
> > > The patch updates the misleading comments and also minimizes the amount of
> > > time that the kernel disables interrupts during the reading.
> > >     
> > 
> > While I think that the UIP change is correct and a must have, the
> > locking change is not really useful. read_persistent_clock is called
> > from exactly three places:
> >   
> What locking change?  I didn't change how locking works in
> read_persistent_clock at all.
> I did introduce cpu_relax() because if anyone else ever calls from a hot path,
> that would be good practice and its' one line.

Hot path calls to this code would be extremly stupid and are forbidden
by the Penguin Law. :)

cpu_relax is not the problem, but you actuall changed the locking:

Old code:

    spin_lock();
    do {
       ....
    } while (stupid check);
    spin_unlock();

New code:
    while (1) {
        spin_lock();
        if (useful_check) {
             spin_unlock();
             cpu_relax();
        } else
             break;
   }

So with the old code I can take out the inner loop and do what
paravirtualization in the 32 bit code does:

	spin_lock_irqsave(&rtc_lock, flags);
	result = get_wallclock();
	spin_unlock_irqrestore(&rtc_lock, flags);

Where get_wallclock() either resolves to the plain rtc code or to the
paravirtualized function depending on the boot mode of the kernel.

With your change we either would need to put lokck/unlock of rtc_lock
into each incarnation of paravirt or do some nasty hack, where we
convey the flags to the called function. Neither of this makes sense
and is worth the work.

> > Right after boot, right before suspend and right after resume. None of
> > those places is a hot path, where we really care about the interrupt
> > enable/disable. IIRC, this is even called with interrupts disabled
> > most of the time, so no real gain here.
> > 
> > Another reason not to do the locking change is the paravirt stuff
> > which is coming for 64bit. I looked into the existing 32bit code and
> > doing the same lock thing would introduce a real nasty hackery, which
> > is definitely not worth the trouble.
> >   
> I presume time_64.c and time_32.c will be unified at some point, discarding
> time_64.c.  There's no arch-specific reason to be separate.  The current
> time_32.c depends on a different nmi path (that does some weird stuff saving
> and restoring the CMOS index register!), and I didn't dare usurp your
> long-term plan to unify architectures.  But a simple cleanup here makes sense,
> lest someone copy the bad technique as if it were good.

Yeah, those files are on the radar. The cleanup branch of the x86 git
tree has a first go on this already. And I'm currently figuring out
what we can do about this ugly CMOS index hack.

Anyway I keep the locking straight and simple as it is right now, the
cpu_relax() works fine with a lock held, while we are waiting the
bunch of usecs for UIP going away.

Thanks,

	tglx
