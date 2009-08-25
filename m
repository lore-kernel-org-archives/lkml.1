Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZHYIy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZHYIy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZHYIy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:54:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49221 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZHYIy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:54:26 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory (f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090825084808.GA14003@elte.hu>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu>
Date: Tue, 25 Aug 2009 11:54:26 +0300
Message-Id: <1251190466.7261.12.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 10:48 +0200, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Tue, 2009-08-25 at 10:32 +0200, Ingo Molnar wrote:
> > > > In any case, I don't think it is very productive to run them both 
> > > > at the same time, simply because kmemcheck slows every memory 
> > > > access down so much and scanning memory doesn't exactly help that. 
> > > > It _could_ be useful to have them compiled into the same kernel, 
> > > > though, e.g. a distro "-debug" kernel.
> > > > 
> > > > Maybe you can just add the "depends on !KMEMLEAK" to 
> > > > CONFIG_KMEMCHECK in tip/out-of-tree for now?
> > > 
> > > i think it would be far more intelligent to annotate those accesses 
> > > by kmemleak as 'trust me, dont check'. Willing to test such a patch.
> > 
> > I guess something like this totally untested patch should do it. 
> > Vegard, Catalin?
> 
> Looks good - but doesnt apply cleanly to -tip because i picked up a 
> number of kmemleak patches into tip:out-of-tree for testing - so 
> i'll leave it up for Vegard/Catalin to do a blessed version of it 
> against the kmemleak tree - which i hope will apply fine to tip too
> :)

I thik this should be fine for -tip.

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
index 6debe0d..73947e4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -97,6 +97,7 @@
 #include <asm/processor.h>
 #include <asm/atomic.h>
 
+#include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 
 /*
@@ -951,6 +952,8 @@ static void scan_object(struct kmemleak_object *object)
 	if (!(object->flags & OBJECT_ALLOCATED))
 		/* already freed object */
 		goto out;
+	if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
+		goto out;
 	if (hlist_empty(&object->area_list)) {
 		void *start = (void *)object->pointer;
 		void *end = (void *)(object->pointer + object->size);


