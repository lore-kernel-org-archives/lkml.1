Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYDNLZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYDNLZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYDNLY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:24:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:31394 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYDNLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=l2boMnyEcLG4SUeTcnAvGQM2g5jhtvybEx4GViOce1gI4HQmFEv/7XtguU+LajiQYPeMTU+K5QSfd4HQ1/yfWx/jlpa/wLUdmVgKoq+tmQj5RRbuzISvzJkAvU2KpimobRiH2AIrmUV/CRtAvjmDp2dEXDIE5/xzmzbnsBAH4DA=
Message-ID: <48033E2C.2080504@gmail.com>
Date: Mon, 14 Apr 2008 13:21:16 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org> <20080414085307.GG19865@elte.hu> <20080414085927.GC11372@uranus.ravnborg.org> <48031FA7.9050803@gmail.com> <20080414095259.GA11966@uranus.ravnborg.org>
In-Reply-To: <20080414095259.GA11966@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg pisze:
> On Mon, Apr 14, 2008 at 11:11:03AM +0200, Jacek Luczak wrote:
>> Sam Ravnborg pisze:
>>> On Mon, Apr 14, 2008 at 10:53:07AM +0200, Ingo Molnar wrote:
>>>> * Sam Ravnborg <sam@ravnborg.org> wrote:
>>>>
>>>>>> hm, that's an interesting case: we need those annotations probably 
>>>>>> because gcc decided to not inline those functions. (this is possible 
>>>>>> via the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take 
>>>>>> on that?
>>>>> gcc uses different heuristics for inlining between the different 
>>>>> versions. Therefore to achieve somehow predictable results I added 
>>>>> -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH 
>>>>> is enabled.
>>>>>
>>>>> So in the above case for any normal kernel build we would see that gcc 
>>>>> inlined the above and everything is fine. But for the 
>>>>> CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and thus we see 
>>>>> that we have a section mismatch.
>>>> ah, ok. So i guess this will result in a few isolated cases of __init 
>>>> annotations added to inline functions - Jacek fixed one such case - but 
>>>> it should not result in the general spreading of __init annotations to 
>>>> inline functions, correct? (which i was worried about)
>>> I do not think so. The need for small isolated inline functions
>>> in the init paths are minimal and last I did a section mismatch free
>>> sweep on the kernel it was only few if any inline functions(*) I had
>>> to annotate.
>>>
>>> (*) Considering only the minimal amount of function that ought
>>> to be annotated inlined.
>> There's a lot of inline __init functions already - which, on the other hand
>> should not result in more of such. Attached you can find grep on tree which
>> shows all inline __init functions (you won't find my paravirt_pagetable_setup_*
>> functions in output as I removed __init for test).
> 
> Most of the functionas listed should never have been annotated inline.
> If you filter aways the functions that are in one one of their
> incarnations longer than 8 lines or are located in a .c file the list
> is much shorter. This is the real candidates (the figure '8' is just bad way
> to filter away 'complex' functions).
> Your paravirt_pagetable_setup_done is a real one btw.

It's worth of closer investigation I think.

>> Sam, do -fno-inline-functions-called-once could affect
>> paravirt_pagetable_setup_done? In general there was no section mismatch warning
>> for this function, but I've annotated it also.
> Most liekly yes - but I did not check.

GCC is ok, I mean it inlines paravirt_pagetable_setup_[start,done] even with
CONFIG_OPTIMIZE_INLINING=y:
$ objdump -t vmlinux.o | grep pagetable_setup_start
0000a418 g     F .init.text     000000a1 native_pagetable_setup_start

While running with CONFIG_DEBUG_SECTION_MISMTCH=y it does not inline
paravirt_pagetable_setup_start (_done is OK):
$ objdump -t vmlinux.o | grep pagetable_setup_start
00017100 l     F .text  0000000b paravirt_pagetable_setup_start
00009fb0 g     F .init.text     00000089 native_pagetable_setup_start

DEBUG_SECTION_MISMATCH probably generated mismatch with smpboot_setup_io_apic()
(commit: 96c968742fa1e6d64f979464acf2fd90cdc117b3, already merged). I will check
and if __init is really superfluous I will post delta patch to remove all those
__init annotations.

Similar situation might be found with unlock_ExtINT_logic()
(arch/x86/kernel/io_apic_32.c), which I annotated with __init in one of previous
patches, but here, this function IMO shouldn't be marked inline.

-Jacek
