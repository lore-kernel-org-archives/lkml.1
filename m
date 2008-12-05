Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYLESQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYLESQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYLESQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:16:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7061 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbYLESQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:16:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=YfJwNkC+UPoaoJhHLRDuYO9Lp+SHvYyqpCXoD0UJ1QNbrT1YPP0ZtmQ/0WcnKPd0t
	DjCyfh2wG628/5ZuM1eyg==
MIME-Version: 1.0
In-Reply-To: <20081205135253.GE27039@elte.hu>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
	 <49376BE3.1040909@cn.fujitsu.com>
	 <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
	 <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>
	 <4938DE1C.6070608@cn.fujitsu.com>
	 <b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com>
	 <4938E7C1.9040102@cn.fujitsu.com> <20081205135253.GE27039@elte.hu>
Date: Fri, 5 Dec 2008 10:16:30 -0800
Message-ID: <b040c32a0812051016q7912688dw2c663a77121a8f18@mail.gmail.com>
Subject: Re: [patch] export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 5:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Could someone please send the final patch with a final changelog, with
> all fixlets and tags in place please?

Here it is:

This patch export per-cpu CPU cycle usage for a given cpuacct cgroup.
There is a need for a user space monitor daemon to track group CPU
usage on per-cpu base.  It is also useful for monitoring CFS load
balancer behavior by tracking per CPU group usage.


Signed-off-by: Ken Chen <kenchen@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index b7480fb..055c54f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9345,12 +9345,34 @@ out:
 	return err;
 }

+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_possible_cpu(i) {
+		spin_lock_irq(&cpu_rq(i)->lock);
+		percpu = *percpu_ptr(ca->cpuusage, i);
+		spin_unlock_irq(&cpu_rq(i)->lock);
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
