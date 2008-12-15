Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYLOOx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYLOOx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYLOOwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:52:54 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60489 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYLOOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:52:53 -0500
Message-Id: <20081215145250.204875669@de.ibm.com>
References: <20081215143437.843064041@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 15:34:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: mingo@elte.hu, akpm@linux-foundation.org
Cc: maxk@qualcomm.com, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RESEND 2/2] sched: re-add missing arch_update_cpu_topology call
Content-Disposition: inline; filename=002_partition_update.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

arch_reinit_sched_domains used to call arch_update_cpu_topology
via arch_init_sched_domains. This call got lost with
e761b7725234276a802322549cee5255305a0930 ("cpu hotplug, sched: Introduce
cpu_active_map and redo sched domain managment (take 2)".

So we might end up with outdated and missing cpus in the cpu core
maps (architecture used to call arch_reinit_sched_domains if cpu
topology changed).

This adds a call to arch_update_cpu_topology in partition_sched_domains
which gets called whenever scheduling domains get updated. Which is
what is supposed to happen when cpu topology changes.

Since arch_update_cpu_topology returns 0 if the cpu topology didn't
change this is a NOP for all architectures but s390 (currently).

If arch_update_cpu_topology returns 1 this causes all scheduling domains
to be destroyed and rebuilt.

Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7813,17 +7813,21 @@ void partition_sched_domains(int ndoms_n
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
+	int top_changed;
 
 	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
+	/* Let architecture update cpu core mappings. */
+	top_changed = arch_update_cpu_topology();
+
 	n = doms_new ? ndoms_new : 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
-		for (j = 0; j < n; j++) {
+		for (j = 0; j < n && !top_changed; j++) {
 			if (cpus_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
@@ -7843,7 +7847,7 @@ match1:
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
-		for (j = 0; j < ndoms_cur; j++) {
+		for (j = 0; j < ndoms_cur && !top_changed; j++) {
 			if (cpus_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;

-- 
