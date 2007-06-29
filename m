Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXF2Vtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXF2Vtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXF2Vtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:49:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2528 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbXF2Vte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:49:34 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 0/6] sys_indirect RFC - sys_indirect introduction
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set implements the skeleton for a new sys_indirect() system call.
The reason for such system call would be to avoid the proliferation of new
system calls, introduced to only wrap old ones by setting/unsetting a given
context before/after the real system call.
The internal operation of sys_indirect() would be (pseudo-code):

	for_each_ctx(wrap_ctx, &user_ctxs) {
		save_prev_ctx(&saved_chain, tsk->xxx);
		tsk->xxx = wrap_ctx;
	}
	err = call_system_call(nr, params);
	for_each_saved_ctx(ctx, &saved_chain) {
		restore_ctx(tsk->xxx, ctx);
	}
	return err;

To made sys_indirect() decently flexible, and to avoid a sys_indirect2()
anytime soon, a simple "flags" parameter is clearly not sufficent to be
passed down with it.
To be flexible we need to allow 1) more than a simple "flags" to be passed
down 2) more than one context possibly to be set before the real system
call.  Also, the data structures passed down as new-context-to-be-set should
be compat-free, in order to simplify the compat code.
The prototype for sys_indirect() is:

	struct indirect_ctx {
		__u32 ctx;
	};

	long sys_indirect(unsigned int nr,
			const struct indirect_ctx **ctxs,
			unsigned int nctxs,
			const unsigned long *params);

The "struct indirect_ctx" is a stub structure that is supposed to be the
base for all the context set/unset operations.
An example usage for userspace POV (referring to the example in the next
patches) is:

[include/linux/indirect.h]
	#define SYSIND_CTX_OPENFLAGS	0
	struct sysind_ctx_OPENFLAGS {
		__u32 ctx;
		__u32 flags;
	};

[userspace]
	struct sysind_ctx_OPENFLAGS octx;
	struct indirect_ctx *ctxs[1];
	unsigned long params[6];
	
	octx.ctx = SYSIND_CTX_OPENFLAGS;
	octx.flags = O_CLOEXEC;
	ctxs[0] = (struct indirect_ctx *) &octx;
	params[0] = domain;
	params[1] = type;
	params[2] = proto;
	res = indirect(__NR_socket, ctxs, 1, params);


The sys_indirect() system call requires a small arch-dependent asm function
call_syscall() in order to call a system call by passing call number and
parameters (compat_call_syscall() is also needed for archs having 32 bit compat).
I currently implemented them for i386 and x86-64.
The following patches builds but are totally untested at the moment.
Comments?




- Davide


