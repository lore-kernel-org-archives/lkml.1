Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYLEHpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYLEHpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYLEHpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:45:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYLEHpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:45:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=XvKezyJS7AoXwwXT7XpIuNkEowY6CrGP+bu5ncOm+lkECllJlwDINgBfanW/oARZJ
	4z3S7iM9IQq69I09qpOOw==
MIME-Version: 1.0
In-Reply-To: <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
	 <49376BE3.1040909@cn.fujitsu.com>
	 <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
Date: Thu, 4 Dec 2008 23:44:58 -0800
Message-ID: <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>
Subject: Re: [patch] export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 9:34 PM, Li Zefan wrote:
>> +             seq_printf(m, "%lld ", percpu);
>
> Should be %llu. And if we don't cast percpu to unsigned long long, will
> it trigger compile warning in some archs?


On Thu, Dec 4, 2008 at 3:02 PM, Paul Menage wrote:
>> IMO percpu_usage is a better name.
>
> Maybe usage_percpu ?


Thank you all for your comments.  Patch updated.


=====

This patch export per-cpu CPU cycle usage for a given cpuacct cgroup.
There is a need for a user space monitor daemon to track group CPU
usage on per-cpu base.  It is also useful for monitor CFS load
balancer behavior by tracking per CPU group usage.


Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index b7480fb..e32c094 100644
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
+		seq_printf(m, "%llu ", percpu);
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
