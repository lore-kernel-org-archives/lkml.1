Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbXG1Ve1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbXG1Ve1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 17:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbXG1VeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 17:34:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbXG1VeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 17:34:20 -0400
Date: Sat, 28 Jul 2007 14:33:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707281222410.3442@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707281417201.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <1185615848.13701.16.camel@localhost> <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707282054330.15125@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0707281222410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Linus Torvalds wrote:
> 
> Yes, it's what "/proc/sys/kernel/sched_granularity_ns" is supposed to 
> tweak, but maybe there's some misfeature there, or maybe the default is 
> just bad for games, or whatever.
> 
> Ingo: that sysctl_sched_granularity initialization doesn't make sense. You 
> talk about it being in units of nanoseconds, but then you do
> 
> 	2000000000ULL/HZ
> 
> which is nonsensical.

Btw, people who actually have 3D games installed (I have exactly one: 
ppracer, and I can't really say that I care about how it feels), if you 
don't have CONFIG_HZ=1000, this really is worth testing.

I think Ingo probably ran with CONFIG_NO_HZ and HZ_1000, but the default 
timer tick is actually 250Hz, which makes all the default scheduler values 
come out four times bigger than they are documented/supposed to be.

On SMP, that scheduler granularity then gets doubled once more if you have 
two CPU's, so rather than 2ms by default, it ends up being 16ns (and the 
time slices themselves end up being bigger than that). 

So doing some testing with a simple

	echo 2000000 > /proc/sys/kernel/sched_granularity_ns
	echo 1000000 > /proc/sys/kernel/sched_batch_wakeup_granularity_ns
	echo 8000000 > /proc/sys/kernel/sched_runtime_limit_ns

might be worth doing (and if you vary numbers to see if it matters, 
please do let people know!)

		Linus
