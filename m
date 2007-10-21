Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXJULIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXJULIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXJULH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:58418 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbXJULHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:53 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 02/11] KVM: x86 emulator: fix repne/repnz decoding
Date: Sun, 21 Oct 2007 13:08:03 +0200
Message-Id: <11929648921877-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

The repnz/repne instructions must set rep_prefix to 1 like rep/repe/repz.

This patch correct the disk probe problem met with OpenBSD.

This issue appears with commit e70669abd4e60dfea3ac1639848e20e2b8dd1255
because before it, the decoding was done internally to kvm and after it
is done by x86_emulate.c (which doesn't do it correctly).

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index b1026d2..80b1758 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -596,11 +596,10 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		case 0xf0:	/* LOCK */
 			lock_prefix = 1;
 			break;
+		case 0xf2:	/* REPNE/REPNZ */
 		case 0xf3:	/* REP/REPE/REPZ */
 			rep_prefix = 1;
 			break;
-		case 0xf2:	/* REPNE/REPNZ */
-			break;
 		default:
 			goto done_prefixes;
 		}
-- 
1.5.3

