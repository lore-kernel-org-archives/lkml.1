Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYLPHGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYLPHGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYLPHGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:06:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYLPHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:06:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=Gb36Aa62YC6s9zI2aRhqUC6Smo7HtNzkTuqitsj8v8Ns4AmJN+OhXeM9y+BvokPE6
	xSUUDkZhT+EmmPvQwfA4A==
MIME-Version: 1.0
In-Reply-To: <b040c32a0812152204x3b3d378aie7a1898aa67c4278@mail.gmail.com>
References: <b040c32a0812152204x3b3d378aie7a1898aa67c4278@mail.gmail.com>
Date: Mon, 15 Dec 2008 23:06:41 -0800
Message-ID: <b040c32a0812152306p6b72e1d6r548daa66f27f24d6@mail.gmail.com>
Subject: [patch 2/2] cpuacct: export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, forgot to cc lkml on initial post.

---------- Forwarded message ----------
From: Ken Chen <kenchen@google.com>
Date: Mon, Dec 15, 2008 at 10:04 PM
Subject: [patch 2/2] cpuacct: export percpu cpuacct cgroup stats
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton
<akpm@linux-foundation.org>, Paul Menage <menage@google.com>, Li Zefan
<lizf@cn.fujitsu.com>


This patch export per-cpu CPU cycle usage for a given cpuacct cgroup.
There is a need for a user space monitor daemon to track group CPU
usage on per-cpu base.  It is also useful for monitoring CFS load
balancer behavior by tracking per CPU group usage.

Signed-off-by: Ken Chen <kenchen@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/kernel/sched.c b/kernel/sched.c
index 124bd7a..cfdaace 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9369,12 +9369,32 @@ out:
 	return err;
 }

+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpuacct_cpuusage_read(ca, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_u64 = cpuusage_read,
 		.write_u64 = cpuusage_write,
 	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+	},
+
 };

 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
