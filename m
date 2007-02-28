Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXB1LXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXB1LXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXB1LXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:23:31 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:37944 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbXB1LXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:23:30 -0500
Message-ID: <45E56626.3020107@free.fr>
Date: Wed, 28 Feb 2007 12:23:18 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@suse.de>, johnstul@us.ibm.com, mingo@elte.hu,
       zippel@linux-m68k.org, tglx@timesys.com, akpm@linux-foundation.org,
       jbohac@suse.cz, linux.kernel@free.fr
Subject: Re: CLOCK_MONOTONIC datagram timestamps by the kernel
References: <45E1FFCC.50201@free.fr> <45E2B5E4.7020208@free.fr> <200702261320.57726.ak@suse.de> <45E2EBE4.7080202@free.fr>
In-Reply-To: <45E2EBE4.7080202@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John wrote:

> Andi Kleen wrote:
> 
>> John wrote:
>>
>>> My app expects a stream of UDP datagrams containing compressed video.
>>> These datagrams have been time stamped by the source using a high
>>> resolution clock.
>>
>> Why do you need another time stamp then?
> 
> Source and receiver do not share a common clock. Thus, I have to monitor
> clock skew. If I simply use the time stamps produced by the source, my
> buffer will eventually underflow or overflow.
> 
> As far as I have seen, clock skew is on the order of ±10^-5, i.e. when
> the source thinks 100000 seconds have elapsed, the receiver thinks
> 100001 seconds have elapsed.

I've considered running NTP to synchronize the clocks, but I'm afraid it 
wouldn't help, for several reasons:

1) The 40.5 MHz clock used to timestamp datagrams at the source is 
located on a PCI board. I have read access to a 32-bit counter that is 
incremented every cycle (somewhat like the TSC on x86).

2) Source and receiver are inside a VPN, and do not have access to the 
Internet. I don't think I can keep NTP happy if it can't talk to any NTP 
servers.

(I'm not snipping the rest of the message in case someone is willing
to comment.)

>>> The video stream is played out in real-time. I buffer several packets,
>>> then repeatedly arm a one-shot timer (with TIMER_ABSTIME set) to wait
>>> until it's time to send the oldest packet.
>>>
>>> AFAIU, if I use the CLOCK_REALTIME clock in my app, and if the 
>>> sysadmin changes the date, hell will break loose in my app.
>>
>> Only if your app cannot handle time going backwards.
> 
> My app cannot handle time going backwards.
> 
> The algorithm looks like:
> 
> /* Start transmission, record start date */
> NEXT_DEADLINE = now;
> 
> while ( 1 )
> {
>   send(oldest_packet);
>   recv_available_packets();
>   /* compute next deadline */
>   NEXT_DEADLINE += time_to_wait_until_next_packet();
>   sleep_until(NEXT_DEADLINE);
> }
> 
> If the clock changes under me, I'm toast.
> 
>>> I suppose that if I change sock_get_timestamp() in core/sock.c to
>>> call __get_realtime_clock_ts() instead of do_gettimeofday() I'll
>>> break 50 billion applications (ping? traceroute?) that expect a
>>> struct timeval?
>>
>> Not that many, but some probably.
> 
> Another option would be to change sock_get_timestamp() to call
> ktime_get_ts() instead of do_gettimeofday() and convert ns to us.
> 
> i.e. I still return a struct timeval, but using CLOCK_MONOTONIC.
> 
>> Letting the kernel do the time stamping is usually quite useless
>> anyways. You can as well do it in your application when you receive
>> it. After all you're interested in when you can read the packet in
>> your app, not when the driver processes it.
> 
> I use clock_nanosleep() to sleep until it's time to send the next
> packet. I check for packets when I wake up. I need the kernel to time
> stamp the packets because I was sleeping when they reached the system.
> 
> I try to do it this way because I read this:
> 
> http://rt.wiki.kernel.org/index.php/High_resolution_timers
> 
> "Note that (clock_)nanosleep functions do not suffer from this problem
> as the wakeup function at timer expiry is executed in the context of the
> high resolution timer interrupt. If an application is not using
> asynchronous signal handlers, it is recommended to use the
> clock_nanosleep() function with the TIMER_ABSTIME flag set instead of
> waiting for the periodic timer signal delivery. The application has to
> maintain the absolute expiry time for the next interval itself, but this
> is a lightweight operation of adding and normalizing two struct timespec
> values. The benefit is significantly lower maximum latencies (~50us) and
> less OS overhead in general."

