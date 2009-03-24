Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbZCXMOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbZCXMOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbZCXMNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:13:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:44737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083AbZCXMNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:13:35 -0400
Date: Tue, 24 Mar 2009 12:12:54 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C8AB42.1000802@cn.fujitsu.com>
References: <49C8AB42.1000802@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: print human-readable act_mask
Message-ID: <tip-093419971e03362a00f499960557c119982ea09f@git.kernel.org>
Git-Commit-ID: 093419971e03362a00f499960557c119982ea09f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 12:12:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  093419971e03362a00f499960557c119982ea09f
Gitweb:     http://git.kernel.org/tip/093419971e03362a00f499960557c119982ea09f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 17:43:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 13:09:00 +0100

blktrace: print human-readable act_mask

Impact: new feature, allow symbolic values in /debug/tracing/act_mask

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
 - fix a bug that 'value' is unsigned, so it can < 0
 - propagate error value of blk_trace_mask2str() to userspace, but not
   always return -ENXIO.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49C8AB42.1000802@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |  103 +++++++++++++++++++++++++++++-----------------
 1 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index f69f8bd..6fb274f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1316,53 +1316,77 @@ struct attribute_group blk_trace_attr_group = {
 	.attrs = blk_trace_attrs,
 };
 
-static int blk_str2act_mask(const char *str)
+static const struct {
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
+	return p - buf;
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
@@ -1424,7 +1448,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	struct request_queue *q;
 	struct hd_struct *p;
 	u64 value;
-	ssize_t ret = -ENXIO;
+	ssize_t ret = -EINVAL;
 
 	if (count == 0)
 		goto out;
@@ -1432,13 +1456,16 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	if (attr == &dev_attr_act_mask) {
 		if (sscanf(buf, "%llx", &value) != 1) {
 			/* Assume it is a list of trace category names */
-			value = blk_str2act_mask(buf);
-			if (value < 0)
+			ret = blk_trace_str2mask(buf);
+			if (ret < 0)
 				goto out;
+			value = ret;
 		}
 	} else if (sscanf(buf, "%llu", &value) != 1)
 		goto out;
 
+	ret = -ENXIO;
+
 	lock_kernel();
 	p = dev_to_part(dev);
 	bdev = bdget(part_devt(p));
