Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYGGKkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYGGKkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYGGKkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:40:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:12675 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYGGKkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=HIIRAtgkn5SbiJ5eB/cI6ZV6iivyvDvD76wY0R8YXY8LPhimax06+A3zqBpW0THWSj
         dVw5ix9jfCuFQ4s0du7bB68atLvj/Cadg7No0zC+JdR5x64jlBhno56nsQkCx41XVBnd
         dg/LyQ2T2ISU+HYnGYkhxqaXLbNpwzXOHZHMM=
Subject: [PATCH][RE-SEND] drivers/isdn/i4l/isdn_common.c fix small resource
	leak
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       kernel Janitors <kernel-janitors@vger.kernel.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Jul 2008 08:52:38 +1000
Message-Id: <1215384758.11092.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people,


Coverity CID: 1356 RESOURCE_LEAK


I found a very old patch for this that was Acked but did not get applied
https://lists.linux-foundation.org/pipermail/kernel-janitors/2006-September/016362.html


There looks to be a small leak in isdn_writebuf_stub() in isdn_common.c,
when copy_from_user() returns an un-copied data length (length != 0).
The below patch should be a minimally invasive fix.

﻿﻿﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
Acked-by: Karsten Keil <kkeil@suse.de>

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 0f3c66d..8d8c6b7 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1977,8 +1977,10 @@ isdn_writebuf_stub(int drvidx, int chan, const u_char __user * buf, int len)
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, hl);
-	if (copy_from_user(skb_put(skb, len), buf, len))
+	if (copy_from_user(skb_put(skb, len), buf, len)) {
+		dev_kfree_skb(skb);
 		return -EFAULT;
+	}
 	ret = dev->drv[drvidx]->interface->writebuf_skb(drvidx, chan, 1, skb);
 	if (ret <= 0)
 		dev_kfree_skb(skb);


