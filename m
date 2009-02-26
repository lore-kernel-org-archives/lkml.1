Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbZBZOWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbZBZOWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZBZOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43079 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/40] KVM: Fix vmload and friends misinterpreted as lidt
Date: Thu, 26 Feb 2009 16:15:13 +0200
Message-Id: <1235657730-27683-24-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD SVM instruction family all overload the 0f 01 /3 opcode, further
multiplexing on the three r/m bits.  But the code decided that anything that
isn't a vmmcall must be an lidt (which shares the 0f 01 /3 opcode, for the
case that mod = 3).

Fix by aborting emulation if this isn't a vmmcall.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d174db7..54fb098 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1908,11 +1908,16 @@ twobyte_insn:
 			c->dst.type = OP_NONE;
 			break;
 		case 3: /* lidt/vmmcall */
-			if (c->modrm_mod == 3 && c->modrm_rm == 1) {
-				rc = kvm_fix_hypercall(ctxt->vcpu);
-				if (rc)
-					goto done;
-				kvm_emulate_hypercall(ctxt->vcpu);
+			if (c->modrm_mod == 3) {
+				switch (c->modrm_rm) {
+				case 1:
+					rc = kvm_fix_hypercall(ctxt->vcpu);
+					if (rc)
+						goto done;
+					break;
+				default:
+					goto cannot_emulate;
+				}
 			} else {
 				rc = read_descriptor(ctxt, ops, c->src.ptr,
 						     &size, &address,
-- 
1.6.0.6

