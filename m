Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXAWKTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXAWKTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXAWKTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:19:16 -0500
Received: from vsmtp4.tin.it ([212.216.176.224]:57667 "EHLO vsmtp4.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938AbXAWKTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:19:15 -0500
Date: Tue, 23 Jan 2007 11:19:10 +0100 (CET)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: linux-kernel@vger.kernel.org
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
Message-ID: <Pine.LNX.4.64.0701231118290.22876@Phoenix.oltrelinux.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

reproduced.
it took more or less one hour to reproduce it.  I could reproduce it olny
running also irqbalance 0.55 and commenting out the sleep 1. The message 
in
syslog is the same and then, after a few seconds I think, KABOM! system 
crash
and reboot.

I tested also a similar system that has 4 dual core CPU Opteron 2600MHZ. 
On
this system (linux sees 8 CPU, but it is the same kernel, same gcc, same
config, same glibc, same active services) I could not reproduce it even
running irqbalance 0.55 in almost 1 hour. Maybe I could reproduce it 
waiting
for more time, but my users need to do their work, so I could not have a
longer test window. So on 16 CPU I had the crash, on 8 CPU I had no crash.

I need to give back the system to the users, so if you need other tests,
please, tell me as soon.

thanx

Luigi Genoni

On Monday 22 January 2007 18:14, Eric W. Biederman wrote:
> "Luigi Genoni" <luigi.genoni@pirelli.com> writes:
> > (e-mail resent because not delivered using my other e-mail account)
> >
> > Hi,
> > this night a linux server 8 dual core CPU Optern 2600Mhz crashed just
> > after giving this message
> >
> > Jan 22 04:48:28 frey kernel: do_IRQ: 1.98 No irq handler for vector
>
> Ok.  This indicates that the hardware is doing something we didn't 
expect.
> We don't know which irq the hardware was trying to deliver when it
> sent vector 0x98 to cpu 1.
>
> > I have no other logs, and I eventually lost the OOPS since I have no 
net
> > console setled up.
>
> If you had an oops it may have meant the above message was a secondary
> symptom.  Groan.  If it stayed up long enough to give an OOPS then
> there is a chance the above message appearing only once had nothing
> to do with the actual crash.
>
> How long had the system been up?
>
> > As I said sistem is running linux 2.6.19 compiled with gcc 4.1.1 for 
AMD
> > Opteron (attached see .config), no kernel preemption excepted the BKL
> > preemption. glibc 2.4.
> >
> > System has 16 GB RAM and 8 dual core Opteron 2600Mhz.
> >
> > I am running irqbalance 0.55.
> >
> > any hints on what has happened?
>
> Three guesses.
>
> - A race triggered by irq migration (but I would expect more people to 
be
> yelling). The code path where that message comes from is new in 2.6.19 
so
> it may not have had all of the bugs found yet :(
> - A weird hardware or BIOS setup.
> - A secondary symptom triggered by some other bug.
>
> If this winds up being reproducible we should be able to track it down.
> If not this may end up in the files of crap something bad happened that
> we don't understand.
>
> The one condition I know how to test for (if you are willing) is an
> irq migration race.  Simply by triggering irq migration much more often,
> and thus increasing our chances of hitting a problem.
>
> Stopping irqbalance and running something like:
> for irq in 0 24 28 29 44 45 60 68 ; do
>       while :; do
>               for mask in 1 2 4 8 10 20 40 80 100 200 400 800 1000 2000 
4000 8000 ; do
>                       echo mask > /proc/irq/$irq/smp_affinity
>                       sleep 1
>               done
>       done &
> done
>
> Should force every irq to migrate once a second, and removing the sleep 
1
> is even harsher, although we max at one irq migration by irq received.
>
> If some variation of the above loop does not trigger the do_IRQ ??? No 
irq
> handler for vector message chances are it isn't a race in irq migration.
>
> If we can rule out the race scenario it will at least put us in the 
right
> direction for guessing what went wrong with your box.
>
> Eric

-- 

