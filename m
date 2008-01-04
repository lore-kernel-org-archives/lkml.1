Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYADDfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYADDfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 22:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYADDfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 22:35:47 -0500
Received: from smtp.knology.net ([24.214.63.101]:49475 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYADDfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 22:35:46 -0500
Subject: [2.6.24-rc minor bugfix] IB/srp: release transport before removing
	host
From: Dave Dillow <dillowda@ornl.gov>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
In-Reply-To: <20080104115427F.fujita.tomonori@lab.ntt.co.jp>
References: <1199393485.7561.51.camel@lap75545.ornl.gov>
	 <20080104094722F.fujita.tomonori@lab.ntt.co.jp>
	 <1199414359.3636.13.camel@obelisk.thedillows.org>
	 <20080104115427F.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Oak RIdge National Laboratory
Date: Thu, 03 Jan 2008 22:35:41 -0500
Message-Id: <1199417741.3636.18.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documented call sequence for removing a host is to call the
transport xxx_remove_host() prior to scsi_remove_host(). The SRP
transport used to crash when that order was followed, but as it is now
fixed, use the documented order.

Signed-off-by: David Dillow <dillowda@ornl.gov>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---

On Fri, 2008-01-04 at 11:54 +0900, FUJITA Tomonori wrote:
> Linus has already merged your previous patch:
[snip]
> So please resend a patch to move srp_remove_host before
> scsi_remove_host instead of adding srp_remove_host.
[snip]
> > Not sure if your Acked-by was for this one as well, so I left it off.
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 77e8b90..bdb6f85 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2053,8 +2053,8 @@ static void srp_remove_one(struct ib_device *device)
 
 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
-			scsi_remove_host(target->scsi_host);
 			srp_remove_host(target->scsi_host);
+			scsi_remove_host(target->scsi_host);
 			srp_disconnect_target(target);
 			ib_destroy_cm_id(target->cm_id);
 			srp_free_target_ib(target);

