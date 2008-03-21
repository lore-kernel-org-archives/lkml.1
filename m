Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYCUTdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYCUTdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYCUTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:33:05 -0400
Received: from www.tglx.de ([62.245.132.106]:52222 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYCUTdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:33:01 -0400
Date: Fri, 21 Mar 2008 20:32:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] [3/3] Replace macro recursion with more conventional
 loop
In-Reply-To: <20080321171724.GF2346@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211953520.3781@apollo.tec.linutronix.de>
References: <20080311223.655043226@firstfloor.org> <20080311012322.B1E221B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0803211806590.3781@apollo.tec.linutronix.de> <20080321171724.GF2346@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:
> On Fri, Mar 21, 2008 at 06:07:55PM +0100, Thomas Gleixner wrote:
> > On Tue, 11 Mar 2008, Andi Kleen wrote:
> > > The early exception handlers are currently set up using a macro
> > > recursion. Replace that with a standard loop.
> > > 
> > > Noop patch, just a cleanup.
> > 
> > Cleanups before code changes please.
> 
> It relies on the earlier changes.

I just had a closer look. Your patch order makes sense. It's less
noise that way due to the previous removal of the 3 users of the macro. 

I applied the series with the following changes:

- Moved 3/3 before 2/3 to make it clear that this is a consecutive cleanup
- Simplified 3/3 (patch below)
- fixed the commit log of 3/3 so it points out why the cleanup is done 

Btw, can you please add a "x86:" prefix to your subject lines ?

Thanks,

	tglx
--

The early exception handlers are currently set up using a macro
recursion. There is only one user left. Replace the macro with a
standard loop in place.

--- linux-2.6.orig/arch/x86/kernel/head_64.S
+++ linux-2.6/arch/x86/kernel/head_64.S
@@ -269,15 +269,12 @@ bad_address:
 
 	.section ".init.text","ax"
 #ifdef CONFIG_EARLY_PRINTK
-.macro early_idt_tramp i
-	movl $\i, %esi
-	jmp early_idt_handler
-.endm
 	.globl early_idt_handlers
 early_idt_handlers:
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
-	early_idt_tramp i
+	movl $i, %esi
+	jmp early_idt_handler
 	i = i + 1
 	.endr
 #endif

