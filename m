Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYGGBlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYGGBlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 21:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYGGBlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 21:41:42 -0400
Received: from mail.queued.net ([207.210.101.209]:4280 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYGGBll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 21:41:41 -0400
Date: Mon, 7 Jul 2008 01:41:26 +0000
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Cortland Setlow <csetlow@tower-research.com>,
       corbet@lwn.net, video4linux-list@redhat.com
Subject: [PATCH] ov7670: clean up ov7670_read semantics
Message-ID: <20080707014126.0809a5bd@fred>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cortland Setlow pointed out a bug in ov7670.c where the result from
ov7670_read() was just being checked for !0, rather than <0.  This
made me realize that ov7670_read's semantics were rather confusing;
it both fills in 'value' with the result, and returns it.  This is
goes against general kernel convention; so rather than fixing callers,
let's fix the function.

This makes ov7670_read return <0 in the case of an error, and 0 upon
success. Thus, code like:

res = ov7670_read(...);
if (!res)
	goto error;

..will work properly.

Signed-off-by: Cortland Setlow <csetlow@tower-research.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/media/video/ov7670.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 2bc6bdc..d7bfd30 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -406,8 +406,10 @@ static int ov7670_read(struct i2c_client *c, unsigned char reg,
 	int ret;
 
 	ret = i2c_smbus_read_byte_data(c, reg);
-	if (ret >= 0)
+	if (ret >= 0) {
 		*value = (unsigned char) ret;
+		ret = 0;
+	}
 	return ret;
 }
 
-- 
1.5.5.3
