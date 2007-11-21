Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbXKUKUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbXKUKUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXKUKUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:20:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbXKUKUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:20:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/5] x86: use get_desc_base
In-Reply-To: Roland McGrath's message of  Wednesday, 21 November 2007 02:19:28 -0800 <20071121101928.A08CF26F8BE@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
Emacs: a real time environment for simulating molasses-based life forms.
Message-Id: <20071121102037.A960326F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 02:20:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes a couple of places to use the get_desc_base function.
They were duplicating the same calculation with different equivalent code.

Signed-off-by: Roland McGrath <roland@redhat.com>

diff --git a/arch/x86/ia32/tls32.c b/arch/x86/ia32/tls32.c
index 1cc4340..5291596 100644
--- a/arch/x86/ia32/tls32.c
+++ b/arch/x86/ia32/tls32.c
@@ -85,11 +85,6 @@ asmlinkage long sys32_set_thread_area(struct user_desc __user *u_info)
  * Get the current Thread-Local Storage area:
  */
 
-#define GET_BASE(desc) ( \
-	(((desc)->a >> 16) & 0x0000ffff) | \
-	(((desc)->b << 16) & 0x00ff0000) | \
-	( (desc)->b        & 0xff000000)   )
-
 #define GET_LIMIT(desc) ( \
 	((desc)->a & 0x0ffff) | \
 	 ((desc)->b & 0xf0000) )
@@ -117,7 +112,7 @@ int do_get_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
 
 	memset(&info, 0, sizeof(struct user_desc));
 	info.entry_number = idx;
-	info.base_addr = GET_BASE(desc);
+	info.base_addr = get_desc_base(desc);
 	info.limit = GET_LIMIT(desc);
 	info.seg_32bit = GET_32BIT(desc);
 	info.contents = GET_CONTENTS(desc);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..b8d131d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -453,11 +453,7 @@ static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 
 static inline u32 read_32bit_tls(struct task_struct *t, int tls)
 {
-	struct desc_struct *desc = (void *)t->thread.tls_array;
-	desc += tls;
-	return desc->base0 | 
-		(((u32)desc->base1) << 16) | 
-		(((u32)desc->base2) << 24);
+	return get_desc_base(&t->thread.tls_array[tls]);
 }
 
 /*
