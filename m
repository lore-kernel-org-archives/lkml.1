Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYAHUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYAHUZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYAHUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:25:26 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:64769 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYAHUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:25:25 -0500
X-IronPort-AV: E=Sophos;i="4.24,259,1196668800"; 
   d="scan'208";a="18570026"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 08 Jan 2008 12:25:23 -0800
Message-ID: <adatzlo83po.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jan 2008 20:25:24.0025 (UTC) FILETIME=[9916E290:01C85234]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few one-line fixes: change a maintainer email address
that is going away soon, fix a bug that would make the second port on
some HCAs useless, and fix SRP the right way now that the root cause
is fixed via James's tree.

(And just to counter James's suggestion that the SRP user base is
comparable to voyager's: these SRP fixes are coming from a real
production user, and that user is @ornl.gov, which means that SRP is
actually being used to do something involving things like atomic bombs
or sharks with laser beams)

Dave Dillow (1):
      IB/srp: Release transport before removing host

Dotan Barak (1):
      IB/mlx4: Fix value of pkey_index in QP1 completions

Sean Hefty (1):
      MAINTAINERS: Update Sean Hefty's email address

 MAINTAINERS                         |    2 +-
 drivers/infiniband/hw/mlx4/cq.c     |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 79c711e..56e6159 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1919,7 +1919,7 @@ INFINIBAND SUBSYSTEM
 P:	Roland Dreier
 M:	rolandd@cisco.com
 P:	Sean Hefty
-M:	mshefty@ichips.intel.com
+M:	sean.hefty@intel.com
 P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com 
 L:	general@lists.openfabrics.org
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 8bf44da..9d32c49 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -430,7 +430,7 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 		wc->dlid_path_bits = (be32_to_cpu(cqe->g_mlpath_rqpn) >> 24) & 0x7f;
 		wc->wc_flags      |= be32_to_cpu(cqe->g_mlpath_rqpn) & 0x80000000 ?
 			IB_WC_GRH : 0;
-		wc->pkey_index     = be32_to_cpu(cqe->immed_rss_invalid) >> 16;
+		wc->pkey_index     = be32_to_cpu(cqe->immed_rss_invalid) & 0x7f;
 	}
 
 	return 0;
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
