Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbXLZROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbXLZROV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 12:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLZROO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 12:14:14 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:46089 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXLZRON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 12:14:13 -0500
Date: Wed, 26 Dec 2007 12:14:11 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
In-reply-to: <20071223014407L.tomof@acm.org>
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org, pw@osc.edu,
       fujita.tomonori@lab.ntt.co.jp
Message-id: <1198689251.25003.2.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
 <1198275532.9979.43.camel@lap75545.ornl.gov> <20071223014407L.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-23 at 01:41 +0900, FUJITA Tomonori wrote:
> transport_container_unregister(&i->rport_attr_cont) should not fail here.
> 
> It fails because there is still a srp rport.
> 
> I think that as Pete pointed out, srp_remove_one needs to call
> srp_remove_host.
> 
> Can you try this?

That patched oopsed in scsi_remove_host(), but reversing the order has
survived over 500 insert/probe/remove cycles.

Tested-by: David Dillow <dillowda@ornl.gov>
---
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 950228f..77e8b90 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
 			scsi_remove_host(target->scsi_host);
+			srp_remove_host(target->scsi_host);
 			srp_disconnect_target(target);
 			ib_destroy_cm_id(target->cm_id);
 			srp_free_target_ib(target);


