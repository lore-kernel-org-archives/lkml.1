Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbXBWLWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbXBWLWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbXBWLWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:22:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53631 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628AbXBWLWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:22:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 06/14] x86_64 irq: Simplfiy the set_affinity logic.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:20:59 -0700
In-Reply-To: <m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:19:08 -0700")
Message-ID: <m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For some reason the code has been picking TARGET_CPUS when asked to
set the affinity to an empty set of cpus.  That is just silly it's
extra work.  Instead if there are no cpus to set the affinity to we
should just give up immediately.  That is simpler and a little more
intuitive.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index e064838..74671de 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -244,9 +244,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	cpus_and(mask, tmp, CPU_MASK_ALL);
+		return;
 
 	vector = assign_irq_vector(irq, mask, &tmp);
 	if (vector < 0)
@@ -1890,9 +1888,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	cpus_and(mask, tmp, CPU_MASK_ALL);
+		return;
 
 	vector = assign_irq_vector(irq, mask, &tmp);
 	if (vector < 0)
@@ -1985,9 +1981,7 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	cpus_and(mask, tmp, CPU_MASK_ALL);
+		return;
 
 	vector = assign_irq_vector(irq, mask, &tmp);
 	if (vector < 0)
-- 
1.5.0.g53756

