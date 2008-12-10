Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYLJKB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYLJKB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYLJKBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:01:18 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:37743 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYLJKBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:01:17 -0500
Date: Wed, 10 Dec 2008 13:01:13 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <503391615.20081210130113@emcraft.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Detlev Zundel <dzu@denx.de>, Wolfgang Denk <wd@denx.de>,
       Milton Miller <miltonm@bga.com>, Ilya Yanok <yanok@emcraft.com>
Subject: Re[2]: [PATCH] fork_init: fix division by zero
In-Reply-To: <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be>
References: <200812092044.40649.yur@emcraft.com> <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hello Geert,

On Wednesday, December 10, 2008 you wrote:
> On Tue, 9 Dec 2008, Yuri Tikhonov wrote:
>> The following patch fixes divide-by-zero error for the
>> cases of really big PAGE_SIZEs (e.g. 256KB on ppc44x).
>> Support for such big page sizes on 44x is not present in the
>> current kernel yet, but coming soon.
>> 
>> Also this patch fixes the comment for the max_threads
>> settings, as this didn't match the things actually done
>> in the code.
>> 
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
>> ---
>>  kernel/fork.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 2a372a0..b0ac2fb 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -181,10 +181,14 @@ void __init fork_init(unsigned long mempages)
>>  
>>       /*
>>        * The default maximum number of threads is set to a safe
>> -      * value: the thread structures can take up at most half
>> -      * of memory.
>> +      * value: the thread structures can take up at most
>> +      * (1/8) part of memory.
>>        */
>> +#if (8 * THREAD_SIZE) > PAGE_SIZE
>>       max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
>> +#else
>> +     max_threads = mempages * PAGE_SIZE / (8 * THREAD_SIZE);
>                       ^^^^^^^^^^^^^^^^^^^^
>> +#endif

> Can't this overflow, e.g. on 32-bit machines with HIGHMEM?

 The multiplier here is not PAGE_SIZE, but [PAGE_SIZE / (8 * 
THREAD_SIZE)], and this value is expected to be rather small (2, 4, or 
so).

 Furthermore, due to the #if/#endif construction multiplication is 
used only with rather big PAGE_SIZE values, and the bigger page size 
is then the smaller 'mempages' is.

 So, for example, when running with PAGE_SIZE=256KB, THREAD_SIZE=8KB, 
on 32-bit 440spe-based machine with 4GB RAM installed, here we have:

 max_threads = (4G/256K) * (256K / 8 * 8K) = 16384 * 4 = 65536.

 And the overflow will have a place only in case of very very big 
sizes of RAM: >= 256TB:

 max_threads = (256T / 256K) * (256K / 8 * 8K) = 0x4000.0000 * 4.

 But I don't think that with 256TB RAM installed this code will be 
the only place of problems :)

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

