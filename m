Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXKEFLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXKEFLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 00:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbXKEFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 00:11:47 -0500
Received: from [222.73.24.84] ([222.73.24.84]:57173 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXKEFLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 00:11:46 -0500
Message-ID: <472EA59F.3060800@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 13:09:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, buytenh@wantstofly.org
Subject: Re: [PATCH 1/6] ARM: fix memset size error
References: <472E7CB4.5020301@cn.fujitsu.com> <Pine.LNX.4.64.0711042302580.31550@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0711042302580.31550@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Mon, 5 Nov 2007, Li Zefan wrote:
> 
>> The size passing to memset is wrong. And here we can replace
>> kmalloc with kzalloc.
>>
>> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
>>
>> ---
>>  arch/arm/common/uengine.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/common/uengine.c b/arch/arm/common/uengine.c
>> index 95c8508..117cab3 100644
>> --- a/arch/arm/common/uengine.c
>> +++ b/arch/arm/common/uengine.c
>> @@ -374,8 +374,8 @@ static int set_initial_registers(int uengine, struct ixp2000_uengine_code *c)
>>  	u8 *ucode;
>>  	int i;
>>
>> -	gpr_a = kmalloc(128 * sizeof(u32), GFP_KERNEL);
>> -	gpr_b = kmalloc(128 * sizeof(u32), GFP_KERNEL);
>> +	gpr_a = kzalloc(128 * sizeof(u32), GFP_KERNEL);
>> +	gpr_b = kzalloc(128 * sizeof(u32), GFP_KERNEL);
>>  	ucode = kmalloc(513 * 5, GFP_KERNEL);
>>  	if (gpr_a == NULL || gpr_b == NULL || ucode == NULL) {
>>  		kfree(ucode);
>> @@ -388,8 +388,6 @@ static int set_initial_registers(int uengine, struct ixp2000_uengine_code *c)
>>  	if (c->uengine_parameters & IXP2000_UENGINE_4_CONTEXTS)
>>  		per_ctx_regs = 32;
>>
>> -	memset(gpr_a, 0, sizeof(gpr_a));
>> -	memset(gpr_b, 0, sizeof(gpr_b));
>>  	for (i = 0; i < 256; i++) {
>>  		struct ixp2000_reg_value *r = c->initial_reg_values + i;
>>  		u32 *bank;
>>
>   it's unlikely that patch will cause any trouble whatsoever, but
> notice that it *is* changing the underlying logic.  those original
> memsets should probably have been written initially as
> "sizeof(*gpr_a)" so they would previously have zeroed only memory the
>         ^
> size of a pointer, no?
> 
>   now, i'm guessing the logic is correct but i figured it's worth
> noting what the code *used* to do.  unless i'm misreading something
> horribly.
> 

In the for loop, some elems of gpr_a and gpr_b will be assigned with a value,
but not all elems. So those unassigned elems should be filled with 0.

I think it happens now and then to mistake to regard a pointer as a static
array, and I guess this is what sizeof(gpr_a) means.

Li Zefan
