Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXCOWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXCOWPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933890AbXCOWPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:39 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33692 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 29 of 33] IB/ipath - fix unit selection due to all cpu
	affinity bits set
X-Mercurial-Node: 8c4f730dbde3eed6e066ead5be4746d58840f24f
Message-Id: <8c4f730dbde3eed6e066.1173995113@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:13 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID 8c4f730dbde3eed6e066ead5be4746d58840f24f
# Parent  b436c73d4fe312c3cba092d5f642de5c0ff6aa91
IB/ipath - fix unit selection due to all cpu affinity bits set

At some point things changed so that all the affinity bits can be
set, but cpus_full() macro is not true.  This caused problems with
the unit selection logic on multi-unit (board) configurations.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r b436c73d4fe3 -r 8c4f730dbde3 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
@@ -1592,15 +1592,16 @@ static int find_best_unit(struct file *f
 	 */
 	if (!cpus_empty(current->cpus_allowed) &&
 	    !cpus_full(current->cpus_allowed)) {
-		int ncpus = num_online_cpus(), curcpu = -1;
+		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
 		for (i = 0; i < ncpus; i++)
 			if (cpu_isset(i, current->cpus_allowed)) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
-					   "cpu %d\n", current->comm,
-					   current->pid, i);
+					   "cpu %d/%d\n", current->comm,
+					   current->pid, i, ncpus);
 				curcpu = i;
+				nset++;
 			}
-		if (curcpu != -1) {
+		if (curcpu != -1 && nset != ncpus) {
 			if (npresent) {
 				prefunit = curcpu / (ncpus / npresent);
 				ipath_cdbg(PROC,"%s[%u] %d chips, %d cpus, "
