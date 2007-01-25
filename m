Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXAYWTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXAYWTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030629AbXAYWTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:19:14 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49272 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030628AbXAYWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:19:13 -0500
Subject: Re: One-shot high-resolution POSIX timer periodically late
From: john stultz <johnstul@us.ibm.com>
To: John <shill@free.fr>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com, mingo@elte.hu,
       akpm@osdl.org
In-Reply-To: <45B87F9A.9060201@free.fr>
References: <fa.NwnlFyMPfa3XG6my3HKGWnCW3x4@ifi.uio.no>
	 <fa.Ji4GnAbBF2FR5JbSxvxn2haJZIk@ifi.uio.no>  <45B87F9A.9060201@free.fr>
Content-Type: text/plain; charset=utf-8
Date: Thu, 25 Jan 2007 14:19:03 -0800
Message-Id: <1169763543.5396.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 10:59 +0100, John wrote:
> John Stultz wrote:
> > On Wed, 2007-01-24 at 10:41 +0100, John wrote:
> >> As you can see, the first diagnostic came at 472.410501014... Then
> >> another diagnostic almost exactly two seconds apart 9 times in a row!
> >>
> >> My process is the only SCHED_FIFO process on the system. There are no
> >> user-space processes with a higher priority. AFAICT, only a kernel
> >> thread could keep the CPU away from my app.
> >>
> >> Is there a periodic kernel thread that runs every 2 seconds, cannot be
> >> preempted, and runs for over 50 µs??
> > 
> > This sounds like a BIOS SMI issue. Can you reproduce this behavior on
> > different hardware?
[snip]
> Do PCs typically enter System Management Mode periodically?

Completely depends on the system hardware and BIOS.

> Is it possible to disable SMM?

Not usually. Sometimes some SMIs can be disabled via BIOS options.

> According to the Wikipedia article, even the kernel is unaware that
> the CPU has entered SMM, is that correct?

Yes. The kernel has no notification that the SMI occurred.

> I've run my tests on a Dell PC. IIRC, the BIOS options are very basic.
> 
> I'll also try another PC as you suggest.

Also do check the -rt tree as Ingo suggested. I mis-read your earlier
email and thought you were running it.


> +++++
> 
> On a related note, John, AFAIU, you wrote the GTOD infrastructure. In my 
> app, I need to call clock_gettime(CLOCK_MONOTONIC, ...) very often, i.e. 
> around 2000 times every second (when I receive a packet, and when I 
> re-send a packet). Is there a way to improve the overhead / latency of 
> these calls? I've heard about vsyscalls, are they relevant?
> 
> Do I need a specific glibc to use vsyscalls?

vsyscalls are only supported on x86_64/powerpc (I think) right now.
glibc support is necessary, and right now its only for gettimeofday()
not clock_gettime().

> If I call clock_gettime(CLOCK_MONOTONIC, &spec) twice in a row, then 
> subtract the two timespecs, I get ~1400 ns on a 2.8 GHz P4. AFAIU, my 
> clock source is acpi_pm. I tried setting it to tsc but it made hell 
> break loose.
> 
> http://groups.google.com/group/fa.linux.kernel/msg/a095241d49adfc44?dmode=source
> 
> Apparently, 1400 ns is similar to what you observe with acpi_pm.
> I suppose I'll need to use the TSC if I want any improvement?

Yea, unfortunately the ACPI PM is much slower then the TSC.
However, the TSC is often unstable, so you might not be able to utilize
it.

You can play around w/ the "idle=poll" boot option to see if that allows
you to use it, but that will up your power usage and has possible
thermal risks.

thanks
-john


