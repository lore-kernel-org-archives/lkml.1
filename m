Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYKQH3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYKQH3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYKQHV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:28 -0500
Received: from kroah.org ([198.145.64.141]:38504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755122AbYKQHVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:19 -0500
Date: Sun, 16 Nov 2008 23:15:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jens Axboe <jens.axboe@oracle.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 26/46] S390: cpu topology: fix locking
Message-ID: <20081117071554.GA29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s390-cpu-topology-fix-locking.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 74af283102b358b0da545460d0d176f473e110f6 upstream.

cpu_coregroup_map used to grab a mutex on s390 since it was only
called from process context.
Since c7c22e4d5c1fdebfac4dba76de7d0338c2b0d832 "block: add support
for IO CPU affinity" this is not true anymore.
It now also gets called from softirq context.

To prevent possible deadlocks change this in architecture code and
use a spinlock instead of a mutex.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/topology.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -65,18 +65,21 @@ static int machine_has_topology_irq;
 static struct timer_list topology_timer;
 static void set_topology_timer(void);
 static DECLARE_WORK(topology_work, topology_work_fn);
+/* topology_lock protects the core linked list */
+static DEFINE_SPINLOCK(topology_lock);
 
 cpumask_t cpu_core_map[NR_CPUS];
 
 cpumask_t cpu_coregroup_map(unsigned int cpu)
 {
 	struct core_info *core = &core_info;
+	unsigned long flags;
 	cpumask_t mask;
 
 	cpus_clear(mask);
 	if (!machine_has_topology)
 		return cpu_present_map;
-	mutex_lock(&smp_cpu_state_mutex);
+	spin_lock_irqsave(&topology_lock, flags);
 	while (core) {
 		if (cpu_isset(cpu, core->mask)) {
 			mask = core->mask;
@@ -84,7 +87,7 @@ cpumask_t cpu_coregroup_map(unsigned int
 		}
 		core = core->next;
 	}
-	mutex_unlock(&smp_cpu_state_mutex);
+	spin_unlock_irqrestore(&topology_lock, flags);
 	if (cpus_empty(mask))
 		mask = cpumask_of_cpu(cpu);
 	return mask;
@@ -133,7 +136,7 @@ static void tl_to_cores(struct tl_info *
 	union tl_entry *tle, *end;
 	struct core_info *core = &core_info;
 
-	mutex_lock(&smp_cpu_state_mutex);
+	spin_lock_irq(&topology_lock);
 	clear_cores();
 	tle = info->tle;
 	end = (union tl_entry *)((unsigned long)info + info->length);
@@ -157,7 +160,7 @@ static void tl_to_cores(struct tl_info *
 		}
 		tle = next_tle(tle);
 	}
-	mutex_unlock(&smp_cpu_state_mutex);
+	spin_unlock_irq(&topology_lock);
 }
 
 static void topology_update_polarization_simple(void)

-- 
