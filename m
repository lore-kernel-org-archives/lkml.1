Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYFROLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYFROLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYFROLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:11:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYFROLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xBM4AqF+2DNBhdnSTKW7xjueJff3vu9HA0ucjg1RAY/qE1ogphYGHwjkVrGcaonBvT
         oIHiR5G/M4oj0g02eVntK0x9QPNLKpmju74mlM0VdtUd1m96eQKMMa92LrNxlEmh8zrA
         JQmezflEQJR2wMe5Qz12ieO5ImKuP9GRt8XRU=
Message-ID: <48591799.6050508@gmail.com>
Date: Wed, 18 Jun 2008 16:11:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/1] MM: virtual address debug
References: <1213271800-1556-1-git-send-email-jirislaby@gmail.com> <20080618121221.GB13714@elte.hu> <20080618135928.GA12803@elte.hu>
In-Reply-To: <20080618135928.GA12803@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napsal(a):
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> Add some (configurable) expensive sanity checking to catch wrong address
>>> translations on x86.
>>>
>>> - create linux/mmdebug.h file to be able include this file in
>>>   asm headers to not get unsolvable loops in header files
>>> - __phys_addr on x86_32 became a function in ioremap.c since
>>>   PAGE_OFFSET, is_vmalloc_addr and VMALLOC_* non-constasts are undefined
>>>   if declared in page_32.h
>>> - add __phys_addr_const for initializing doublefault_tss.__cr3
>> applied, thanks Jiri. I have created a new tip/x86/mm-debug topic for 
>> this because the patch touches mm/vmalloc.c and other MM bits.
> 
> -tip testing triggered an early boot crash and i have bisected it down 
> to your patch. The crash:
> 
> No NUMA configuration found
> Faking a node at 0000000000000000-000000003fff0000
> Entering add_active_range(0, 0, 159) 0 entries of 25600 used
> Entering add_active_range(0, 256, 262128) 1 entries of 25600 used
> Bootmem setup node 0 0000000000000000-000000003fff0000
>   NODE_DATA [000000000000a000 - 000000000003dfff]
> PANIC: early exception 06 rip 10:ffffffff80ba7531 error 0 cr2 f06f53

Expception 06 is an invalid opcode. This is maybe a false positive, probably 
a mistake in phys_to_nid, I'll look into that, thanks.

> Pid: 0, comm: swapper Not tainted 2.6.26-rc6 #7709
> 
> Call Trace:
>  [<ffffffff80b9c196>] early_idt_handler+0x56/0x6a
>  [<ffffffff80ba7531>] setup_node_bootmem+0x12a/0x2d4
>  [<ffffffff80ba7505>] setup_node_bootmem+0xfe/0x2d4
>  [<ffffffff80b9dd73>] setup_arch+0x2a2/0x3e7
>  [<ffffffff8024e858>] clockevents_register_notifier+0x2d/0x31
>  [<ffffffff80b9cb5d>] start_kernel+0x8d/0x30a
>  [<ffffffff80b9f87d>] reserve_early+0x16/0xad
>  [<ffffffff80b9c35f>] x86_64_start_kernel+0x16d/0x174
> 
> RIP 0x10
