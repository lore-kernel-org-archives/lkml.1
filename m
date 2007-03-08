Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXCHOxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXCHOxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXCHOxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:53:00 -0500
Received: from mail10.syd.optusnet.com.au ([211.29.132.191]:53087 "EHLO
	mail10.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbXCHOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:52:59 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc3-mm2
Date: Fri, 9 Mar 2007 01:52:49 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org>
In-Reply-To: <20070307201915.4d579113.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1737
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703090152.49253.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 15:19, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.
>6.21-rc3-mm2/
>
> - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
>   were dropped.

As for benchmarking between them I haven't seen anyone post anything yet. 
Test.kernel.org is having a field day with both of them ABORTing or WARNing 
without one GOOD so far. Urgh what was the description you gave of -mm to 
Gene?...I don't envy you :(

Apart from your big fat oops on that massive config, I've had people boot it 
also on alpha and IA64. The bitmap error also manifested on alpha but not on 
IA64 (neither oopsed).


So on qemu I can reproduce the oops you're getting with your config (make 
oldconfig all default on top of your config), but I'm getting other wonderful 
related problems too on rc3-mm2. On qemu -mm1 boots mostly without error and 
then crashes nicely when I type 'ps' with a long pause for about twenty 
seconds and then a combination of soft lockups, bitmap errors, and eventually 
hits the BUG_ON I put in bitmap_error(). However, -mm2 also vomits on 
typing 'ps'. 

It pauses and then spits out (fun lines selected from ps output):

    7 ?        serial8250: too much work for irq4
00:00:00 watchdog/1
   88 ?        00:00:0serial8250: too much work for irq4
0 cqueue/1
  137 ?        00:00serial8250: too much work for irq4
:00 aio/0

Checking a few /proc files I see that "serial83250" info littered 
throughout /proc/stat as well. -mm2 does not oops but the proc output is 
variously corrupted.

Interestingly if I don't type 'ps' in the -mm1 qemu it runs fine with no sign 
of a bug... In summary, here I can only reproduce your big fat oops by it 
being triggered by some corruption elsewhere on this config related to /proc 
breakage that I haven't managed to track down. I checked the broken-out 
patches to see which touched /proc and it was oh, most of them. I tried on rc3 
and had the same thing happen. I haven't tried rc3 without rsdl (your config 
takes too darn long to build!).


The bitmap error that you're hitting on ppc I believe is a different issue. I 
don't have hardware that does it at my end but one user has hit it also on 
alpha and is trying to help me find the root cause. If we change it from 
being a once only printk to every time, it seems to go away after 10 mins of 
runtime never to return again. What could possibly change over that time for 
the error never to return again is a mystery. This part definitely looks to 
be my fault but a bug "getting better and going away" is a new one for me. I 
have to think about some timer interaction although I don't use jiffies or 
timers directly at all in my code. It also happens on 2.6.20 with RSDL.


Summary from what I've been able to find:
x86_32: ok
x86_64: ok
x86_64 fat config: scheduler code oops brought on by accessing /proc
IA64 ok: ok
Alpha: bitmap error, runs ok


I'm off to pass out for now so that I'm of some use to the rest of my 
existence tomorrow.

-- 
-ck
