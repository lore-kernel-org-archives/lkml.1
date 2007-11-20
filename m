Return-Path: <linux-kernel-owner+w=401wt.eu-S1761854AbXKTSas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbXKTSas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbXKTS0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761530AbXKTS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:40 -0500
Date: Tue, 20 Nov 2007 10:24:09 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Tobias Powalowski <t.powa@gmx.de>
Subject: [patch 12/29] sata_sis: fix SCR read breakage
Message-ID: <20071120182409.GO28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_sis-fix-scr-read-breakage.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Tejun Heo <htejun@gmail.com>

patch aaa092a114696f4425cd57c4d7fa05110007e247 in mainline.

sata_sis: fix SCR read breakage

SCR read for controllers which uses PCI configuration space for SCR
access got broken while adding @val argument to SCR accessors.  Fix
it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Tobias Powalowski <t.powa@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_sis.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -168,11 +168,11 @@ static unsigned int get_scr_cfg_addr(str
 	return addr;
 }
 
-static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg)
+static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
-	u32 val, val2 = 0;
+	u32 val2 = 0;
 	u8 pmr;
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
@@ -180,13 +180,16 @@ static u32 sis_scr_cfg_read (struct ata_
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
-	pci_read_config_dword(pdev, cfg_addr, &val);
+	pci_read_config_dword(pdev, cfg_addr, val);
 
 	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
 	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 		pci_read_config_dword(pdev, cfg_addr+0x10, &val2);
 
-	return (val|val2) &  0xfffffffb; /* avoid problems with powerdowned ports */
+	*val |= val2;
+	*val &= 0xfffffffb;	/* avoid problems with powerdowned ports */
+
+	return 0;
 }
 
 static void sis_scr_cfg_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
@@ -216,7 +219,7 @@ static int sis_scr_read(struct ata_port 
 		return -EINVAL;
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		return sis_scr_cfg_read(ap, sc_reg);
+		return sis_scr_cfg_read(ap, sc_reg, val);
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 

-- 
