Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYAYGxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYAYGxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 01:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAYGxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 01:53:08 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59278 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYAYGxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 01:53:07 -0500
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 01:53:07 EST
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH] PCI: modify SB700 SATA MSI quirk
Date: Fri, 25 Jan 2008 14:33:20 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E501BF9C7@sshaexmb1.amd.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] PCI: modify SB700 SATA MSI quirk
Thread-Index: AchfHC2YBI3NzQ5LTJukmvbAdkLn9Q==
From: "Shane Huang" <Shane.Huang@amd.com>
To: gregkh@suse.de, "Tejun Heo" <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 06:33:24.0501 (UTC)
 FILETIME=[2FC1C450:01C85F1C]
X-WSS-ID: 6B875D402IW8752056-01-01
Content-Type: multipart/mixed;
 boundary="----_=_NextPart_001_01C85F1C.2CBFACFB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C85F1C.2CBFACFB
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable


SB700 SATA MSI bug will be fixed in SB700 revision A21 at hardware
level,
but the SB700 revision older than A21 will also be found in the market.
This patch modify the original quirk commit
bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.
The patch also removes quirk to 0x4395 because 0x4395 is SB800 device
ID.

Signed-off-by: Shane Huang <shane.huang@amd.com>


diff -ruN linux-2.6.24-rc7_org/drivers/pci/quirks.c
linux-2.6.24-rc7_new/drivers/pci/quirks.c
--- linux-2.6.24-rc7_org/drivers/pci/quirks.c	2008-01-23
14:44:53.000000000 +0800
+++ linux-2.6.24-rc7_new/drivers/pci/quirks.c	2008-01-25
12:55:05.000000000 +0800
@@ -1709,6 +1709,23 @@
 {
 	dev->dev_flags |=3D PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
 }
+static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev
*dev)
+{
+	struct pci_dev *p;
+
+	/* SB700 MSI issue will be fixed at HW level from revision A21,
+	 * we need check PCI REVISION ID of SMBus controller to get
SB700
+	 * revision.
+	 */
+	p =3D pci_get_device(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+			   NULL);
+	if (!p)
+		return;
+
+	if ((p->revision < 0x3B) && (p->revision >=3D 0x30))
+		dev->dev_flags |=3D PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+	pci_dev_put(p);
+}
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_TIGON3_5780,
 			quirk_msi_intx_disable_bug);
@@ -1729,17 +1746,15 @@
 			quirk_msi_intx_disable_bug);
=20
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4390,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4391,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4392,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4393,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4394,
-			quirk_msi_intx_disable_bug);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4395,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
=20
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4373,
 			quirk_msi_intx_disable_bug);



Thanks
Shane

------_=_NextPart_001_01C85F1C.2CBFACFB
Content-Type: application/octet-stream;
 name=modify_SB700_MSI_3.patch
Content-Transfer-Encoding: base64
Content-Description: modify_SB700_MSI_3.patch
Content-Disposition: attachment;
 filename=modify_SB700_MSI_3.patch

