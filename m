Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZLISsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZLISsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbZLISrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:47:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042AbZLISrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:47:53 -0500
Date: Wed, 9 Dec 2009 10:47:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
In-Reply-To: <4B1FED0D.7060003@goop.org>
Message-ID: <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Jeremy Fitzhardinge wrote:
> 
> How does this look?

I would actually prefer it if the calling convention was just made to 
match on both x86 and x86-64. Wouldn't it be nice if they both just had

> +/* kernel/ioport.c */
> +asmlinkage long sys_iopl(unsigned int, struct pt_regs *);

as the prototype, and looked the same?

I realize that right now the 32-bit PTREGSCALL() thing doesn't support 
that (very different macros for entry.S x86-32 and -64), but isn't that 
just another thing we should try to fix too?

IOW, maybe something like this would be good, and would change the x86-32 
calling convention to match the x86-64 one?

NOTE NOTE NOTE! Totally untested. Is the second argument even in %edx? I 
don't remember, I didn't check, I'm just throwing this out as a "hey, 
maybe something _like_ this can work" patch, and will be immediately 
removing it from my machine after sending this email.

		Linus

---
 arch/x86/kernel/entry_32.S |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 50b9c22..22b4431 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -725,22 +725,22 @@ END(syscall_badsys)
 /*
  * System calls that need a pt_regs pointer.
  */
-#define PTREGSCALL(name) \
+#define PTREGSCALL(name, reg) \
 	ALIGN; \
 ptregs_##name: \
-	leal 4(%esp),%eax; \
+	leal 4(%esp),reg; \
 	jmp sys_##name;
 
-PTREGSCALL(iopl)
-PTREGSCALL(fork)
-PTREGSCALL(clone)
-PTREGSCALL(vfork)
-PTREGSCALL(execve)
-PTREGSCALL(sigaltstack)
-PTREGSCALL(sigreturn)
-PTREGSCALL(rt_sigreturn)
-PTREGSCALL(vm86)
-PTREGSCALL(vm86old)
+PTREGSCALL(iopl,%edx)
+PTREGSCALL(fork,%eax)
+PTREGSCALL(clone,%eax)
+PTREGSCALL(vfork,%eax)
+PTREGSCALL(execve,%eax)
+PTREGSCALL(sigaltstack,%eax)
+PTREGSCALL(sigreturn,%eax)
+PTREGSCALL(rt_sigreturn,%eax)
+PTREGSCALL(vm86,%eax)
+PTREGSCALL(vm86old,%eax)
 
 .macro FIXUP_ESPFIX_STACK
 /*
