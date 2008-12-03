Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbYLCTvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbYLCTvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYLCTuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:06 -0500
Received: from kroah.org ([198.145.64.141]:34501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752503AbYLCTuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:03 -0500
Date: Wed, 3 Dec 2008 11:48:21 -0800
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
       alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
       Libin Yang <libin.yang@amd.com>
Subject: [patch 004/104] USB: fix SB700 usb subsystem hang bug
Message-ID: <20081203194821.GE8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-sb700-usb-subsystem-hang-bug.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andiry Xu <andiry.xu@amd.com>

commit b09bc6cbae4dd3a2d35722668ef2c502a7b8b093 upstream.

This patch is required for AMD SB700 south bridge revision A12 and A13 to avoid
USB subsystem hang symptom. The USB subsystem hang symptom is observed when the
system has multiple USB devices connected to it. In some cases a USB hub may be
required to observe this symptom.

This patch works around the problem by correcting the internal register setting
that will help by changing the behavior of the internal logic to avoid the
USB subsystem hang issue. The change in the behavior of the logic does not
impact the normal operation of the USB subsystem.

Reported-by: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Tested-by: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Libin Yang <libin.yang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-pci.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -66,6 +66,8 @@ static int ehci_pci_setup(struct usb_hcd
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
+	struct pci_dev		*p_smbus;
+	u8			rev;
 	u32			temp;
 	int			retval;
 
@@ -166,6 +168,25 @@ static int ehci_pci_setup(struct usb_hcd
 			pci_write_config_byte(pdev, 0x4b, tmp | 0x20);
 		}
 		break;
+	case PCI_VENDOR_ID_ATI:
+		/* SB700 old version has a bug in EHCI controller,
+		 * which causes usb devices lose response in some cases.
+		 */
+		if (pdev->device == 0x4396) {
+			p_smbus = pci_get_device(PCI_VENDOR_ID_ATI,
+						 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+						 NULL);
+			if (!p_smbus)
+				break;
+			rev = p_smbus->revision;
+			if ((rev == 0x3a) || (rev == 0x3b)) {
+				u8 tmp;
+				pci_read_config_byte(pdev, 0x53, &tmp);
+				pci_write_config_byte(pdev, 0x53, tmp | (1<<3));
+			}
+			pci_dev_put(p_smbus);
+		}
+		break;
 	}
 
 	ehci_reset(ehci);

