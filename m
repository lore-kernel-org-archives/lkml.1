Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbXJULKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbXJULKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXJULH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:58445 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXJULHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/11] KVM: x86 emulator: fix access registers for instructions with ModR/M byte and Mod = 3
Date: Sun, 21 Oct 2007 13:08:09 +0200
Message-Id: <11929648921167-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

The patch belows changes the access type to register from memory for
instructions that are declared as SrcMem or DstMem, but have a
ModR/M byte with Mod = 3.

It fixes (at least) the lmsw and smsw instructions on an AMD64 CPU,
which are needed for FreeBSD.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 0a8696d..a6ace30 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -825,6 +825,14 @@ done_prefixes:
 		if (twobyte && b == 0x01 && modrm_reg == 7)
 			break;
 	      srcmem_common:
+		/*
+		 * For instructions with a ModR/M byte, switch to register
+		 * access if Mod = 3.
+		 */
+		if ((d & ModRM) && modrm_mod == 3) {
+			src.type = OP_REG;
+			break;
+		}
 		src.type = OP_MEM;
 		src.ptr = (unsigned long *)cr2;
 		src.val = 0;
@@ -893,6 +901,14 @@ done_prefixes:
 		dst.ptr = (unsigned long *)cr2;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
 		dst.val = 0;
+		/*
+		 * For instructions with a ModR/M byte, switch to register
+		 * access if Mod = 3.
+		 */
+		if ((d & ModRM) && modrm_mod == 3) {
+			dst.type = OP_REG;
+			break;
+		}
 		if (d & BitOp) {
 			unsigned long mask = ~(dst.bytes * 8 - 1);
 
-- 
1.5.3

