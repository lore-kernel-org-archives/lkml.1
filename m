Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbYD1HJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbYD1HJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764765AbYD1HJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:09:49 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:38490 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763374AbYD1HJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:09:48 -0400
Date: Mon, 28 Apr 2008 09:09:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428070946.GA4507@osiris.boeblingen.de.ibm.com>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com> <20080427183926.acb66fff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427183926.acb66fff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 06:39:26PM -0700, Andrew Morton wrote:
> On Sun, 27 Apr 2008 23:12:24 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > Index: linux-2.6/kernel/cpuset.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/cpuset.c
> > +++ linux-2.6/kernel/cpuset.c
> > @@ -684,7 +684,9 @@ restart:
> >  rebuild:
> >  	/* Have scheduler rebuild sched domains */
> >  	get_online_cpus();
> > +	mutex_lock(&sched_domains_mutex);
> >  	partition_sched_domains(ndoms, doms, dattr);
> > +	mutex_unlock(&sched_domains_mutex);
> >  	put_online_cpus();
> >  
> 
> It seems a bit fragile to take this lock in the caller without even adding
> a comment at the callee site which documents the new locking rule.
> 
> It would be more robust to take the lock within partition_sched_domains().
> 
> partition_sched_domains() already covers itself with lock_doms_cur().  Can
> we take that in arch_reinit_sched_domains() rather than adding the new lock?

I think you meant taking it in partition_sched_domains? But anyway, I moved
it all over to sched.c. So here's the new patch. Shorter and doesn't export
a new lock :)


Subject: [PATCH] sched: fix sched_domains locking

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Concurrent calls to detach_destroy_domains and arch_init_sched_domains
were prevented by the old scheduler subsystem cpu hotplug mutex. When
this got converted to get_online_cpus() the locking got broken.
Unlike before now several processes can concurrently enter the critical
sections that were protected by the old lock.

So add a new sched_domains_mutex which protects these sections again.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sched.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7730,6 +7730,12 @@ static int dattrs_equal(struct sched_dom
 }
 
 /*
+ * Protects against concurrent calls to detach_destroy_domains
+ * and arch_init_sched_domains.
+ */
+static DEFINE_MUTEX(sched_domains_mutex);
+
+/*
  * Partition sched domains as specified by the 'ndoms_new'
  * cpumasks in the array doms_new[] of cpumasks. This compares
  * doms_new[] to the current sched domain partitioning, doms_cur[].
@@ -7756,7 +7762,8 @@ void partition_sched_domains(int ndoms_n
 	int i, j;
 
 	lock_doms_cur();
-
+	mutex_lock(&sched_domains_mutex);
+
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
@@ -7804,6 +7811,7 @@ match2:
 
 	register_sched_domain_sysctl();
 
+	mutex_unlock(&sched_domains_mutex);
 	unlock_doms_cur();
 }
 
@@ -7813,8 +7821,10 @@ int arch_reinit_sched_domains(void)
 	int err;
 
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
 	return err;
@@ -7932,10 +7942,12 @@ void __init sched_init_smp(void)
 	BUG_ON(sched_group_nodes_bycpu == NULL);
 #endif
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
