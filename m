Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbZAUFVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbZAUFVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZAUFVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:21:10 -0500
Received: from kroah.org ([198.145.64.141]:53317 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbZAUFVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:21:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Bryan Kadzban <bryan@kadzban.is-a-geek.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] PNP: fix broken pnp lowercasing for acpi module aliases
Date: Tue, 20 Jan 2009 21:19:54 -0800
Message-Id: <1232515197-3974-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090121051855.GA3665@kroah.com>
References: <20090121051855.GA3665@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Based on a patch from Brian, who identified the issue.

Signed-off-by: Bryan Kadzban <bryan@kadzban.is-a-geek.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 scripts/mod/file2alias.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d4dc222..491b8b1 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -366,11 +366,17 @@ static void do_pnp_device_entry(void *symval, unsigned long size,
 
 	for (i = 0; i < count; i++) {
 		const char *id = (char *)devs[i].id;
+		char acpi_id[sizeof(devs[0].id)];
+		int j;
 
 		buf_printf(&mod->dev_table_buf,
 			   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+
+		/* fix broken pnp bus lowercasing */
+		for (j = 0; j < sizeof(acpi_id); j++)
+			acpi_id[j] = toupper(id[j]);
 		buf_printf(&mod->dev_table_buf,
-			   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id);
+			   "MODULE_ALIAS(\"acpi*:%s:*\");\n", acpi_id);
 	}
 }
 
@@ -416,10 +422,17 @@ static void do_pnp_card_entries(void *symval, unsigned long size,
 
 			/* add an individual alias for every device entry */
 			if (!dup) {
+				char acpi_id[sizeof(card->devs[0].id)];
+				int k;
+
 				buf_printf(&mod->dev_table_buf,
 					   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+
+				/* fix broken pnp bus lowercasing */
+				for (k = 0; k < sizeof(acpi_id); k++)
+					acpi_id[k] = toupper(id[k]);
 				buf_printf(&mod->dev_table_buf,
-					   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id);
+					   "MODULE_ALIAS(\"acpi*:%s:*\");\n", acpi_id);
 			}
 		}
 	}
-- 
1.6.0.4

