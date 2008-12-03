Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYLCTvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYLCTvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYLCTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:07 -0500
Received: from kroah.org ([198.145.64.141]:34517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754267AbYLCTuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:04 -0500
Date: Wed, 3 Dec 2008 11:48:23 -0800
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
       alan@lxorguk.ukuu.org.uk, Shane Huang <shane.huang@amd.com>
Subject: [patch 005/104] USB: fix SB600 USB subsystem hang bug
Message-ID: <20081203194823.GF8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-sb600-usb-subsystem-hang-bug.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Shane Huang <shane.huang@amd.com>

commit 0a99e8ac430a27825bd055719765fd0d65cd797f upstream.

This patch is required for all AMD SB600 revisions to avoid USB subsystem hang
symptom. The USB subsystem hang symptom is observed when the system has
multiple USB devices connected to it. In some cases a USB hub may be required
to observe this symptom.

Reported in bugzilla as #11599, the similar patch for SB700 old revision is:
commit b09bc6cbae4dd3a2d35722668ef2c502a7b8b093

Reported-by: raffaele <ralfconn@tele2.it>
Tested-by: Roman Mamedov <roman@rm.pp.ru>
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-pci.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -169,18 +169,21 @@ static int ehci_pci_setup(struct usb_hcd
 		}
 		break;
 	case PCI_VENDOR_ID_ATI:
-		/* SB700 old version has a bug in EHCI controller,
+		/* SB600 and old version of SB700 have a bug in EHCI controller,
 		 * which causes usb devices lose response in some cases.
 		 */
-		if (pdev->device == 0x4396) {
+		if ((pdev->device == 0x4386) || (pdev->device == 0x4396)) {
 			p_smbus = pci_get_device(PCI_VENDOR_ID_ATI,
 						 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 						 NULL);
 			if (!p_smbus)
 				break;
 			rev = p_smbus->revision;
-			if ((rev == 0x3a) || (rev == 0x3b)) {
+			if ((pdev->device == 0x4386) || (rev == 0x3a)
+			    || (rev == 0x3b)) {
 				u8 tmp;
+				ehci_info(ehci, "applying AMD SB600/SB700 USB "
+					"freeze workaround\n");
 				pci_read_config_byte(pdev, 0x53, &tmp);
 				pci_write_config_byte(pdev, 0x53, tmp | (1<<3));
 			}

