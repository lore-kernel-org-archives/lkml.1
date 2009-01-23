Return-Path: <linux-kernel-owner+w=401wt.eu-S1762343AbZAWGT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762343AbZAWGT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760859AbZAWGQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:30 -0500
Received: from kroah.org ([198.145.64.141]:36177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760817AbZAWGQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:29 -0500
Date: Thu, 22 Jan 2009 22:13:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 10/40] usb-storage: set CAPACITY_HEURISTICS flag for bad
	vendors
Message-ID: <20090123061327.GJ2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-set-capacity_heuristics-flag-for-bad-vendors.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a81a81a25d3ecdab777abca87c5ddf484056103d upstream.

This patch (as1194c) makes usb-storage set the CAPACITY_HEURISTICS flag
for all devices made by Nokia, Nikon, or Motorola.  These companies
seem to include the READ CAPACITY bug in all of their devices.

Since cell phones and digital cameras rely on flash storage, which
always has an even number of sectors, setting CAPACITY_HEURISTICS
shouldn't cause any problems.  Not even if the companies wise up and
start making devices without the bug.

A large number of unusual_devs entries are now unnecessary, so the
patch removes them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/scsiglue.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -59,6 +59,13 @@
 #include "transport.h"
 #include "protocol.h"
 
+/* Vendor IDs for companies that seem to include the READ CAPACITY bug
+ * in all their devices
+ */
+#define VENDOR_ID_NOKIA		0x0421
+#define VENDOR_ID_NIKON		0x04b0
+#define VENDOR_ID_MOTOROLA	0x22b8
+
 /***********************************************************************
  * Host functions 
  ***********************************************************************/
@@ -134,6 +141,22 @@ static int slave_configure(struct scsi_d
 	 * settings can't be overridden via the scsi devinfo mechanism. */
 	if (sdev->type == TYPE_DISK) {
 
+		/* Some vendors seem to put the READ CAPACITY bug into
+		 * all their devices -- primarily makers of cell phones
+		 * and digital cameras.  Since these devices always use
+		 * flash media and can be expected to have an even number
+		 * of sectors, we will always enable the CAPACITY_HEURISTICS
+		 * flag unless told otherwise. */
+		switch (le16_to_cpu(us->pusb_dev->descriptor.idVendor)) {
+		case VENDOR_ID_NOKIA:
+		case VENDOR_ID_NIKON:
+		case VENDOR_ID_MOTOROLA:
+			if (!(us->fflags & (US_FL_FIX_CAPACITY |
+					US_FL_CAPACITY_OK)))
+				us->fflags |= US_FL_CAPACITY_HEURISTICS;
+			break;
+		}
+
 		/* Disk-type devices use MODE SENSE(6) if the protocol
 		 * (SubClass) is Transparent SCSI, otherwise they use
 		 * MODE SENSE(10). */

