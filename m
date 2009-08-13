Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZHMPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZHMPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZHMPth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:49:37 -0400
Received: from smtp-4.hut.fi ([130.233.228.94]:40190 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZHMPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:49:37 -0400
X-Greylist: delayed 1020 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 11:49:36 EDT
Date: Thu, 13 Aug 2009 18:32:11 +0300 (EEST)
From: Jan Wagner <jwagner@kurp.hut.fi>
X-X-Sender: jwagner@orbit.lan
To: linux-kernel@vger.kernel.org
Subject: 32-bit sys/times.h incorrect return value (fwd)
Message-ID: <alpine.DEB.2.00.0908131831580.28962@orbit.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we see times() return a really large positive value like 0x66693CF1 i.e. 
signed int32 +1718172913 just a few minutes after booting.

Note that clock_gettime(CLOCK_MONOTONIC) works correctly and returns the 
uptime. While times() +1718172913/100Hz time is in no relation to uptime.

Checking 'man 2 times': "Since Linux 2.6, this point is (2^32/HZ) - 300 (i.e., 
about 429 million) seconds before system boot time. [...] the returned value 
may overflow the range of clock_t [...]"

Hence in theory on a 32-bit platform where clock_t is signed 32-bit, at first 
times() should return negative values.

Then 300 seconds later they should become positive. Correct?

This should also happen via glibc times() call. There the times()
   ./sysdeps/unix/sysv/linux/times.c
simply does
   clock_t ret = INTERNAL_SYSCALL (times, err, 1, buf);
with no extra "+- some constant".

In the kernel all jiffies and times syscall related handling is 64-bit:

---------
amn@multics:/home/etu/Desktop/linux-2.6.30.3/include$ fgrep INITIAL_JIFFIES
linux/jiffies.h:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) 
(-300*HZ))

kernel/sys.c:   return (long) jiffies_64_to_clock_t(get_jiffies_64());

kernel/time.c:u64 get_jiffies_64(void)
kernel/time.c:          ret = jiffies_64;
---------

On 32-bit platforms and signed int32 clock_t it should take at least

octave:1>  2^31/(24*60*60 * 100)
ans =  248.55
octave:2>  (2^31/100 - 300)/(24*60*60)
ans =  248.55

days until the positive times() return value wraps back to smallest negative 
signed 32-bit int.

However, two bugs(?) :

1) times() return value after 1080 'uptime' seconds is 0x66693CF1, why?

Expected value would be (1080-300)*100Hz = 78000 = 0x000130B0 !

2) the times() wraps to negative only after 50 days uptime. Following the 
intention of INITIAL_JIFFIES, how is this 50-day warp supposed to reveal 
wrapping bugs right at 300 seconds after boot?

2) on 64-bit platforms, clock_t is 64-bit. There times() does not wrap after 50 
days, however it still starts at 0x000000006669**** !?


Any ideas?

  - Jan
