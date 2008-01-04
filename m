Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYADVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYADVpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYADVpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:45:24 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45700 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbYADVpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:45:23 -0500
Subject: [GIT PATCH] another SCSI critical bug fix for 2.6.24-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Jan 2008 15:45:17 -0600
Message-Id: <1199483117.17877.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They just keep coming out of the woodwork, sorry.  This one's in the
SCSI over RDMA Protocol transport class, so it's causing SCSI over
infiniband installations to oops on shutdown.  I'm told that their are
now nearly as many SCSI over IB users as their are voyager users, so,
since it's nearly mainstream, we need to fix the problem urgently ...

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

I've just attached it below as well.

James

---

>From 911833440b498e3e4fe2f12c1ae2bd44400c7004 Mon Sep 17 00:00:00 2001
From: Dave Dillow <dillowda@ornl.gov>
Date: Thu, 3 Jan 2008 21:34:49 -0500
Subject: [SCSI] SRP transport: only remove our own entries

The SCSI SRP transport class currently iterates over all children
devices of the host that is being removed in srp_remove_host(). However,
not all of those children were created by the SRP transport, and
removing them will cause corruption and an oops when their creator tries
to remove them.

Signed-off-by: David Dillow <dillowda@ornl.gov>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_transport_srp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
 
-- 
1.5.3.7



