Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYIXTih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYIXTih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYIXTiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:38:17 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:50775 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbYIXTiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:38:16 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, serue@linux.vnet.ibm.com,
       safford@watson.ibm.com, debora@linux.vnet.ibm.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/2] TPM: Fixed tpm release timing
Date: Wed, 24 Sep 2008 16:34:17 -0300
Message-Id: <1222284857-32042-2-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1222284857-32042-1-git-send-email-srajiv@linux.vnet.ibm.com>
References: <1222284857-32042-1-git-send-email-srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed by Jonathan Corbet, the timer must be deleted before flushing
the work queue in order to avoid a job being submitted after 
the chip had been released.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Jonathan Corbet <corbet@lwn.net>
---
 drivers/char/tpm/tpm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ab03b4d..8d090d3 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1004,9 +1004,9 @@ int tpm_release(struct inode *inode, struct file *file)
 {
 	struct tpm_chip *chip = file->private_data;
 
+	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_scheduled_work();
 	file->private_data = NULL;
-	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
 	kfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
-- 
1.5.6.3

