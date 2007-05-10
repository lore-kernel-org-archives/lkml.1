Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbXEJKCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbXEJKCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXEJKB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:01:57 -0400
Received: from mail.exanet.com ([212.143.73.109]:37751 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXEJKB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:01:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] interface for doing a full host scsi rescan
Date: Thu, 10 May 2007 13:01:55 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59C8@hawk.exanet-il.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] interface for doing a full host scsi rescan
Thread-Index: AceS6j1EFt8XqRFkRlmJxeXhpf8ddA==
From: "Menny Hamburger" <menny@exanet.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When we do want to rescan the SCSI host, a userland script needs to be
provided that does add/remove.
This patch adds an interface for doing this inside the kernel - seems
more appropriate:

--- linux-2.6.20/drivers/scsi/scsi_proc.c	2007-02-04
20:44:54.000000000 +0200
+++ linux-2.6.20_patched/drivers/scsi/scsi_proc.c	2007-05-10
12:52:13.353652000 +0300
@@ -227,6 +227,20 @@
 	return error;
 }
 
+static int scsi_scan_selected_host(uint host, uint rescan)
+{
+	struct Scsi_Host *shost;
+	int error = -ENXIO;
+
+	shost = scsi_host_lookup(host);
+	if (IS_ERR(shost))
+		return PTR_ERR(shost);
+
+	error = scsi_scan_host_selected(shost, SCAN_WILD_CARD,
SCAN_WILD_CARD, SCAN_WILD_CARD, rescan);
+	scsi_host_put(shost);
+	return error;
+}
+
 static ssize_t proc_scsi_write(struct file *file, const char __user
*buf,
 			       size_t length, loff_t *ppos)
 {
@@ -278,7 +292,24 @@
 		lun = simple_strtoul(p + 1, &p, 0);
 
 		err = scsi_remove_single_device(host, channel, id, lun);
-	}
+	/*
+	 * Usage: echo "scsi scan-devices 0 1" >/proc/scsi/scsi
+	 * where 0 is Host and 1 is whether to rescan (1) or do a full
scan (0).
+	 */
+	} else if(!strncmp("scsi scan-devices", buffer, 17)) {
+		p = buffer + 18;
+
+		host = simple_strtoul(p, &p, 0);
+		rescan = simple_strtoul(p + 1, &p, 0);
+
+		if (rescan)
+			printk(KERN_DEBUG "Rescanning SCSI host %d\n",
host);
+		else
+			printk(KERN_DEBUG "Scanning SCSI host %d\n",
host);
+
+		err = scsi_scan_selected_host(host, rescan);
+    }
+
 
 	/*
 	 * convert success returns so that we return the 


Menny
