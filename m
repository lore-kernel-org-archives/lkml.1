Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0BDOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:40:26 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20691 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954Ab0BDOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:40:13 -0500
Subject: [PATCH 19/30] hpsa: Retry commands completing with a sense key of
	ABORTED_COMMAND
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:43:00 -0600
Message-ID: <20100204144300.10406.47550.stgit@beardog.cce.hp.com>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Gates <matthew.gates@hp.com>

hpsa: Retry commands completing with a sense key of ABORTED_COMMAND

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bcc51f9..d07b3d3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1037,8 +1037,15 @@ static void complete_scsi_command(struct CommandList *cp,
 					break;
 				}
 			}
-
-
+			if (sense_key == ABORTED_COMMAND) {
+				/* Aborted command is retryable */
+				dev_warn(&h->pdev->dev, "cp %p "
+					"has check condition: aborted command: "
+					"ASC: 0x%x, ASCQ: 0x%x\n",
+					cp, asc, ascq);
+				cmd->result = DID_SOFT_ERROR << 16;
+				break;
+			}
 			/* Must be some other type of check condition */
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "

