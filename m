Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZHYJ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZHYJ04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZHYJ0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:26:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60066 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZHYJ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:26:54 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory  (f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191507.26351.0.camel@penberg-laptop>
	 <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
Date: Tue, 25 Aug 2009 12:26:55 +0300
Message-Id: <1251192415.26351.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 10:21 +0100, Catalin Marinas wrote:
> On Tue, 2009-08-25 at 12:11 +0300, Pekka Enberg wrote:
> > On Tue, 2009-08-25 at 11:03 +0200, Vegard Nossum wrote:
> > > I don't know so much about the kmemleak internals, but this I can say
> > > about the kmemcheck part: According to your definition, an object is
> > > initialized if all the bytes of an object are initialized.
> > > 
> > > Is it possible that because of this, if we have a partially
> > > uninitialized object, kmemleak will not record the pointers found in
> > > that object? If so, it might skip valid pointers, and deem an object
> > > unreferenced. Which could make kmemleak give false-positives.
> > > 
> > > I think it would be better to ask kmemcheck on a per-pointer basis
> > > (i.e. for each pointer-sized word in the object), whether it is
> > > initialized or not.
> > 
> > Yeah, makes sense.
> 
> I think this patch should work. With a few minor (aesthetic) things
> below and assuming that Ingo tests it (I don't have x86 hardware at hand
> now):

Does this look OK to you?

>From 2ee25007d6bfe931ff2ae6c7e22a098578fb2dc5 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Tue, 25 Aug 2009 12:22:51 +0300
Subject: [PATCH] kmemleak: Don't scan uninitialized memory when kmemcheck is enabled

Ingo Molnar reported the following kmemcheck warning when running both
kmemleak and kmemcheck enabled:

  PM: Adding info for No Bus:vcsa7
  WARNING: kmemcheck: Caught 32-bit read from uninitialized memory
  (f6f6e1a4)
  d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
   i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
           ^

  Pid: 3091, comm: kmemleak Not tainted (2.6.31-rc7-tip #1303) P4DC6
  EIP: 0060:[<c110301f>] EFLAGS: 00010006 CPU: 0
  EIP is at scan_block+0x3f/0xe0
  EAX: f40bd700 EBX: f40bd780 ECX: f16b46c0 EDX: 00000001
  ESI: f6f6e1a4 EDI: 00000000 EBP: f10f3f4c ESP: c2605fcc
   DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
  CR0: 8005003b CR2: e89a4844 CR3: 30ff1000 CR4: 000006f0
  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
  DR6: ffff4ff0 DR7: 00000400
   [<c110313c>] scan_object+0x7c/0xf0
   [<c1103389>] kmemleak_scan+0x1d9/0x400
   [<c1103a3c>] kmemleak_scan_thread+0x4c/0xb0
   [<c10819d4>] kthread+0x74/0x80
   [<c10257db>] kernel_thread_helper+0x7/0x3c
   [<ffffffff>] 0xffffffff
  kmemleak: 515 new suspected memory leaks (see
  /sys/kernel/debug/kmemleak)
  kmemleak: 42 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

The problem here is that kmemleak will scan partially initialized
objects that makes kmemcheck complain. Fix that up by skipping
uninitialized memory regions when kmemcheck is enabled.

Reported-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |   14 ++++++++++++++
 include/linux/kmemcheck.h         |    7 +++++++
 mm/kmemleak.c                     |   12 ++++++++++--
 3 files changed, 31 insertions(+), 2 deletions(-)

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
index 6debe0d..e217c21 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -97,6 +97,7 @@
 #include <asm/processor.h>
 #include <asm/atomic.h>
 
+#include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 
 /*
@@ -884,15 +885,22 @@ static void scan_block(void *_start, void *_end,
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
 
 	for (ptr = start; ptr < end; ptr++) {
-		unsigned long flags;
-		unsigned long pointer = *ptr;
 		struct kmemleak_object *object;
+		unsigned long flags;
+		unsigned long pointer;
 
 		if (allow_resched)
 			cond_resched();
 		if (scan_should_stop())
 			break;
 
+		/* Don't scan uninitialized memory. */
+		if (!kmemcheck_is_obj_initialized((unsigned long) ptr,
+							BYTES_PER_POINTER))
+			continue;
+
+		pointer = *ptr;
+
 		object = find_and_get_object(pointer, 1);
 		if (!object)
 			continue;
-- 
1.5.6.3



