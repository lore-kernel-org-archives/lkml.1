Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZFETTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZFETTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZFETTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:19:12 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60616 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631AbZFETTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:19:07 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191851.584051004@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:26 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
       Olaf Weber <olaf@sgi.com>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 07/11] xfs_icsb_modify_counters does not need "cpu" variable
Content-Disposition: inline; filename=this_cpu_ptr_xfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xfs_icsb_modify_counters() function no longer needs the cpu variable
if we use this_cpu_ptr() and we can get rid of get/put_cpu().

cc: Christoph Hellwig <hch@lst.de>
Acked-by: Olaf Weber <olaf@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/xfs/xfs_mount.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2009-05-28 15:03:50.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_mount.c	2009-05-28 15:09:05.000000000 -0500
@@ -2320,12 +2320,12 @@ xfs_icsb_modify_counters(
 {
 	xfs_icsb_cnts_t	*icsbp;
 	long long	lcounter;	/* long counter for 64 bit fields */
-	int		cpu, ret = 0;
+	int		ret = 0;
 
 	might_sleep();
 again:
-	cpu = get_cpu();
-	icsbp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, cpu);
+	preempt_disable();
+	icsbp = (xfs_icsb_cnts_t *)this_cpu_ptr(mp->m_sb_cnts);
 
 	/*
 	 * if the counter is disabled, go to slow path
@@ -2369,11 +2369,11 @@ again:
 		break;
 	}
 	xfs_icsb_unlock_cntr(icsbp);
-	put_cpu();
+	preempt_enable();
 	return 0;
 
 slow_path:
-	put_cpu();
+	preempt_enable();
 
 	/*
 	 * serialise with a mutex so we don't burn lots of cpu on
@@ -2421,7 +2421,7 @@ slow_path:
 
 balance_counter:
 	xfs_icsb_unlock_cntr(icsbp);
-	put_cpu();
+	preempt_enable();
 
 	/*
 	 * We may have multiple threads here if multiple per-cpu

-- 
