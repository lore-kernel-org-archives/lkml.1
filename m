Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbYCDRRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbYCDRRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761505AbYCDRQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:16:42 -0500
Received: from gw.goop.org ([64.81.55.164]:46066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761348AbYCDRQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:16:41 -0500
Message-ID: <47CD82C5.8060605@goop.org>
Date: Tue, 04 Mar 2008 09:11:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Mark McLoughlin <markmc@redhat.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
References: <47C22568.1010405@zytor.com>   <1203958478.20033.1239002461@webmail.messagingengine.com>   <20080225170134.GA15839@elte.hu>   <20080225180750.GA31054@mailshack.com>   <20080228131341.GA25213@mailshack.com>   <1204232996.28798.8.camel@cthulhu.hellion.org.uk>   <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>   <1204310323.24514.1239870063@webmail.messagingengine.com>   <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com>   <1204631082.16613.7.camel@muff> <47CD6858.9070603@goop.org> <1204649476.5048.1240509149@webmail.messagingengine.com>
In-Reply-To: <1204649476.5048.1240509149@webmail.messagingengine.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Tue, 04 Mar 2008 07:18:48 -0800, "Jeremy Fitzhardinge"
> <jeremy@goop.org> said:
>   
>> Mark McLoughlin wrote:
>>     
>>> This is a bit magic, is it worth splitting it out as something like
>>> is_paravirt_environment() ?
>>>   
>>>       
>> Yes, is_paravirt() already exists for this purpose.
>>     
>
> Hi,
>
> If it exists, it is well-hidden. A grep for is_paravirt on the testing
> tree turns up nothing. Did you get the name right?
>   

Nope.  paravirt_enabled().

>> The code looking at the boot params will only work if we actually booted 
>> via the paravirt Linux boot protocol, which Xen doesn't at present.
>>     
>
> I chose to code it exactly this way, because it is what is used in
> head_32.S to choose how to start the kernel. Or is this code not
> executed at all?
>   

No, this isn't executed when booting under Xen.  Xen is a bit magic, and 
has its own kernel entrypoint which the domain builder finds via 
Xen-specific ELF notes on the vmlinux.  We plan to move to booting via 
this path at some point.

> [excerpt form head_32.S]
>         cmpw $0x207, pa(boot_params + BP_version)
>         jb default_entry
>
>         /* Paravirt-compatible boot parameters.  Look to see what
>         architecture
>                 we're booting under. */
>         movl pa(boot_params + BP_hardware_subarch), %eax
>         cmpl $num_subarch_entries, %eax
>         jae bad_subarch
>
>         movl pa(subarch_entries)(,%eax,4), %eax
>         subl $__PAGE_OFFSET, %eax
>         jmp *%eax
> [and]
> subarch_entries:
>         .long default_entry             /* normal x86/PC */
>         .long lguest_entry              /* lguest hypervisor */
>         .long xen_entry                 /* Xen hypervisor */
> num_subarch_entries = (. - subarch_entries) / 4
> [end]
>
> If this is indeed not executed, is there a way to detect whether
> we can expect the environment to behave like a normal pc in terms
> of magic addresses, bios areas, isa reserved address space and so
> on?
>   

Just because something is paravirtualized and uses a non-PC 
hardware_subarch doesn't mean this stuff isn't present.  Even the 
paravirt_enabled() test isn't accurate, because the environment may 
still choose to emulate these things (or in the Xen dom0 case, it may 
directly expose the real hardware).

    J
