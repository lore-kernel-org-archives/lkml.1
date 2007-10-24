Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbXJXQmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbXJXQmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbXJXQZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:48 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60961 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754397AbXJXQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:27 -0400
Date: Wed, 24 Oct 2007 18:25:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/taskstats.c: fix bogus nlmsg_free()
Message-ID: <20071024162554.GC30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We'd better not nlmsg_free on a pointer containing an undefined value
(and without having anything allocated)...

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/taskstats.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6/kernel/taskstats.c.old	2007-10-23 19:01:07.000000000 +0200
+++ linux-2.6/kernel/taskstats.c	2007-10-23 19:21:54.000000000 +0200
@@ -383,67 +383,67 @@
 
 static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
 	int rc = 0;
 	struct sk_buff *rep_skb;
 	struct cgroupstats *stats;
 	struct nlattr *na;
 	size_t size;
 	u32 fd;
 	struct file *file;
 	int fput_needed;
 
 	na = info->attrs[CGROUPSTATS_CMD_ATTR_FD];
 	if (!na)
 		return -EINVAL;
 
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		size = nla_total_size(sizeof(struct cgroupstats));
 
 		rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
 					size);
 		if (rc < 0)
-			goto err;
+			return rc;
 
 		na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
 					sizeof(struct cgroupstats));
 		stats = nla_data(na);
 		memset(stats, 0, sizeof(*stats));
 
 		rc = cgroupstats_build(stats, file->f_dentry);
+
+		fput_light(file, fput_needed);
+
 		if (rc < 0)
 			goto err;
 
-		fput_light(file, fput_needed);
 		return send_reply(rep_skb, info->snd_pid);
+err:
+		nlmsg_free(rep_skb);
 	}
 
-err:
-	if (file)
-		fput_light(file, fput_needed);
-	nlmsg_free(rep_skb);
 	return rc;
 }
 
 static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
 	int rc = 0;
 	struct sk_buff *rep_skb;
 	struct taskstats *stats;
 	size_t size;
 	cpumask_t mask;
 
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], &mask);
 	if (rc < 0)
 		return rc;
 	if (rc == 0)
 		return add_del_listener(info->snd_pid, &mask, REGISTER);
 
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], &mask);
 	if (rc < 0)
 		return rc;
 	if (rc == 0)
 		return add_del_listener(info->snd_pid, &mask, DEREGISTER);
 
 	/*

