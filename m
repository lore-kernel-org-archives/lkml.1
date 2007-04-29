Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbXD2K5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbXD2K5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbXD2Kxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbXD2KxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:14 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [24/48] i386: Initialize esp0 properly all the time
Message-Id: <20070429105313.462CC15108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

Whenever we schedule, __switch_to calls load_esp0 which does:

	tss->esp0 = thread->esp0;

This is never initialized for the initial thread (ie "swapper"), so when we're
scheduling that, we end up setting esp0 to 0.  This is fine: the swapper never
leaves ring 0, so this field is never used.

lguest, however, gets upset that we're trying to used an unmapped page as our
kernel stack.  Rather than work around it there, let's initialize it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/processor.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -421,6 +421,7 @@ struct thread_struct {
 };
 
 #define INIT_THREAD  {							\
+	.esp0 = sizeof(init_stack) + (long)&init_stack,			\
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\
