Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZL2HIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZL2HIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 02:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZL2HIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 02:08:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42317 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZL2HIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 02:08:37 -0500
Message-ID: <4B39AAF3.4060605@cs.helsinki.fi>
Date: Tue, 29 Dec 2009 09:08:35 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: mingo@elte.hu, vegard.nossum@gmail.com, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] x86: Use KERN_DEFAULT log-level in __show_regs()
References: <1261988819.4641.2.camel@penberg-laptop> <1262029654.3352.27.camel@Joe-Laptop.home>
In-Reply-To: <1262029654.3352.27.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches kirjoitti:
> On Mon, 2009-12-28 at 10:26 +0200, Pekka Enberg wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> Andrew Morton reported a strange looking kmemcheck warning:
>>
>>   WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff88004fba6c20)
>>   0000000000000000310000000000000000000000000000002413000000c9ffff
>>    u u u u u u u u u u u u u u u u i i i i i i i i u u u u u u u u
>>
>>    [<ffffffff810af3aa>] kmemleak_scan+0x25a/0x540
>>    [<ffffffff810afbcb>] kmemleak_scan_thread+0x5b/0xe0
>>    [<ffffffff8104d0fe>] kthread+0x9e/0xb0
>>    [<ffffffff81003074>] kernel_thread_helper+0x4/0x10
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> The above printout is missing register dump completely. The problem here is
>> that the output comes from syslog which doesn't show KERN_INFO log-level
>> messages. We didn't see this before because both of us were testing on 32-bit
>> kernels which use the _default_ log-level.
>>
>> Fix that up by explicitly using KERN_DEFAULT log-level for __show_regs()
>> printks.
>>
>> Cc: Vegard Nossum <vegard.nossum@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> ---
>>  arch/x86/kernel/process.c    |    4 ++--
>>  arch/x86/kernel/process_32.c |   14 +++++++-------
>>  arch/x86/kernel/process_64.c |   24 ++++++++++++------------
>>  3 files changed, 21 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>> index 98c2cde..c6ee241 100644
>> --- a/arch/x86/kernel/process.c
>> +++ b/arch/x86/kernel/process.c
>> @@ -103,8 +103,8 @@ void show_regs_common(void)
>>  	if (!product)
>>  		product = "";
>>  
>> -	printk("\n");
>> -	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
>> +	printk(KERN_CONT "\n");
>> +	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
> 
> What is the reason to convert KERN_INFO to KERN_DEFAULT here?

To be consistent with rest of __show_regs() log-levels.
