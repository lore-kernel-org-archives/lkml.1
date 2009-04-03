Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbZDCHbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbZDCHbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZDCHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:31:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDCHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:31:07 -0400
Message-ID: <49D5BB56.7000807@cn.fujitsu.com>
Date: Fri, 03 Apr 2009 15:31:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Alan D. Brunelle" <alan.brunelle@hp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: fix a bug in blk_msg_write()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another long-standing bug.


================


 (console 1)
 # echo -n 'a' > /sys/kernel/debug/block/sda/msg
 (console 2)
 # blktrace -d /dev/sda -a pc -o - | blkparse -i -
  8,0    0        0     0.000000000     0  m   N a������@��

We should terminate the msg buffer with '\0'.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0ef70d..2bf341f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -327,10 +327,10 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 	char *msg;
 	struct blk_trace *bt;
 
-	if (count > BLK_TN_MAX_MSG)
+	if (count >= BLK_TN_MAX_MSG)
 		return -EINVAL;
 
-	msg = kmalloc(count, GFP_KERNEL);
+	msg = kmalloc(count + 1, GFP_KERNEL);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -338,6 +338,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 		kfree(msg);
 		return -EFAULT;
 	}
+	msg[count] = '\0';
 
 	bt = filp->private_data;
 	__trace_note_message(bt, "%s", msg);
-- 
1.5.4.rc3


