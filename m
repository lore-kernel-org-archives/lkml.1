Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYLCUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYLCUQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLCTyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:45 -0500
Received: from kroah.org ([198.145.64.141]:60436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbYLCTyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:43 -0500
Date: Wed, 3 Dec 2008 11:53:23 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 067/104] libata: improve phantom device detection
Message-ID: <20081203195323.GP8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-improve-phantom-device-detection.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 6a6b97d360702b98c02c7fca4c4e088dcf3a2985 upstream.

Currently libata uses four methods to detect device presence.

1. PHY status if available.
2. TF register R/W test (only promotes presence, never demotes)
3. device signature after reset
4. IDENTIFY failure detection in SFF state machine

Combination of the above works well in most cases but recently there
have been a few reports where a phantom device causes unnecessary
delay during probe.  In both cases, PHY status wasn't available.  In
one case, it passed #2 and #3 and failed IDENTIFY with ATA_ERR which
didn't qualify as #4.  The other failed #2 but as it passed #3 and #4,
it still caused failure.

In both cases, phantom device reported diagnostic failure, so these
cases can be safely worked around by considering any !ATA_DRQ IDENTIFY
failure as NODEV_HINT if diagnostic failure is set.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1227,10 +1227,19 @@ fsm_start:
 			/* ATA PIO protocol */
 			if (unlikely((status & ATA_DRQ) == 0)) {
 				/* handle BSY=0, DRQ=0 as error */
-				if (likely(status & (ATA_ERR | ATA_DF)))
+				if (likely(status & (ATA_ERR | ATA_DF))) {
 					/* device stops HSM for abort/error */
 					qc->err_mask |= AC_ERR_DEV;
-				else {
+
+					/* If diagnostic failed and this is
+					 * IDENTIFY, it's likely a phantom
+					 * device.  Mark hint.
+					 */
+					if (qc->dev->horkage &
+					    ATA_HORKAGE_DIAGNOSTIC)
+						qc->err_mask |=
+							AC_ERR_NODEV_HINT;
+				} else {
 					/* HSM violation. Let EH handle this.
 					 * Phantom devices also trigger this
 					 * condition.  Mark hint.

