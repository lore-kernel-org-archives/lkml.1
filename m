Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYADVQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYADVQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYADVOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:14:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbYADVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lhFFU+lOeyedSZQJmpCJWokY3W0N7UQP6Kw0g3BPEYyzQPnRbmAVGHLHG4BJVh79qbQIvBs9Rkxk8L1GUDhxi0VZzCvL8ZrZ60yD2TArRiayMltqHnlOPYPupYaXkSCUtCZJqRk1lj/I0TCOvKRJy1sTt7RYBDV2RPJCQrlhNoc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:25:39 +0100
Message-Id: <20080104212539.6978.59283.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/15] ide: prepare init_irq() for using ide_remove_port_from_hwgroup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* BUG_ON() early if 'hwif->next == hwif' and there is a 'match' hwgroup.

* Remove printk() for impossible condition and add a BUG_ON(hwgroup->drive)
  to match code in ide_unregister().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-52 bytes
 drivers/ide/ide-probe.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -996,6 +996,7 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_lock_irq(&ide_lock);
 		hwif->next = hwgroup->hwif->next;
 		hwgroup->hwif->next = hwif;
+		BUG_ON(hwif->next == hwif);
 		spin_unlock_irq(&ide_lock);
 	} else {
 		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
@@ -1075,7 +1076,6 @@ static int init_irq (ide_hwif_t *hwif)
 out_unlink:
 	spin_lock_irq(&ide_lock);
 	if (hwif->next == hwif) {
-		BUG_ON(match);
 		BUG_ON(hwgroup->hwif != hwif);
 		kfree(hwgroup);
 	} else {
@@ -1085,8 +1085,7 @@ out_unlink:
 			g = g->next;
 		g->next = hwif->next;
 		if (hwgroup->hwif == hwif) {
-			/* Impossible. */
-			printk(KERN_ERR "Duh. Uninitialized hwif listed as active hwif.\n");
+			BUG_ON(hwgroup->drive);
 			hwgroup->hwif = g;
 		}
 		BUG_ON(hwgroup->hwif == hwif);
