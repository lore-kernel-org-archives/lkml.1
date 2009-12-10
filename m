Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbZLJTUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbZLJTUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbZLJTU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:20:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:51096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZLJTU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:20:29 -0500
Message-ID: <4B2149B4.9060900@kernel.org>
Date: Thu, 10 Dec 2009 11:19:16 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression (Was Re: current -git fails to boot on	nehalem-ex)
References: <20091210091040.GG8742@kernel.dk> <20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu> <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org> <20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk> <20091210190742.GS8742@kernel.dk>
In-Reply-To: <20091210190742.GS8742@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Dec 10 2009, Jens Axboe wrote:
>>>>> [    0.000000] Kernel panic - not syncing: Overlapping early reservations 12-f011 MP-table mpc to 0-fff BIOS data page
>>>> mptable mpc is [12 - f011]
>>>>
>>>> what a BIOS !
>>>>
>>>> can you check if it works with 2.6.32 + "acpi=off"?
>> I'll try that.
> 
> Yes, 2.6.32 boots fine with acpi=off passed.
> 
>>> please check if this one could workaround it.
>>>
>>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>> index d17d482..f60acec 100644
>>> --- a/arch/x86/kernel/e820.c
>>> +++ b/arch/x86/kernel/e820.c
>>> @@ -732,7 +732,7 @@ struct early_res {
>>>  	char overlap_ok;
>>>  };
>>>  static struct early_res early_res[MAX_EARLY_RES] __initdata = {
>>> -	{ 0, PAGE_SIZE, "BIOS data page" },	/* BIOS data page */
>>> +	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
>>>  	{}
>>>  };
>> And then this. Results in 10-15min.
> 
> Doesn't work, it just complains about a different overlap:
> 
> [    0.000000] Kernel panic - not syncing: Overlapping early
> reservations 12-f011 MP-table mpc to 6000-7fff TRAMPOLINE
> [    0.000000] 
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32 #51
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff813c709b>] panic+0xa0/0x16a
> [    0.000000]  [<ffffffff8167d280>] ?
> reserve_early_overlap_ok+0x2e/0x39
> [    0.000000]  [<ffffffff8167d24a>] ?
> drop_overlaps_that_are_ok+0x117/0x11f
> [    0.000000]  [<ffffffff8167d133>] drop_overlaps_that_are_ok+0x0/0x11f
> [    0.000000]  [<ffffffff8167d2c6>] reserve_early+0x3b/0x3d
> [    0.000000]  [<ffffffff81683248>] smp_scan_config+0xe7/0x10e
> [    0.000000]  [<ffffffff816832a9>] default_find_smp_config+0x3a/0x60
> [    0.000000]  [<ffffffff8167b0be>] setup_arch+0x6ae/0xa88
> [    0.000000]  [<ffffffff816789ff>] start_kernel+0x82/0x412
> [    0.000000]  [<ffffffff81678289>] x86_64_start_reservations+0x99/0xb9
> [    0.000000]  [<ffffffff81678389>] x86_64_start_kernel+0xe0/0xf2
> 
> 

that is funny. we may need to use find early for our TRAMPOLINE...?

otherwise your mptable is corrupted....

YH
