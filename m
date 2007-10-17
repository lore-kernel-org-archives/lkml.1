Return-Path: <linux-kernel-owner+w=401wt.eu-S1765431AbXJQNA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765431AbXJQNA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbXJQNAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:00:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbXJQNAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:00:15 -0400
Date: Wed, 17 Oct 2007 13:53:58 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [2.6.24 PATCH 01/04] dm: export name and uuid
Message-ID: <20071017125358.GM24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Anderson <andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds a function to obtain a copy of a mapped device's name and uuid.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-ioctl.c         |   32 ++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 33 insertions(+)

Index: linux-2.6.23/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-ioctl.c	2007-10-14 00:08:12.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-ioctl.c	2007-10-16 13:09:27.000000000 +0100
@@ -1515,3 +1515,35 @@ void dm_interface_exit(void)
 
 	dm_hash_exit();
 }
+
+/**
+ * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
+ * @md: Pointer to mapped_device
+ * @name: Buffer (size DM_NAME_LEN) for name
+ * @uuid: Buffer (size DM_UUID_LEN) for uuid or empty string if uuid not defined
+ */
+int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
+{
+	int r = 0;
+	struct hash_cell *hc;
+
+	if (!md)
+		return -ENXIO;
+
+	dm_get(md);
+	down_read(&_hash_lock);
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		r = -ENXIO;
+		goto out;
+	}
+
+	strcpy(name, hc->name);
+	strcpy(uuid, hc->uuid ? : "");
+
+out:
+	up_read(&_hash_lock);
+	dm_put(md);
+
+	return r;
+}
Index: linux-2.6.23/include/linux/device-mapper.h
===================================================================
--- linux-2.6.23.orig/include/linux/device-mapper.h	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23/include/linux/device-mapper.h	2007-10-14 00:08:31.000000000 +0100
@@ -188,6 +188,7 @@ int dm_wait_event(struct mapped_device *
  * Info functions.
  */
 const char *dm_device_name(struct mapped_device *md);
+int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
