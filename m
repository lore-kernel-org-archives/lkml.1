Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYADCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYADCji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbYADCjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:39:24 -0500
Received: from smtp.knology.net ([24.214.63.101]:35205 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbYADCjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:39:22 -0500
Subject: [2.6.24-rc BUGFIX] IB/srp: release transport when removing host
From: Dave Dillow <dillowda@ornl.gov>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
In-Reply-To: <20080104094722F.fujita.tomonori@lab.ntt.co.jp>
References: <20080103173330T.tomof@acm.org>
	 <1199390957.7561.33.camel@lap75545.ornl.gov>
	 <1199393485.7561.51.camel@lap75545.ornl.gov>
	 <20080104094722F.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Oak RIdge National Laboratory
Date: Thu, 03 Jan 2008 21:39:19 -0500
Message-Id: <1199414359.3636.13.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing the ib_srp module, srp_remove_one() does not release the
SRP transport class when it is releasing the SCSI host. This leads to
dangling references to kfree()'d memory, and an eventual oops.

Signed-off-by: David Dillow <dillowda@ornl.gov>
---
On Fri, 2008-01-04 at 09:47 +0900, FUJITA Tomonori wrote:
> I think that this is the root problem and the patch fixes it in the
> right way. Please send this patch to linux-scsi@vger.kernel.org and a
> patch to move srp_remove_host before scsi_remove_host in
> srp_remove_one to Roland.
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Not sure if your Acked-by was for this one as well, so I left it off.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 950228f..bdb6f85 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2053,6 +2053,7 @@ static void srp_remove_one(struct ib_device *device)
 
 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
+			srp_remove_host(target->scsi_host);
 			scsi_remove_host(target->scsi_host);
 			srp_disconnect_target(target);
 			ib_destroy_cm_id(target->cm_id);

