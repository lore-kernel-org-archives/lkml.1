Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXFMUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXFMUxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXFMUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:53:45 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:46857 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbXFMUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:53:44 -0400
X-IronPort-AV: i="4.16,417,1175497200"; 
   d="scan'208"; a="2981763:sNHT29798052"
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whole bunch o' new IB warnings
X-Message-Flag: Warning: May contain useful information
References: <4670568A.7030809@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 13 Jun 2007 13:53:41 -0700
In-Reply-To: <4670568A.7030809@garzik.org> (Jeff Garzik's message of "Wed, 13 Jun 2007 16:41:46 -0400")
Message-ID: <adaejkf4luy.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Jun 2007 20:53:42.0339 (UTC) FILETIME=[ED074930:01C7ADFC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Current git tree on x86-64 (make allmodconfig) wants fixing for 2.6.22:
 > 
 > drivers/infiniband/hw/mlx4/qp.c: In function ‘set_rq_size’:
 > drivers/infiniband/hw/mlx4/qp.c:210: warning: comparison of distinct
 > pointer types lacks a cast

Thanks, you're right.  You have to admit, it's pretty amusing how many
times roundup_pow_of_two() expands its argument (via ilog2)...

Anyway, I have this queued up to fix it.  I'll ask Linus to pull shortly.

commit 42c059ea2b0aac5f961253ba81c1b464d181a600
Author: Roland Dreier <rolandd@cisco.com>
Date:   Tue Jun 12 10:52:02 2007 -0700

    IB/mlx4: Fix warning in rounding up queue sizes
    
    Doing max(1, foo) where foo is u32 generates a warning, because 1 is a
    signed constant.  Fix this by using 1U instead.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 5c6d054..4c15fa3 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -207,8 +207,8 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge))
 			return -EINVAL;
 
-		qp->rq.max	 = roundup_pow_of_two(max(1, cap->max_recv_wr));
-		qp->rq.max_gs	 = roundup_pow_of_two(max(1, cap->max_recv_sge));
+		qp->rq.max	 = roundup_pow_of_two(max(1U, cap->max_recv_wr));
+		qp->rq.max_gs	 = roundup_pow_of_two(max(1U, cap->max_recv_sge));
 		qp->rq.wqe_shift = ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg));
 	}
 
