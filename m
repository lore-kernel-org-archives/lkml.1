Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZHPMVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZHPMVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZHPMVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:21:42 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:57850 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbZHPMVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GpSqzRZIqzV47OdVgL/ijyIU0rAW4HS0Ww9d3npEkg8aNhEO+TiCzNdnM4FVrFWfMc
         bzzGZK9QHFuVAi+ufJ9e5rj9EQXSKXmVCUxHhGbQba/lol3AtqeAQI04kg8C/EQBk/5Z
         YYlwezgteoDv9DDLZOo5+f+xGYVU+ffUeMZlQ=
Message-ID: <4A87F9C1.5090601@gmail.com>
Date: Sun, 16 Aug 2009 21:21:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH #upstream-fixes] libata: fix off-by-one error in ata_tf_read_block()
References: <20090815.224843.240484147.anemo@mba.ocn.ne.jp>	<4A876BC3.3020407@gmail.com> <20090816.183355.89035427.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090816.183355.89035427.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ata_tf_read_block() has off-by-one error when converting CHS address
to LBA.  The bug isn't very visible because ata_tf_read_block() is
used only when generating sense data for a failed RW command and CHS
addressing isn't used too often these days.

This problem was spotted by Atsushi Nemoto.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
> Well, I expect fix by you (or other libata hackers) since I think you
> can write better warning message and changelog than me ;)

In that case, sure.  Thanks a lot for the nice spotting.  :-)

 drivers/ata/libata-core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 072ba5e..e71149b 100644
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

