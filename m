Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZBWXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZBWXYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZBWXYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:24:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42274 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZBWXYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:24:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Fries <david@fries.net>
Subject: Re: TSC marked unstable on suspend and resume
Date: Tue, 24 Feb 2009 00:23:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090221023943.GA4894@spacedout.fries.net>
In-Reply-To: <20090221023943.GA4894@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240023.52166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, David Fries wrote:
> I'm getting TSC marked as unsable on hibernate to disk with
> 2.6.29-rc3.  The last kernel I ran 2.6.24.4 ran 300+ days without a
> problem and does not loose TSC on hibernate.

Ingo, Andrew, can you please tell us who's the right person to look into this
problem?

> I'm hibernating with `echo disk > /sys/power/state`.
> These look like the relavant messages,
> 
> CPU 0 irqstacks, hard=c0379000 soft=c0378000
> PID hash table entries: 1024 (order: 10, 4096 bytes)
> Fast TSC calibration using PIT
> Detected 300.705 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 601.41 BogoMIPS (lpj=300705)
> hibernate to disk,
> Restarting tasks ... done.
> Clocksource tsc unstable (delta = 499883531 ns)
> 
> another reboot,
> Restarting tasks ... done.
> Clocksource tsc unstable (delta = 499883531 ns)
> 
> another reboot,
> Freezing user space processes ... (elapsed 0.07 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> PM: Shrinking memory...  ^H-<4>Clocksource tsc unstable (delta = 78961880 ns)
> ^H\^H|^H/^Hdone (34745 pages freed)
> 
> 
> 
> I didn't spot the problem until I raw the HP48 calculator emulator x48
> and it was running like a dog, but the same binary ran fine on my
> other systems.  It was looping on gettimeofday intending to delay 2us,
> but was getting 1ms when TSC wasn't available.
> 
> On Thu, Feb 05, 2009 at 10:02:39PM +0100, Ingo Molnar wrote:
> > What does this tool output:
> > 
> >  http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
> 
> time-warp-test is getting the number of CPUs wrong here, trivial
> patch included.
> 
> ./time-warp-test  
> 2 CPUs, running 2 parallel test-tasks.
> 
> grep processor /proc/cpuinfo
> processor       : 0
> model name      : AMD-K6(tm) 3D processor
> 
> 
> --- time-warp-test.c.orig	2009-02-19 20:52:40.000000000 -0600
> +++ time-warp-test.c	2009-02-19 21:32:58.000000000 -0600
> @@ -295,7 +295,7 @@ int main(int argc, char **argv)
>  	unsigned long *shared;
>  	unsigned long cpus, tasks;
>  
> -	cpus = system("exit `grep processor /proc/cpuinfo  | wc -l`");
> +	cpus = system("exit `grep ^processor /proc/cpuinfo  | wc -l`");
>  	cpus = WEXITSTATUS(cpus);
>  
>  	if (argc > 2) {
> 
> 
> 
> 
> With any optimizations, -O or -O1 or -O2 I don't get any status
> output, with -O0 I get,
> 
> ./time-warp-test 
> 1 CPUs, running 1 parallel test-tasks.
> checking for time-warps via:
> - read time stamp counter (RDTSC) instruction (cycle resolution)
> 
>  | TSC: 0.82us, fail:0 /
