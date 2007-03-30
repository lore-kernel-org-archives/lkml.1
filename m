Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXC3VPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXC3VPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXC3VMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51699 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbXC3VMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:07 -0400
Date: Fri, 30 Mar 2007 14:06:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 29/37] ide: revert "ide: fix drive side 80c cable check,
	take 2" for now
Message-ID: <20070330210640.GF29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-revert-ide-fix-drive-side-80c-cable-check-take-2-for-now.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[PATCH] ide: revert "ide: fix drive side 80c cable check, take 2" for now

"ide: fix drive side 80c cable check, take 2" patch from Tejun Heo (commit
fab59375b9543f84d1714f7dd00f5d11e531bd3e) fixed 80c bit test (bit13 of word93)
but we also need to fix master/slave IDENTIFY order (slave device should be
probed first in order to make it release PDIAG- signal) and we should also
check for pre-ATA3 slave devices (which may not release PDIAG- signal).

Unfortunately the fact that IDE driver doesn't reset devices itself helps
only a bit as it seems that some BIOS-es reset ATA devices after programming
the chipset, some BIOS-es can be set to not probe/configure selected devices,
there may be no BIOS in case of add-on cards etc.

Since we are quite late in the release cycle and the required changes will
affect a lot of systems just revert the fix for now.

[ Please also see libata commit f31f0cc2f0b7527072d94d02da332d9bb8d7d94c. ]

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-iops.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -598,6 +598,9 @@ u8 eighty_ninty_three (ide_drive_t *driv
 	if(HWIF(drive)->udma_four == 0)
 		return 0;
 
+	printk(KERN_INFO "%s: hw_config=%04x\n",
+			 drive->name, drive->id->hw_config);
+
 	/* Check for SATA but only if we are ATA5 or higher */
 	if (drive->id->hw_config == 0 && (drive->id->major_rev_num & 0x7FE0))
 		return 1;
@@ -607,8 +610,14 @@ u8 eighty_ninty_three (ide_drive_t *driv
 	if(!(drive->id->hw_config & 0x4000))
 		return 0;
 #endif /* CONFIG_IDEDMA_IVB */
+/*
+ * FIXME: enable this after fixing master/slave IDENTIFY order,
+ *	  also ignore the result if the slave device is pre-ATA3 one
+ */
+#if 0
 	if (!(drive->id->hw_config & 0x2000))
 		return 0;
+#endif
 	return 1;
 }
 

-- 
