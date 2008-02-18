Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYBRTMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYBRTMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYBRTMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:12:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:20054 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYBRTMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wr86CUkDuxzM/UkVawUtMKGe5xdxnQ+MdOpftqiNhtzuKlCK1Fg2Y2HCvm+25ar9Uj8SpRCQCYlaVRh6riroyEExDl5DJwvbtcPKltGiDep5V/T9IEK0y6aN1g5x6awYkNHl1ZPIADw3YVAR8KjSm5iq+ca7xysWLxmPKt7K9EM=
Subject: [PATCH 1/3] x86, kvm: add ad_mask static inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 11:12:48 -0800
Message-Id: <1203361968.5757.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces open-coded mask calculation in macros.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/x86_emulate.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7958600..7460432 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -426,10 +426,15 @@ static u16 twobyte_table[256] = {
 	(_type)_x;							\
 })
 
+static inline unsigned long ad_mask(struct decode_cache *c)
+{
+	return (1UL << (c->ad_bytes << 3)) - 1;
+}
+
 /* Access/update address held in a register, based on addressing mode. */
 #define address_mask(reg)						\
 	((c->ad_bytes == sizeof(unsigned long)) ? 			\
-		(reg) :	((reg) & ((1UL << (c->ad_bytes << 3)) - 1)))
+		(reg) :	((reg) & ad_mask(c)))
 #define register_address(base, reg)                                     \
 	((base) + address_mask(reg))
 #define register_address_increment(reg, inc)                            \
@@ -440,9 +445,9 @@ static u16 twobyte_table[256] = {
 			(reg) += _inc;					\
 		else							\
 			(reg) = ((reg) & 				\
-				 ~((1UL << (c->ad_bytes << 3)) - 1)) |	\
+				 ~ad_mask(c)) |	\
 				(((reg) + _inc) &			\
-				 ((1UL << (c->ad_bytes << 3)) - 1));	\
+				 ad_mask(c));	\
 	} while (0)
 
 #define JMP_REL(rel) 							\
-- 
1.5.4.1.1278.gc75be


