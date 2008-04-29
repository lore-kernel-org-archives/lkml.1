Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbYD2Pas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbYD2Pas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYD2Paj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:30:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:6095 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbYD2Pai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tymVktdRFUDX3w4fUJyrYQTw+yCJ43m9p7uHOqy2BSLCYooZeF214+y3vjbQxbTAEnVAGo6Y1wfoDBmxFHWbpphH36PT1LYnfLqDOFFuMstAenuDbJqloKO98G2FCRm/pdtZovLHFpFUk9KkB6jv62f+i4Qj9VrIgYXkl5VjTgo=
Date: Tue, 29 Apr 2008 19:29:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
Message-ID: <20080429152947.GB6837@cvg>
References: <20080424144120.GA7717@cvg> <4810CC2F.3010600@zytor.com> <20080428182323.GD1685@elte.hu> <20080428192039.GA10267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428192039.GA10267@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Apr 28, 2008 at 09:20:39PM +0200]
| 
| Cyrill,
| 
| randconfig testing in x86.git found a build bug and i bisected it to 
| your patch - output is below. Config attached. Looks like some config 
| file dependency hell problem? The dependencies there definitely need a 
| good look and a handful of cleanups as well.
| 
| 	Ingo
| 
| --------------------->
| In file included from include/asm/vm86.h:139,
|                  from include/asm/processor.h:11,
|                  from include/asm/atomic_32.h:6,
|                  from include/asm/atomic.h:3,
|                  from include/linux/crypto.h:21,
|                  from arch/x86/kernel/asm-offsets_32.c:8,
|                  from arch/x86/kernel/asm-offsets.c:3:
| include/asm/ptrace.h: In function 'user_mode_vm':
| include/asm/ptrace.h:207: error: 'X86_VM_MASK' undeclared (first use in this function)
| include/asm/ptrace.h:207: error: (Each undeclared identifier is reported only once
| include/asm/ptrace.h:207: error: for each function it appears in.)
| include/asm/ptrace.h: In function 'v8086_mode':
| include/asm/ptrace.h:217: error: 'X86_VM_MASK' undeclared (first use in this function)

Argh! Ingo, it seems that the real problem was introdused by

commit 8fc37f2c474b8ea61186fd77193324845432447b
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Oct 23 22:37:24 2007 +0200

    x86: merge ptrace_32/64.h
        
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

with this patch we have <asm/vm86.h> included only
if __i386__ defined *BUT* X86_VM_MASK is tried to be
used *without* __386__ being checked (as example - ptrace.h:user_mode_vm).
I'm not sure how to properly hanle this situation. But will take a look.

So I suggest you drop my last patch (which moves X86_VM_MASK
into __KERNEL__ section) for a while. I'll recheck all
this stuff later (too busy now).

		- Cyrill -
