Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYHGAgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYHGAgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYHGAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:35:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYHGAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:35:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from;
	b=Waq6QygBiFzfusDX6A/B4mCte1mSKxqt3XElFfYb7CMJ40szcwoJCVpyw3Nwv+1IA
	VAWEWKClj9jnT+ntyVVTA==
To: mingo@redhat.com, tglx@linutronix.de
Subject: [PATCH] x86: prevent binaries from making system calls using the wrong syscall interface
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080807003459.37CC629624@localhost>
Date: Wed,  6 Aug 2008 17:34:59 -0700 (PDT)
From: md@google.com (Michael Davidson)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent binaries from making system calls using other than one
of the "normal" system call interfaces for that binary type.

Currently there is nothing to prevent 64 bit binaries from
attempting to make system calls using the 32 bit system call
interfaces and vice versa.

Since the 32 bit and 64 bit system call numbers are different
this means that a binary could attempt to obfuscate which system
calls it was actually making by using the "wrong" system call
interface. In particular, the call to audit_syscall_entry()
relies on checking the TIF_IA32 flag to determine whether it is
dealing with a 32 or 64 bit system call without regard to the
actual type of system call that was made.While this specific issue
could be addressed by checking the TS_COMPAT flag in threadinfo_status
it seems preferable to simply disallow this situation altogether.


Signed-off-by: Michael Davidson <md@google.com>

---

Index: linux-2.6.26.2/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.26.2.orig/arch/x86/ia32/ia32entry.S	2008-08-06 09:19:01.000000000 -0700
+++ linux-2.6.26.2/arch/x86/ia32/ia32entry.S	2008-08-06 13:34:54.566992000 -0700
@@ -123,6 +123,8 @@
  	.quad 1b,ia32_badarg
  	.previous	
 	GET_THREAD_INFO(%r10)
+	testl  $_TIF_IA32,threadinfo_flags(%r10)
+	jz     ia32_bad_abi
 	orl    $TS_COMPAT,threadinfo_status(%r10)
 	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 	CFI_REMEMBER_STATE
@@ -230,6 +232,8 @@
 	.quad 1b,ia32_badarg
 	.previous	
 	GET_THREAD_INFO(%r10)
+	testl $_TIF_IA32,threadinfo_flags(%r10)
+	jz    ia32_bad_abi
 	orl   $TS_COMPAT,threadinfo_status(%r10)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 	CFI_REMEMBER_STATE
@@ -324,6 +328,8 @@
 	   this could be a problem. */
 	SAVE_ARGS 0,0,1
 	GET_THREAD_INFO(%r10)
+	testl $_TIF_IA32,threadinfo_flags(%r10)
+	jz    ia32_bad_abi
 	orl   $TS_COMPAT,threadinfo_status(%r10)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 	jnz ia32_tracesys
@@ -347,6 +353,8 @@
 	jmp ia32_do_syscall
 END(ia32_syscall)
 
+ia32_bad_abi:
+	CFI_REMEMBER_STATE
 ia32_badsys:
 	movq $0,ORIG_RAX-ARGOFFSET(%rsp)
 	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
Index: linux-2.6.26.2/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.26.2.orig/arch/x86/kernel/entry_64.S	2008-08-06 09:19:01.000000000 -0700
+++ linux-2.6.26.2/arch/x86/kernel/entry_64.S	2008-08-06 13:26:28.771994000 -0700
@@ -244,7 +244,7 @@
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP|_TIF_IA32),threadinfo_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
@@ -318,6 +318,8 @@
 
 	/* Do syscall tracing */
 tracesys:			 
+	testl $_TIF_IA32,threadinfo_flags(%rcx)
+	jnz badsys
 	SAVE_REST
 	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
 	FIXUP_TOP_OF_STACK %rdi
