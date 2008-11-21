Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYKUUEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYKUUEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKUUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:04:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53472 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYKUUE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:04:26 -0500
X-IronPort-AV: E=McAfee;i="5100,188,5441"; a="13348671"
Message-ID: <49271449.2030804@qualcomm.com>
Date: Fri, 21 Nov 2008 12:04:25 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <4924C770.7050107@qualcomm.com> <4926158B.9020909@novell.com>
In-Reply-To: <4926158B.9020909@novell.com>
Content-Type: multipart/mixed;
 boundary="------------000303010804020304060503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000303010804020304060503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Greg,

I attached debug instrumentation patch for Dmitri to try. I'll clean it up and
 add things you requested and will resubmit properly some time next week.

More comments inline

Gregory Haskins wrote:
> Max Krasnyansky wrote:
>> ----
>> Trace 1
>> $ echo 0 > cpuset.sched_load_balance
>>
>> [ 1674.811610] cpusets: rebuild ndoms 0
>> [ 1674.811627] CPU0 root domain default
>> [ 1674.811629] CPU0 attaching NULL sched-domain.
>> [ 1674.811633] CPU1 root domain default
>> [ 1674.811635] CPU1 attaching NULL sched-domain.
>> [ 1674.811638] CPU2 root domain default
>> [ 1674.811639] CPU2 attaching NULL sched-domain.
>> [ 1674.811642] CPU3 root domain default
>> [ 1674.811643] CPU3 attaching NULL sched-domain.
>> [ 1674.811646] CPU4 root domain default
>> [ 1674.811647] CPU4 attaching NULL sched-domain.
>> [ 1674.811649] CPU5 root domain default
>> [ 1674.811651] CPU5 attaching NULL sched-domain.
>> [ 1674.811653] CPU6 root domain default
>> [ 1674.811655] CPU6 attaching NULL sched-domain.
>> [ 1674.811657] CPU7 root domain default
>> [ 1674.811659] CPU7 attaching NULL sched-domain.
>>
>> Looks fine.
>>   
> 
> I have to agree.  The code is working "as designed" here since I do not
> support the sched_load_balance=0 mode yet.  While technically not a bug,
> a new feature to add support for it would be nice :)
Hmm, I'm not sure what would be a better way to support this. I see it a
transitional state where CPUs are not assigned to any cpuset and/or domain. So
it seems to be perfectly acceptable to put them into the default root domain.
You could allocate an rd for each of those CPUs but it seems that in most
cases they won't be useful because as a very next action cpusets will create
some real domains.
In other words as long as people and tools are aware of the possible lock
contention in this case we're ok. I already update my 'syspart' tool to create
cpuset set for each isolated cpu.

>> ----
>> Trace 3
>> $ for i in 0 1 2 3 4 5 6 7; do mkdir par$i; echo $i > par$i/cpuset.cpus; done
>> $ echo 0 > cpuset.sched_load_balance
>>
>> SNIP
>>
>> Looks perfectly fine too. Notice how each cpu ended up in a different root_domain.
>>   
> 
> Yep, I concur.  This is how I intended it to work.  However, Dimitri
> reports that this is not working for him and this is what piqued my
> interest and drove the creation of a BZ report.
> 
> Dimitri, can you share your cpuset configuration with us, and also
> re-run both it and Max's approach (assuming they differ) on your end to
> confirm the problem still exists?  Max, perhaps you can post the patch
> with your debugging instrumentation so we can equally see what happens
> on Dimitri's side?
Attached.

>> So. I think the only action item is for me to update 'syspart' to create a
>> cpuset for each isolated cpu to avoid putting a bunch of cpus into the default
>> root domain. Everything else looks perfectly fine.
>>   
> 
> I agree.  We just need to make sure Dimitri can reproduce these findings
> on his side to make sure it is not something like a different cpuset
> configuration that causes the problem.  If you can, Max, could you also
> add the rd->span to the instrumentation just so we can verify that it is
> scoped appropriately?
Will do.

