Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYJ0SQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYJ0SQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYJ0SQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:16:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYJ0SQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:16:03 -0400
Message-ID: <49060561.4060607@redhat.com>
Date: Mon, 27 Oct 2008 14:16:01 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
Subject: Re: Bloatwatch 2.6.28-rc1: last_sysfs_file
References: <1224881514.3248.46.camel@calx> <1224882923.3248.51.camel@calx>	 <4902F710.3020100@redhat.com> <1225123898.3199.20.camel@calx>	 <4905F13B.6000406@redhat.com> <1225129574.3199.82.camel@calx>
In-Reply-To: <1225129574.3199.82.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2008-10-27 at 12:50 -0400, Chris Snook wrote:
>> Matt Mackall wrote:
>>> On Sat, 2008-10-25 at 06:38 -0400, Chris Snook wrote: 
>>>> Matt Mackall wrote:
>>>>> On Fri, 2008-10-24 at 15:52 -0500, Matt Mackall wrote:
>>>>>> 2.6.28-rc1 adds 4k for last_sysfs_file debug tracking. That's one hell
>>>>>> of a long sysfs path.
>>>>>>
>>>>>> http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/fs/sysfs
>>>>> ..especially given that printk is limited to 1k at a time.
>>>>>
>>>>>
>>>>> sysfs: shrink last_sysfs_file to a reasonable size
>>>>>
>>>>> sysfs was reserving 4k to store filenames for debug despite printk being
>>>>> limited to 1k. Shrink this to something more reasonable.
>>>>>
>>>>> Signed-off-by: Matt Mackall <mpm@selenic.com>
>>>>>
>>>>> diff -r ac8c82ff3be7 fs/sysfs/file.c
>>>>> --- a/fs/sysfs/file.c	Fri Oct 24 13:13:04 2008 -0500
>>>>> +++ b/fs/sysfs/file.c	Fri Oct 24 16:11:53 2008 -0500
>>>>> @@ -25,7 +25,7 @@
>>>>>  #include "sysfs.h"
>>>>>  
>>>>>  /* used in crash dumps to help with debugging */
>>>>> -static char last_sysfs_file[PATH_MAX];
>>>>> +static char last_sysfs_file[200]; /* allow for disgustingly long paths */
>>>>>  void sysfs_printk_last_file(void)
>>>>>  {
>>>>>  	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
>>>>>
>>>>>
>>>> Please don't use magic numbers.  Use a symbolic constant, and modify printk.c to 
>>>> use the same.
>>> I'm explicitly not using a magic number because the relevant magic
>>> number is absurdly large. It is in fact 4 times larger than printk can
>>> print. And its 40 times larger than any path we are liable to encounter.
>>> Inventing a new use-once #define meaning "good enough for debugging
>>> 99.99% of sysfs bugs" one line up is not an improvement here.
>>>
>>> And why on earth would I modify anything in printk?
>> Because the 1024 limit is a created by an array declaration in printk.c, which 
>> uses the number 1024.  Instead, put something like this in a header file:
>>
>> #define PRINTK_MAX 1024
> 
> That 1024 is supposed to effectively be infinity. Printk is intended to
> be a largely line-oriented facility. If you're printing something large
> enough that you even have to ask yourself 'hmm, how big a buffer can I
> print?', you're printing something -way- too large.
> 
> So no, I think printk is fine as it stands.
> 
>> Arbitrarily clamping critical debugging features to limits pulled out of one's 
>> ass is generally frowned upon.
> 
> First, I don't think it's accurate to apply the adjective 'critical' to
> a facility that's existed in mainline for mere days, while sysfs itself
> has existed many years.

It's critical for debugging *new* things like PCI domain support, that people 
using very non-embedded systems care a whole lot about.

> Second, I didn't pull it out of my ass, actually. I did a histogram of
> sysfs path lengths on my system, found it cut off at ~100, and then
> added generous padding.

Does your system have multiple NUMA nodes, cascaded PCI bridges, and multipathed 
fibre channel storage?  The point of this debugging feature is to help debug the 
cases that are *not* trivial.  Your workstation probably isn't very interesting 
in this regard.

>>   If you can justify some limit lower than the 
>> length of the printk buffer, great, but "I want to save a few hundred bytes of 
>> RAM, total" is insufficient, unless you want to restrict it to the 
>> CONFIG_EMBEDDED world.
> 
> I think you've got this exactly backwards. This is just a debugging
> hint. It is not a standards correctness or kernel robustness issue.
> Reporting the last 20 bytes of the filename would be a sufficient hint
> for most purposes. On the vast majority of machines, this feature will
> be effectively dormant, and this buffer will be wasted space so we have
> to weigh the usefulness of storing unusually long filenames against the
> value of that space for -all other purposes-. If it's going to be on
> unconditionally, it should be as small as possible.

Showing the last 20 characters doesn't help in a highly repetitive file 
hierarchy where how you got there may be more important than where you ended up. 
  I agree with you that it won't be terribly interesting on most systems. 
Perhaps we should find a way to resolve that.  Would you be satisfied if the 
full buffer were enabled by a debug config option?

As for the savings of 824 bytes, you're going to have a very hard time 
convincing the people who want this feature un-castrated to debug their 
multi-chassis Itanium machines that saving 824 bytes is worth losing valuable 
debugging data.

> Just for fun, let's imagine for a moment that someone -did- have a 1k
> sysfs path. And, further, we happen to have a fatal oops at some point
> after it. And, further, we were lucky enough for it to get directed to a
> text console. But unfortunately, our debugging hint has helpfully taken
> up half the screen, and we've actually scrolled the much more important
> *cause of the oops* off the screen. Hurray! In fact, we'll probably
> scroll most of the giant sysfs path off too when we print a backtrace. 

On the systems where we care about extremely long sysfs paths, screen space 
isn't an issue, because the thing is sitting in a data center and you're 
debugging with netconsole or a serial console.

> Given that the only purpose of this feature is to be printked in an
> already tightly constrained oops report where it's quite likely to be
> completely extraneous, spending more than a couple lines on it is a good
> way to fail.

Now, this is valid.  "200 prevents the printk from consuming more than 3 lines 
on an 80 column terminal." is a much more useful comment than "200 seems to be 
big enough on my box."  So, is 3 lines within budget?  Would 4 lines be too much?

-- Chris
