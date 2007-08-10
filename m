Return-Path: <linux-kernel-owner+w=401wt.eu-S940579AbXHJQHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940579AbXHJQHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940140AbXHJQFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:05:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940106AbXHJQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:38 -0400
Date: Fri, 10 Aug 2007 18:05:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810160519.GA27500@elte.hu>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC7BDA.3000305@googlemail.com> <6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com> <m11webz8dx.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11webz8dx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Yes.  For the sched debug case I sent Ingo and friends but apparently 
> other changes in Ingos tree kept it from applying and Andrew dropped 
> it.  So instead the code now screams at you and refuses to register 
> Ingo sysctl table.

the commit below is now upstream - is your patch still needed?

	Ingo

------------>
commit e0361851e5647cdd62fd5c367df5d7e145769d04
Author: Alexey Dobriyan <adobriyan@sw.ru>
Date:   Thu Aug 9 11:16:46 2007 +0200

    sched: remove binary sysctls from kernel.sched_domain
    
    kernel.sched_domain hierarchy is under CTL_UNNUMBERED and thus
    unreachable to sysctl(2). Generating .ctl_number's in such situation is
    not useful.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 49f5b28..85b9311 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5217,12 +5217,19 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
 
 static struct ctl_table sd_ctl_dir[] = {
-	{CTL_UNNUMBERED, "sched_domain", NULL, 0, 0755, NULL, },
+	{
+		.procname	= "sched_domain",
+		.mode		= 0755,
+	},
 	{0,},
 };
 
 static struct ctl_table sd_ctl_root[] = {
-	{CTL_UNNUMBERED, "kernel", NULL, 0, 0755, sd_ctl_dir, },
+	{
+		.procname	= "kernel",
+		.mode		= 0755,
+		.child		= sd_ctl_dir,
+	},
 	{0,},
 };
 
@@ -5238,11 +5245,10 @@ static struct ctl_table *sd_alloc_ctl_entry(int n)
 }
 
 static void
-set_table_entry(struct ctl_table *entry, int ctl_name,
+set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
 		mode_t mode, proc_handler *proc_handler)
 {
-	entry->ctl_name = ctl_name;
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
@@ -5255,28 +5261,28 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
 	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
-	set_table_entry(&table[0], 1, "min_interval", &sd->min_interval,
+	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
-	set_table_entry(&table[1], 2, "max_interval", &sd->max_interval,
+	set_table_entry(&table[1], "max_interval", &sd->max_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
-	set_table_entry(&table[2], 3, "busy_idx", &sd->busy_idx,
+	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[3], 4, "idle_idx", &sd->idle_idx,
+	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[4], 5, "newidle_idx", &sd->newidle_idx,
+	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[5], 6, "wake_idx", &sd->wake_idx,
+	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[6], 7, "forkexec_idx", &sd->forkexec_idx,
+	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[7], 8, "busy_factor", &sd->busy_factor,
+	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[8], 9, "imbalance_pct", &sd->imbalance_pct,
+	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], 11, "cache_nice_tries",
+	set_table_entry(&table[10], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[12], 13, "flags", &sd->flags,
+	set_table_entry(&table[12], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
 
 	return table;
@@ -5296,7 +5302,6 @@ static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 	i = 0;
 	for_each_domain(cpu, sd) {
 		snprintf(buf, 32, "domain%d", i);
-		entry->ctl_name = i + 1;
 		entry->procname = kstrdup(buf, GFP_KERNEL);
 		entry->mode = 0755;
 		entry->child = sd_alloc_ctl_domain_table(sd);
@@ -5317,7 +5322,6 @@ static void init_sched_domain_sysctl(void)
 
 	for (i = 0; i < cpu_num; i++, entry++) {
 		snprintf(buf, 32, "cpu%d", i);
-		entry->ctl_name = i + 1;
 		entry->procname = kstrdup(buf, GFP_KERNEL);
 		entry->mode = 0755;
 		entry->child = sd_alloc_ctl_cpu_table(i);
