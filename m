Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXEFVIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXEFVIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbXEFVIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:08:52 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:43223 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbXEFVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:08:05 -0400
Message-ID: <463E43AF.9070400@simon.arlott.org.uk>
Date: Sun, 06 May 2007 22:07:59 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>	<463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org>
In-Reply-To: <20070506135403.a6785f7d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/07 21:54, Andrew Morton wrote:
> On Sun, 06 May 2007 21:36:32 +0100 Simon Arlott <simon@fire.lp0.eu> wrote:
> 
>> On 05/05/07 09:49, Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
>> Not sure exactly what's going on here, but it happened with a lock held on my 
>> (XFS) filesystem while compiling part of the kernel because I can't do anything 
>> with it now.
>>
>> [ 1128.122000] BUG: sleeping function called from invalid context at block/cfq-iosched.c:1895
>> [ 1128.122000] in_atomic():1, irqs_disabled():0
>> [ 1128.122000] INFO: lockdep is turned off.
>> [ 1128.122000] BUG: unable to handle kernel paging request at virtual address 8b0c4034
>> [ 1128.122000]  printing eip:
>> [ 1128.122000] b0104e36
>> [ 1128.123000] *pde = 00000000
>> [ 1128.123000] Oops: 0000 [#1]
>> [ 1128.123000] PREEMPT
>> [ 1128.123000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
>> [ 1128.123000] CPU:    0
>> [ 1128.123000] EIP:    0060:[<b0104e36>]    Not tainted VLI
>> [ 1128.123000] EFLAGS: 00010246   (2.6.21-git #195)
>> [ 1128.123000] EIP is at dump_trace+0x66/0xb0
>> [ 1128.123000] eax: 00000000   ebx: b18f6fd0   ecx: b06323ec   edx: b05afc71
>> [ 1128.123000] esi: 8b0c4000   edi: 8b0c4ffd   ebp: b18f6fd0   esp: b18f6fb8
>> [ 1128.123000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
>> [ 1128.123000] Process pdflush (pid: 186, ti=b18f6000 task=eff88b10 task.ti=b18f7000)
>> [ 1128.123000] Stack: b000205d 00000000 fffffffc b05b9937 efd1adb4 00000010 b18f6ff0 b0104f3a
>> [ 1128.123000]        b06323ec b05b9937 00000000 b05d33e6 efd1adb4 b05d33e6 b18f7000 b0104f62
>> [ 1128.123000]        b05b9937 b18f700c
>> [ 1128.123000] Call Trace:
>> [ 1128.123000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
>> [ 1128.123000]  [<b0104ffb>] show_stack_log_lvl+0x8b/0xb0
>> [ 1128.123000]  [<b0105243>] show_registers+0x1c3/0x320
>> [ 1128.123000]  [<b0105525>] die+0x105/0x230
>> [ 1128.123000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
>> [ 1128.123000]  [<b04eae3a>] error_code+0x6a/0x70
>> [ 1128.123000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
>> [ 1128.123000]  [<b0104f62>] show_trace+0x12/0x20
>> [ 1128.123000]  =======================
>> [ 1128.123000] Code: 18 8b 4d 08 8b 45 0c 8b 53 04 ff 51 08 8b 03 39 d8 76 06 89 c3 39 f3 77 e4 8b 4d 08 ba 71 fc 5a b0 8b 45 0c ff 51 0c 85 c0 78 38 <8b> 76 34 85 f6 74 31 8d 76 00 e8 bb d7 00 00 eb b3 89 eb eb af
>> [ 1128.123000] EIP: [<b0104e36>] dump_trace+0x66/0xb0 SS:ESP 0068:b18f6fb8
> 
> Mess.  Someone incorrectly called the IO scheduler under a spinlock (or
> similar), CFQ tried to do a dump_stack(), but the dump_stack() code
> exploded.  Usually this happens when the x86_64 tree contains stacktrace
> improvements, but the unwinder (at least) wasn't present in -mm1.
> 
> How come those addresses are 0xb0......, btw?  You're running a different
> vm split?

I'm using CONFIG_VMSPLIT_3G_OPT, yes.

-- 
Simon Arlott
