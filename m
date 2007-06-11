Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbXFKOTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbXFKOTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXFKOTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:19:33 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:64648 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751839AbXFKOTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:19:32 -0400
Date: Mon, 11 Jun 2007 16:19:26 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kernel BUG at mm/slub.c:3689!
Message-ID: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to get SLUB debugging to not break DMA on AVR32, I ran
into this:

(...)
adding slab: name=kmalloc-64 size=64 objsize=64
adding slab: name=kmalloc-32 size=32 objsize=32
adding slab: name=kmalloc-16 size=32 objsize=16
kobject_add failed for :0000032 with -EEXIST, don't try to register things with the same name in the same directory.
Call trace:
 [<9000f14e>] dump_stack+0x1a/0x24
 [<90093144>] kobject_shadow_add+0xc4/0xe8
 [<90093170>] kobject_add+0x8/0xc
 [<9003ded8>] sysfs_slab_add+0xc8/0x10c
 [<900046c6>] slab_sysfs_init+0x26/0x78
 [<900003f0>] kernel_init+0x74/0x1c0
 [<90015cd0>] do_exit+0x0/0x52c

------------[ cut here ]------------
kernel BUG at /home/hskinnemoen/git/linux/mm/slub.c:3689!
Oops: Kernel BUG, sig: 9 [#1]
FRAME_POINTER chip: 0x01f:0x1e82 rev 0
Modules linked in:
PC is at slab_sysfs_init+0x28/0x78
LR is at 0x9014e654
pc : [<900046c8>]    lr : [<9014e654>]    Not tainted
sp : 901cbf98  r12: ffffffef  r11: 00000001
r10: 00000001  r9 : 00000000  r8 : 9014e654
r7 : 901cbf98  r6 : 9014a2b4  r5 : 00000000  r4 : 00000000
r3 : 00000000  r2 : 90015cd0  r1 : 9000b4d0  r0 : 00000000
Flags: qvNzc
Mode bits: hrje....g
CPU Mode: Supervisor
Process: swapper [1] (task: 901c9000 thread: 901ca000)
Stack: (0x901cbf98 to 0x901cc000)
bf80:                                                       900003f0 901cbfdc
bfa0: 90009b20 00000000 00000000 00000000 00000000 00000000 00400000 9000ebd0
bfc0: 9000ebd0 901cc000 00000000 00000000 00000000 00000000 00000000 90015cd0
bfe0: 00000000 00000000 00000000 00000000 00000000 90015cd0 9000037c 00000000
Call trace:
 [<900003f0>] kernel_init+0x74/0x1c0
 [<90015cd0>] do_exit+0x0/0x52c

Kernel panic - not syncing: Attempted to kill init!


The "adding slab" messages were added by me; see the patch below.

I think the combination that triggered this bug was:
  * CONFIG_SLUB_DEBUG=y
  * ARCH_KMALLOC_MINALIGN=32
  * slub_debug not set at the command line

If I disable CONFIG_SLUB_DEBUG or add slub_debug to the command line,
everything is fine.

Please let me know if you need any additional information.

Haavard

diff --git a/include/asm-avr32/cache.h b/include/asm-avr32/cache.h
index dabb955..d3cf35a 100644
--- a/include/asm-avr32/cache.h
+++ b/include/asm-avr32/cache.h
@@ -4,6 +4,15 @@
 #define L1_CACHE_SHIFT 5
 #define L1_CACHE_BYTES (1 << L1_CACHE_SHIFT)
 
+/*
+ * Memory returned by kmalloc() may be used for DMA, so we must make
+ * sure that all such allocations are cache aligned. Otherwise,
+ * unrelated code may cause parts of the buffer to be read into the
+ * cache before the transfer is done, causing old data to be seen by
+ * the CPU.
+ */
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #ifndef __ASSEMBLER__
 struct cache_info {
 	unsigned int ways;
diff --git a/mm/slub.c b/mm/slub.c
index c9ab688..6c45b4c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3587,6 +3587,9 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		/* Defer until later */
 		return 0;
 
+	printk(KERN_NOTICE "adding slab: name=%s size=%d objsize=%d\n",
+			s->name, s->size, s->objsize);
+
 	unmergeable = slab_unmergeable(s);
 	if (unmergeable) {
 		/*