>> btw We should probably rename 'root_domain' to something else to avoid
>> confusion. ie Most people assume that there should be only one root_romain.
>>   
> 
> Agreed, but that is already true (depending on your perspective ;)  I
> chose "root-domain" as short for root-sched-domain (meaning the top-most
> sched-domain in the hierarchy).  There is only one root-domain per
> run-queue.  There can be multiple root-domains per system.  The former
> is how I intended it to be considered, and I think in this context
> "root" is appropriate.  Just as you could consider that every Linux box
> has a root filesystem, but there can be multiple root filesystems that
> exist on, say, a single HDD for example.  Its simply a context to
> govern/scope the rq behavior.
> 
> Early iterations of my patches actually had the rd pointer hanging off
> the top sched-domain structure, actually.  This perhaps reinforced the
> concept of "root" and thus allowed the reasoning for the chosen name to
> be more apparent.  However, I quickly realized that there was no
> advantage to walking up the sd hierarchy to find "root" and thus the rd
> pointer...you could effectively hang the pointer on the rq directly for
> the same result and with less overhead.  So I moved it in the later
> patches which were ultimately accepted.
> 
> I don't feel strongly about the name either way, however.  So if people
> have a name they prefer and the consensus is that it's less confusing, I
> am fine with that.
I do not feel strong about this one either :)

>> Also we should probably commit those prints that I added and enable then under
>> SCHED_DEBUG. Right now we're just printing sched_domains and it's not clear
>> which root_domain they belong to.
>>   
> 
> Yes, please do!  (and please add the rd->span as indicated earlier, if
> you would be so kind ;)
btw I'm also thinking of adding CONFIG_SCHED_VERBOSE_DOMAIN_MSG and moving
those printks under that option. COFIG_SCHED_DEBUG brings a lot of other
things that add overhead in fast path, where as this stuff does not.
It is actually very useful to see those messages in general. They are useful
even on laptops and stuff, during suspend for example because cpusets and
domains are rebuild as we bring CPUs up and down.

> If Dimitri can reproduce your findings, we can close out the bug as FAD
> and create a new-feature request for the sched_load_balance flag.  In
> the meantime, the workaround for the new feature is to use per-cpu
> exclusive cpusets which it sounds can be supported by your syspart tool.
Yes I added that to 'syspart' already and I as explained above I think that's
where it belongs (ie userspace tools). I guess we could change
cpuset.c:generate_sched_domains() to generate a domain for each cpu that is
not in any cpuset but since nothing really brakes (not crashes or anything) if
it does not then I'd leave it up to userspace.

Max



--------------000303010804020304060503
Content-Type: text/plain;
 name="sched_domain_debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched_domain_debug.patch"

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 827cd9a..b94a6de 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -760,6 +760,16 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
 
+	printk(KERN_INFO "cpusets: rebuild ndoms %u\n", ndoms);
+	if (doms) {
+		char str[128];
+		int i;
+		for (i=0; i < ndoms; i++) {
+			cpumask_scnprintf(str, sizeof(str), *(doms + i));
+			printk(KERN_INFO "cpuset: domain %u cpumask %s\n", i, str);
+		}
+	}
+
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index ad1962d..7833224 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6647,11 +6647,16 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	return 0;
 }
 
-static void sched_domain_debug(struct sched_domain *sd, int cpu)
+static void sched_domain_debug(struct root_domain *rd, struct sched_domain *sd, int cpu)
 {
 	cpumask_t *groupmask;
 	int level = 0;
 
+	if (rd == &def_root_domain)
+		printk(KERN_DEBUG "CPU%d root domain default\n", cpu); 
+	else
+		printk(KERN_DEBUG "CPU%d root domain %p\n", cpu, rd); 
+
 	if (!sd) {
 		printk(KERN_DEBUG "CPU%d attaching NULL sched-domain.\n", cpu);
 		return;
@@ -6676,7 +6681,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 	kfree(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
-# define sched_domain_debug(sd, cpu) do { } while (0)
+# define sched_domain_debug(rd, sd, cpu) do { } while (0)
 #endif /* CONFIG_SCHED_DEBUG */
 
 static int sd_degenerate(struct sched_domain *sd)
@@ -6819,7 +6824,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			sd->child = NULL;
 	}
 
-	sched_domain_debug(sd, cpu);
+	sched_domain_debug(rd, sd, cpu);
 
 	rq_attach_root(rq, rd);
 	rcu_assign_pointer(rq->sd, sd);

--------------000303010804020304060503--
