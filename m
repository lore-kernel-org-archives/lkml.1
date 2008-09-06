Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYIFNly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYIFNly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYIFNlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:41:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYIFNlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:41:45 -0400
Date: Sat, 6 Sep 2008 15:41:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception
	- lockdep related?]
Message-ID: <20080906134118.GD4910@elte.hu>
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com> <1220642738.11202.21.camel@twins.programming.kicks-ass.net> <48C19415.9060108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C19415.9060108@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@kernel.org> wrote:

> Peter Zijlstra wrote:
>> On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
>>> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>> Sadly your config just boots, albeit not to userspace due to missing
>>>>> drivers.
>>>> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
>>>> kernel dies too early.
>>>> I also managed to get a stack trace :D
>>>>
>>>> http://img151.imageshack.us/my.php?image=tracedm1.jpg
>>>>
>>>> It seems that lockdep is an innocent bystander... the kernel died with
>>>> panic() in __reserve_early, and then took another exception while
>>>> printing the panic (I guess).
>>>> Will add further debug stuff to see wtf is going on.
>>> Hum, kernel says:
>>>
>>> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
>>>
>>> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
>>> TEXT DATA BSS
>>>
>>> It would appear that the initramfs is overlapping the kernel itself,
>>> is the boot loader (LILO) doing something stupid?
>>
>> Suppose it is, lets ask hpa..
>>
>
> It definitely looks like it.

yeah. Kernel is loaded at the standard 2MB physical, and goes up to 
13.6MB physical. That's a tad large at 11.6 MB but still valid.

ramdisk image goes from 11.6 MB to 14.9 MB - roughly standard size. That 
overlaps 2 MB into the kernel image so we have to panic. LILO should 
have loaded the ramdisk somewhere else. (or should have aborted the boot 
if it cannot do that)

We could perhaps print a prominent warning, delay the boot for 5 seconds 
or so via mdelay(5000) and simply not load the ramdisk if this happens? 
The kernel is obviously still functional - and such a large vmlinuz 
likely has all the built-in drivers to boot up to user-space - the lack 
of the ramdisk does not necessarily hurt .

	Ingo
