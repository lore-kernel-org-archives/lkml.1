Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbYD1IiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbYD1IiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764064AbYD1IiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:38:17 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:50969 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762565AbYD1IiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:38:15 -0400
Message-ID: <48158CF3.60004@zoopnet.de>
Date: Mon, 28 Apr 2008 10:38:11 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org> <86802c440804272350y33d69a32o5533dc01dc5a6c96@mail.gmail.com>
In-Reply-To: <86802c440804272350y33d69a32o5533dc01dc5a6c96@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Yinghai Lu schrieb:
>>  reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>>  reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
>>  reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>>  reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>>  reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>>
>>  which screws up the X server's attempt to map the video memory at
>>  0xd0000000.
> 
> please try the patch at
> 
> http://lkml.org/lkml/2008/4/28/52
> 
> with mtrr_chunk_size=1g, and you should get
> 
> you should get
>>  reg00: base=0x00000000 ( 0MB), size=2048MB: write-back, count=1
>>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>>  reg02: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>>  reg03: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>>  reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1

Wow, thanks a lot for this patch! It almost works. This is what I get
with mtrr_chunk_size=1g:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg03: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
reg04: base=0x100001000 (4096MB), size=   4KB: write-back, count=1
reg05: base=0x100002000 (4096MB), size=   8KB: write-back, count=1
reg06: base=0x100004000 (4096MB), size=  16KB: write-back, count=1
reg07: base=0x100008000 (4096MB), size=  32KB: write-back, count=1

And this is what I get without mtrr_chunk_size=1g:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
reg06: base=0x100001000 (4096MB), size=   4KB: write-back, count=1
reg07: base=0x100002000 (4096MB), size=   8KB: write-back, count=1

I attached these outputs and the dmesgs to the bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=10508

dmesg with mtrr_chunk_size=1g:
http://bugzilla.kernel.org/attachment.cgi?id=15945

dmesg without mtrr_chunk_size=1g:
http://bugzilla.kernel.org/attachment.cgi?id=15946

There are some warnings in the output:
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory,
losing 1023MB of RAM.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at
/home/mika/src/linux-2.6/arch/x86/kernel/cpu/mtrr/main.c:1049
mtrr_trim_uncached_memory+0x118/0x250()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25 #5
[    0.000000]  [<c01273af>] warn_on_slowpath+0x5f/0x90
[    0.000000]  [<c03a8f9d>] _spin_unlock_irqrestore+0xd/0x10
[    0.000000]  [<c0127d4a>] release_console_sem+0x1ba/0x1e0
[    0.000000]  [<c01280d8>] vprintk+0x1c8/0x3a0
[    0.000000]  [<c010ebd3>] generic_get_mtrr+0x93/0x100
[    0.000000]  [<c01282cb>] printk+0x1b/0x20
[    0.000000]  [<c05069d8>] mtrr_trim_uncached_memory+0x118/0x250
[    0.000000]  [<c0504292>] setup_arch+0x312/0x590
[    0.000000]  [<c04fd774>] start_kernel+0x64/0x3a0
[    0.000000]  =======================
[    0.000000] ---[ end trace ca143223eefdc828 ]---

Let me know if there's anything else I can do to help!

Regards,
 Mika
