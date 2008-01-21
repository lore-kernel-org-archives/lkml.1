Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYAUTAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYAUTAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYAUTAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:00:40 -0500
Received: from gw.goop.org ([64.81.55.164]:50859 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbYAUTAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:00:39 -0500
Message-ID: <4794EBD2.6010804@goop.org>
Date: Mon, 21 Jan 2008 11:00:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] Fix early_ioremap on x86-64 II
References: <20080120172840.GA24608@basil.nowhere.org> <20080120180431.GA7452@basil.nowhere.org>
In-Reply-To: <20080120180431.GA7452@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This patch changes all flushes in init_64.c to be __flush_tlb_all()
>> and fixes the problem here.
>>     
>
> Hmm, I see new early crashes with that patch here in some cases unfortunately:
>
> PANIC: early exception 06 rip 10:ffffffff8082df2d error 0 cr2 0
> Pid: 0, comm: swapper Not tainted 2.6.24-rc8-g7ada4254 #39
>
> Call Trace:
>  [<ffffffff8082df2d>] free_bootmem_core+0x1a/0x6b
>  [<ffffffff8082f143>] free_bootmem_with_active_regions+0x51/0x67
>  [<ffffffff8082a0f3>] setup_node_bootmem+0x16b/0x1b3
>  [<ffffffff8082b3a4>] acpi_scan_nodes+0x136/0x230
>  [<ffffffff8082a6bb>] numa_initmem_init+0x331/0x459
>  [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
>  [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
>  [<ffffffff80355726>] number+0x10e/0x1f9
>  [<ffffffff802354d8>] printk+0x4e/0x56
>  [<ffffffff80355726>] number+0x10e/0x1f9
>  [<ffffffff803563f8>] vsnprintf+0x53f/0x583
>  [<ffffffff80355726>] number+0x10e/0x1f9
>  [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
>  [<ffffffff803563f8>] vsnprintf+0x53f/0x583
>  [<ffffffff8022468a>] early_serial_write+0x22/0x32
>
> Not sure what's going wrong. I think the patch is correct, but there
> are probably more bugs around triggered by some change. Perhaps it is 
> better to just revert Jeremy's patch (789bad4ca2b604f2f21ae7e3d64b67325ec8f9bb) for now.
>   

It's a purely "make things prettier" patch, so I have no problem with 
that.   If the non-global flags used in early 64-bit pagetables is very 
deeply ingrained, I wonder if its worth making a separate set of 
explicitly non-global _PAGE_KERNEL flags for its use, so that at least 
_PAGE_KERNEL* is consistent between 32 and 64 bits.  Otherwise its going 
to be the sort of difference which gets increasingly awkward as things 
get unified (I guess its mitigated by the fact that 32-bit code can 
never assume that global mappings are available and present).

    J
