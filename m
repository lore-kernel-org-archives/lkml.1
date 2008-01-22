Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYAVF0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYAVF0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYAVF0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:26:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYAVF0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:26:04 -0500
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: The SMP alternatives code breaks exception fixup?
References: <479504F6.4080005@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Jan 2008 06:26:03 +0100
In-Reply-To: <479504F6.4080005@redhat.com>
Message-ID: <p73zluymnx0.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:
> 
> There is a fixup, so this should never happen. But the lock instruction
> was replaced with a nop by the altinstruction code, and that makes the fixup
> address wrong. AFAICT we don't fix up the exception table when we replace
> a lock with a nop, which makes the fixup table point to the nop instead
> of the cmpxchg instruction and causes us to miss the fixup.

Indeed.  Nasty issue.

A quick fix would be to add another fixup to handle both cases
I checked the other LOCK_PREFIX users and they look ok.

Does this fix it?

-Andi

(untested) 

---

Add exception handlers for both the LOCK and no LOCK prefix
case in futex.

Hopefully fixes https://bugzilla.redhat.com/show_bug.cgi?id=429412

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-x86/futex.h
===================================================================
--- linux.orig/include/asm-x86/futex.h
+++ linux/include/asm-x86/futex.h
@@ -30,7 +30,7 @@
 "1:	movl	%2, %0\n					\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n			\
+"2:	" LOCK_PREFIX "\n5: cmpxchgl %3, %2\n			\
 	jnz	1b\n						\
 3:	.section .fixup,\"ax\"\n				\
 4:	mov	%5, %1\n					\
@@ -38,7 +38,7 @@
 	.previous\n						\
 	.section __ex_table,\"a\"\n				\
 	.align	8\n"						\
-	_ASM_PTR "1b,4b,2b,4b\n					\
+	_ASM_PTR "1b,4b,2b,4b,5b,4b\n				\
 	.previous"						\
 	: "=&a" (oldval), "=&r" (ret), "+m" (*uaddr),		\
 	  "=&r" (tem)						\
