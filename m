Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbXLWOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbXLWOwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXLWOvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:40 -0500
Received: from il.qumranet.com ([82.166.9.18]:35866 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXLWOvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:37 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 01/50] KVM: x86 emulator: Add vmmcall/vmcall to x86_emulate (v3)
Date: Sun, 23 Dec 2007 16:50:46 +0200
Message-Id: <1198421495-31481-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

Add vmmcall/vmcall to x86_emulate.  Future patch will implement functionality
for these instructions.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index bd46de6..84af9cc 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1380,6 +1380,12 @@ twobyte_insn:
 			u16 size;
 			unsigned long address;
 
+		case 0: /* vmcall */
+			if (modrm_mod != 3 || modrm_rm != 1)
+				goto cannot_emulate;
+
+			/* nop */
+			break;
 		case 2: /* lgdt */
 			rc = read_descriptor(ctxt, ops, src.ptr,
 					     &size, &address, op_bytes);
@@ -1387,12 +1393,17 @@ twobyte_insn:
 				goto done;
 			realmode_lgdt(ctxt->vcpu, size, address);
 			break;
-		case 3: /* lidt */
-			rc = read_descriptor(ctxt, ops, src.ptr,
-					     &size, &address, op_bytes);
-			if (rc)
-				goto done;
-			realmode_lidt(ctxt->vcpu, size, address);
+		case 3: /* lidt/vmmcall */
+			if (modrm_mod == 3 && modrm_rm == 1) {
+				/* nop */
+			} else {
+				rc = read_descriptor(ctxt, ops, src.ptr,
+						     &size, &address,
+						     op_bytes);
+				if (rc)
+					goto done;
+				realmode_lidt(ctxt->vcpu, size, address);
+			}
 			break;
 		case 4: /* smsw */
 			if (modrm_mod != 3)
-- 
1.5.3.7

