Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbZB0KpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbZB0KpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbZB0Kos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:44:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:40525 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbZB0Kor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=okCKOLtNzmljwAD0YinRl7gLmXt5j5R9fVpUEN2JRxRzOdhaOwMGXk7qjlGktTAS/f
         PUqUWyLDjsU/t3KZC+nQ8AnvjNuSJ5EBYTlJXEaZvBFToiXrWOvQ6xlZVJiXV36vj6fg
         F7Cp3ogVF72eCHpIbPqYsMVsJNQa+hx1gqYTQ=
Date: Fri, 27 Feb 2009 11:44:41 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: decode sign/zero-extension move instructions
	correctly
Message-ID: <20090227104441.GB1899@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From add26ecb4c0e9569ac172fb96b516fdc8198ff93 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 27 Feb 2009 11:39:31 +0100
Subject: [PATCH] kmemcheck: decode sign/zero-extension move instructions correctly

There were quite a few errors in this area. For 32-bit, we didn't
handle sign-extension (only zero-extension), and for 64-bit we
didn't do anything right. This patch hopefully fixes that.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/kmemcheck/opcode.c |   46 +++++++++++++++++++++++++++++----------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
index 5283f0b..63c19e2 100644
--- a/arch/x86/mm/kmemcheck/opcode.c
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -28,6 +28,8 @@ static bool opcode_is_rex_prefix(uint8_t b)
 }
 #endif
 
+#define REX_W (1 << 3)
+
 /*
  * This is a VERY crude opcode decoder. We only need to find the size of the
  * load/store that caused our #PF and this should work for all the opcodes
@@ -47,27 +49,47 @@ void kmemcheck_opcode_decode(const uint8_t *op, unsigned int *size)
 
 	/* REX prefix */
 	if (opcode_is_rex_prefix(*op)) {
-		if (*op & 0x08) {
+		uint8_t rex = *op;
+
+		++op;
+		if (rex & REX_W) {
+			switch (*op) {
+			case 0x63:
+				*size = 4;
+				return;
+			case 0x0f:
+				++op;
+
+				switch (*op) {
+				case 0xb6:
+				case 0xbe:
+					*size = 1;
+					return;
+				case 0xb7:
+				case 0xbf:
+					*size = 2;
+					return;
+				}
+
+				break;
+			}
+
 			*size = 8;
 			return;
 		}
-
-		++op;
 	}
 
 	/* escape opcode */
 	if (*op == 0x0f) {
 		++op;
 
-		if (*op == 0xb6) {
-			*size = 1;
-			return;
-		}
-
-		if (*op == 0xb7) {
-			*size = 2;
-			return;
-		}
+		/*
+		 * This is move with zero-extend and sign-extend, respectively;
+		 * we don't have to think about 0xb6/0xbe, because this is
+		 * already handled in the conditional below.
+		 */
+		if (*op == 0xb7 || *op == 0xbf)
+			operand_size_override = 2;
 	}
 
 	*size = (*op & 1) ? operand_size_override : 1;
-- 
1.6.0.6

