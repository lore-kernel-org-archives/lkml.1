Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZBJSwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZBJSwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZBJSwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:52:25 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:43017 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbZBJSwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Se/dnWDvoHAn876oUmSO6gaHvBv63M5K3yVjoF8hRctW0bqEvR4BaI6dd5x5fvZNqC
         hLiDIwFPM/Xf/rHrzSBlQkVWvopSBCPFj8CV2wJyJWi+q56qgjsfRMs9EbwRjFmk9ZBp
         FJ8esUw7gRW/g7DQG0sQyMkx9kthO831KzGbs=
MIME-Version: 1.0
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com>
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com>
	 <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com>
	 <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org>
	 <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com>
Date: Tue, 10 Feb 2009 10:52:23 -0800
X-Google-Sender-Auth: f38839d41de1a216
Message-ID: <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com>
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 
	on IBM x3400
From: Yinghai Lu <yinghai@kernel.org>
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 8:21 AM, Morten P.D. Stevens
<mstevens@win-professional.com> wrote:
> Hi,
>
>> please try:
>> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c
> b/arch/x86/kernel/cpu/mtrr/generic.c
>> index 0c0a455..7a359ce 100644
>> --- a/arch/x86/kernel/cpu/mtrr/generic.c
>> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
>> @@ -397,7 +397,8 @@ static void generic_get_mtrr(unsigned int reg,
> unsigned long *base,
>>               tmp |= ~((1<<(hi - 1)) - 1);
>>
>>               if (tmp != mask_lo) {
>> -                     WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
> up an incorrect mask, fixing it up.\n");
>> +                     printk(KERN_INFO "mtrr: BIOS set mask_lo: %x
> should be %x, fixing it up\n", mask_lo, tmp);
>> +                     WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
> up an incorrect mask.\n");
>>                       mask_lo = tmp;
>>               }
>>       }
>
> result:
>
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:405
> generic_get_mtrr+0xd0/0x10a()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask.
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28.4-ibm #1
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8023acca>] warn_slowpath+0xb4/0xda
> [    0.000000]  [<ffffffff8023b8c6>] vprintk+0x2a4/0x2d1
> [    0.000000]  [<ffffffff80221bea>] default_spin_lock_flags+0x6/0x8
> [    0.000000]  [<ffffffff80451cf9>] printk+0x4e/0x5d
> [    0.000000]  [<ffffffff80453e6a>] _spin_lock_irqsave+0x25/0x2c
> [    0.000000]  [<ffffffff802194c0>] mtrr_wrmsr+0x1b/0x48
> [    0.000000]  [<ffffffff805e5f88>] get_mtrr_state+0x2e5/0x2f1
> [    0.000000]  [<ffffffff8021960e>] generic_get_mtrr+0xd0/0x10a
> [    0.000000]  [<ffffffff805e4e0d>] mtrr_bp_init+0x1f5/0xc39
> [    0.000000]  [<ffffffff805e58e4>]
> mtrr_trim_uncached_memory+0x93/0x374
> [    0.000000]  [<ffffffff805f07c9>] early_iounmap+0x13d/0x19d
> [    0.000000]  [<ffffffff805f07c9>] early_iounmap+0x13d/0x19d
> [    0.000000]  [<ffffffff805da140>] early_idt_handler+0x0/0x71
> [    0.000000]  [<ffffffff805e0d56>] setup_arch+0x407/0x78c
> [    0.000000]  [<ffffffff805f4c81>] cgroup_init_subsys+0x2a/0xd9
> [    0.000000]  [<ffffffff805f4f5e>] cgroup_init_early+0x1a4/0x1b6
> [    0.000000]  [<ffffffff80453f10>] _spin_lock+0x6/0x7
> [    0.000000]  [<ffffffff805da931>] start_kernel+0x7b/0x38b
> [    0.000000]  [<ffffffff805da140>] early_idt_handler+0x0/0x71
> [    0.000000]  [<ffffffff805da3a1>] x86_64_start_kernel+0xe7/0xf4
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>


the line before this? it should tell why BIOS set the mask wrong.

YH
