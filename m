Return-Path: <linux-kernel-owner+w=401wt.eu-S934714AbXLPQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714AbXLPQxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 11:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933316AbXLPQxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 11:53:45 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59636 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752206AbXLPQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 11:53:45 -0500
Date: Sun, 16 Dec 2007 17:53:48 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RANDOM] Move two variables to read_mostly section to save
	memory
Message-ID: <20071216165348.GC14233@stusta.de>
References: <47650FBD.2060209@cosmosbay.com> <20071216130028.GB14233@stusta.de> <476539D5.7050305@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <476539D5.7050305@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 03:44:37PM +0100, Eric Dumazet wrote:
> Adrian Bunk a écrit :
>> On Sun, Dec 16, 2007 at 12:45:01PM +0100, Eric Dumazet wrote:
>>> While examining vmlinux namelist on i686, I noticed :
>>>
>>> c0581300 D random_table
>>> c0581480 d input_pool
>>> c0581580 d random_read_wakeup_thresh
>>> c0581584 d random_write_wakeup_thresh
>>> c0581600 d blocking_pool
>>>
>>> That means that the two integers random_read_wakeup_thresh and 
>>> random_write_wakeup_thresh use a full cache entry (128 bytes).
>>>
>>> Moving them to read_mostly section can shrinks vmlinux by 120 bytes.
>>>
>>> # size vmlinux*
>>>    text    data     bss     dec     hex filename
>>> 4835553  450210  610304 5896067  59f783 vmlinux.after_patch
>>> 4835553  450330  610304 5896187  59f7fb vmlinux.before_patch
>>>
>>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>>
>>> diff --git a/drivers/char/random.c b/drivers/char/random.c
>>> index 5fee056..af48e86 100644
>>> --- a/drivers/char/random.c
>>> +++ b/drivers/char/random.c
>>> @@ -256,14 +256,14 @@
>>>   * The minimum number of bits of entropy before we wake up a read on
>>>   * /dev/random.  Should be enough to do a significant reseed.
>>>   */
>>> -static int random_read_wakeup_thresh = 64;
>>> +static int random_read_wakeup_thresh __read_mostly = 64;
>>>   /*
>>>   * If the entropy count falls under this number of bits, then we
>>>   * should wake up processes which are selecting or polling on write
>>>   * access to /dev/random.
>>>   */
>>> -static int random_write_wakeup_thresh = 128;
>>> +static int random_write_wakeup_thresh __read_mostly = 128;
>>
>> Please never ever do such ugly and unmaintainable micro-optimizations in 
>> the code unless you can show a measurable performance improvement of the 
>> kernel.
>
> You seem to to be confused between speed micro-otimizations and memory 
> savings. This patch has nothing to do about a speed optimization. Here, no 
> tradeoff justify a "measurable performance improvement" study.
> 
> I copied this patch to you because your recent proposal to remove 
> read_mostly from linux kernel.
>
> Only you find read_mostly ugly and unmaintanable. I find it way more 
> usefull than "static" attributes.
>
> I find 120 bytes is a measurable gain, thank you.


I am well aware that your patch is about space saving and not speed
improvement.

But trying to save space this way is simply not maintainable.

And it's trivial to see that your patch actually makes the code _bigger_ 
for all people who try hard to get their kernel small and use 
CONFIG_SYSCTL=n - funnily your patch has exactly the problem I described 
as drawback of __read_mostly in the thread you are referring to...


And even more funny, with gcc 4.2 and CONFIG_CC_OPTIMIZE_FOR_SIZE=y your 
patch doesn't seem to make any space difference - are you using an older 
compiler or even worse CONFIG_CC_OPTIMIZE_FOR_SIZE=n for being able to 
see any space difference?

In both cases your code uglification would be even more pointless...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

