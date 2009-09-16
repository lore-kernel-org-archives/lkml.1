Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbZIPWny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbZIPWny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933600AbZIPWnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:43:42 -0400
Received: from kroah.org ([198.145.64.141]:55399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583AbZIPWkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:19 2009
Message-Id: <20090916223718.880939612@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 38/45] KVM: x86 emulator: Implement zero-extended immediate decoding
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-emulator-implement-zero-extended-immediate-decoding.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

commit c9eaf20f268c7051bfde2ba212c5ea76a6cbc7a1 upstream.

Absolute jumps use zero extended immediate operands.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86_emulate.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -60,6 +60,7 @@
 #define SrcImmByte  (6<<4)	/* 8-bit sign-extended immediate operand. */
 #define SrcOne      (7<<4)	/* Implied '1' */
 #define SrcImmUByte (8<<4)      /* 8-bit unsigned immediate operand. */
+#define SrcImmU     (9<<4)      /* Immediate operand, unsigned */
 #define SrcMask     (0xf<<4)
 /* Generic ModRM decode. */
 #define ModRM       (1<<8)
@@ -1027,6 +1028,7 @@ done_prefixes:
 		c->src.type = OP_MEM;
 		break;
 	case SrcImm:
+	case SrcImmU:
 		c->src.type = OP_IMM;
 		c->src.ptr = (unsigned long *)c->eip;
 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
@@ -1044,6 +1046,19 @@ done_prefixes:
 			c->src.val = insn_fetch(s32, 4, c->eip);
 			break;
 		}
+		if ((c->d & SrcMask) == SrcImmU) {
+			switch (c->src.bytes) {
+			case 1:
+				c->src.val &= 0xff;
+				break;
+			case 2:
+				c->src.val &= 0xffff;
+				break;
+			case 4:
+				c->src.val &= 0xffffffff;
+				break;
+			}
+		}
 		break;
 	case SrcImmByte:
 	case SrcImmUByte:


