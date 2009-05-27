Return-Path: <linux-kernel-owner+w=401wt.eu-S933229AbZE0STI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbZE0STI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761582AbZE0SS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:18:56 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47122 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761538AbZE0SSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:18:55 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090527180716.456986138@gentwo.org>
References: <20090527180635.008102701@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 13:47:02 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
       Olaf Weber <olaf@sgi.com>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [my_cpu_ptr 4/5] sda_icsb_modify_counters() does not need a "cpu" variable
Content-Disposition: inline; filename=my_cpu_ptr_xfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xfs_icsb_modify_counters() function no longer needs the cpu variable
if we use my_cpu_ptr() and we can get rid of get/put_cpu().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Olaf Weber <olaf@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/xfs/xfs_mount.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2009-05-27 11:54:37.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_mount.c	2009-05-27 11:55:10.000000000 -0500
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
+	icsbp = (xfs_icsb_cnts_t *)my_cpu_ptr(mp->m_sb_cnts);
 
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
