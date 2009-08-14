Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZHNJAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZHNJAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZHNJAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:00:06 -0400
Received: from leia.mcbone.net ([194.97.104.42]:54702 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbZHNJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:00:04 -0400
Subject: Re: 32-bit sys/times.h incorrect return value (fwd)
From: Jens Rosenboom <jens@mcbone.net>
To: Jan Wagner <jwagner@kurp.hut.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1250238987.16632.34.camel@fnki-nb00130>
References: <alpine.DEB.2.00.0908131831580.28962@orbit.lan>
	 <1250238987.16632.34.camel@fnki-nb00130>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 10:59:57 +0200
Message-Id: <1250240397.16632.37.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 10:36 +0200, Jens Rosenboom wrote:
> On Thu, 2009-08-13 at 18:32 +0300, Jan Wagner wrote: 
> > Hi,
> > 
> > we see times() return a really large positive value like 0x66693CF1 i.e. 
> > signed int32 +1718172913 just a few minutes after booting.
> > 
> > Note that clock_gettime(CLOCK_MONOTONIC) works correctly and returns the 
> > uptime. While times() +1718172913/100Hz time is in no relation to uptime.
> > 
> > Checking 'man 2 times': "Since Linux 2.6, this point is (2^32/HZ) - 300 (i.e., 
> > about 429 million) seconds before system boot time. [...] the returned value 
> > may overflow the range of clock_t [...]"
> > 
> > Hence in theory on a 32-bit platform where clock_t is signed 32-bit, at first 
> > times() should return negative values.
> > 
> > Then 300 seconds later they should become positive. Correct?
> > 
> > This should also happen via glibc times() call. There the times()
> >    ./sysdeps/unix/sysv/linux/times.c
> > simply does
> >    clock_t ret = INTERNAL_SYSCALL (times, err, 1, buf);
> > with no extra "+- some constant".
> > 
> > In the kernel all jiffies and times syscall related handling is 64-bit:
> > 
> > ---------
> > amn@multics:/home/etu/Desktop/linux-2.6.30.3/include$ fgrep INITIAL_JIFFIES
> > linux/jiffies.h:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) 
> > (-300*HZ))
> > 
> > kernel/sys.c:   return (long) jiffies_64_to_clock_t(get_jiffies_64());
> > 
> > kernel/time.c:u64 get_jiffies_64(void)
> > kernel/time.c:          ret = jiffies_64;
> > ---------
> > 
> > On 32-bit platforms and signed int32 clock_t it should take at least
> > 
> > octave:1>  2^31/(24*60*60 * 100)
> > ans =  248.55
> > octave:2>  (2^31/100 - 300)/(24*60*60)
> > ans =  248.55
> > 
> > days until the positive times() return value wraps back to smallest negative 
> > signed 32-bit int.
> > 
> > However, two bugs(?) :
> > 
> > 1) times() return value after 1080 'uptime' seconds is 0x66693CF1, why?
> > 
> > Expected value would be (1080-300)*100Hz = 78000 = 0x000130B0 !
> > 
> > 2) the times() wraps to negative only after 50 days uptime. Following the 
> > intention of INITIAL_JIFFIES, how is this 50-day warp supposed to reveal 
> > wrapping bugs right at 300 seconds after boot?
> > 
> > 2) on 64-bit platforms, clock_t is 64-bit. There times() does not wrap after 50 
> > days, however it still starts at 0x000000006669**** !?
> 
> 1718172913 * 2.5 is pretty close to 2^32, so I assume that you have
> CONFIG_HZ=250. With CONFIG_HZ=300 I am getting something like 1431542881
> instead which is close to 2^32/3. I'm not sure though where the wrong
> initial value comes from, maybe the INITIAL_JIFFIES definition uses the
> wrong HZ value.

On second though, there isn't any bug here at all, times() returns
jiffies converted to USER_HZ, so this can wrap at completely different
times than the 32-bit jiffies value itself.

