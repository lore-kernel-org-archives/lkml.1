Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbXLVQle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbXLVQle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXLVQlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:41:25 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59469 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbXLVQlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:41:25 -0500
Date: Sun, 23 Dec 2007 01:41:03 +0900
To: dave@thedillows.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org, pw@osc.edu
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <1198275532.9979.43.camel@lap75545.ornl.gov>
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
	<1198275532.9979.43.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071223014407L.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 17:18:52 -0500
David Dillow <dave@thedillows.org> wrote:

> 
> On Fri, 2007-12-21 at 16:52 -0500, David Dillow wrote:
> > I'm getting the following oops when doing the following commands:
> > 
> > modprobe ib_srp
> > <add targets(s) to ib_srp using sysfs>
> > rmmod ib_srp
> > modprobe ib_srp
> > <OOPS>
> > 
> > I'm going to try and track down how the list is getting corrupted; it
> > looks like attribute_container_list in
> > drivers/base/attribute_container.c is the one getting corrupted.
> 
> Ok, found the culprit, now to figure out the motive and fix it.
> 
> ib_srp's srp_cleanup_module calls srp_release_transport(), which calls
> transport_container_unregister() for the rport_attr_cont member of
> struct srp_internal.
> 
> That last unregister call is returning -EBUSY, but it gets ignored, and
> the list node gets erased (or just reused) when the module's text/memory
> is free'd.

transport_container_unregister(&i->rport_attr_cont) should not fail here.

It fails because there is still a srp rport.

I think that as Pete pointed out, srp_remove_one needs to call
srp_remove_host.

Can you try this?

Thanks,

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
