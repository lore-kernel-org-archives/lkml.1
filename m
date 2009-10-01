Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZJBBtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZJBBtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZJBBth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:49:37 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:53283 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756079AbZJBBd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:28 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20091001212559.113173079@gentwo.org>
References: <20091001212521.123389189@gentwo.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Oct 2009 17:25:29 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Olaf Weber <olaf@sgi.com>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V4 08/20] this_cpu_ptr: xfs_icsb_modify_counters does not need "cpu" variable
Content-Disposition: inline; filename=this_cpu_ptr_xfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xfs_icsb_modify_counters() function no longer needs the cpu variable
if we use this_cpu_ptr() and we can get rid of get/put_cpu().

Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Olaf Weber <olaf@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/xfs/xfs_mount.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2009-06-15 09:08:01.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_mount.c	2009-06-15 14:20:11.000000000 -0500
@@ -2389,12 +2389,12 @@ xfs_icsb_modify_counters(
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
+	icsbp = this_cpu_ptr(mp->m_sb_cnts);
 
 	/*
 	 * if the counter is disabled, go to slow path
@@ -2438,11 +2438,11 @@ again:
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
@@ -2490,7 +2490,7 @@ slow_path:
 
 balance_counter:
 	xfs_icsb_unlock_cntr(icsbp);
-	put_cpu();
+	preempt_enable();
 
 	/*
 	 * We may have multiple threads here if multiple per-cpu

-- 
