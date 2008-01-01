Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYAAPjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYAAPjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYAAPgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:31 -0500
Received: from il.qumranet.com ([82.166.9.18]:33792 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 09/54] KVM: x86 emulator: Make a distinction between repeat prefixes F3 and F2
Date: Tue,  1 Jan 2008 17:35:35 +0200
Message-Id: <1199201780-14001-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

cmps and scas instructions accept repeat prefixes F3 and F2. So in
order to emulate those prefixed instructions we need to be able to know
if prefixes are REP/REPE/REPZ or REPNE/REPNZ. Currently kvm doesn't make
this distinction. This patch introduces this distinction.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    4 +++-
 drivers/kvm/x86_emulate.h |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 6e7f774..9f8d59a 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -824,8 +824,10 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 			c->lock_prefix = 1;
 			break;
 		case 0xf2:	/* REPNE/REPNZ */
+			c->rep_prefix = REPNE_PREFIX;
+			break;
 		case 0xf3:	/* REP/REPE/REPZ */
-			c->rep_prefix = 1;
+			c->rep_prefix = REPE_PREFIX;
 			break;
 		default:
 			goto done_prefixes;
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 4603b2b..644086e 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -162,6 +162,10 @@ struct x86_emulate_ctxt {
 	struct decode_cache decode;
 };
 
+/* Repeat String Operation Prefix */
+#define REPE_PREFIX  1
+#define REPNE_PREFIX    2
+
 /* Execution mode, passed to the emulator. */
 #define X86EMUL_MODE_REAL     0	/* Real mode.             */
 #define X86EMUL_MODE_PROT16   2	/* 16-bit protected mode. */
-- 
1.5.3.7

