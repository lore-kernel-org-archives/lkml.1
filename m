Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZFPIvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZFPIvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZFPIu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:50:59 -0400
Received: from webmail.frequentis.com ([213.47.210.151]:26736 "EHLO
	webmail.frequentis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZFPIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:50:58 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 04:50:58 EDT
Date: Tue, 16 Jun 2009 10:35:12 +0200
From: Christian Engelmayer <christian.engelmayer@frequentis.com>
To: mingo@elte.hu
Cc: christian.engelmayer@frequentis.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] scheduler: access to variable out of scope in
 sched_slice()
Message-ID: <20090616103512.0c846e51@frequentis.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2009 08:35:12.0783 (UTC) FILETIME=[5DAE19F0:01C9EE5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Engelmayer <christian.engelmayer@frequentis.com>

Access to local variable lw is aliased by usage of pointer load. Access to
pointer load in calc_delta_mine() happens when lw is already out of scope.

Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
--
Reported by static code analysis. 

--- linux-2.6.30/kernel/sched_fair.c.orig	2009-06-16 10:01:50.000000000 +0200
+++ linux-2.6.30/kernel/sched_fair.c	2009-06-16 10:02:39.000000000 +0200
@@ -430,12 +430,13 @@ static u64 sched_slice(struct cfs_rq *cf
 
 	for_each_sched_entity(se) {
 		struct load_weight *load;
+		struct load_weight lw;
 
 		cfs_rq = cfs_rq_of(se);
 		load = &cfs_rq->load;
 
 		if (unlikely(!se->on_rq)) {
-			struct load_weight lw = cfs_rq->load;
+			lw = cfs_rq->load;
 
 			update_load_add(&lw, se->load.weight);
 			load = &lw;
