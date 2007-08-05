Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbXHETyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbXHETyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXHETyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:54:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33343 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755839AbXHETyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:54:13 -0400
Date: Sun, 5 Aug 2007 21:53:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       =?utf-8?B?UmVuw6k=?= Treffer <treffer@in.tum.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [2.6.23 regression fix] fix thinkpad_acpi without hardware
Message-ID: <20070805195354.GF3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

René Treffer reported that booting a CONFIG_THINKPAD_ACPI=y kernel on a 
machine without the hardware results in an Oops.

The trace is thinkpad_acpi_module_init -> thinkpad_acpi_module_exit -> 
driver_remove_file -> sysfs_hash_and_remove.

The error handling if thinkpad_acpi_module_init() fails generally looks 
suspicious, but this patch at least fixes the common case if no hardware 
was found, and it seems in this case there isn't any cleanup 
actually required.

Broken by commit d5a2f2f1d68e2da538ac28540cddd9ccc733b001.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
bfa7bcd2b872f2c20afa7f7260d9be7dffe92d2e 
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index fa80f35..c7432a7 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -4644,10 +4644,8 @@ static int __init thinkpad_acpi_module_init(void)
 
 	get_thinkpad_model_data(&thinkpad_id);
 	ret = probe_for_thinkpad();
-	if (ret) {
-		thinkpad_acpi_module_exit();
+	if (ret)
 		return ret;
-	}
 
 	/* Driver initialization */
 

