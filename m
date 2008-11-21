Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYKUNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYKUNvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYKUNu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:50:57 -0500
Received: from ozlabs.org ([203.10.76.45]:36401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbYKUNu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:50:57 -0500
To: Ralph Campbell <infinipath@qlogic.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 22 Nov 2008 00:20:53 +1030
Subject: [PATCH 3/3] cpumask: use new cpumask API in drivers/infiniband/hw/ipath
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811220020.53641.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

We're moving from handing around cpumask_t's to handing around struct
cpumask *'s.  cpus_*, cpumask_t and cpu_*_map are deprecated: convert
to cpumask_*, cpu_*_mask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ralph Campbell <infinipath@qlogic.com>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -r c68644561092 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Nov 20 14:02:15 2008 +1030
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Nov 20 14:04:38 2008 +1030
@@ -1674,7 +1674,7 @@
 	 * InfiniPath chip to that processor (we assume reasonable connectivity,
 	 * for now).  This code assumes that if affinity has been set
 	 * before this point, that at most one cpu is set; for now this
-	 * is reasonable.  I check for both cpus_empty() and cpus_full(),
+	 * is reasonable.  I check for both cpumask_empty() and cpumask_full(),
 	 * in case some kernel variant sets none of the bits when no
 	 * affinity is set.  2.6.11 and 12 kernels have all present
 	 * cpus set.  Some day we'll have to fix it up further to handle
@@ -1683,11 +1683,11 @@
 	 * information.  There may be some issues with dual core numbering
 	 * as well.  This needs more work prior to release.
 	 */
-	if (!cpus_empty(current->cpus_allowed) &&
-	    !cpus_full(current->cpus_allowed)) {
+	if (!cpumask_empty(&current->cpus_allowed) &&
+	    !cpumask_full(&current->cpus_allowed)) {
 		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
 		for (i = 0; i < ncpus; i++)
-			if (cpu_isset(i, current->cpus_allowed)) {
+			if (cpumask_test_cpu(i, &current->cpus_allowed)) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
 					   "cpu %d/%d\n", current->comm,
 					   current->pid, i, ncpus);


