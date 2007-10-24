Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXJXQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXJXQmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759890AbXJXQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60965 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760015AbXJXQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:31 -0400
Date: Wed, 24 Oct 2007 18:26:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] acpi/ec.c: fix use-after-free
Message-ID: <20071024162600.GD30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a use-after-free introduced by
commit 30c08574da0ead1a47797ce028218ce5b2de61c7.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/acpi/ec.c.old	2007-10-23 19:39:47.000000000 +0200
+++ linux-2.6/drivers/acpi/ec.c	2007-10-23 19:34:55.000000000 +0200
@@ -434,11 +442,11 @@
 EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
 
 void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 {
-	struct acpi_ec_query_handler *handler;
+	struct acpi_ec_query_handler *handler, *tmp;
 	mutex_lock(&ec->lock);
-	list_for_each_entry(handler, &ec->list, node) {
+	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
 		if (query_bit == handler->query_bit) {
 			list_del(&handler->node);
 			kfree(handler);
 		}

