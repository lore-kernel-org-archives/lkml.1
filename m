Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZHYJLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZHYJLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZHYJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:11:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54554 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZHYJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:11:46 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory  (f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
Date: Tue, 25 Aug 2009 12:11:47 +0300
Message-Id: <1251191507.26351.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:03 +0200, Vegard Nossum wrote:
> I don't know so much about the kmemleak internals, but this I can say
> about the kmemcheck part: According to your definition, an object is
> initialized if all the bytes of an object are initialized.
> 
> Is it possible that because of this, if we have a partially
> uninitialized object, kmemleak will not record the pointers found in
> that object? If so, it might skip valid pointers, and deem an object
> unreferenced. Which could make kmemleak give false-positives.
> 
> I think it would be better to ask kmemcheck on a per-pointer basis
> (i.e. for each pointer-sized word in the object), whether it is
> initialized or not.

Yeah, makes sense.

			Pekka

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 2c55ed0..528bf95 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -331,6 +331,20 @@ static void kmemcheck_read_strict(struct pt_regs *regs,
 	kmemcheck_shadow_set(shadow, size);
 }
 
+bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
+{
+	enum kmemcheck_shadow status;
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup(addr);
+	if (!shadow)
+		return true;
+
+	status = kmemcheck_shadow_test(shadow, size);
+
+	return status == KMEMCHECK_SHADOW_INITIALIZED;
+}
+
 /* Access may cross page boundary */
 static void kmemcheck_read(struct pt_regs *regs,
 	unsigned long addr, unsigned int size)
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index 47b39b7..dc2fd54 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -34,6 +34,8 @@ void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n);
 int kmemcheck_show_addr(unsigned long address);
 int kmemcheck_hide_addr(unsigned long address);
 
+bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
+
 #else
 #define kmemcheck_enabled 0
 
@@ -99,6 +101,11 @@ static inline void kmemcheck_mark_initialized_pages(struct page *p,
 {
 }
 
+static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
+{
+	return true;
+}
+
 #endif /* CONFIG_KMEMCHECK */
 
 /*
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 6debe0d..b075bf0 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -97,6 +97,7 @@
 #include <asm/processor.h>
 #include <asm/atomic.h>
 
+#include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 
 /*
@@ -885,7 +886,8 @@ static void scan_block(void *_start, void *_end,
 
 	for (ptr = start; ptr < end; ptr++) {
 		unsigned long flags;
-		unsigned long pointer = *ptr;
+		unsigned long pointer;
+
 		struct kmemleak_object *object;
 
 		if (allow_resched)
@@ -893,6 +895,13 @@ static void scan_block(void *_start, void *_end,
 		if (scan_should_stop())
 			break;
 
+		/* Don't scan uninitialized memory. */
+		if (!kmemcheck_is_obj_initialized((unsigned long) ptr,
+							sizeof(unsigned long)))
+			continue;
+
+		pointer = *ptr;
+
 		object = find_and_get_object(pointer, 1);
 		if (!object)
 			continue;


