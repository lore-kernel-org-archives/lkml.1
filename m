Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbXBLDdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbXBLDdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXBLDdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:33:50 -0500
Received: from ozlabs.org ([203.10.76.45]:50826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbXBLDdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:33:49 -0500
Subject: [PATCH 2/7] cleanup: Initialize esp0 properly all the time
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>, Andi Kleen <ak@muc.de>
In-Reply-To: <1171251120.10409.2.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:33:05 +1100
Message-Id: <1171251185.10409.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever we schedule, __switch_to calls load_esp0 which does:

	tss->esp0 = thread->esp0;

This is never initialized for the initial thread (ie "swapper"), so
when we're scheduling that, we end up setting esp0 to 0.  This is
fine: the swapper never leaves ring 0, so this field is never used.

lguest, however, gets upset that we're trying to used an unmapped page
as our kernel stack.  Rather than work around it there, let's
initialize it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -421,6 +421,7 @@ struct thread_struct {
 };
 
 #define INIT_THREAD  {							\
+	.esp0 = sizeof(init_stack) + (long)&init_stack,			\
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\


