Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYJ0QuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYJ0QuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYJ0QuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:50:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34681 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbYJ0QuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:50:06 -0400
Message-ID: <4905F13B.6000406@redhat.com>
Date: Mon, 27 Oct 2008 12:50:03 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
Subject: Re: Bloatwatch 2.6.28-rc1: last_sysfs_file
References: <1224881514.3248.46.camel@calx> <1224882923.3248.51.camel@calx>	 <4902F710.3020100@redhat.com> <1225123898.3199.20.camel@calx>
In-Reply-To: <1225123898.3199.20.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Sat, 2008-10-25 at 06:38 -0400, Chris Snook wrote: 
>> Matt Mackall wrote:
>>> On Fri, 2008-10-24 at 15:52 -0500, Matt Mackall wrote:
>>>> 2.6.28-rc1 adds 4k for last_sysfs_file debug tracking. That's one hell
>>>> of a long sysfs path.
>>>>
>>>> http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/fs/sysfs
>>> ..especially given that printk is limited to 1k at a time.
>>>
>>>
>>> sysfs: shrink last_sysfs_file to a reasonable size
>>>
>>> sysfs was reserving 4k to store filenames for debug despite printk being
>>> limited to 1k. Shrink this to something more reasonable.
>>>
>>> Signed-off-by: Matt Mackall <mpm@selenic.com>
>>>
>>> diff -r ac8c82ff3be7 fs/sysfs/file.c
>>> --- a/fs/sysfs/file.c	Fri Oct 24 13:13:04 2008 -0500
>>> +++ b/fs/sysfs/file.c	Fri Oct 24 16:11:53 2008 -0500
>>> @@ -25,7 +25,7 @@
>>>  #include "sysfs.h"
>>>  
>>>  /* used in crash dumps to help with debugging */
>>> -static char last_sysfs_file[PATH_MAX];
>>> +static char last_sysfs_file[200]; /* allow for disgustingly long paths */
>>>  void sysfs_printk_last_file(void)
>>>  {
>>>  	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
>>>
>>>
>> Please don't use magic numbers.  Use a symbolic constant, and modify printk.c to 
>> use the same.
> 
> I'm explicitly not using a magic number because the relevant magic
> number is absurdly large. It is in fact 4 times larger than printk can
> print. And its 40 times larger than any path we are liable to encounter.
> Inventing a new use-once #define meaning "good enough for debugging
> 99.99% of sysfs bugs" one line up is not an improvement here.
> 
> And why on earth would I modify anything in printk?

Because the 1024 limit is a created by an array declaration in printk.c, which 
uses the number 1024.  Instead, put something like this in a header file:

#define PRINTK_MAX 1024

Now use that in printk.c where the buffer is declared, and again in sysfs/file.c 
where last_sysfs_file is defined, in place of PATH_MAX.  1024 isn't nearly as 
bad as 4096.  If you desperately need it to be even smaller, you might want to 
make the printk buffer a CONFIG option to live under CONFIG_EMBEDDED, which 
could be taken advantage of elsewhere in the kernel as well.

Arbitrarily clamping critical debugging features to limits pulled out of one's 
ass is generally frowned upon.  If you can justify some limit lower than the 
length of the printk buffer, great, but "I want to save a few hundred bytes of 
RAM, total" is insufficient, unless you want to restrict it to the 
CONFIG_EMBEDDED world.

-- Chris
