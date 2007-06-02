Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbXFBTCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbXFBTCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbXFBTCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:02:43 -0400
Received: from enterprise.noxa.de ([212.60.197.71]:41642 "EHLO
	enterprise.noxa.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbXFBTCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:02:42 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jun 2007 15:02:41 EDT
Date: Sat, 2 Jun 2007 20:55:13 +0200
From: Jonathan Schleifer <js@h3c.de>
To: aeb@cwi.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Ignore partition table on device
Message-ID: <20070602205513.0312ebe0@localhost>
X-Mailer: Sylpheed-Claws 2.5.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch adds a new kernel parameter (ignore_partitions=device) to
the kernel. It is useful when using a fake RAID with dmraid so that
Linux won't complain about attemps to access the drive beyond its
boundaries when udev and/or hald are started.

--- linux-2.6.21.1/fs/partitions/check.c.orig	2007-06-02 14:19:26.000000000 +0200
+++ linux-2.6.21.1/fs/partitions/check.c	2007-06-02 15:16:22.000000000 +0200
@@ -39,6 +39,14 @@
 extern void md_autodetect_dev(dev_t dev);
 #endif
 
+static char * __initdata ignore_dev;
+static int __init ignore_dev_fn(char *str)
+{
+	ignore_dev = str;
+	return 1;
+}
+__setup("ignore_partitions=", ignore_dev_fn);
+
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
 static int (*check_part[])(struct parsed_partitions *, struct block_device *) = {
@@ -165,6 +173,13 @@
 		sprintf(state->name, "p");
 
 	state->limit = hd->minors;
+
+	if (ignore_dev != NULL && !strcmp(state->name, ignore_dev)) {
+		memset(&state->parts, 0, sizeof(state->parts));
+		printk(" partition table ignored.\n");
+		return state;
+	}
+
 	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));

-- 
Jonathan
