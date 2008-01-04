Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYADCfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYADCfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYADCey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:34:54 -0500
Received: from smtp.knology.net ([24.214.63.101]:42497 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYADCex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:34:53 -0500
Subject: [2.6.24-rc BUGFIX] SRP transport: only remove our own entries
From: Dave Dillow <dillowda@ornl.gov>
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080104094722F.fujita.tomonori@lab.ntt.co.jp>
References: <20080103173330T.tomof@acm.org>
	 <1199390957.7561.33.camel@lap75545.ornl.gov>
	 <1199393485.7561.51.camel@lap75545.ornl.gov>
	 <20080104094722F.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Oak RIdge National Laboratory
Date: Thu, 03 Jan 2008 21:34:49 -0500
Message-Id: <1199414089.3636.7.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI SRP transport class currently iterates over all children
devices of the host that is being removed in srp_remove_host(). However,
not all of those children were created by the SRP transport, and
removing them will cause corruption and an oops when their creator tries
to remove them.

Signed-off-by: David Dillow <dillowda@ornl.gov>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
On Fri, 2008-01-04 at 09:47 +0900, FUJITA Tomonori wrote:
> On Thu, 03 Jan 2008 15:51:25 -0500
> I think that this is the root problem and the patch fixes it in the
> right way. Please send this patch to linux-scsi@vger.kernel.org and a
> patch to move srp_remove_host before scsi_remove_host in
> srp_remove_one to Roland.
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 44a340b..65c584d 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -265,7 +265,8 @@ EXPORT_SYMBOL_GPL(srp_rport_del);
 
 static int do_srp_rport_del(struct device *dev, void *data)
 {
-	srp_rport_del(dev_to_rport(dev));
+	if (scsi_is_srp_rport(dev))
+		srp_rport_del(dev_to_rport(dev));
 	return 0;
 }
 

