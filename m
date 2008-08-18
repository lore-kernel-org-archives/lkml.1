Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYHRJPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYHRJPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYHRJP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:15:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58833 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYHRJPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:15:24 -0400
Date: Mon, 18 Aug 2008 11:15:23 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818091522.GA6635@atrey.karlin.mff.cuni.cz>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818064120.GA28941@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * David Fries <david@fries.net> wrote:
> 
> > arch/x86/power/cpu_32.c __save_processor_state calls read_cr4() only a 
> > i486 CPU doesn't have the CR4 register.  Trying to read it produces an 
> > invalid opcode oops during suspend to disk.
> > 
> > Added the check (boot_cpu_data.x86 >= 5) before reading the register.  
> > If the value to be written is zero the write is skipped.
> > 
> > arch/x86/power/hibernate_asm_32.S
> > done: swapped the use of %eax and %ecx to use jecxz for
> > the zero test and jump over store to %cr4.
> > restore_image: s/%ecx/%eax/ to be consistent with done:
> > 
> > In addition to __save_processor_state, acpi_save_state_mem, 
> > efi_call_phys_prelog, and efi_call_phys_epilog had checks added (acpi 
> > restore was in assembly and already had a check for non-zero).  There 
> > were other reads and writes of CR4, but MCE and virtualization 
> > shouldn't be executed on a i486 anyway.
> > 
> > Signed-off-by: David Fries <david@fries.net>
> 
> applied to tip/x86/urgent, thanks David. I've changed the conditions to 
> read_cr4_safe() instead - that's cleaner. Could you please check whether 
> the patch below works fine too on your box?
> 
> Rafael, Pavel - does the commit below look good to you too?
> 
> 	Ingo
> 
> ---------------------->
> >From e437fa5586f2e3b2aaeba649fae52be1f9a6eabb Mon Sep 17 00:00:00 2001
> From: David Fries <david@fries.net>
> Date: Sun, 17 Aug 2008 23:03:40 -0500
> Subject: [PATCH] x86: fix i486 suspend to disk CR4 oops
> 
> arch/x86/power/cpu_32.c __save_processor_state calls read_cr4()
> only a i486 CPU doesn't have the CR4 register.  Trying to read it
> produces an invalid opcode oops during suspend to disk.
> 
> Use the safe rc4 reading op instead. If the value to be written is
> zero the write is skipped.
> 
> arch/x86/power/hibernate_asm_32.S
> done: swapped the use of %eax and %ecx to use jecxz for
> the zero test and jump over store to %cr4.
> restore_image: s/%ecx/%eax/ to be consistent with done:
> 
> In addition to __save_processor_state, acpi_save_state_mem,
> efi_call_phys_prelog, and efi_call_phys_epilog had checks added
> (acpi restore was in assembly and already had a check for
> non-zero).  There were other reads and writes of CR4, but MCE and
> virtualization shouldn't be executed on a i486 anyway.
> 
> Signed-off-by: David Fries <david@fries.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Pavel Machek <pavel@suse.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
