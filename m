Return-Path: <linux-kernel-owner+w=401wt.eu-S933935AbYDNSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935AbYDNSbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbYDNSba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:31:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48894 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765723AbYDNSb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:31:27 -0400
Date: Mon, 14 Apr 2008 20:31:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
Message-ID: <20080414183156.GA15287@uranus.ravnborg.org>
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org> <20080414085307.GG19865@elte.hu> <20080414085927.GC11372@uranus.ravnborg.org> <48031FA7.9050803@gmail.com> <20080414095259.GA11966@uranus.ravnborg.org> <48033E2C.2080504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48033E2C.2080504@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> GCC is ok, I mean it inlines paravirt_pagetable_setup_[start,done] even with
> CONFIG_OPTIMIZE_INLINING=y:
> $ objdump -t vmlinux.o | grep pagetable_setup_start
> 0000a418 g     F .init.text     000000a1 native_pagetable_setup_start
> 
> While running with CONFIG_DEBUG_SECTION_MISMTCH=y it does not inline
> paravirt_pagetable_setup_start (_done is OK):
> $ objdump -t vmlinux.o | grep pagetable_setup_start
> 00017100 l     F .text  0000000b paravirt_pagetable_setup_start
> 00009fb0 g     F .init.text     00000089 native_pagetable_setup_start
> 
> DEBUG_SECTION_MISMATCH probably generated mismatch with smpboot_setup_io_apic()
> (commit: 96c968742fa1e6d64f979464acf2fd90cdc117b3, already merged). I will check
> and if __init is really superfluous I will post delta patch to remove all those
> __init annotations.
> 
> Similar situation might be found with unlock_ExtINT_logic()
> (arch/x86/kernel/io_apic_32.c), which I annotated with __init in one of previous
> patches, but here, this function IMO shouldn't be marked inline.

Hi Jacek.

Please consider following code snippet:

static void __init foo() {}

static void __init bar() { foo(); }

static void __init baz() { bar(); }

Browsing this code it makes perfect sense that when baz()
is annotated __init bar and suddenly foo() has same annotation.

There is no point in removing the __init annotation of bar()
just becasue we happen to know it will be inlined by gcc.
Removing the __init anotation is actually wrong - because
the __init annotation has a two-fold purpose.
It is used to locate this function in a section that
is later discarded.
But it is also used to document that this function
is only used in the early init of this driver/what-ever.
So using this function in non-__init code is wrong.

Therefore I recommend to keep the __init annotation
also for the inline functions - assuming these functions
are supposed to be used only in the early init as the annotation
says they are.

	Sam
