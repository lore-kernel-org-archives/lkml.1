Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYACUUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYACUUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYACUUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:20:14 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:64862 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYACUUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:20:12 -0500
Date: Thu, 03 Jan 2008 15:20:09 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
In-reply-to: <1199391187.7561.38.camel@lap75545.ornl.gov>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Message-id: <1199391609.7561.46.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <adak5mqu5i8.fsf@cisco.com>
 <1199385590.7561.11.camel@lap75545.ornl.gov> <adafxxeu495.fsf@cisco.com>
 <1199391187.7561.38.camel@lap75545.ornl.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: IB/srp: Fix list corruption/oops on module reload

ib_srp doesn't clean up the transport attributes properly when
unloading, so it leaves references around to free'd memory.

The srp_remove_host() cannot go before the scsi_remove_host() call as
the documented call sequence suggests, as it will cause an oops when the
SRP transport code will free up an object that is not its own. So,
temporarily reorder the calls in srp_remove_work() to avoid the problem
as well until the transport code can be fixed.

Signed-off-by: David Dillow <dillowda@ornl.gov>
---
On Thu, 2008-01-03 at 15:13 -0500, David Dillow wrote:
> I'll send a new patch to you for just the ib_srp.c side.

Should've just sent it with the last email.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 950228f..6e7e3c8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -423,8 +423,8 @@ static void srp_remove_work(struct work_struct *work)
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
 
-	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
+	srp_remove_host(target->scsi_host);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	scsi_host_put(target->scsi_host);
@@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
 			scsi_remove_host(target->scsi_host);
+			srp_remove_host(target->scsi_host);
 			srp_disconnect_target(target);
 			ib_destroy_cm_id(target->cm_id);
 			srp_free_target_ib(target);


