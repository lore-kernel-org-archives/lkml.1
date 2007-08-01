Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbXHAJVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbXHAJVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXHAJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:21:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:32881 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbXHAJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:21:36 -0400
Date: Wed, 1 Aug 2007 11:21:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707281222410.3442@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708011111030.26668@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <1185615848.13701.16.camel@localhost> <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707282054330.15125@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0707281222410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 28 2007 12:34, Linus Torvalds wrote:
>On Sat, 28 Jul 2007, Jan Engelhardt wrote:
>> 
>> Time to investigate...

Well it really is different.

Simple test:
- run Unreal Tournament 99 (nice 0, it gets 98%,99% CPU most of the time)
- in a shell, `renice 20 $$; while :; do date; done;`

The shell only produces one or two outputs per second.
This seems different from the old-2.6 behavior, where a nice-20
process seemed to get a bit more share. (Due to interactivity bonus)


Does anyone have a cpu hog test program that spreads its cpu time
over the second rather than doing 300 ms wake and 700 ms sleep cycles
after another?

>Well, one thing that would be worth doing is to simply create a trace of 
>time-slices for both schedulers.
>
>It could easily be some hacky thing that just saves the process name and 
>TSC at each scheduling event in some fairly small fixed-sized per-CPU 
>circular buffer, and have a /sys interface that reads it out, and then you 
>do
>
>	sleep 60 ; cat /sys/cpubuffer > buffer
>
>and play the game for 60 seconds (so that you get a buffer that represents 
>perhaps the last 10 seconds of play).

Send me patches, I run the test.

>It could *literally* just be an effect of the time quanta used, and CFS 
>just deciding that it's not interactive and giving things too long of a 
>CPU slice.
>
>Yes, it's what "/proc/sys/kernel/sched_granularity_ns" is supposed to 
>tweak, but maybe there's some misfeature there, or maybe the default is 
>just bad for games, or whatever.
>
>Ingo: that sysctl_sched_granularity initialization doesn't make sense. You 
>talk about it being in units of nanoseconds, but then you do
>
>	2000000000ULL/HZ
>
>which is nonsensical. That value is "2 seconds" (not 2ms like the comment 
>says) in nanoseconds, but then divided by HZ, so what's the meaning of 
>that HZ thing? Nothing in the scheduler should care about jiffies, why is 
>that related to HZ? All the scheduler clocks are in ns.
>
>			Linus
>

	Jan
-- 
