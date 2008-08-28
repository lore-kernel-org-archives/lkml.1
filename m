Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYH1RTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYH1RTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYH1RTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:19:10 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3660 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYH1RTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:19:08 -0400
Date: Thu, 28 Aug 2008 12:14:39 -0500 (CDT)
Message-Id: <200808281714.m7SHEdCX096569@sullivan.realtime.net>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [BUG] linux-next: Tree for August 26 - Badness at kernel/notifier.c:25 
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, mingo@elte.hu,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1219935307.7107.302.camel@pmac.infradead.org>
References: <1219935307.7107.302.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Woodhouse dwmw2 at infradead.org
Fri Aug 29 00:55:07 EST 2008

> On Thu, 2008-08-28 at 15:23 +0100, David Woodhouse wrote:
>> On Thu, 2008-08-28 at 00:38 +1000, Stephen Rothwell wrote:
>>> Hi Arjan,
>>> 
>>> On Thu, 28 Aug 2008 00:33:08 +1000 Stephen Rothwell <sfr at canb.auug.org.au> wrote:
>>>>
>>>> The original reported trace was during setup_system which is very early in
>>>> the boot.
>>> 
>>> But, of course, that version didn't have the necessary extra dereference
>>> of the function address ...
>>> 
>>> And the later debug patch did not check the address at register time,
>>> only at notify time.
>>> 
>>> The later trace also looks to be early in the boot.
>> 
>> It's isa_bridge_notify(), which is neither within _[se]text nor
>> _[se]inittext, so the core_kernel_text() function disavows it.
>> 
>> Where are __devinit functions supposed to end up?
> 
> The TEXT_TEXT macro defined in <asm-generic/vmlinux.lds.h> should get
> this right... but we don't use it. Is there any particular reason for
> that, or should we....

gitk -- arch/powerpc/kernel/vmlinux.S

	e95c91821fa56b489d7beb74103a419466c5ec10
	[POWERPC] Fix link errors for allyesconfig
    
    An allyesconfig build creates a .text section that is so big that the
    .text.init.refok and .fixup sections are too far away for the relocations
    to be fixed up correctly. This patch fixes that by linking all the
    relevent text sections for each file together.
    
    Suggested by Paul Mackerras.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>


Although I think its really fac23fe4be23259a8eaa9bad822f5b14dd07d15c 
powerpc: Introduce infrastructure for feature sections with alternatives
that causes the problems.

If the problem is only reaching the branch-out-of-fixup-section, then
we could create a macro that caculates the branch as if it were already
at the destination address (using something like

	b (target-fixup_start)-(current-alternative_start)

and then removing the code that determines the branch target goes beyond
the feature section.

Just a concept, have't tried it yet and don't know if there are other
problems with .text.init.refok.

Or we fix our defintion and put a comment next to TEXT_TEXT that we
don't use it for future editors.

> 
> Signed-off-by: David Woodhouse <David.Woodhouse at intel.com>
> 
> --- linux-2.6.26.ppc64/arch/powerpc/kernel/vmlinux.lds.S~	2008-07-13 22:51:29.000000000 +0100
> +++ linux-2.6.26.ppc64/arch/powerpc/kernel/vmlinux.lds.S	2008-08-28 15:39:14.000000000 +0100
> @@ -35,10 +35,11 @@ SECTIONS
>  		ALIGN_FUNCTION();
>  		*(.text.head)
>  		_text = .;
> -		*(.text .fixup .text.init.refok .exit.text.refok)
> +		TEXT_TEXT
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT
> +		*(.fixup)
>  
>  #ifdef CONFIG_PPC32
>  		*(.got1)
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse at intel.com                              Intel Corporation
