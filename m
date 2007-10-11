Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbXJKISR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbXJKISR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXJKISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:18:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010AbXJKISF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:18:05 -0400
Date: Thu, 11 Oct 2007 01:18:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
Message-Id: <20071011011800.0c051792.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 14:17:24 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> i386 and x86_64: randomize brk()

I seem to have a different copy of this patch from the one which you
originally sent.  It's the one which implements arch_randomize_brk() in
each arch's header file.  Mayeb it wasn't cc'ed to a mailing list of maybe
I just lost the email, dunno.

Anyway, it breaks on ia64:

  CC      arch/ia64/ia32/binfmt_elf32.o
In file included from arch/ia64/ia32/binfmt_elf32.c:49:
arch/ia64/ia32/../../../fs/binfmt_elf.c: In function `load_elf_binary':
arch/ia64/ia32/../../../fs/binfmt_elf.c:1085: error: implicit declaration of function `arch_randomize_brk'
make[1]: *** [arch/ia64/ia32/binfmt_elf32.o] Error 1
make: *** [arch/ia64/ia32/binfmt_elf32.o] Error 2

This is because ia64 takes the exceptional stupidity which is our
elf-handling build system and adds an extra layer of stupidity on top of
it.  Look:

akpm2:/usr/src/25> head include/asm-ia64/elf.h
#ifndef _ASM_IA64_ELF_H
#define _ASM_IA64_ELF_H

/*
 * ELF-specific definitions.
 *
 * Copyright (C) 1998-1999, 2002-2004 Hewlett-Packard Co
 *      David Mosberger-Tang <davidm@hpl.hp.com>
 */

akpm2:/usr/src/25> grep -r _ASM_IA64_ELF_H arch/ia64
arch/ia64/ia32/ia32priv.h:#define _ASM_IA64_ELF_H               /* Don't include elf.h */

can you believe this stuff?

Anyway, I'm presently running with this loveliness:


--- a/include/asm-ia64/elf.h~i386-and-x86_64-randomize-brk-2-fix
+++ a/include/asm-ia64/elf.h
@@ -249,8 +249,10 @@ do {									\
 
 #endif /* __KERNEL__ */
 
+#endif /* _ASM_IA64_ELF_H */
+
+#ifndef IA64_IS_WEIRD
 static inline void arch_randomize_brk(void)
 {
 }
-
-#endif /* _ASM_IA64_ELF_H */
+#endif
_

Wanna see if there's something saner we can do please?
