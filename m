Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZCXIGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZCXIGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZCXIGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:06:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757187AbZCXIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:06:10 -0400
Message-ID: <49C89488.4030604@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:06:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] blktrace: print human-readable act_mask
References: <49C893FC.9080905@cn.fujitsu.com>
In-Reply-To: <49C893FC.9080905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print stringified act_mask instead of hex value:
 # cat act_mask
 read,write,barrier,sync,queue,requeue,issue,complete,fs,pc,ahead,meta,
 discard,drv_data
 # echo "meta,write" > act_mask
 # cat act_mask
 write,meta

Also:
 - make act_mask accept "ahead", "meta", "discard" and "drv_data"
 - use strsep() instead of strchr() to parse user input
 - return -EINVAL if a token is not found in the mask map
 - propagate error value of blk_trace_mask2str() to userspace, but not
   always return -ENXIO.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |  100 +++++++++++++++++++++++++++++-----------------
 1 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index f33c176..3b2ba28 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1316,53 +1316,77 @@ struct attribute_group blk_trace_attr_group = {
 	.attrs = blk_trace_attrs,
 };
 
-static int blk_str2act_mask(const char *str)
+static struct {
+	int mask;
+	const char *str;
+} mask_maps[] = {
+	{ BLK_TC_READ,		"read"		},
+	{ BLK_TC_WRITE,		"write"		},
+	{ BLK_TC_BARRIER,	"barrier"	},
+	{ BLK_TC_SYNC,		"sync"		},
+	{ BLK_TC_QUEUE,		"queue"		},
+	{ BLK_TC_REQUEUE,	"requeue"	},
+	{ BLK_TC_ISSUE,		"issue"		},
+	{ BLK_TC_COMPLETE,	"complete"	},
+	{ BLK_TC_FS,		"fs"		},
+	{ BLK_TC_PC,		"pc"		},
+	{ BLK_TC_AHEAD,		"ahead"		},
+	{ BLK_TC_META,		"meta"		},
+	{ BLK_TC_DISCARD,	"discard"	},
+	{ BLK_TC_DRV_DATA,	"drv_data"	},
+};
+
+static int blk_trace_str2mask(const char *str)
 {
+	int i;
 	int mask = 0;
-	char *copy = kstrdup(str, GFP_KERNEL), *s;
+	char *s, *token;
 
-	if (copy == NULL)
+	s = kstrdup(str, GFP_KERNEL);
+	if (s == NULL)
 		return -ENOMEM;
-
-	s = strstrip(copy);
+	s = strstrip(s);
 
 	while (1) {
-		char *sep = strchr(s, ',');
-
-		if (sep != NULL)
-			*sep = '\0';
-
-		if (strcasecmp(s, "barrier") == 0)
-			mask |= BLK_TC_BARRIER;
-		else if (strcasecmp(s, "complete") == 0)
-			mask |= BLK_TC_COMPLETE;
-		else if (strcasecmp(s, "fs") == 0)
-			mask |= BLK_TC_FS;
-		else if (strcasecmp(s, "issue") == 0)
-			mask |= BLK_TC_ISSUE;
-		else if (strcasecmp(s, "pc") == 0)
-			mask |= BLK_TC_PC;
-		else if (strcasecmp(s, "queue") == 0)
-			mask |= BLK_TC_QUEUE;
-		else if (strcasecmp(s, "read") == 0)
-			mask |= BLK_TC_READ;
-		else if (strcasecmp(s, "requeue") == 0)
-			mask |= BLK_TC_REQUEUE;
-		else if (strcasecmp(s, "sync") == 0)
-			mask |= BLK_TC_SYNC;
-		else if (strcasecmp(s, "write") == 0)
-			mask |= BLK_TC_WRITE;
-
-		if (sep == NULL)
+		token = strsep(&s, ",");
+		if (token == NULL)
 			break;
 
-		s = sep + 1;
+		if (*token == '\0')
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(mask_maps); i++) {
+			if (strcasecmp(token, mask_maps[i].str) == 0) {
+				mask |= mask_maps[i].mask;
+				break;
+			}
+		}
+		if (i == ARRAY_SIZE(mask_maps)) {
+			mask = -EINVAL;
+			break;
+		}
 	}
-	kfree(copy);
+	kfree(s);
 
 	return mask;
 }
 
+static ssize_t blk_trace_mask2str(char *buf, int mask)
+{
+	int i;
+	char *p = buf;
+
+	for (i = 0; i < ARRAY_SIZE(mask_maps); i++) {
+		if (mask & mask_maps[i].mask) {
+			p += sprintf(p, "%s%s",
+				    (p == buf) ? "" : ",", mask_maps[i].str);
+		}
+	}
+	*p++ = '\n';
+
+	return (p - buf);
+}
+
 static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
 {
 	if (bdev->bd_disk == NULL)
@@ -1399,7 +1423,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	if (q->blk_trace == NULL)
 		ret = sprintf(buf, "disabled\n");
 	else if (attr == &dev_attr_act_mask)
-		ret = sprintf(buf, "%#x\n", q->blk_trace->act_mask);
+		ret = blk_trace_mask2str(buf, q->blk_trace->act_mask);
 	else if (attr == &dev_attr_pid)
 		ret = sprintf(buf, "%u\n", q->blk_trace->pid);
 	else if (attr == &dev_attr_start_lba)
@@ -1432,9 +1456,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	if (attr == &dev_attr_act_mask) {
 		if (sscanf(buf, "%llx", &value) != 1) {
 			/* Assume it is a list of trace category names */
-			value = blk_str2act_mask(buf);
-			if (value < 0)
+			value = blk_trace_str2mask(buf);
+			if (value < 0) {
+				ret = value;
 				goto out;
+			}
 		}
 	} else if (sscanf(buf, "%llu", &value) != 1)
 		goto out;
-- 
1.5.4.rc3

