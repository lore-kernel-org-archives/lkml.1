Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZG0JoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZG0JoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZG0JoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:44:03 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:32223 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZG0JoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:44:01 -0400
Message-ID: <4A6D76DB.1050902@monstr.eu>
Date: Mon, 27 Jul 2009 11:43:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: Re: generic uaccess.h
References: <4A69651E.7040305@monstr.eu> <200907241120.22483.arnd@arndb.de>
In-Reply-To: <200907241120.22483.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 24 July 2009, Michal Simek wrote:
>> I have just look at asm-generic uaccess.h and there is one thing which
>> seems to me wrong.
>>
>> For put_user macro - you use __copy_to_user but you have for 64bit case
>> ifdef CONFIG_64BIT
>> but  look at fs/eventfd: eventfd_read function. At least for this
>> function(syscall) is necessary "return" 64bit
>> value on 32bit machines too.
>> IMHO that ifdef CONFIG_64BIT shouldn't be there.
>>
>> What do you think?
>> If you agree with me, I'll generate proper patch with description.
> 
> The code was intentional, because 32 bit architectures normally
> don't acces u64 values efficiently. I would expect the memcpy
> to produce better object code in that case.
> Did you see an actual bug in my version or are you only
> guessing that the assignment should work better than the
> memcpy?
> 
> What object code do you get with
> 
> int test(unsigned long long __user *out, unsigned long long in)
> {
> 	return put_user(in, ptr);
> }
> 
> in both cases?

I found that I have problem on noMMU with replacing
put_user macro

with

#define put_user(x, ptr)					\
({								\
	might_sleep();						\
	access_ok(VERIFY_WRITE, ptr, sizeof(*ptr)) ?		\
		__put_user(x, ptr) :				\
		-EFAULT;					\
})

(The similar issue is for get_user) (__put_user function is origin - not asm-generic)

I am getting any short write error. It is caused with adding access_ok macro.
It is weird.

RPC: Registered tcp transport module.
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 100k freed
0: short write
Kernel panic - not syncing: Attempted to kill init!


I have more important work in front of me - I take a look at it later.

Michal


> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
