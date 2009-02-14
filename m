Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbZBNBqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbZBNBqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbZBNBQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:56 -0500
Received: from kroah.org ([198.145.64.141]:50709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762147AbZBNBQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:43 -0500
Date: Fri, 13 Feb 2009 17:13:49 -0800
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
Subject: [patch 44/48] libata: fix EH device failure handling
Message-ID: <20090214011349.GS17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-fix-eh-device-failure-handling.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d89293abd95bfd7dd9229087d6c30c1464c5ac83 upstream.

The dev->pio_mode > XFER_PIO_0 test is there to avoid unnecessary
speed down warning messages but it accidentally disabled SATA link spd
down during configuration phase after reset where PIO mode is always
zero.

This patch fixes the problem by moving the test where it belongs.
This makes libata probing sequence behave better when the connection
is flaky at higher link speeds which isn't too uncommon for eSATA
devices.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2959,12 +2959,13 @@ static int ata_eh_handle_dev_fail(struct
 		/* give it just one more chance */
 		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
 	case -EIO:
-		if (ehc->tries[dev->devno] == 1 && dev->pio_mode > XFER_PIO_0) {
+		if (ehc->tries[dev->devno] == 1) {
 			/* This is the last chance, better to slow
 			 * down than lose it.
 			 */
 			sata_down_spd_limit(ata_dev_phys_link(dev));
-			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
+			if (dev->pio_mode > XFER_PIO_0)
+				ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
 		}
 	}
 

