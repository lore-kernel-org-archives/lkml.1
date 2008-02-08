Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbYBHAbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbYBHAbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762505AbYBHAas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:30:48 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:45194 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbYBHAa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tIclGvqNtC2BlFcaMgZOZioXQhIqx7RCpgn97qNX+fb+NZYGzTZwmen9wHyiFNVLmxaicE7Bvh+nhm4FggWW9xseKNKCKXCRYCJQktmXq4Hc2Q7KA2qcEtFbpkymy+Zn+/GXvOvyE2ZyokvzneGYvVC/ZL/mDnZMy8XmRqr5bvI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:44:34 +0100
Message-Id: <20080208004434.17746.33986.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/18] ide: fix ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Instead of checking for '->io_ports[IDE_DATA_OFFSET] == 0' check for
  '->chipset == ide_unknown' when looking for an empty ide_hwifs[] slot.

* Do ide-pnp initialization after ide-generic when IDE is built-in
  (ide-pnp is the only user of ide_find_port() which needs such fixup).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile |    2 +-
 drivers/ide/ide.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -36,9 +36,9 @@ ifeq ($(CONFIG_BLK_DEV_CMD640), y)
 endif
 
 obj-$(CONFIG_BLK_DEV_IDE)		+= cris/ ppc/
-obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
+obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -259,7 +259,7 @@ ide_hwif_t * ide_find_port(unsigned long
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		hwif = &ide_hwifs[i];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
+		if (hwif->chipset == ide_unknown)
 			goto found;
 	}
 
