Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZBEPHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZBEPHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbZBEPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:07:28 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:52882 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZBEPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:07:27 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, akpm@linux-foundation.org, serue@us.ibm.com,
       safford@watson.ibm.com, Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH] TPM: integrity fix
Date: Thu,  5 Feb 2009 13:06:30 -0200
Message-Id: <1233846390-21146-1-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to function which is called by IMA, now tpm_chip_find_get() considers the case in which the machine doesn't have a TPM or, if it has, its TPM isn't enabled.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 0387965..912a473 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -666,18 +666,20 @@ EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
  */
 static struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
-	struct tpm_chip *pos;
+	struct tpm_chip *pos, *chip = NULL;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
 		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
 			continue;
 
-		if (try_module_get(pos->dev->driver->owner))
+		if (try_module_get(pos->dev->driver->owner)) {
+			chip = pos;
 			break;
+		}
 	}
 	rcu_read_unlock();
-	return pos;
+	return chip;
 }
 
 #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
-- 
1.5.6.3

