Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbYJJVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbYJJVl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761461AbYJJVlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:41:50 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:22760 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761447AbYJJVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:41:49 -0400
X-IronPort-AV: E=Sophos;i="4.33,391,1220227200"; 
   d="scan'208";a="172907504"
From: Roland Dreier <rdreier@cisco.com>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, micfaath@de.ibm.com, raisch@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: [PATCH 1/1] IB/ehca: Disallow creating UC QP with SRQ
References: <200810011306.31544.hnguyen@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 10 Oct 2008 14:41:39 -0700
In-Reply-To: <200810011306.31544.hnguyen@linux.vnet.ibm.com> (Hoang-Nam
	Nguyen's message of "Wed, 1 Oct 2008 13:06:31 +0200")
Message-ID: <adazllcku0c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Oct 2008 21:41:40.0388 (UTC) FILETIME=[FAD37640:01C92B20]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied -- it didn't apply to the latest tree, because of the
flush CQE changes, so I merged it manually as below -- let me know if
this is wrong:

commit 0540bbbe455e123a1692d26205ad1a29983883b0
Author: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Date:   Fri Oct 10 14:40:39 2008 -0700

    IB/ehca: Don't allow creating UC QP with SRQ
    
    This patch prevents a UC QP to be created attached to an SRQ, since
    current firmware does not support this feature.
    
    Signed-off-by: Michael Faath <micfaath@de.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 4dbe287..40b578d 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -502,6 +502,12 @@ static struct ehca_qp *internal_create_qp(
 	if (init_attr->srq) {
 		my_srq = container_of(init_attr->srq, struct ehca_qp, ib_srq);
 
+		if (qp_type == IB_QPT_UC) {
+			ehca_err(pd->device, "UC with SRQ not supported");
+			atomic_dec(&shca->num_qps);
+			return ERR_PTR(-EINVAL);
+		}
+
 		has_srq = 1;
 		parms.ext_type = EQPT_SRQBASE;
 		parms.srq_qpn = my_srq->real_qp_num;
