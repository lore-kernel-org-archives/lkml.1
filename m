Return-Path: <linux-kernel-owner+w=401wt.eu-S1946240AbXBCCga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946240AbXBCCga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946251AbXBCCgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:25 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52692 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946243AbXBCCfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:53 -0500
Message-Id: <20070203023933.841475000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:17 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 13/59] ieee1394: sbp2: fix probing of some DVD-ROM/RWs
Content-Disposition: inline; filename=ieee1394-sbp2-fix-probing-of-some-dvd-rom-rws.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Since commit 98e238cd42be6c0852da519303cf0182690f8d9f in Linux 2.6.19,
"ieee1394: sbp2: don't prefer MODE SENSE 10", some FireWire DVD-ROMs and
DVD-RWs were mistaken as CD-ROM because sr_mod now sent MODE SENSE 6.
The MMC command set includes only MODE SENSE 10.
http://bugzilla.kernel.org/show_bug.cgi?id=7800

This fix lets sbp2 switch scsi_device.use_10_for_rw on for MMC LUs.
This should rather be done in the command set driver sr_mod, not in the
sbp2 transport driver, and an according patch will follow for a next
Linux release.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
same as commit 1a74bc68e4c0534d150e6454b45a70dab831fa32

---
 drivers/ieee1394/sbp2.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.19.2.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.19.2/drivers/ieee1394/sbp2.c
@@ -2530,6 +2530,8 @@ static int sbp2scsi_slave_configure(stru
 	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
 	sdev->use_10_for_rw = 1;
 
+	if (sdev->type == TYPE_ROM)
+		sdev->use_10_for_ms = 1;
 	if (sdev->type == TYPE_DISK &&
 	    scsi_id->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
 		sdev->skip_ms_page_8 = 1;

--
