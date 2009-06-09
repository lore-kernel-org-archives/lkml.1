Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbZFIK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbZFIK1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbZFIKTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:51 -0400
Received: from kroah.org ([198.145.64.141]:54939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760734AbZFIKTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:50 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:02 2009
Message-Id: <20090609094102.145068152@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 43/87] ide_pci_generic: add quirk for Netcell ATA RAID
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ide_pci_generic-add-quirk-for-netcell-ata-raid.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit c339dfdd65b52bfd947ab29d1210314a2f6d622d upstream.

We need to explicitly mark words 85-87 as valid ones since
firmware doesn't do it.

This should fix support for LBA48 and FLUSH CACHE [EXT] command
which stopped working after we applied more strict checking of
identify words in:

	commit 942dcd85bf8edf38cdc3745306ca250684d99a61
	("ide: idedisk_supports_lba48() -> ata_id_lba48_enabled()")

and

	commit 4b58f17d7c45a8e5f4acda641bec388398b9c0fa
	("ide: ide_id_has_flush_cache() -> ata_id_flush_enabled()")

Reported-and-tested-by: "Trevor Hemsley" <trevor.hemsley@ntlworld.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-pci-generic.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -35,6 +35,16 @@ MODULE_PARM_DESC(all_generic_ide, "IDE g
 
 #define IDE_HFLAGS_UMC (IDE_HFLAG_NO_DMA | IDE_HFLAG_FORCE_LEGACY_IRQS)
 
+static void netcell_quirkproc(ide_drive_t *drive)
+{
+	/* mark words 85-87 as valid */
+	drive->id[ATA_ID_CSF_DEFAULT] |= 0x4000;
+}
+
+static const struct ide_port_ops netcell_port_ops = {
+	.quirkproc		= netcell_quirkproc,
+};
+
 #define DECLARE_GENERIC_PCI_DEV(extra_flags) \
 	{ \
 		.name		= DRV_NAME, \
@@ -76,6 +86,7 @@ static const struct ide_port_info generi
 
 	{	/* 6: Revolution */
 		.name		= DRV_NAME,
+		.port_ops	= &netcell_port_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,


