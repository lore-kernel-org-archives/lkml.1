Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYKDSfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYKDSfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYKDSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:34:51 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:18779 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYKDSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:34:50 -0500
X-IronPort-AV: E=Sophos;i="4.33,544,1220227200"; 
   d="scan'208";a="51504598"
From: Roland Dreier <rdreier@cisco.com>
To: jeff@garzik.org
Cc: "Phillip O'Donnell" <phillip.odonnell@gmail.com>,
       "Oskar Liljeblad" <oskar@osk.mine.nu>, linux-kernel@vger.kernel.org
Subject: [PATCH] libata: Avoid overflow in ata_tf_read_block() when tf->hba_lbal > 127
References: <20081028170105.GA21933@osk.mine.nu>
	<7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>
	<ada4p2wmg5n.fsf_-_@cisco.com>
	<7a9b5c320810281904x6b8b3226uaba502146be854a7@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 04 Nov 2008 10:34:48 -0800
In-Reply-To: <7a9b5c320810281904x6b8b3226uaba502146be854a7@mail.gmail.com>
	(Phillip O'Donnell's message of "Wed, 29 Oct 2008 15:04:17 +1300")
Message-ID: <adatzantk53.fsf_-_@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Nov 2008 18:34:49.0279 (UTC) FILETIME=[04CFBCF0:01C93EAC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip O'Donnell <phillip.odonnell@gmail.com> pointed out that the same
sign extension bug that was fixed in commit ba14a9c2 ("libata: Avoid
overflow in ata_tf_to_lba48() when tf->hba_lbal > 127") also appears to
exist in ata_tf_read_block().  Fix this by adding a cast to u64.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
I don't have any way to test this -- I guess you would have to get an
error on a block above 2G (ie data above 1TB)?  But it looks "obviously
correct" enough to add to -next I guess.

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 622350d..a6ad862 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -612,7 +612,7 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		if (tf->flags & ATA_TFLAG_LBA48) {
 			block |= (u64)tf->hob_lbah << 40;
 			block |= (u64)tf->hob_lbam << 32;
-			block |= tf->hob_lbal << 24;
+			block |= (u64)tf->hob_lbal << 24;
 		} else
 			block |= (tf->device & 0xf) << 24;
 
