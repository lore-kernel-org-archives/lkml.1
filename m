Return-Path: <linux-kernel-owner+w=401wt.eu-S936462AbXG0PqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936462AbXG0PqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762042AbXG0Ppz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:45:55 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36401 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761915AbXG0Ppy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:45:54 -0400
Date: Fri, 27 Jul 2007 18:45:53 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix integer overflow warning in i2o_block
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B32D@otce2k301.adaptec.com>
Message-ID: <Pine.SOC.4.64.0707271842330.27338@math.ut.ee>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B32D@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I would change tid from an int to an unsigned instead, he is the culprit
> that is promoting the unsigned to an signed.

Thanks, this is the culprit.

> >   CC [M]  drivers/message/i2o/i2o_block.o
> > drivers/message/i2o/i2o_block.c: In function 'i2o_block_transfer':
> > drivers/message/i2o/i2o_block.c:837: warning: integer 
> > overflow in expression

The patch below changes local variable tid to u32 so the whole 
expression is of u32 type and fits well into u32 result. Compile tested 
only since I have currently no extra I2O hardware available for testing.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 5e1c99f..50b2c73 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -744,7 +744,7 @@ static int i2o_block_transfer(struct request *req)
 {
 	struct i2o_block_device *dev = req->rq_disk->private_data;
 	struct i2o_controller *c;
-	int tid = dev->i2o_dev->lct_data.tid;
+	u32 tid = dev->i2o_dev->lct_data.tid;
 	struct i2o_message *msg;
 	u32 *mptr;
 	struct i2o_block_request *ireq = req->special;

-- 
Meelis Roos (mroos@linux.ee)
