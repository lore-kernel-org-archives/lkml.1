Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYA1JBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYA1JBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYA1JBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:01:24 -0500
Received: from kunder.interhost.no ([80.239.54.98]:42682 "EHLO
	kunder.interhost.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYA1JBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:01:22 -0500
Message-ID: <479D9A0D.2060606@sannes.org>
Date: Mon, 28 Jan 2008 10:02:05 +0100
From: =?UTF-8?B?QXNiasO4cm4gU2FubmVz?= <ace@sannes.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071217)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unpredictable performance
References: <4799C8E8.9060501@ifi.uio.no>	 <2c0942db0801250916v6b1f988fre454dd7e33d7985@mail.gmail.com>	 <479A4B6E.9070607@sannes.org> <2c0942db0801251332k43e0b7d5xa012227f19ac4983@mail.gmail.com>
In-Reply-To: <2c0942db0801251332k43e0b7d5xa012227f19ac4983@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Jan 25, 2008 12:49 PM, Asbjørn Sannes <ace@sannes.org> wrote:
>   
>> Ray Lee wrote:
>>     
>>> On Jan 25, 2008 3:32 AM, Asbjorn Sannes <asbjorsa@ifi.uio.no> wrote:
>>>
>>>       
>>>> Hi,
>>>>
>>>> I am experiencing unpredictable results with the following test
>>>> without other processes running (exception is udev, I believe):
>>>> cd /usr/src/test
>>>> tar -jxf ../linux-2.6.22.12
>>>> cp ../working-config linux-2.6.22.12/.config
>>>> cd linux-2.6.22.12
>>>> make oldconfig
>>>> time make -j3 > /dev/null # This is what I note down as a "test" result
>>>> cd /usr/src ; umount /usr/src/test ; mkfs.ext3 /dev/cc/test
>>>> and then reboot
>>>>
>>>> The kernel is booted with the parameter mem=81920000
>>>>
>>>> For 2.6.23.14 the results vary from (real time) 33m30.551s to 45m32.703s
>>>> (30 runs)
>>>> For 2.6.23.14 with nop i/o scheduler from 29m8.827s to 55m36.744s (24 runs)
>>>> For 2.6.22.14 also varied a lot.. but, lost results :(
>>>> For 2.6.20.21 only vary from 34m32.054s to 38m1.928s (10 runs)
>>>>
>>>> Any idea of what can cause this? I have tried to make the runs as equal
>>>> as possible, rebooting between each run.. i/o scheduler is cfq as default.
>>>>
>>>> sys and user time only varies a couple of seconds.. and the order of
>>>> when it is "fast" and when it is "slow" is completly random, but it
>>>> seems that the results are mostly concentrated around the mean.
>>>>
>>>>         
>> .. I may have jumped the gun a "little" early saying that it is mostly
>> concentrated around the mean, grepping from memory is not always .. hm,
>> accurate :P
>>     
>
> For you (or anyone!) to have any faith in your conclusions at all, you
> need to generate the mean and the standard deviation of each of your
> runs.
>
>   
>>> First off, not all tests are good tests. In particular, small timing
>>> differences can get magnified horrendously by heading into swap.
>>>
>>>
>>>       
>> So, what you are saying is that it is expected to vary this much under
>> memory pressure? That I can not do anything with this on real hardware?
>>     
>
> No, I'm saying exactly what I wrote.
>
> What you're testing is basically a bunch of processes competing for
> the CPU scheduler. Who wins that competition is essentially random.
> Whoever wins then places pressure on the IO subsystem. If you then go
> into swap, you're then placing even *more* random pressure on the IO
> system. The reason is that  the order of the requests you're asking it
> to do vary *wildly* between each of your 'tests', and disk drives have
> a horrible time seeking between tracks. That's what I'm saying by
> minute differences in the kernel's behavior can get magnified
> thousands of times if you start hitting swap, or running a test that
> won't all fit into cache.
>
>   
Yes, I get this, just to make it clear, the test is supposed to throw
things out from the page cache, because this is in part what I want to
test. I was under the impression that (not anymore though) a kernel
compile would be pretty deterministic in how it would pressure the page
cache and how much I/O would result from that.. so, I'm going to try and
change the test.
> So whatever you're trying to measure, you need to be aware that you're
> basically throwing a random number generator into the mix.
>
>   
>>> That said, do you have the means and standard deviations of those
>>> runs? That's a good way to tell whether the tests are converging or
>>> not, and whether your results are telling you anything.
>>>
>>>
>>>       
>> I have all the numbers, I was just hoping that there was a way to
>> benchmark a small change without a lot of runs. It seems to me to quite
>> randomly distributed .. from the 2.6.23.14 runs:
>>     
>
> Sure, you just keep running the tests until your standard deviation
> converges to a significant enough range, where significant is whatever
> you like it to be (+- one minute, say, or 10 seconds, or whatever).
> But beware, if your test is essentially random, then it may never
> converge. That in itself is interesting, too.
>
>   
>> It seems to me to quite
>> randomly distributed .. from the 2.6.23.14 runs:
>> 43m10.022s, 34m31.104s, 43m47.221s, 41m17.840s, 34m15.454s,
>> 37m54.327s, 35m6.193s, 38m16.909s, 37m45.411s, 40m13.169s
>> 38m17.414s, 34m37.561s, 43m18.181s, 35m46.233s, 34m44.414s,
>> 39m55.257s, 35m28.477s, 33m30.551s, 41m36.394s, 43m6.359s,
>> 42m42.396s, 37m44.293s, 41m6.615s, 35m43.084s, 39m25.846s,
>> 34m23.753s, 36m0.556s, 41m38.095s, 45m32.703s, 36m18.325s,
>> 42m4.840s, 43m53.759s, 35m51.138s, 40m19.001s
>>
>> Say I made a histogram of this (tilt your head :P) with 1 minute intervals:
>> 33 *
>> 34 *****
>> 35 *****
>> 36 **
>> 37 ***
>> 38 **
>> 39 **
>> 40 **
>> 41 ****
>> 42 **
>> 43 *****
>> 44
>> 45 *
>>     
>
>   
Mean is 2328s and standard deviation is 210s.
> Just eyeballing that, I can tell you your standard deviation is large,
> and you would therefore need to run more tests.
>
> However, let me just underscore that unless you're planning on setting
> up a compile server that you *want* to push into swap all the time,
> then this is a pretty silly test for getting good numbers, and instead
> should try testing something closer to what you're actually concerned
> about.
>
> As an example -- there's a reason kernel developers have stopped
> trying to get good numbers from dbench: it's horribly sensitive to
> timing issues.
>
>   
>> I don't really know what to make of that.. Going to see what happens
>> with less memory and make -j1, perhaps it will be more stable.
>>     
>>> Also as you're on a uniprocessor system, make -j2 is probably going to
>>> be faster than make -j3. Perhaps immaterial to whatever you're trying
>>> to test, but there you go.
>>>       
>> Yes, I was hoping to have a more deterministic test to get a higher
>> confidence in fewer runs when testing changes. Especially under memory
>> pressure. And I truly was not expecting this much fluctuations, which is
>> why I tested several kernel versions to see if this influenced it and
>> mailed lkml. The computer is actually a dual core amd processor, but I
>> compiled the kernel with no smp to see if that helped on the dispersion.
>>     
>
> Well, if you really feel something is weird between the different
> kernel versions, then you should try bisecting various kernels between
> 2.6.20 and 2.6.22 and see if it leads you to anything conclusive. You
> only took 10 data points on 2.6.20, though, so I'd retest it as much
> as you have the other versions just to make sure the results are
> stable.
>
>   
Just going to put this here, did more tests on 2.6.20.21 (56runs) and
here is the outcome of that:
33: **
34: *********  
35: ************
36: *****************
37: **********
38: *****
39: *

Mean is 2175s (~36m) and standard deviation 77s.

> The kernel really *does* change behavior between each version,
> sometimes intentional, sometimes not. But good tests are one of the
> few starting points for discovering that.
>
> In particular, though, you need to be aware that Ingo Molnar's
> "Completely Fair Scheduler" went into 2.6.23. What that means is that
> the processes get scheduled on the CPU more fairly. It also means that
> the disk drive access in your test is going to be much more random and
> seeky than before, as the processes are now interleaving their
> requests together in a much more fine grained way. This is why I keep
> saying (sorry!) that I don't think you're really testing whatever it
> is that you actually care about.
>   
What I want to test is how compressed caching (compressing the page
cache) improves performance under memory pressure. Now, if I just
compared it to the vanilla kernel and I only had one version of
compressed caching to test with, then that would be fine. But I want to
test some small changes to heuristics that may only change the outcome
by 2-3%. A good starting point for me would be to have a vanilla kernel
and a test that gives me consistent  enough results, before starting to
compare it.

I'm going to try a kernel compile with no parallel processes, the
randomness should become less I suppose :)


--
Asbjorn Sannes

