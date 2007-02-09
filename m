Return-Path: <linux-kernel-owner+w=401wt.eu-S1946246AbXBIJTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946246AbXBIJTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:19:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946247AbXBIJTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:19:01 -0500
Received: from ozlabs.org ([203.10.76.45]:39256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946246AbXBIJS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:18:59 -0500
Subject: [PATCH 4/10] lguest: Initialize esp0 properly all the time
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171012458.2718.30.camel@localhost.localdomain>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012458.2718.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 20:18:13 +1100
Message-Id: <1171012693.2718.37.camel@localhost.localdomain>
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


