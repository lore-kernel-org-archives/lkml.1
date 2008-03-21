Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbYCUW77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbYCUW77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763736AbYCUWuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:51 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59288 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762989AbYCUWur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:47 -0400
Message-Id: <20080321224411.038720410@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <tomof@acm.org>, James.Bottomley@HansenPartnership.com,
       fujita.tomonori@lab.ntt.co.jp, matthew@wil.cx,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 41/76] SCSI advansys: fix overrun_buf aligned bug
Content-Disposition: inline; filename=scsi-advansys-fix-overrun_buf-aligned-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 7d5d408c77cee95d1380511de46b7a4c8dc2211d

struct asc_dvc_var needs overrun buffer to be placed on an 8 byte
boundary. advansys defines struct asc_dvc_var:

struct asc_dvc_var {
    ...
    uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);

The problem is that struct asc_dvc_var is placed on
shost->hostdata. So if the hostdata is not on an 8 byte boundary, the
advansys crashes. The hostdata is placed on a sizeof(unsigned long)
boundary so the 8 byte boundary is not garanteed with x86_32.

With 2.6.23 and 2.6.24, the hostdata is on an 8 byte boundary by
chance, but with the current git, it's not.

This patch removes overrun_buf static array and use kzalloc.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

FUJITA Tomonori notes:
  We thought that 2.6.24 doesn't have this bug, however it does.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/advansys.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -566,7 +566,7 @@ typedef struct asc_dvc_var {
 	ASC_SCSI_BIT_ID_TYPE unit_not_ready;
 	ASC_SCSI_BIT_ID_TYPE queue_full_or_busy;
 	ASC_SCSI_BIT_ID_TYPE start_motor;
-	uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);
+	uchar *overrun_buf;
 	dma_addr_t overrun_dma;
 	uchar scsi_reset_wait;
 	uchar chip_no;
@@ -13833,6 +13833,12 @@ static int __devinit advansys_board_foun
 	 */
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DBG(2, "AscInitAsc1000Driver()\n");
+
+		asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
+		if (!asc_dvc_varp->overrun_buf) {
+			ret = -ENOMEM;
+			goto err_free_wide_mem;
+		}
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
 		if (warn_code || asc_dvc_varp->err_code) {
@@ -13840,8 +13846,10 @@ static int __devinit advansys_board_foun
 					"warn 0x%x, error 0x%x\n",
 					asc_dvc_varp->init_state, warn_code,
 					asc_dvc_varp->err_code);
-			if (asc_dvc_varp->err_code)
+			if (asc_dvc_varp->err_code) {
 				ret = -ENODEV;
+				kfree(asc_dvc_varp->overrun_buf);
+			}
 		}
 	} else {
 		if (advansys_wide_init_chip(shost))
@@ -13894,6 +13902,7 @@ static int advansys_release(struct Scsi_
 		dma_unmap_single(board->dev,
 					board->dvc_var.asc_dvc_var.overrun_dma,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(board->dvc_var.asc_dvc_var.overrun_buf);
 	} else {
 		iounmap(board->ioremap_addr);
 		advansys_wide_free_mem(board);

-- 
