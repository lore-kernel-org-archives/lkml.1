Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYLCUIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYLCUIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYLCTw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:59 -0500
Received: from kroah.org ([198.145.64.141]:60112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754619AbYLCTwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:55 -0500
Date: Wed, 3 Dec 2008 11:51:30 -0800
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
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>,
       Roland Dreier <rdreier@cisco.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 047/104] libata: Avoid overflow in libata when tf->hba_lbal
	> 127
Message-ID: <20081203195130.GV8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-avoid-overflow-in-libata-when-tf-hba_lbal-127.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

Combination of these two upstream patches:

ba14a9c291aa867896a90b3571fcc1c3759942ff
libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127

44901a96847b9967c057832b185e2f34ee6a14e5
libata: Avoid overflow in ata_tf_read_block() when tf->hba_lbal > 127

Originally written by Roland Dreier, but backported by Chuck.


Cc: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -551,7 +551,7 @@ u64 ata_tf_read_block(struct ata_taskfil
 		if (tf->flags & ATA_TFLAG_LBA48) {
 			block |= (u64)tf->hob_lbah << 40;
 			block |= (u64)tf->hob_lbam << 32;
-			block |= tf->hob_lbal << 24;
+			block |= (u64)tf->hob_lbal << 24;
 		} else
 			block |= (tf->device & 0xf) << 24;
 
@@ -1207,7 +1207,7 @@ u64 ata_tf_to_lba48(const struct ata_tas
 
 	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
 	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
-	sectors |= (tf->hob_lbal & 0xff) << 24;
+	sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
 	sectors |= (tf->lbah & 0xff) << 16;
 	sectors |= (tf->lbam & 0xff) << 8;
 	sectors |= (tf->lbal & 0xff);

