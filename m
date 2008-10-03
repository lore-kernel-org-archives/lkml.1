Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYJCQa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYJCQa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYJCQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:30:25 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:35339 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYJCQaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:30:24 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, zohar@linux.vnet.ibm.com, akpm@linux-foundation.org,
       jmorris@namei.org
Subject: [PATCH 5/5] TPM: Fixed tpm_release() timing
Date: Fri,  3 Oct 2008 13:30:10 -0300
Message-Id: <8c2433aaa7856591c06d1168a30e109d2183519f.1223042186.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
In-Reply-To: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Jonathan Corbet, the timer must be deleted before flushing
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

