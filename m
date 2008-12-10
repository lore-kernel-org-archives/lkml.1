Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYLJN0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYLJN0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYLJN0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:26:03 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:39159 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYLJN0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:26:01 -0500
Date: Wed, 10 Dec 2008 16:25:53 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <1356341274.20081210162553@emcraft.com>
To: David Howells <dhowells@redhat.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Wolfgang Denk <wd@denx.de>,
       Detlev Zundel <dzu@denx.de>, <linux-kernel@vger.kernel.org>,
       Milton Miller <miltonm@bga.com>, <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Ilya Yanok <yanok@emcraft.com>
Subject: Re[4]: [PATCH] fork_init: fix division by zero
In-Reply-To: <5545.1228914404@redhat.com>
References: <1795455197.20081210132912@emcraft.com> <200812092044.40649.yur@emcraft.com> <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be> <503391615.20081210130113@emcraft.com> <20081210101745.GG28946@ZenIV.linux.org.uk> <5545.1228914404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hello David,

On Wednesday, December 10, 2008 you wrote:

> Yuri Tikhonov <yur@emcraft.com> wrote:

>>  Here we believe in preprocessor: since all PAGE_SIZE, 8, and 
>> THREAD_SIZE are the constants we expect it will calculate this.

> The preprocessor shouldn't be calculating this.  I believe it will _only_
> calculate expressions for #if.  In the situation you're referring to, it
> should perform a substitution and nothing more.  The preprocessor doesn't
> necessarily know how to handle the types involved.

> In any case, there's an easy way to find out: you can ask the compiler to give
> you the result of running the source through the preprocessor only. For
> instance, if you run this:

>         #define PAGE_SIZE 4096
>         #define THREAD_SIZE 8192
>         unsigned long mempages;
>         unsigned long jump(void)
>         {
>                 unsigned long max_threads;
>                 max_threads = mempages * PAGE_SIZE / (8 * THREAD_SIZE);
>                 return max_threads;
>         }

> through "gcc -E", you get:

>         # 1 "calc.c"
>         # 1 "<built-in>"
>         # 1 "<command line>"
>         # 1 "calc.c"
>         unsigned long mempages;
>         unsigned long jump(void)
>         {
>          unsigned long max_threads;
>          max_threads = mempages * 4096 / (8 * 8192);
>          return max_threads;
>         }


>>  In any case, adding braces as follows probably would be better:
>> 
>> +     max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));

> I think you mean brackets, not braces '{}'.

 Yes, it was a typo.


>>  Right ?

> Definitely not.

> I added this function to the above:

>         unsigned long alt(void)
>         {
>                 unsigned long max_threads;
>                 max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
>                 return max_threads;
>         }

> and ran it through "gcc -S -O2" for x86_64:

>         jump:
>                 movq    mempages(%rip), %rax
>                 salq    $12, %rax
>                 shrq    $16, %rax
>                 ret
>         alt:
>                 xorl    %eax, %eax
>                 ret

> Note the difference?  In jump(), x86_64 first multiplies mempages by 4096, and
> _then_ divides by 8*8192.

> In alt(), it just returns 0 because the compiler realised that you're
> multiplying by 0.

 I think Geert has already commented this: you've compiled your alt() 
functions having 4K PAGE_SIZE and 8K THREAD_SIZE - this case is 
handled by the old code in fork_init.

> If you're going to bracket the expression, it must be:

>                 max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE);

> which should be superfluous.

>>  E.g. here is the result from this line as produced by cross-gcc 
>> 4.2.2:
>> 
>>         lis     r9,0
>>         rlwinm  r29,r29,2,16,29
>>         stw     r29,0(r9)
>> 
>>  As you see - only rotate-left, i.e. multiplication to the constant.

> Ummm...  On powerpc, I believe rotate-left would be a division as it does the
> bit-numbering and the bit direction the opposite way to more familiar CPUs
> such as x86.

 On powerpc shifting left is multiplication by 2, as this has the most 
significant bit first.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

