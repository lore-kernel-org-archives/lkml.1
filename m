Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbYBQPUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbYBQPUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYBQPT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:19:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:31501 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbYBQPT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=ey5VtUzloPuxoPmiR8fwBPF0/u0yJT/ejd7o0BJDlnvmwPp8/26cYmvZLWBq5EDNcYROeRlJpJOB/Z9Fh1q3vBfjpuhOg1uVestuVDAXSbxwA6v0Y9aYRvaebFy89AhJY5WpSi5jC5oZ9sXDfGh5eRO28DoG9HiYjXKzMsn+x+M=
Message-Id: <20080217151925.402628615@gmail.com>
References: <20080217151716.274134094@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 17 Feb 2008 18:17:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: ak@suse.de, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric constant
Content-Disposition: inline; filename=x86-thread-size
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though we use PDA for regular task stack but that
is not acceptable for init_task wich is special
one. We still have to allocate init_task's stack
in that manner.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Ingo, Peter, I can be wrong but take a look please
to x86/lgest/i386_head.S:41

	/* Set up the initial stack so we can run C code. */
	movl $(init_thread_union+THREAD_SIZE),%esp

if we just eliminate this string from lds scripts - I bet
we get bad situation here. Xen has a similar trick.
And even head_32.S and head_64.S both have

32bits
======
ENTRY(stack_start)
	.long init_thread_union+THREAD_SIZE

64bits
======
	ENTRY(init_rsp)
	.quad  init_thread_union+THREAD_SIZE-8

So if we just remove that string from lds file - we will
be screwed up I think ;)

Index: linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/vmlinux_64.lds.S	2008-02-17 13:56:54.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S	2008-02-17 14:10:21.000000000 +0300
@@ -129,7 +129,7 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-  . = ALIGN(8192);		/* init_task */
+  . = ALIGN(THREAD_SIZE);	/* init_task */
   .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
 	*(.data.init_task)
   }:data.init

-- 
