Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYDCK5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYDCK5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYDCK5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:57:11 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:2223 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbYDCK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:57:10 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 06:57:10 EDT
Message-ID: <47F4C3C2.8030004@superbug.co.uk>
Date: Thu, 03 Apr 2008 12:47:14 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tim Ricketts <tr@earth.li>, Michael Smith <msmith@xiph.org>,
       linux-kernel@vger.kernel.org, Andy Wingo <wingo@fluendo.com>,
       tglx@linutronix.de
Subject: Re: gettimeofday() jumping into the future
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>	<Pine.LNX.4.64.0803302210060.3056@falcon.foo> <87r6dr8iq3.fsf@basil.nowhere.org>
In-Reply-To: <87r6dr8iq3.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On Thu, 23 Aug 2007, Michael Smith wrote:
>>
>>     
> [...]
>   
>> +static inline u64 __get_nsec_offset(void)
>>   {
>>   	cycle_t cycle_now, cycle_delta;
>> -	s64 ns_offset;
>> +	u64 ns_offset;
>>
>>   	/* read clocksource: */
>>   	cycle_now = clocksource_read(clock);
>>
>> +	if (cycle_now < clock->cycle_last)
>> +		return 0;
>>     


That does not work as cycle_now can go backwards as well as wrap around.
The only way to catch all edge cases is to be able to make an assumption
on the maximum acceptable difference between cycle_now and cycle_last,
where difference is the shortest distance between values if they were
pointers into a ring buffer. If this maximum difference value is less
than half of the max value cycle_now can have, one can take a very
simple approach.
Treat the cycle_now, cycle_last value as signed.
If they have same sign, do the comparison as unsigned.
If they have different signs, do the comparision as signed.

James


