Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXFQQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXFQQwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXFQQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:52:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:32298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbXFQQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YJg+Wy/VxO/gXc7+dCyj/2jSnDyUTa0UEbPPUihm2NkSrRL27fD7DXGZ6V39zTvOj8+eQnjeRI2zfQ86Q2RF3JyQ8Zxkd4ZLBRAXv0pBM3ofhCMIY88I939wHWTq7Zj3vyfWqzeD2GNCUckgczqhIVmAVOkRgLXQuXuEo0lJ9xk=
Date: Sun, 17 Jun 2007 18:52:01 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kvm: Fix x86 emulator writeback
Message-ID: <20070617165201.GA23885@dreamland.darkstar.lan>
Mail-Followup-To: Avi Kivity <avi@qumranet.com>,
	kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4675523C.9020703@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the old value and new one are the same the emulator skips the
write; this is undesiderable when the destination is a MMIO area and the
write shall be performed regardless of the previous value. This
optimization breaks e.g. a Linux guest APIC compiled without
X86_GOOD_APIC.

Remove the check and always perform the writeback stage in the
emulation.

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>

---
 drivers/kvm/x86_emulate.c |   60 +++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a4a8481..cea9f3a 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1057,40 +1057,38 @@ done_prefixes:
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
-		switch (dst.type) {
-		case OP_REG:
-			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
-			switch (dst.bytes) {
-			case 1:
-				*(u8 *)dst.ptr = (u8)dst.val;
-				break;
-			case 2:
-				*(u16 *)dst.ptr = (u16)dst.val;
-				break;
-			case 4:
-				*dst.ptr = (u32)dst.val;
-				break;	/* 64b: zero-ext */
-			case 8:
-				*dst.ptr = dst.val;
-				break;
-			}
+	switch (dst.type) {
+	case OP_REG:
+		/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
+		switch (dst.bytes) {
+		case 1:
+			*(u8 *)dst.ptr = (u8)dst.val;
 			break;
-		case OP_MEM:
-			if (lock_prefix)
-				rc = ops->cmpxchg_emulated((unsigned long)dst.
-							   ptr, &dst.orig_val,
-							   &dst.val, dst.bytes,
-							   ctxt);
-			else
-				rc = ops->write_emulated((unsigned long)dst.ptr,
-							 &dst.val, dst.bytes,
-							 ctxt);
-			if (rc != 0)
-				goto done;
-		default:
+		case 2:
+			*(u16 *)dst.ptr = (u16)dst.val;
+			break;
+		case 4:
+			*dst.ptr = (u32)dst.val;
+			break;	/* 64b: zero-ext */
+		case 8:
+			*dst.ptr = dst.val;
 			break;
 		}
+		break;
+	case OP_MEM:
+		if (lock_prefix)
+			rc = ops->cmpxchg_emulated((unsigned long)dst.
+						   ptr, &dst.orig_val,
+						   &dst.val, dst.bytes,
+						   ctxt);
+		else
+			rc = ops->write_emulated((unsigned long)dst.ptr,
+						 &dst.val, dst.bytes,
+						 ctxt);
+		if (rc != 0)
+			goto done;
+	default:
+		break;
 	}
 
 	/* Commit shadow register state. */

Luca
-- 
Software is like sex; it's better when it's free.
Linus Torvalds
