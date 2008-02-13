Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYBMLEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYBMLEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764559AbYBMLE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:04:27 -0500
Received: from mx1.suse.de ([195.135.220.2]:46676 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763983AbYBMLE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:04:26 -0500
Message-ID: <47B2CEFD.4020208@suse.de>
Date: Wed, 13 Feb 2008 12:05:33 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/8] RFC: Fix some EFI problems
References: <200802111034.764275766@suse.de> <20080211093436.EAFB11B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0802122043460.12988@apollo.tec.linutronix.de> <200802122123.08732.ak@suse.de> <alpine.LFD.1.00.0802122145050.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802122145050.12988@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 12 Feb 2008, Andi Kleen wrote:
> 
>> On Tuesday 12 February 2008 21:04:06 Thomas Gleixner wrote:
>>
>>> And you just copied the real bug in that logic as well:
>>>
>>>           set_memory_uc(md->virt_addr, size);
>> Oops you're right. I wanted to fix that, but didn't. Ok I'll put up
>> my brown paper back tonight when I go out.
>>  
>>> ------------------------^^^^^^^^
>>>
>>> which is initialized a couple of lines down.
>>>
>>> 	md->virt_addr = (u64) (unsigned long) va;
>>>
>>> The reordering/optimizing needs to be a separate patch.
>> What optimizing? It wasn't intended to be an optimization.
>> It fixes a bug.
> 
> No, it does not. Please go back and read my mail.

I describe the problem again:

- efi_ioremap on 64bit returns a fixmap address:
void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long
size)
{
       ...
        return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE -
                                             (pages_mapped - pages));

}
- __fix_to_virt is:
 (FIXADDR_TOP - ((x) << PAGE_SHIFT)) and x is a small integer <30 or so.
- Fixmap is
#define VSYSCALL_END (-2UL << 20)
#define FIXADDR_TOP (VSYSCALL_END-PAGE_SIZE)
that gives e.g. 0xffffffdfffff for the top fixmap; the efi fixmap
is only slightly pages below.
- You pass that into set_memory_uc()
- That eventually calls __pa() on it several times
(in static_protections and in change_page_attr_addr for 64bit to
check for the kernel mapping)
- __pa calls __phys_addr which does
unsigned long __phys_addr(unsigned long x)
{
        if (x >= __START_KERNEL_map)
                return x - __START_KERNEL_map + phys_base;
        return x - PAGE_OFFSET;
}
- Now __START_KERNEL_map is 0xffffffff80000000.
- That ends up with

x = 0xffffffdfffff - smallnumber*PAGE_SIZE

if (x >= 0xffffffff80000000)    (evaluates to true)
	return x - 0xffffffff80000000 + phys_addr
- This ends up with some fictional number in cpa (but likely one
looking like a valid pa address) that has nothing
to do with the address that is mapped below the fixmap
- cpa() does weird things to random unrelated memory then or
might clear rw if you're really unlucky.
- I think on 32bit with a real ioremap it's also not completely kosher
with the right __PAGE_OFFSET (but I have not double checked
that step by step)

This is why I avoided calling set_memory_uc for the fixmap
and instead changed the code to set the correct PAT
attribute into the fixmap directly to avoid this.

I believe the full original change or some Thomasized variant of it
is still needed.

-Andi
