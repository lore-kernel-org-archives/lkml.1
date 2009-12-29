Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbZL2Cm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbZL2Cm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 21:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZL2Cmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 21:42:55 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:55094 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZL2Cmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 21:42:55 -0500
Message-ID: <4B396C45.2010102@vflare.org>
Date: Tue, 29 Dec 2009 08:11:09 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <87eimf87m5.fsf@basil.nowhere.org> <4B38D0CF.9000403@vflare.org> <20091228172903.GF4994@basil.fritz.box> <4B38FC42.7000204@cs.helsinki.fi> <20091228192325.GG4994@basil.fritz.box>
In-Reply-To: <20091228192325.GG4994@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 12:53 AM, Andi Kleen wrote:
>>>>> The first question to ask is if compressed swap is worth
>>>>> it. Do you have benchmark numbers showing it to be an improvement?
>>>>> Are there cases where it is slower than uncompressed swap?
>>>>>
>>>> http://code.google.com/p/compcache/wiki/Performance
>>>
>>> That should be included in the changelog of the patches.
>>
>> Which patches? The driver is already in staging and there's a pointer to 
>> the home page in
> 
> How can it be in staging if there are no hooks for it yet?
> 
>>>> ramzswap is an optional module.
>>>
>>> I have some doubts on the wisdom of making swap algorithms modular.
>>> Better compile them in. Then you don't need messy notifiers either.

These notifiers are the only in-kernel changes ramzswap needs. Giving away
modularity just because of this might not be a good idea. Also, we are
not making any swap algorithm modular. This driver simply creates virtual
block devices to be used as swap disks. This approach allows seamless
integration with existing swap code and 0 overhead when not used.

>>
>> What's so messy about them? The whole point of having the notifiers is to 
>> avoid CONFIG_RAMZSWAP in core kernel code...
> 
> They make the code much harder to read and follow. When you try to follow
> the code flow and you find a notifier it's always a complicated operation
> to figure out what code will end up being called.
> 
> Sometimes they are needed, but they have a high cost in maintainability.
> 

For SWAP_SLOT_FREE notification, I can add a comment mentioning that ramzswap is
currently the only user. Other two notifiers, for swapon and swapoff, are fairly
generic and I hope will find some more users soon.
Maybe I'm missing something but simple cscope query for notifier chain name will
instantly reveal all its users :)

If we remove _any_ of these notifiers, we will end up with lot of ramzswap #ifdef'ery
all over the core kernel code, as Pekka mentioned. This includes swapon/swapoff syscalls(!),
 swap.h, swapfile.c. In fact, some of my initial patches (before mainline merge)
did the same thing but they were obviously too ugly/hacky with CONFIG_RAMZSWAP all over
the place due to which I had to temporarily drop swap notify callback support which is
essential for this driver.

Thanks,
Nitin
