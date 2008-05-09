Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbYEIQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbYEIQgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYEIQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:36:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:50061 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbYEIQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=iYkwqqW+PTNtxJ0Rgqrk9jRcJbur5uG7qdUT+1bNqgxZ+3/cFX1rcfa/GTqTErJQD6KP/MWX31OQZ+NzNHN5VGUCFQ6zxPdzyfjZQ3r5vY25RfeUxAPdwepVxgSzmteNT8Wdi1n/Ar+CvyNyn+B3pd6uhDi2jLkwKby8DVNxZVY=
Date: Fri, 9 May 2008 18:36:29 +0200
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: dump shadow memory on errors
Message-ID: <20080509163629.GA9087@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Check this out. Cool or what? :-)

(The only thing I'm slightly concerned about is the correctness of the
copying -- we're rounding down to nearest SHADOW_COPY_SIZE and copying
upwards to the nearest SHADOW_COPY_SIZE. So as long as SHADOW_COPY_SHIFT
is less than PAGE_SHIFT, there should be no way we'll be able to cross a
page boundary during the shadow copy. Does this sound right?)

Vegard


>From f2cb6108e86d0c2dc73a1f89eb4f3ad843eeeb9b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 9 May 2008 18:09:56 +0200
Subject: [PATCH] kmemcheck: dump shadow memory on errors

This patch will save a (small) snapshot of the shadow memory
surrounding the target of an invalid access and displays it when the
report is printed. This in order to aid the debugging of errors.

A report now typically looks something like this:

  kmemcheck: Caught 32-bit read from uninitialized memory (c7809f14)
  iiiiiiiiiiiiiiiiiiiiuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
                      ^

  Pid: 1, comm: swapper Not tainted (2.6.26-rc1-00012-g0364f4e-dirty #42)
  EIP: 0060:[<c04032b1>] EFLAGS: 00000282 CPU: 0
  EIP is at pskb_expand_head+0x91/0x150
  EAX: 00000044 EBX: c7852140 ECX: 00000036 EDX: c78be000
  ESI: c7809f14 EDI: c78be094 EBP: c783bed0 ESP: c06c9dc8
   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
  CR0: 8005003b CR2: c74006e4 CR3: 006ba000 CR4: 00000680
  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
  DR6: 00004000 DR7: 00000000
   [<c01190f1>] kmemcheck_read+0xd1/0x160
   [<c01192de>] kmemcheck_access+0x15e/0x1a0
   [<c04bd2d6>] do_page_fault+0x5e6/0x690
   [<c04bb32a>] error_code+0x72/0x78
   [<c0417f46>] netlink_broadcast+0x66/0x370
   [<c041abba>] genl_ctrl_event+0x2fa/0x310
   [<c041b037>] genl_register_mc_group+0xe7/0x130
   [<c0698cf3>] genl_init+0x93/0xd0
   [<c06735c7>] kernel_init+0x127/0x290
   [<c0104cc7>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/Kconfig.debug      |   11 +++++++++++
 arch/x86/kernel/kmemcheck.c |   43 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 255d054..b758750 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -298,6 +298,17 @@ config KMEMCHECK_QUEUE_SIZE
 	  if the number of errors occuring between two bursts is larger than
 	  this number, the extra error reports will get lost.
 
+config KMEMCHECK_SHADOW_COPY_SHIFT
+	int "kmemcheck: shadow copy size (5 => 32 bytes, 6 => 64 bytes)"
+	depends on KMEMCHECK
+	range 2 8
+	default 6
+	help
+	  Select the number of shadow bytes to save along with each entry of
+	  the queue. These bytes indicate what parts of an allocation are
+	  initialized, uninitialized, etc. and will be displayed when an
+	  error is detected to help the debugging of a particular problem.
+
 config KMEMCHECK_PARTIAL_OK
 	bool "kmemcheck: allow partially uninitialized memory"
 	depends on KMEMCHECK
diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index f03024a..bdc66ae 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -37,6 +37,8 @@ enum kmemcheck_error_type {
 	ERROR_BUG,
 };
 
+#define SHADOW_COPY_SIZE (1 << CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT)
+
 struct kmemcheck_error {
 	enum kmemcheck_error_type type;
 
@@ -54,6 +56,8 @@ struct kmemcheck_error {
 	struct pt_regs		regs;
 	struct stack_trace	trace;
 	unsigned long		trace_entries[32];
+
+	enum shadow shadow_copy[SHADOW_COPY_SIZE];
 };
 
 /*
@@ -101,6 +105,9 @@ error_next_rd(void)
 	return e;
 }
 
+static void *
+address_get_shadow(unsigned long address);
+
 /*
  * Save the context of an error.
  */
@@ -111,6 +118,7 @@ error_save(enum shadow state, unsigned long address, unsigned int size,
 	static unsigned long prev_ip;
 
 	struct kmemcheck_error *e;
+	enum shadow *shadow_copy;
 
 	/* Don't report several adjacent errors from the same EIP. */
 	if (regs->ip == prev_ip)
@@ -136,6 +144,12 @@ error_save(enum shadow state, unsigned long address, unsigned int size,
 	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
 	e->trace.skip = 1;
 	save_stack_trace(&e->trace);
+
+	/* Round address down to nearest 16 bytes */
+	shadow_copy = address_get_shadow(address & ~(SHADOW_COPY_SIZE - 1));
+	BUG_ON(!shadow_copy);
+
+	memcpy(e->shadow_copy, shadow_copy, SHADOW_COPY_SIZE);
 }
 
 /*
@@ -171,7 +185,15 @@ error_recall(void)
 		[SHADOW_FREED]		= "freed",
 	};
 
+	static const char short_desc[] = {
+		[SHADOW_UNALLOCATED]	= 'a',
+		[SHADOW_UNINITIALIZED]	= 'u',
+		[SHADOW_INITIALIZED]	= 'i',
+		[SHADOW_FREED]		= 'f',
+	};
+
 	struct kmemcheck_error *e;
+	unsigned int i;
 
 	e = error_next_rd();
 	if (!e)
@@ -181,7 +203,20 @@ error_recall(void)
 	case ERROR_INVALID_ACCESS:
 		printk(KERN_ERR  "kmemcheck: Caught %d-bit read "
 			"from %s memory (%p)\n",
-			e->size, desc[e->state], (void *) e->address);
+			e->size, e->state < ARRAY_SIZE(desc) ?
+				desc[e->state] : "(invalid shadow state)",
+			(void *) e->address);
+
+		printk(KERN_INFO);
+		for (i = 0; i < SHADOW_COPY_SIZE; ++i) {
+			if (e->shadow_copy[i] < ARRAY_SIZE(short_desc))
+				printk("%c", short_desc[e->shadow_copy[i]]);
+			else
+				printk("?");
+		}
+		printk("\n");
+		printk(KERN_INFO "%*c\n",
+			1 + (int) (e->address & (SHADOW_COPY_SIZE - 1)), '^');
 		break;
 	case ERROR_BUG:
 		printk(KERN_EMERG "kmemcheck: Fatal error\n");
@@ -714,14 +749,14 @@ kmemcheck_read(struct pt_regs *regs, unsigned long address, unsigned int size)
 	if (status == SHADOW_INITIALIZED)
 		return;
 
-	/* Don't warn about it again. */
-	set(shadow, size);
-
 	if (kmemcheck_enabled)
 		error_save(status, address, size, regs);
 
 	if (kmemcheck_enabled == 2)
 		kmemcheck_enabled = 0;
+
+	/* Don't warn about it again. */
+	set(shadow, size);
 }
 
 static void
-- 
1.5.4.1

