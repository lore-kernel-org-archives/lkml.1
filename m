Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbZIPWgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbZIPWgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbZIPWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:36:07 -0400
Received: from kroah.org ([198.145.64.141]:40992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbZIPWcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:04 2009
Message-Id: <20090916222904.562048865@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 22/24] libata: fix off-by-one error in ata_tf_read_block()
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=libata-fix-off-by-one-error-in-ata_tf_read_block.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <htejun@gmail.com>

commit ac8672ea922bde59acf50eaa1eaa1640a6395fd2 upstream.

ata_tf_read_block() has off-by-one error when converting CHS address
to LBA.  The bug isn't very visible because ata_tf_read_block() is
used only when generating sense data for a failed RW command and CHS
addressing isn't used too often these days.

This problem was spotted by Atsushi Nemoto.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -709,7 +709,13 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		head = tf->device & 0xf;
 		sect = tf->lbal;
 
-		block = (cyl * dev->heads + head) * dev->sectors + sect;
+		if (!sect) {
+			ata_dev_printk(dev, KERN_WARNING, "device reported "
+				       "invalid CHS sector 0\n");
+			sect = 1; /* oh well */
+		}
+
+		block = (cyl * dev->heads + head) * dev->sectors + sect - 1;
 	}
 
 	return block;


