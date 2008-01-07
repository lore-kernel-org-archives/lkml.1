Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYAGNJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYAGNJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbYAGNGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:06:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbYAGNGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:06:45 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/16] make emulate_insn receive a vcpu struct.
Date: Mon,  7 Jan 2008 11:05:31 -0200
Message-Id: <11997111841603-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11997111801864-git-send-email-gcosta@redhat.com>
References: 11981576363806-git-send-email-gcosta@redhat.com <1199711137195-git-send-email-gcosta@redhat.com> <11997111432356-git-send-email-gcosta@redhat.com> <11997111481113-git-send-email-gcosta@redhat.com> <11997111523234-git-send-email-gcosta@redhat.com> <1199711157132-git-send-email-gcosta@redhat.com> <11997111623212-git-send-email-gcosta@redhat.com> <11997111661344-git-send-email-gcosta@redhat.com> <11997111711574-git-send-email-gcosta@redhat.com> <11997111751377-git-send-email-gcosta@redhat.com> <11997111801864-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

emulate_insn() needs to know about current eip, which will be,
in the future, a per-vcpu thing. So in this patch, the function
prototype is modified to receive a vcpu struct

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/x86/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 125a14b..b336fff 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -220,8 +220,9 @@ void lguest_arch_run_guest(struct lg_vcpu *vcpu)
  * When the Guest uses one of these instructions, we get a trap (General
  * Protection Fault) and come here.  We see if it's one of those troublesome
  * instructions and skip over it.  We return true if we did. */
-static int emulate_insn(struct lguest *lg)
+static int emulate_insn(struct lg_vcpu *vcpu)
 {
+	struct lguest *lg = vcpu->lg;
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
 	/* The eip contains the *virtual* address of the Guest's instruction:
@@ -294,7 +295,7 @@ void lguest_arch_handle_trap(struct lg_vcpu *vcpu)
 		 * instructions which we need to emulate.  If so, we just go
 		 * back into the Guest after we've done it. */
 		if (lg->regs->errcode == 0) {
-			if (emulate_insn(lg))
+			if (emulate_insn(vcpu))
 				return;
 		}
 		break;
-- 
1.5.0.6

