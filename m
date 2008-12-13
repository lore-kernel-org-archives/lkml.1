Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYLMXVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYLMXVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYLMXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:21:34 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:43095 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYLMXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xXCCo2P+zkJUqFIwe4t/IGeR0a8/iy40hWiWyBcxmfRjoHfDAVKa/gu5Dwuh43nW1K
         gapnqqyPj1iuuMmtVSHXq5SkeN1A5O9qxwChzQfXO1jSr27Zd+OAzeHXwAKfMXpy4JMj
         ayk4HV8xuaLkiuahnaaDem1ywqkMR95V/mJ9E=
Subject: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling broken
 on big-endian
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:21:29 -0800
Message-Id: <1229210489.11257.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After annotating the frame structs, this was left:
drivers/ieee1394/dv1394.c:2113:23: warning: invalid assignment: |=
drivers/ieee1394/dv1394.c:2113:23:    left side has type restricted __le32
drivers/ieee1394/dv1394.c:2113:23:    right side has type int
drivers/ieee1394/dv1394.c:2121:24: warning: invalid assignment: &=
drivers/ieee1394/dv1394.c:2121:24:    left side has type restricted __le32
drivers/ieee1394/dv1394.c:2121:24:    right side has type int
drivers/ieee1394/dv1394.c:2123:24: warning: invalid assignment: |=
drivers/ieee1394/dv1394.c:2123:24:    left side has type restricted __le32
drivers/ieee1394/dv1394.c:2123:24:    right side has type int

Which looks like a real bug on a big-endian arch as it would set/clear
the wrong bit.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/dv1394.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index f258e61..a329e6b 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -2110,17 +2110,17 @@ static void ir_tasklet_func(unsigned long data)
 			f = video->frames[next_i / MAX_PACKETS];
 			next = &(f->descriptor_pool[next_i % MAX_PACKETS]);
 			next_dma = ((unsigned long) block - (unsigned long) f->descriptor_pool) + f->descriptor_pool_dma;
-			next->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
-			next->u.in.il.q[2] = 0; /* disable branch */
+			next->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
+			next->u.in.il.q[2] = cpu_to_le32(0); /* disable branch */
 
 			/* link previous to next */
 			prev_i = (next_i == 0) ? (MAX_PACKETS * video->n_frames - 1) : (next_i - 1);
 			f = video->frames[prev_i / MAX_PACKETS];
 			prev = &(f->descriptor_pool[prev_i % MAX_PACKETS]);
 			if (prev_i % (MAX_PACKETS/2)) {
-				prev->u.in.il.q[0] &= ~(3 << 20); /* no interrupt */
+				prev->u.in.il.q[0] &= ~cpu_to_le32(3 << 20); /* no interrupt */
 			} else {
-				prev->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
+				prev->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
 			}
 			prev->u.in.il.q[2] = cpu_to_le32(next_dma | 1); /* set Z=1 */
 			wmb();
-- 
1.6.1.rc2.306.ge5d5e

