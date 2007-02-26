Return-Path: <linux-kernel-owner+w=401wt.eu-S1751199AbXBZK0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbXBZK0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXBZK0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:26:31 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:33340 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbXBZK0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:26:30 -0500
Message-ID: <45E2B5E4.7020208@free.fr>
Date: Mon, 26 Feb 2007 11:26:44 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org,
       tglx@timesys.com, akpm@linux-foundation.org, ak@suse.de, jbohac@suse.cz,
       linux.kernel@free.fr
Subject: Re: CLOCK_MONOTONIC datagram timestamps by the kernel
References: <45E1FFCC.50201@free.fr>
In-Reply-To: <45E1FFCC.50201@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John wrote:

> It is possible to ask Linux to timestamp incoming datagrams when they
> are received, then to retrieve this timestamp with an ioctl command or
> a recvmsg call (which would save one round trip to kernel space).
> 
> SIOCGSTAMP
>     Return a struct timeval with the receive timestamp of the last
> packet passed to the user. This is useful for accurate round trip time
> measurements. See setitimer(2) for a description of struct timeval.
> 
> As far as I understand, this timestamp is given by the CLOCK_REALTIME
> clock. I would like to get the timestamp given by a different clock:
> the CLOCK_MONOTONIC clock.
> 
> In other words, I would like the kernel to do the equivalent of
> 
>   struct timespec spec;
>   clock_gettime(CLOCK_MONOTONIC, &spec)
> 
> for each datagram the system receives, as soon as it is received.
> 
> Is there a way to achieve that?
> 
> Is there a different ioctl perhaps? (I don't think so.)

I've been reading the following documents:

Clocks and Timers
http://www.opengroup.org/onlinepubs/009695399/xrat/xsh_chap02.html#tag_03_02_08_18

Rationale for the Monotonic Clock
http://www.opengroup.org/onlinepubs/009695399/xrat/xsh_chap02.html#tag_03_02_08_19

"For those applications that use time services to achieve realtime 
behavior, changing the value of the clock on which these services rely 
may cause erroneous timing behavior. For these applications, it is 
necessary to have a monotonic clock which cannot run backwards, and 
which has a maximum clock jump that is required to be documented by the 
implementation. Additionally, it is desirable (but not required by IEEE 
Std 1003.1-2001) that the monotonic clock increases its value uniformly. 
This clock should not be affected by changes to the system time; for 
example, to synchronize the clock with an external source or to account 
for leap seconds. Such changes would cause errors in the measurement of 
time intervals for those time services that use the absolute value of 
the clock."

clock and timer functions
http://www.opengroup.org/onlinepubs/009695399/functions/clock_settime.html

"If the value of the CLOCK_REALTIME clock is set via clock_settime(), 
the new value of the clock shall be used to determine the time of 
expiration for absolute time services based upon the CLOCK_REALTIME 
clock. This applies to the time at which armed absolute timers expire. 
If the absolute time requested at the invocation of such a time service 
is before the new value of the clock, the time service shall expire 
immediately as if the clock had reached the requested time normally."

"The effect of setting a clock via clock_settime() on armed per-process 
timers associated with a clock other than CLOCK_REALTIME is 
implementation-defined."


Here's some background on what I'm trying to do:

My app expects a stream of UDP datagrams containing compressed video.
These datagrams have been time stamped by the source using a high 
resolution clock.

The video stream is played out in real-time. I buffer several packets, 
then repeatedly arm a one-shot timer (with TIMER_ABSTIME set) to wait 
until it's time to send the oldest packet.

AFAIU, if I use the CLOCK_REALTIME clock in my app, and if the sysadmin 
changes the date, hell will break loose in my app. Hence my need for 
CLOCK_MONOTONIC.


On a related note, I see that do_gettimeofday() in kernel/timer.c 
actually gets a struct timespec from __get_realtime_clock_ts() then 
throws bits away in the ns to us conversion. The integer division is 
also a waste of cycles in my case, as I want the result in ns.

I suppose that if I change sock_get_timestamp() in core/sock.c to call 
__get_realtime_clock_ts() instead of do_gettimeofday() I'll break 50 
billion applications (ping? traceroute?) that expect a struct timeval?

Anyway, thanks for reading this far.

Regards.
