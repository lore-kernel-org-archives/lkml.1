Return-Path: <linux-kernel-owner+w=401wt.eu-S1765288AbXLTWSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765288AbXLTWSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762515AbXLTWQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:16:31 -0500
Received: from baron.coraid.com ([65.14.39.133]:28912 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762507AbXLTWQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:16:26 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/13] only install new AoE device once
Date: Thu, 20 Dec 2007 17:15:56 -0500
Message-Id: <1198188961-25147-8-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An aoe driver user who had about 70 AoE targets found that he was
hitting a BUG in sysfs_create_file because the aoe driver was trying
to tell the kernel about an AoE device more than once.  Each AoE
device was reachable by several local network interfaces, and multiple
ATA device indentify responses were returning from that single device.

This patch eliminates a race condition so that aoe always informs the
block layer of a new AoE device once in the presence of multiple
incoming ATA device identify responses.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index b49e06e..7a96183 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -698,6 +698,8 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
 	d->geo.start = 0;
+	if (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
+		return;
 	if (d->gd != NULL) {
 		d->gd->capacity = ssize;
 		d->flags |= DEVFL_NEWSIZE;
-- 
1.5.3.4

