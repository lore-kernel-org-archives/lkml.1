Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXLFTwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXLFTwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXLFTwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:52:01 -0500
Received: from mail.tmr.com ([64.65.253.246]:43867 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbXLFTwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:52:00 -0500
Message-ID: <475856BE.4050207@tmr.com>
Date: Thu, 06 Dec 2007 15:08:30 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204180158.GT19691@waste.org>
In-Reply-To: <20071204180158.GT19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Dec 04, 2007 at 08:54:52AM -0800, Ray Lee wrote:
>> (Why hasn't anyone been cc:ing Matt on this?)
>>
>> On Dec 4, 2007 8:18 AM, Adrian Bunk <bunk@kernel.org> wrote:
>>> On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
>>>
>>>> While debugging Exim4's GnuTLS interface, I recently found out that
>>>> reading from /dev/urandom depletes entropy as much as reading from
>>>> /dev/random would. This has somehow surprised me since I have always
>>>> believed that /dev/urandom has lower quality entropy than /dev/random,
>>>> but lots of it.
>>> man 4 random
>>>
>>>> This also means that I can "sabotage" applications reading from
>>>> /dev/random just by continuously reading from /dev/urandom, even not
>>>> meaning to do any harm.
>>>>
>>>> Before I file a bug on bugzilla,
>>>> ...
>>> The bug would be closed as invalid.
>>>
>>> No matter what you consider as being better, changing a 12 years old and
>>> widely used userspace interface like /dev/urandom is simply not an
>>> option.
>> You seem to be confused. He's not talking about changing any userspace
>> interface, merely how the /dev/urandom data is generated.
>>
>> For Matt's benefit, part of the original posting:
>>
>>> Before I file a bug on bugzilla, can I ask why /dev/urandom wasn't
>>> implemented as a PRNG which is periodically (say, every 1024 bytes or
>>> even more) seeded from /dev/random? That way, /dev/random has a much
>>> higher chance of holding enough entropy for applications that really
>>> need "good" entropy.
>> A PRNG is clearly unacceptable. But roughly restated, why not have
>> /dev/urandom supply merely cryptographically strong random numbers,
>> rather than a mix between the 'true' random of /dev/random down to the
>> cryptographically strong stream it'll provide when /dev/random is
>> tapped? In principle, this'd leave more entropy available for
>> applications that really need it, especially on platforms that don't
>> generate a lot of entropy in the first place (servers).
> 
> The original /dev/urandom behavior was to use all the entropy that was
> available, and then degrade into a pure PRNG when it was gone. The
> intent is for /dev/urandom to be precisely as strong as /dev/random
> when entropy is readily available.
> 
> The current behavior is to deplete the pool when there is a large
> amount of entropy, but to always leave enough entropy for /dev/random
> to be read. This means we never completely starve the /dev/random
> side. The default amount is twice the read wakeup threshold (128
> bits), settable in /proc/sys/kernel/random/.
> 
In another post I suggested having a minimum bound (use not entropy) and 
a maximum bound (grab some entropy) with the idea that between these 
values some limited entropy could be used. I have to wonder if the 
entropy available is at least as unpredictable as the entropy itself.

> But there's really not much point in changing this threshold. If
> you're reading the /dev/random side at the same rate or more often
> that entropy is appearing, you'll run out regardless of how big your
> buffer is.
> 
Right, my thought is to throttle user + urandom use such that the total 
stays below the available entropy. I had forgotten that that was a lower 
bound, although it's kind of an on-off toggle rather than proportional. 
Clearly if you care about this a *lot* you will use a hardware RNG.

Thanks for the reminder on read_wakeup.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