ZGlmZiAtcnVOIGxpbnV4LTIuNi4yNC1yYzdfb3JnL2RyaXZlcnMvcGNpL3F1aXJrcy5jIGxpbnV4
LTIuNi4yNC1yYzdfbmV3L2RyaXZlcnMvcGNpL3F1aXJrcy5jCi0tLSBsaW51eC0yLjYuMjQtcmM3
X29yZy9kcml2ZXJzL3BjaS9xdWlya3MuYwkyMDA4LTAxLTIzIDE0OjQ0OjUzLjAwMDAwMDAwMCAr
MDgwMAorKysgbGludXgtMi42LjI0LXJjN19uZXcvZHJpdmVycy9wY2kvcXVpcmtzLmMJMjAwOC0w
MS0yNSAxMjo1NTowNS4wMDAwMDAwMDAgKzA4MDAKQEAgLTE3MDksNiArMTcwOSwyMyBAQAogewog
CWRldi0+ZGV2X2ZsYWdzIHw9IFBDSV9ERVZfRkxBR1NfTVNJX0lOVFhfRElTQUJMRV9CVUc7CiB9
CitzdGF0aWMgdm9pZCBfX2RldmluaXQgcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9hdGlfYnVnKHN0
cnVjdCBwY2lfZGV2ICpkZXYpCit7CisJc3RydWN0IHBjaV9kZXYgKnA7CisKKwkvKiBTQjcwMCBN
U0kgaXNzdWUgd2lsbCBiZSBmaXhlZCBhdCBIVyBsZXZlbCBmcm9tIHJldmlzaW9uIEEyMSwKKwkg
KiB3ZSBuZWVkIGNoZWNrIFBDSSBSRVZJU0lPTiBJRCBvZiBTTUJ1cyBjb250cm9sbGVyIHRvIGdl
dCBTQjcwMAorCSAqIHJldmlzaW9uLgorCSAqLworCXAgPSBwY2lfZ2V0X2RldmljZShQQ0lfVkVO
RE9SX0lEX0FUSSwgUENJX0RFVklDRV9JRF9BVElfU0JYMDBfU01CVVMsCisJCQkgICBOVUxMKTsK
KwlpZiAoIXApCisJCXJldHVybjsKKworCWlmICgocC0+cmV2aXNpb24gPCAweDNCKSAmJiAocC0+
cmV2aXNpb24gPj0gMHgzMCkpCisJCWRldi0+ZGV2X2ZsYWdzIHw9IFBDSV9ERVZfRkxBR1NfTVNJ
X0lOVFhfRElTQUJMRV9CVUc7CisJcGNpX2Rldl9wdXQocCk7Cit9CiBERUNMQVJFX1BDSV9GSVhV
UF9GSU5BTChQQ0lfVkVORE9SX0lEX0JST0FEQ09NLAogCQkJUENJX0RFVklDRV9JRF9USUdPTjNf
NTc4MCwKIAkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKQEAgLTE3MjksMTcgKzE3NDYs
MTUgQEAKIAkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKIAogREVDTEFSRV9QQ0lfRklY
VVBfRklOQUwoUENJX1ZFTkRPUl9JRF9BVEksIDB4NDM5MCwKLQkJCXF1aXJrX21zaV9pbnR4X2Rp
c2FibGVfYnVnKTsKKwkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYXRpX2J1Zyk7CiBERUNMQVJF
X1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0FUSSwgMHg0MzkxLAotCQkJcXVpcmtfbXNp
X2ludHhfZGlzYWJsZV9idWcpOworCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9hdGlfYnVnKTsK
IERFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfQVRJLCAweDQzOTIsCi0JCQlx
dWlya19tc2lfaW50eF9kaXNhYmxlX2J1Zyk7CisJCQlxdWlya19tc2lfaW50eF9kaXNhYmxlX2F0
aV9idWcpOwogREVDTEFSRV9QQ0lfRklYVVBfRklOQUwoUENJX1ZFTkRPUl9JRF9BVEksIDB4NDM5
MywKLQkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKKwkJCXF1aXJrX21zaV9pbnR4X2Rp
c2FibGVfYXRpX2J1Zyk7CiBERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0FU
SSwgMHg0Mzk0LAotCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9idWcpOwotREVDTEFSRV9QQ0lf
RklYVVBfRklOQUwoUENJX1ZFTkRPUl9JRF9BVEksIDB4NDM5NSwKLQkJCXF1aXJrX21zaV9pbnR4
X2Rpc2FibGVfYnVnKTsKKwkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYXRpX2J1Zyk7CiAKIERF
Q0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfQVRJLCAweDQzNzMsCiAJCQlxdWly
a19tc2lfaW50eF9kaXNhYmxlX2J1Zyk7Cg==

------_=_NextPart_001_01C85F1C.2CBFACFB--


