Return-Path: <linux-kernel-owner+w=401wt.eu-S1765536AbYBMEL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765536AbYBMEL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbYBMELs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:11:48 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36049 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753005AbYBMELr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:11:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YCLcurPp16B4xkR+gRrBXgKM+Vjek73qKeCRbT19IK/8WLEHhCvhLeX4GstbyDYO5V98FXH95oAKMFB6mHgI2zltJZZ4s5b5r0FGzwKS5+tFQY4F4c5d1fPEODlSkof20V33MhtAkHi9YaDUHjGEqgZcPbS8zzXzFtGugBDmBiM=  ;
X-YMail-OSG: Y9Vr8RUVM1ltIM79o6hFsFVHTLXyD_zmEJ8VPFxXDik08sZC5J_4ThrjnrBc.ANd91ToXRWi4Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
Date: Wed, 13 Feb 2008 15:11:28 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl, gregkh@suse.de,
       rusty@rustcorp.com.au
References: <47B11C45.6060408@qualcomm.com> <20080211.224436.174153780.davem@davemloft.net> <47B264E3.4090605@qualcomm.com>
In-Reply-To: <47B264E3.4090605@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131511.28643.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 14:32, Max Krasnyansky wrote:
> David Miller wrote:
> > From: Nick Piggin <nickpiggin@yahoo.com.au>
> > Date: Tue, 12 Feb 2008 17:41:21 +1100
> >
> >> stop machine is used for more than just module loading and unloading.
> >> I don't think you can just disable it.
> >
> > Right, in particular it is used for CPU hotplug.
>
> Ooops. Totally missed that. And a bunch of other places.
>
> [maxk@duo2 cpuisol-2.6.git]$ git grep -l stop_machine_run
> Documentation/cpu-hotplug.txt
> arch/s390/kernel/kprobes.c
> drivers/char/hw_random/intel-rng.c
> include/linux/stop_machine.h
> kernel/cpu.c
> kernel/module.c
> kernel/stop_machine.c
> mm/page_alloc.c
>
> I wonder why I did not see any issues when I disabled stop machine
> completely. I mentioned in the other thread that I commented out the part
> that actually halts the machine and ran it for several hours on my dual
> core laptop and on the quad core server. Tried all kinds of workloads,
> which include constant module removal and insertion, and cpu hotplug as
> well. It cannot be just luck :).

It really is. With subtle races, it can take a lot more than a few
hours. Consider that we have subtle races still in the kernel now,
which are almost never or rarely hit in maybe 10,000 hours * every
single person who has been using the current kernel for the past
year.

For a less theoretical example -- when I was writing the RCU radix
tree code, I tried to run directed stress tests on a 64 CPU Altix
machine (which found no bugs). Then I ran it on a dedicated test
harness that could actually do a lot more than the existing kernel
users are able to, and promptly found a couple more bugs (on a 2
CPU system).

But your primary defence against concurrency bugs _has_ to be
knowing the code and all its interactions.


> Clearly though, you guys are right. It cannot be simply disabled. Based on
> the above grep it's needed for CPU hotplug, mem hotplug, kprobes on s390
> and intel rng driver. Hopefully we can avoid it at least in module
> insertion/removal.

Yes, reducing the number of users by going through their code and
showing that it is safe, is the right way to do this. Also, you
could avoid module insertion/removal?

FWIW, I think the idea of trying to turn Linux into giving hard
realtime guarantees is just insane. If that is what you want, you
would IMO be much better off to spend effort with something like
improving adeos and communicatoin/administration between Linux and
the hard-rt kernel.

But don't let me dissuade you from making these good improvements
to Linux as well :) Just that it isn't really going to be hard-rt
in general.
