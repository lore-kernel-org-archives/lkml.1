Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYGZGXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYGZGXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYGZGXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:23:38 -0400
Received: from nebensachen.de ([195.34.83.29]:37617 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYGZGXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:23:37 -0400
X-Hashcash: 1:20:080726:alan@lxorguk.ukuu.org.uk::XEw39h9HKu4pobfr:00000000000000000000000000000000000004uIN
X-Hashcash: 1:20:080726:jeff@garzik.org::hH4lfGbT/K9ZZcYL:002yEc
X-Hashcash: 1:20:080726:bzolnier@gmail.com::jX44TxwwK/J1NDFi:00000000000000000000000000000000000000000007+XX
X-Hashcash: 1:20:080726:james.bottomley@hansenpartnership.com::wO+MrU0qght6/Yv3:0000000000000000000000001JJA
X-Hashcash: 1:20:080726:pavel@ucw.cz::jVJwkTXVGiOgudPI:000001PDN
X-Hashcash: 1:20:080726:linux-ide@vger.kernel.org::PLB+N0gBXvFsjn6H:0000000000000000000000000000000000006Exl
X-Hashcash: 1:20:080726:linux-kernel@vger.kernel.org::NrQEQQEJRmZi0M0A:0000000000000000000000000000000000gRS
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Make sure that ata_force_tbl is freed in case of an error
In-Reply-To: <87prp1kvyy.fsf@denkblock.local>
Message-ID: <20080726062141.29070.75212.stgit@denkblock.local>
References: <87prp1kvyy.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 08:23:23 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a trivial fix of a potential memory leak when ata_init()
encounters an error.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ata/libata-core.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9bef1a8..0a2f921 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6088,16 +6088,20 @@ static int __init ata_init(void)
 
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
-		return -ENOMEM;
+		goto free_force_tbl;
 
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
-	if (!ata_aux_wq) {
-		destroy_workqueue(ata_wq);
-		return -ENOMEM;
-	}
+	if (!ata_aux_wq)
+		goto free_wq;
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
+
+free_wq:
+	destroy_workqueue(ata_wq);
+free_force_tbl:
+	kfree(ata_force_tbl);
+	return -ENOMEM;
 }
 
 static void __exit ata_exit(void)


