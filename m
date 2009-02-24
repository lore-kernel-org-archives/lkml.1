Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZBXE7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZBXE7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBXE6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:58:53 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:57655 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZBXE6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:58:52 -0500
Date: Mon, 23 Feb 2009 22:58:03 -0600
From: David Fries <david@fries.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: TSC marked unstable on suspend and resume
Message-ID: <20090224045803.GB4894@spacedout.fries.net>
References: <20090221023943.GA4894@spacedout.fries.net> <200902240023.52166.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902240023.52166.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 23 Feb 2009 22:58:06 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 12:23:51AM +0100, Rafael J. Wysocki wrote:
> On Saturday 21 February 2009, David Fries wrote:
> > I'm getting TSC marked as unsable on hibernate to disk with
> > 2.6.29-rc3.  The last kernel I ran 2.6.24.4 ran 300+ days without a
> > problem and does not loose TSC on hibernate.
> 
> Ingo, Andrew, can you please tell us who's the right person to look into this
> problem?

I'll be looking into it, I haven't yet started debugging it.  If
anyone has a theory of operation or what I should be lookking for, I'm
all ears.  This is an old AMD K6-2 300MHz system.  I don't know if it
matters or not, but I have NO_HZ enabled, but the timer is still going
off at 1000 Hz.

I have to decide if it is worth it to split my swap partition in two
so I can hibernate both my working kernel, and the test kernel.  It
would be nice to test a kernel and pick up where I left off.  I expect
rootfstype=ext2 on the test kernel and it really will keep my
filesystem read only.

> > I'm hibernating with `echo disk > /sys/power/state`.
> > These look like the relavant messages,
> > 
> > CPU 0 irqstacks, hard=c0379000 soft=c0378000
> > PID hash table entries: 1024 (order: 10, 4096 bytes)
> > Fast TSC calibration using PIT
> > Detected 300.705 MHz processor.
> > Calibrating delay loop (skipped), value calculated using timer frequency.. 601.41 BogoMIPS (lpj=300705)
> > hibernate to disk,
> > Restarting tasks ... done.
> > Clocksource tsc unstable (delta = 499883531 ns)
> > 
> > another reboot,
> > Restarting tasks ... done.
> > Clocksource tsc unstable (delta = 499883531 ns)
> > 
> > another reboot,
> > Freezing user space processes ... (elapsed 0.07 seconds) done.
> > Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > PM: Shrinking memory...  ^H-<4>Clocksource tsc unstable (delta = 78961880 ns)
> > ^H\^H|^H/^Hdone (34745 pages freed)
> > 
> > 
> > 
> > I didn't spot the problem until I raw the HP48 calculator emulator x48
> > and it was running like a dog, but the same binary ran fine on my
> > other systems.  It was looping on gettimeofday intending to delay 2us,
> > but was getting 1ms when TSC wasn't available.
> > 
> > On Thu, Feb 05, 2009 at 10:02:39PM +0100, Ingo Molnar wrote:
> > > What does this tool output:
> > > 
> > >  http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
> > 
> > time-warp-test is getting the number of CPUs wrong here, trivial
> > patch included.
> > 
> > ./time-warp-test  
> > 2 CPUs, running 2 parallel test-tasks.
> > 
> > grep processor /proc/cpuinfo
> > processor       : 0
> > model name      : AMD-K6(tm) 3D processor
> > 
> > 
> > --- time-warp-test.c.orig	2009-02-19 20:52:40.000000000 -0600
> > +++ time-warp-test.c	2009-02-19 21:32:58.000000000 -0600
> > @@ -295,7 +295,7 @@ int main(int argc, char **argv)
> >  	unsigned long *shared;
> >  	unsigned long cpus, tasks;
> >  
> > -	cpus = system("exit `grep processor /proc/cpuinfo  | wc -l`");
> > +	cpus = system("exit `grep ^processor /proc/cpuinfo  | wc -l`");
> >  	cpus = WEXITSTATUS(cpus);
> >  
> >  	if (argc > 2) {
> > 
> > 
> > 
> > 
> > With any optimizations, -O or -O1 or -O2 I don't get any status
> > output, with -O0 I get,
> > 
> > ./time-warp-test 
> > 1 CPUs, running 1 parallel test-tasks.
> > checking for time-warps via:
> > - read time stamp counter (RDTSC) instruction (cycle resolution)
> > 
> >  | TSC: 0.82us, fail:0 /
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
