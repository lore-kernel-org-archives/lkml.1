Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYHURmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYHURmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760460AbYHURl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:41:28 -0400
Received: from mail.suse.de ([195.135.220.2]:48635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760425AbYHURl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:41:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/15] pnp: fix "add acpi:* modalias entries"
Date: Thu, 21 Aug 2008 10:33:03 -0700
Message-Id: <1219339983-9634-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

With 22454cb99fc39f2629ad06a7eccb3df312f8830e we added only the
first entry of the device table. We need to loop over the whole
device list.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 scripts/mod/file2alias.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 4fa1f3a..4c9890e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -344,14 +344,20 @@ static void do_pnp_device_entry(void *symval, unsigned long size,
 				struct module *mod)
 {
 	const unsigned long id_size = sizeof(struct pnp_device_id);
-	const struct pnp_device_id *id = symval;
+	const unsigned int count = (size / id_size)-1;
+	const struct pnp_device_id *devs = symval;
+	unsigned int i;
 
 	device_id_check(mod->name, "pnp", size, id_size, symval);
 
-	buf_printf(&mod->dev_table_buf,
-		   "MODULE_ALIAS(\"pnp:d%s*\");\n", id->id);
-	buf_printf(&mod->dev_table_buf,
-		   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id->id);
+	for (i = 0; i < count; i++) {
+		const char *id = (char *)devs[i].id;
+
+		buf_printf(&mod->dev_table_buf,
+			   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+		buf_printf(&mod->dev_table_buf,
+			   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id);
+	}
 }
 
 /* looks like: "pnp:dD" for every device of the card */
-- 
1.5.6.5

