Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYDHLWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYDHLWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYDHLT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46513 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYDHLTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:21 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 12/29] zorro: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:19 +0400
Message-Id: <1207653576-12640-12-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/proc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index b7a8c7b..2de70fc 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -76,6 +76,7 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 }
 
 static const struct file_operations proc_bus_zorro_operations = {
+	.owner		= THIS_MODULE,
 	.llseek		= proc_bus_zorro_lseek,
 	.read		= proc_bus_zorro_read,
 };
@@ -114,11 +115,11 @@ static int __init zorro_proc_attach_device(u_int slot)
 	char name[4];
 
 	sprintf(name, "%02x", slot);
-	entry = create_proc_entry(name, 0, proc_bus_zorro_dir);
+	entry = proc_create_data(name, 0, proc_bus_zorro_dir,
+				 &proc_bus_zorro_operations,
+				 &zorro_autocon[slot]);
 	if (!entry)
 		return -ENOMEM;
-	entry->proc_fops = &proc_bus_zorro_operations;
-	entry->data = &zorro_autocon[slot];
 	entry->size = sizeof(struct zorro_dev);
 	return 0;
 }
-- 
1.5.3.rc5

