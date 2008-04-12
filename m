Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYDLQXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYDLQXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYDLQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:23:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:8297 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbYDLQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=jnHvyCM9j6JBgqx+Pc5MP9vjNMBV68VxxEcUEyuG+6TeS0pNhjRmz4MPc0sl3KnYGFPi1VpsAKLU7oaJEQUCYowKGHdpSmQ4SKMt2TQNpEKSPxUC6UIVcjECoioMHvhTZlYhipDy9h8I26H5tWFkXZWhDHDY0AlgBwNE2886BYs=
Message-ID: <4800E134.8040602@gmail.com>
Date: Sat, 12 Apr 2008 18:20:04 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, ijc@hellion.org.uk, tglx@linutronix.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: *_pagetable_setup_[start,done] crap ?
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

while investigating following section mismatch warning:
WARNING: arch/x86/mm/built-in.o(.text+0xf2): Section mismatch in reference from the function paravirt_pagetable_setup_start() to the function
 .init.text:native_pagetable_setup_start()

I have found something with looks quite strange for me. This section mismatch is really easy to fix, as paravirt_pagetable_setup_start() is used by __init pagetable_init().
paravirt_pagetable_setup_start() (body in include/asm-x86/pgtable_32.h) calls, #ifndef CONFIG_PARAVIRT, __init native_pagetable_setup_start(). Here everything is OK and case is clear: to fix that mismatch, we need to annotate paravirt_pagetable_setup_start() with __init.

Same situation applies to paravirt_pagetable_setup_done(), but here it calls __init native_pagetable_setup_done(). On the other hand native_pagetable_setup_done() is quite strange:
void __init native_pagetable_setup_done(pgd_t *base)
{
}

This ,,change'' was introduced by commit: 551889a6e2a24a9c06fd453ea03b57b7746ffdc0 (x86: construct 32-bit boot time page tables in native format.), diff:
 void __init native_pagetable_setup_done(pgd_t *base)
 {
-#ifdef CONFIG_X86_PAE
-       /*
-        * Add low memory identity-mappings - SMP needs it when
-        * starting up on an AP from real-mode. In the non-PAE
-        * case we already have these mappings through head.S.
-        * All user-space mappings are explicitly cleared after
-        * SMP startup.
-        */
-       set_pgd(&base[0], base[USER_PTRS_PER_PGD]);
-#endif
 }

native_pagetable_setup_done() is used in __init pagetable_init() through paravirt_pagetable_setup_done(), nothing really scary.
One can take a look at arch/x86/kernel/paravirt.c:
struct pv_mmu_ops pv_mmu_ops = {
#ifndef CONFIG_X86_64
        .pagetable_setup_start = native_pagetable_setup_start,
        .pagetable_setup_done = native_pagetable_setup_done,
#endif
So when paravirt_pagetable_setup_done() will be called while CONFIG_PARAVIRT set it will be exactly same function as aravirt_pagetable_setup_done() while CONFIG_PARAVIRT not set.

Ohh... and prototypes are wrong:
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 6cbc520..2167879 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -204,8 +204,8 @@ do {                                                \
  */
 #define update_mmu_cache(vma, address, pte) do { } while (0)

-void native_pagetable_setup_start(pgd_t *base);
-void native_pagetable_setup_done(pgd_t *base);
+extern void native_pagetable_setup_start(pgd_t *base) __init;
+extern void native_pagetable_setup_done(pgd_t *base) __init;

For me it looks like a complete crap :) Maybe it's OK, can anybody convince me?

-Jacek
