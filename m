Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXDAOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXDAOiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933278AbXDAOiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:38:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:47560 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbXDAOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 36/41] KVM: x86 emulator: fix bit string operations operand size
Date: Sun,  1 Apr 2007 17:35:33 +0300
Message-Id: <11754381392948-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381393714-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com> <11754381391161-git-send-email-avi@qumranet.com> <11754381393714-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, bit operations operate on a string of bits that can reside in
multiple words.  For example, 'btsl %eax, (blah)' will touch the word
at blah+4 if %eax is between 32 and 63.

The x86 emulator compensates for that by advancing the operand address
by (bit offset / BITS_PER_LONG) and truncating the bit offset to the
range (0..BITS_PER_LONG-1).  This has a side effect of forcing the operand
size to 8 bytes on 64-bit hosts.

Now, a 32-bit guest goes and fork()s a process.  It write protects a stack
page at 0xbffff000 using the 'btr' instruction, at offset 0xffc in the page
table, with bit offset 1 (for the write permission bit).

The emulator now forces the operand size to 8 bytes as previously described,
and an innocent page table update turns into a cross-page-boundary write,
which is assumed by the mmu code not to be a page table, so it doesn't
actually clear the corresponding shadow page table entry.  The guest and
host permissions are out of sync and guest memory is corrupted soon
afterwards, leading to guest failure.

Fix by not using BITS_PER_LONG as the word size; instead use the actual
operand size, so we get a 32-bit write in that case.

Note we still have to teach the mmu to handle cross-page-boundary writes
to guest page table; but for now this allows Damn Small Linux 0.4 (2.4.20)
to boot.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 7513cdd..bcf872b 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -833,8 +833,9 @@ done_prefixes:
 		dst.ptr = (unsigned long *)cr2;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
 		if (d & BitOp) {
-			dst.ptr += src.val / BITS_PER_LONG;
-			dst.bytes = sizeof(long);
+			unsigned long mask = ~(dst.bytes * 8 - 1);
+
+			dst.ptr = (void *)dst.ptr + (src.val & mask) / 8;
 		}
 		if (!(d & Mov) && /* optimisation - avoid slow emulated read */
 		    ((rc = ops->read_emulated((unsigned long)dst.ptr,
-- 
1.5.0.5

