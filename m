Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYGEQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYGEQCf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYGEQC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 12:02:27 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:21862 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYGEQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 12:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iHv2v0XJj/I+BPQFU6+nRXmNRO0lyVKHvx0aJC1Kh3e0Q42acLBSYcH+3nlNdLDqWD
         XGXmtKd2bGjHWoafNu0T4C7qLNqYoItumnX/JTUCqGGIiVkdYsKpvEQLgDPLphSCohEh
         q5ozoS+ioZ3iTV9bgkru9Os+OBcSDBWisV2K8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix IDE port slots reservation and freeing (take 2)
Date: Sat, 5 Jul 2008 18:02:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051802.46207.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make ide_find_port_slot() return port slot index.

* Add ide_free_port_slot() helper.

* Move ide_init_port_data() call and error printk() from
  ide_find_port_slot() to ide_host_alloc_all().

* Make ide_{find,free}_port_slot() take ide_cfg_mtx mutex
  and convert them use ide_indexes bitmap to keep track of
  reserved port slots.

* Don't set hwif->chipset in ide_host_alloc_all() as it is
  no longer necessary.

v2:
* Pass the correct slot index to ide_init_port_data().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 drivers/ide/ide-probe.c |   87 +++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 37 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1474,18 +1474,20 @@ static int ide_sysfs_register_port(ide_h
 	return rc;
 }
 
+static unsigned int ide_indexes;
+
 /**
- *	ide_find_port_slot	-	find free ide_hwifs[] slot
+ *	ide_find_port_slot	-	find free port slot
  *	@d: IDE port info
  *
- *	Return the new hwif.  If we are out of free slots return NULL.
+ *	Return the new port slot index or -ENOENT if we are out of free slots.
  */
 
-static ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
+static int ide_find_port_slot(const struct ide_port_info *d)
 {
-	ide_hwif_t *hwif;
-	int i;
+	int idx = -ENOENT;
 	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
+	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;;
 
 	/*
 	 * Claim an unassigned slot.
@@ -1497,35 +1499,33 @@ static ide_hwif_t *ide_find_port_slot(co
 	 * Unless there is a bootable card that does not use the standard
 	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
 	 */
-	if (bootable) {
-		i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
-
-		for (; i < MAX_HWIFS; i++) {
-			hwif = &ide_hwifs[i];
-			if (hwif->chipset == ide_unknown)
-				goto out_found;
-		}
+	mutex_lock(&ide_cfg_mtx);
+	if (MAX_HWIFS == 1) {
+		if (ide_indexes == 0 && i == 0)
+			idx = 1;
 	} else {
-		for (i = 2; i < MAX_HWIFS; i++) {
-			hwif = &ide_hwifs[i];
-			if (hwif->chipset == ide_unknown)
-				goto out_found;
-		}
-		for (i = 0; i < 2 && i < MAX_HWIFS; i++) {
-			hwif = &ide_hwifs[i];
-			if (hwif->chipset == ide_unknown)
-				goto out_found;
+		if (bootable) {
+			if ((ide_indexes | i) != (1 << MAX_HWIFS) - 1)
+				idx = ffz(ide_indexes | i);
+		} else {
+			if ((ide_indexes | 3) != (1 << MAX_HWIFS) - 1)
+				idx = ffz(ide_indexes | 3);
+			else if ((ide_indexes & 3) != 3)
+				idx = ffz(ide_indexes);
 		}
 	}
+	if (idx >= 0)
+		ide_indexes |= (1 << idx);
+	mutex_unlock(&ide_cfg_mtx);
 
-	printk(KERN_ERR "%s: no free slot for interface\n",
-			d ? d->name : "ide");
-
-	return NULL;
+	return idx;
+}
 
-out_found:
-	ide_init_port_data(hwif, i);
-	return hwif;
+static void ide_free_port_slot(int idx)
+{
+	mutex_lock(&ide_cfg_mtx);
+	ide_indexes &= ~(1 << idx);
+	mutex_unlock(&ide_cfg_mtx);
 }
 
 struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
@@ -1540,17 +1540,24 @@ struct ide_host *ide_host_alloc_all(cons
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif;
+		int idx;
 
 		if (hws[i] == NULL)
 			continue;
 
-		hwif = ide_find_port_slot(d);
-		if (hwif) {
-			hwif->chipset = hws[i]->chipset;
-
-			host->ports[i] = hwif;
-			host->n_ports++;
+		idx = ide_find_port_slot(d);
+		if (idx < 0) {
+			printk(KERN_ERR "%s: no free slot for interface\n",
+					d ? d->name : "ide");
+			continue;
 		}
+
+		hwif = &ide_hwifs[idx];
+
+		ide_init_port_data(hwif, idx);
+
+		host->ports[i] = hwif;
+		host->n_ports++;
 	}
 
 	if (host->n_ports == 0) {
@@ -1699,11 +1706,17 @@ EXPORT_SYMBOL_GPL(ide_host_add);
 
 void ide_host_remove(struct ide_host *host)
 {
+	ide_hwif_t *hwif;
 	int i;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (host->ports[i])
-			ide_unregister(host->ports[i]);
+		hwif = host->ports[i];
+
+		if (hwif == NULL)
+			continue;
+
+		ide_unregister(hwif);
+		ide_free_port_slot(hwif->index);
 	}
 
 	kfree(host);
