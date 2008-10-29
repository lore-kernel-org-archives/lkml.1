Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJ2PHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJ2PHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJ2PHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:07:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41153 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYJ2PHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:07:34 -0400
Subject: Re: [UPDATED PATCH VER2] Cell OProfile: Incorrect local array size
	in activate spu profiling function
From: Carl Love <cel@us.ibm.com>
To: michael@ellerman.id.au
Cc: Hannsj_uhl <Hannsj_uhl@de.ibm.com>, acjohnso <acjohnso@us.ibm.com>,
       oprofile-list@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       cel@linux.vnet.ibm.com, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1225241514.7799.2.camel@localhost>
References: <1224874049.20229.5.camel@carll-linux-desktop>
	 <1224909595.16090.5.camel@localhost>
	 <1225207079.20229.32.camel@carll-linux-desktop>
	 <1225241514.7799.2.camel@localhost>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 08:06:45 -0700
Message-Id: <1225292805.20229.52.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the patch to address comments by Michael Ellerman.  
Specifically, changed upper limit in for loop to 
ARRAY_SIZE() macro and added a check to make sure the 
number of events specified by the user, which is used as
the max for indexing various arrays, is no bigger then the
declared size of the arrays.

The size of the pm_signal_local array should be equal to the
number of SPUs being configured in the array.  Currently, the
array is of size 4 (NR_PHYS_CTRS) but being indexed by a for 
loop from 0 to 7 (NUM_SPUS_PER_NODE).  

Signed-off-by: Carl Love <carll@us.ibm.com>


Index: Cell_kernel_10_24_2008/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_10_24_2008.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_10_24_2008/arch/powerpc/oprofile/op_model_cell.c
@@ -582,6 +582,13 @@ static int cell_reg_setup(struct op_coun
 
 	num_counters = num_ctrs;
 
+	if (unlikely(num_ctrs > NR_PHYS_CTRS)) {
+		printk(KERN_ERR
+		       "%s: Oprofile, number of specified events " \
+		       "exceeds number of physical counters\n",
+		       __func__);
+		return -EIO;
+	}
 	pm_regs.group_control = 0;
 	pm_regs.debug_bus_control = 0;
 
@@ -830,13 +837,13 @@ static int calculate_lfsr(int n)
 static int pm_rtas_activate_spu_profiling(u32 node)
 {
 	int ret, i;
-	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
+	struct pm_signal pm_signal_local[NUM_SPUS_PER_NODE];
 
 	/*
 	 * Set up the rtas call to configure the debug bus to
 	 * route the SPU PCs.  Setup the pm_signal for each SPU
 	 */
-	for (i = 0; i < NUM_SPUS_PER_NODE; i++) {
+	for (i = 0; i < ARRAY_SIZE(pm_signal_local); i++) {
 		pm_signal_local[i].cpu = node;
 		pm_signal_local[i].signal_group = 41;
 		/* spu i on word (i/2) */
@@ -848,7 +855,7 @@ static int pm_rtas_activate_spu_profilin
 
 	ret = rtas_ibm_cbe_perftools(SUBFUNC_ACTIVATE,
 				     PASSTHRU_ENABLE, pm_signal_local,
-				     (NUM_SPUS_PER_NODE
+				     (ARRAY_SIZE(pm_signal_local)
 				      * sizeof(struct pm_signal)));
 
 	if (unlikely(ret)) {


