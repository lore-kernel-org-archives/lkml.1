Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYLIRya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYLIRya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYLIRxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:53:42 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:33778 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYLIRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:53:41 -0500
Message-Id: <20081209175338.434266578@de.ibm.com>
References: <20081209174949.355669577@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 09 Dec 2008 18:49:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] sched: add missing arch_update_cpu_topology() call
Content-Disposition: inline; filename=002_partition_update.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

arch_reinit_sched_domains() used to call arch_update_cpu_topology()
via arch_init_sched_domains(). This call got lost with
e761b7725234276a802322549cee5255305a0930 ("cpu hotplug, sched: Introduce
cpu_active_map and redo sched domain managment (take 2)".

So we might end up with outdated and missing cpus in the cpu core
maps (architecture used to call arch_reinit_sched_domains if cpu
topology changed).

This adds a call to arch_update_cpu_topology in partition_sched_domains
which gets called whenever scheduling domains get updated. Which is
what is supposed to happen when cpu topology changes.

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
@@ -7811,17 +7811,21 @@ void partition_sched_domains(int ndoms_n
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
+	int new_topology;
 
 	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
+	/* Let architecture update cpu core mappings. */
+	new_topology = arch_update_cpu_topology();
+
 	n = doms_new ? ndoms_new : 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
-		for (j = 0; j < n; j++) {
+		for (j = 0; j < n && !new_topology; j++) {
 			if (cpus_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
@@ -7841,7 +7845,7 @@ match1:
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
-		for (j = 0; j < ndoms_cur; j++) {
+		for (j = 0; j < ndoms_cur && !new_topology; j++) {
 			if (cpus_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;

-- 
