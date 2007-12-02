Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXLBLSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXLBLSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXLBLSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:41421 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbXLBLSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Aurelien Jarno <aurelien@aurel32.net>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 02/10] KVM: x86 emulator: fix access registers for instructions with ModR/M byte and Mod = 3
Date: Sun,  2 Dec 2007 13:18:39 +0200
Message-Id: <11965943274184-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
 drivers/kvm/x86_emulate.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 804e86c..08cd4a3 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -773,6 +773,14 @@ done_prefixes:
 	case SrcMem:
 		src.bytes = (d & ByteOp) ? 1 : op_bytes;
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
 		if ((rc = ops->read_emulated((unsigned long)src.ptr,
@@ -839,6 +847,15 @@ done_prefixes:
 		dst.type = OP_MEM;
 		dst.ptr = (unsigned long *)cr2;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
+		dst.val = 0;
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

