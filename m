Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZG1RW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZG1RW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZG1RW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:22:57 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:2476 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753838AbZG1RSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:20 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DT-03-BM7-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 25/26] x86/oprofile: Add counter reservation check for virtual counters
Date: Tue, 28 Jul 2009 19:07:25 +0200
Message-ID: <1248800846-25422-26-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:51.0712 (UTC) FILETIME=[56686E00:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check for the availability of a counter. A virtual
counter is used only if its physical counter is not reserved.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 5856e61..cb88b1a 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -435,15 +435,13 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		struct dentry *dir;
 		char buf[4];
 
-#ifndef CONFIG_OPROFILE_EVENT_MULTIPLEX
 		/* quick little hack to _not_ expose a counter if it is not
 		 * available for use.  This should protect userspace app.
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
 		 *        sequentially in their struct assignment).
 		 */
-		if (unlikely(!avail_to_resrv_perfctr_nmi_bit(i)))
+		if (!avail_to_resrv_perfctr_nmi_bit(op_x86_virt_to_phys(i)))
 			continue;
-#endif /* CONFIG_OPROFILE_EVENT_MULTIPLEX */
 
 		snprintf(buf,  sizeof(buf), "%d", i);
 		dir = oprofilefs_mkdir(sb, root, buf);
-- 
1.6.3.3


