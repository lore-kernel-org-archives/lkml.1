Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYKQHih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYKQHih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYKQHV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:57 -0500
Received: from kroah.org ([198.145.64.141]:38576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754426AbYKQHVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:24 -0500
Date: Sun, 16 Nov 2008 23:16:08 -0800
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
       alan@lxorguk.ukuu.org.uk, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 30/46] SCSI: qla2xxx: Do not honour max_vports from
	firmware for 2G ISPs and below.
Message-ID: <20081117071608.GE29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla2xxx-do-not-honour-max_vports-from-firmware-for-2g-isps-and-below.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shyam Sundar <shyam.sundar@qlogic.com>

commit 680d7db88ace53c673e1c437c9b6abcc053e8d6f upstream.

For 23XX ISPs, max_vports may return an invalid value.
Do not honour it.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -974,7 +974,6 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size);
-				qla2x00_resize_request_q(ha);
 				ha->flags.npiv_supported = 0;
 				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha) ||
 				     IS_QLA84XX(ha)) &&
@@ -986,6 +985,7 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
+				qla2x00_resize_request_q(ha);
 
 				if (ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(ha);
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1964,7 +1964,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_
 			*cur_iocb_cnt = mcp->mb[7];
 		if (orig_iocb_cnt)
 			*orig_iocb_cnt = mcp->mb[10];
-		if (max_npiv_vports)
+		if (ha->flags.npiv_supported && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
 	}
 

-- 
