Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZGNSsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZGNSsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZGNSsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:48:54 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33917 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbZGNSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:48:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADdwXEqrR7PD/2dsb2JhbAC5cIgjkDYFhAiBQg
X-IronPort-AV: E=Sophos;i="4.42,398,1243814400"; 
   d="scan'208";a="346581203"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 14 Jul 2009 11:48:52 -0700
Message-ID: <adaskgzt817.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jul 2009 18:48:52.0801 (UTC) FILETIME=[BBAFFB10:01CA04B3]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a new PCI ID for the mlx4 driver, which also requires
handling one new firmware status code.  The chance of regressions
should be near-nil, since existing devices won't hit any of the new
code (and the worst case seems to be printing an incorrect error
message anyway).

Yevgeny Petrilin (2):
      mlx4_core: Handle multi-physical function devices
      mlx4_core: Add new ConnectX EN PCI ID 0x6764

 drivers/net/mlx4/cmd.c  |    5 ++++-
 drivers/net/mlx4/main.c |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index 2845a05..65ec77d 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -80,7 +80,9 @@ enum {
 	/* Bad management packet (silently discarded): */
 	CMD_STAT_BAD_PKT	= 0x30,
 	/* More outstanding CQEs in CQ than new CQ size: */
-	CMD_STAT_BAD_SIZE	= 0x40
+	CMD_STAT_BAD_SIZE	= 0x40,
+	/* Multi Function device support required: */
+	CMD_STAT_MULTI_FUNC_REQ	= 0x50,
 };
 
 enum {
@@ -128,6 +130,7 @@ static int mlx4_status_to_errno(u8 status)
 		[CMD_STAT_LAM_NOT_PRE]	  = -EAGAIN,
 		[CMD_STAT_BAD_PKT]	  = -EINVAL,
 		[CMD_STAT_BAD_SIZE]	  = -ENOMEM,
+		[CMD_STAT_MULTI_FUNC_REQ] = -EACCES,
 	};
 
 	if (status >= ARRAY_SIZE(trans_table) ||
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 018348c..dac621b 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -729,7 +729,10 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 
 	err = mlx4_QUERY_FW(dev);
 	if (err) {
-		mlx4_err(dev, "QUERY_FW command failed, aborting.\n");
+		if (err == -EACCES)
+			mlx4_info(dev, "non-primary physical function, skipping.\n");
+		else
+			mlx4_err(dev, "QUERY_FW command failed, aborting.\n");
 		return err;
 	}
 
@@ -1285,6 +1288,7 @@ static struct pci_device_id mlx4_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x6750) }, /* MT25408 "Hermon" EN 10GigE PCIe gen2 */
 	{ PCI_VDEVICE(MELLANOX, 0x6372) }, /* MT25458 ConnectX EN 10GBASE-T 10GigE */
 	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT25458 ConnectX EN 10GBASE-T+Gen2 10GigE */
+	{ PCI_VDEVICE(MELLANOX, 0x6764) }, /* MT26468 ConnectX EN 10GigE PCIe gen2*/
 	{ 0, }
 };
 
