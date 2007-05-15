Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXEOMnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXEOMnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXEOMnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:43:32 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14442 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbXEOMnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:43:32 -0400
Message-ID: <4649AAE5.50004@sw.ru>
Date: Tue, 15 May 2007 16:43:17 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [patch i2o 2/6] wrong memory access in i2o_block_device_lock()
References: <4649AA6C.2080808@sw.ru>
In-Reply-To: <4649AA6C.2080808@sw.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes access to memory that has not been allocated:
i2o_msg_get_wait() can returns errors different from I2O_QUEUE_EMPTY. But the
result is checked only against this code. If it is not I2O_QUEUE_EMPTY then we
dereference the error code as the pointer later.

Signed-off-by: Vasily Averin <vvs@sw.ru>

--- lk2.6/drivers/message/i2o/i2o_block.c
+++ lk2.6/drivers/message/i2o/i2o_block.c
@@ -215,7 +215,7 @@ static int i2o_block_device_lock(struct
 	struct i2o_message *msg;

 	msg = i2o_msg_get_wait(dev->iop, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg) == I2O_QUEUE_EMPTY)
+	if (IS_ERR(msg))
 		return PTR_ERR(msg);

 	msg->u.head[0] = cpu_to_le32(FIVE_WORD_MSG_SIZE | SGL_OFFSET_0);

