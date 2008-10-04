Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYJDVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYJDVvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYJDVvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:51:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:27229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYJDVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TCeNof3sLh1kX1MORvxe7LzNETR09QSYfFS/dl2prvl6uhuhCzvvzYrbXrFgDKl5L9
         Y4o3r9U896LlWSY3LpVEUAuPD8mI2ItOw3rKoNF30Bry3UG3gUsKfidSZNPy6/rSf20d
         QsMOkRRix2be+gFTsHWPIphb/Kjsb/vFBcXIc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in var mtrrs
Date: Sat,  4 Oct 2008 14:50:32 -0700
Message-Id: <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1292,6 +1292,15 @@ static int __init mtrr_cleanup(unsigned
 			(mtrr_tom2 >> PAGE_SHIFT) - extra_remove_base;
 	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base,
 					  extra_remove_size);
+	/*
+	 * [0, 1M) should always be coverred by var mtrr with WB
+	 * and fixed mtrrs should take effective before var mtrr for it
+	 */
+	nr_range = add_range_with_merge(range, nr_range, 0,
+					(1ULL<<(20 - PAGE_SHIFT)) - 1);
+	/* sort the ranges */
+	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+
 	range_sums = sum_ranges(range, nr_range);
 	printk(KERN_INFO "total RAM coverred: %ldM\n",
 	       range_sums >> (20 - PAGE_SHIFT));
