Return-Path: <linux-kernel-owner+w=401wt.eu-S1765269AbXLTWT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765269AbXLTWT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764847AbXLTWQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:16:40 -0500
Received: from baron.borf.com ([65.14.39.133]:28916 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761006AbXLTWQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:16:39 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/13] add module parameter for users who need more outstanding I/O
Date: Thu, 20 Dec 2007 17:15:58 -0500
Message-Id: <1198188961-25147-10-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An AoE target provides an estimate of the number of outstanding
commands that the AoE initiator can send before getting a response.
The aoe_maxout parameter provides a way to set an even lower limit.
It will not allow a user to use more outstanding commands than the
target permits.  If a user discovers a problem with a large setting,
this parameter provides a way for us to work with them to debug the
problem.  We expect to improve the dynamic window sizing algorithm and
drop this parameter.  For the time being, it is a debugging aid.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 7a96183..e92d885 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -18,6 +18,11 @@ static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
 
+static int aoe_maxout = 16;
+module_param(aoe_maxout, int, 0644);
+MODULE_PARM_DESC(aoe_maxout,
+	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
+
 static struct sk_buff *
 new_skb(ulong len)
 {
@@ -984,7 +989,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
-	enum { MAXFRAMES = 16 };
 	u16 n;
 
 	h = (struct aoe_hdr *) skb_mac_header(skb);
@@ -1009,8 +1013,8 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	}
 
 	n = be16_to_cpu(ch->bufcnt);
-	if (n > MAXFRAMES)	/* keep it reasonable */
-		n = MAXFRAMES;
+	if (n > aoe_maxout)	/* keep it reasonable */
+		n = aoe_maxout;
 
 	d = aoedev_by_sysminor_m(sysminor);
 	if (d == NULL) {
-- 
1.5.3.4

