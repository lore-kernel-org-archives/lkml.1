Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbYDULlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbYDULlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbYDULlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:41:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbYDULli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:41:38 -0400
Message-ID: <480C7C4E.6070309@zytor.com>
Date: Mon, 21 Apr 2008 07:36:46 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Andres Salomon <dilinger@queued.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419031024.GC3503@nineveh.local>	<20080418202925.b18452c5.akpm@linux-foundation.org>	<20080419092544.378664a8@ephemeral>	<20080419133909.5aa6b63e@ephemeral>	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	<480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral> <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com> <480C0C5B.2050403@firmworks.com>
In-Reply-To: <480C0C5B.2050403@firmworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Bradley wrote:
> 
> d) OFW itself lives at the top of the virtual address space, just below 
> the ROM.  (The ROM is mapped virtual=physical  for convenience)  OFW 
> uses RAM allocated from the top of physical memory, mapped at the 
> aforementioned high virtual addresses.  One page directory entry - the 
> next to last one - is used for that RAM mapping and also for mapping 
> additional miscellaneous I/O devices.  The 8MB frame buffer requires 2 
> additional PDEs, just below.  When Linux takes over the display, OFW no 
> longer needs the frame buffer mapping, but it is convenient to preserve 
> that mapping temporarily while using OFW as a debugger.
> 

So let me see here... you want the virtual address range [0xffc00000, 
0xfff00000) to be reserved for OFW, and you are prohibiting the kernel 
from using PAE?

> e) Low memory - everything except the ~1Meg that OFW lives in - is 
> mapped virtual=physical.

Are you making this assumption when called from the kernel, too?

> j) Linux must save the following information during early startup:
>  1) The callback function address - either from the initial value of eax 
> or from the OFW info block.
>  2) The the next-to-last page directory entry - just the pointer to the 
> page table.  The page table itself lives in OFW's reserved memory.
> 
> k) When calling back into OFW, Linux must:
>  1) Establish a page directory that contains OFW's PDE (saved in j2 
> above) and that maps the client interface argument array, including any 
> buffer pointers.
>  2) Call callback_function with the address of the argument array in 
> eax.  (Ordinary 32-bit near call).
> 
> For all of the OLPC kernel's current callbacks into OFW, the 
> requirements (j2) and (k1) are easily satisfied by "priming" 
> swapper_pg_dir with the contents of the current page directory (as 
> pointed to by the CR3 register).

I do not like it, simply because it amounts to "initialize this 
otherwise zero-initialized piece of data without making any kind of 
reservations and blindly hope nothing else overwrites it."

I'm also troubled with the assumption that the kernel doesn't use PAE. 
I realize that this is not an issue for OLPC, but it certainly makes 
this a less-than-generic solution.

Having mapped page table entries which are not under kernel control is a 
very serious problem for PAT - PAT requires, by hardware specification, 
the kernel to eliminate all potential aliases with different mappings.

One way to deal with this, of course, is to save the firmware-provided 
PGD and only use it for OFW calls.  On the other hand, perhaps a better 
questions is to what extent it is needed at all.

Furthermore, since you're using a nonstandard OFW interface (not 
compliant with the x86 OFW binding document), all of this should be 
called something like OLPC_OFW to make it clear that it's the OLPC variant.

If I had designed this, I would probably have used an SMI; since you 
have control over the firmware you can do that.  SMI saves the entire 
machine state including all the modes, cleans them all up for you, and 
puts it all back together at RSM time.  It is slow, of course, but it 
completely decouples the firmware and the OS, which is why it's used.

	-hpa

