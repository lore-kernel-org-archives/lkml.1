Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYAYD1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYAYD1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYAYD1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:27:40 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27733 "EHLO
	outbound4-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbYAYD1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:27:39 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] PCI: modify SB700 SATA MSI quirk
Date: Fri, 25 Jan 2008 11:26:09 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E501BF8F0@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: modify SB700 SATA MSI quirk
Thread-Index: AcgRZ03q+e8QbKDsTOCx0eCcyylAZBNDi9UAAACvOKAAIeqqEA==
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com>
From: "Shane Huang" <Shane.Huang@amd.com>
To: gregkh@suse.de, htejun@gmail.com
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 03:26:13.0548 (UTC)
 FILETIME=[099656C0:01C85F02]
X-WSS-ID: 6B8789532IW8740051-01-01
Content-Type: multipart/mixed;
 boundary="----_=_NextPart_001_01C85F02.06B2AE2B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C85F02.06B2AE2B
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

I did some modification to this patch and send it again, Please check
it.
The quirk to 0x4395 has been removed because 0x4395 only belongs to
SB800.


Thanks
Shane


> -----Original Message-----
> From: Shane Huang=20
>=20
> SB700 SATA MSI bug will be fixed in SB700 revision A21 at=20
> hardware level,
> but the SB700 revision older than A21 will also be found in=20
> the market.
> This patch modify the original quirk commit
> bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.
>=20
>=20
> Signed-off-by: Shane Huang <shane.huang@amd.com>


diff -ruN linux-2.6.24-rc7_org/drivers/pci/quirks.c
linux-2.6.24-rc7_new/drivers/pci/quirks.c
--- linux-2.6.24-rc7_org/drivers/pci/quirks.c	2008-01-23
14:44:53.000000000 +0800
+++ linux-2.6.24-rc7_new/drivers/pci/quirks.c	2008-01-25
10:55:21.000000000 +0800
@@ -1709,6 +1709,24 @@
 {
 	dev->dev_flags |=3D PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
 }
+static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev
*dev)
+{
+	struct pci_dev *p;
+	u8 rev =3D 0;
+
+	/* SB700 MSI issue will be fixed at HW level from revision A21,
+	 * we need check PCI REVISION ID of SMBus controller to get
SB700
+	 * revision.
+	 */
+	p =3D pci_get_device(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+			   NULL);
+	if (p) {
+		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
+	}
+	if ((rev < 0x3B) && (rev >=3D 0x30)) {
+		dev->dev_flags |=3D PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+	}
+}
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_TIGON3_5780,
 			quirk_msi_intx_disable_bug);
@@ -1729,17 +1747,15 @@
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

------_=_NextPart_001_01C85F02.06B2AE2B
Content-Type: application/octet-stream;
 name=modify_SB700_MSI_2.patch
Content-Transfer-Encoding: base64
Content-Description: modify_SB700_MSI_2.patch
Content-Disposition: attachment;
 filename=modify_SB700_MSI_2.patch

ZGlmZiAtcnVOIGxpbnV4LTIuNi4yNC1yYzdfb3JnL2RyaXZlcnMvcGNpL3F1aXJrcy5jIGxpbnV4
LTIuNi4yNC1yYzdfbmV3L2RyaXZlcnMvcGNpL3F1aXJrcy5jCi0tLSBsaW51eC0yLjYuMjQtcmM3
X29yZy9kcml2ZXJzL3BjaS9xdWlya3MuYwkyMDA4LTAxLTIzIDE0OjQ0OjUzLjAwMDAwMDAwMCAr
MDgwMAorKysgbGludXgtMi42LjI0LXJjN19uZXcvZHJpdmVycy9wY2kvcXVpcmtzLmMJMjAwOC0w
MS0yNSAxMDo1NToyMS4wMDAwMDAwMDAgKzA4MDAKQEAgLTE3MDksNiArMTcwOSwyNCBAQAogewog
CWRldi0+ZGV2X2ZsYWdzIHw9IFBDSV9ERVZfRkxBR1NfTVNJX0lOVFhfRElTQUJMRV9CVUc7CiB9
CitzdGF0aWMgdm9pZCBfX2RldmluaXQgcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9hdGlfYnVnKHN0
cnVjdCBwY2lfZGV2ICpkZXYpCit7CisJc3RydWN0IHBjaV9kZXYgKnA7CisJdTggcmV2ID0gMDsK
KworCS8qIFNCNzAwIE1TSSBpc3N1ZSB3aWxsIGJlIGZpeGVkIGF0IEhXIGxldmVsIGZyb20gcmV2
aXNpb24gQTIxLAorCSAqIHdlIG5lZWQgY2hlY2sgUENJIFJFVklTSU9OIElEIG9mIFNNQnVzIGNv
bnRyb2xsZXIgdG8gZ2V0IFNCNzAwCisJICogcmV2aXNpb24uCisJICovCisJcCA9IHBjaV9nZXRf
ZGV2aWNlKFBDSV9WRU5ET1JfSURfQVRJLCBQQ0lfREVWSUNFX0lEX0FUSV9TQlgwMF9TTUJVUywK
KwkJCSAgIE5VTEwpOworCWlmIChwKSB7CisJCXBjaV9yZWFkX2NvbmZpZ19ieXRlKHAsIFBDSV9D
TEFTU19SRVZJU0lPTiwgJnJldik7CisJfQorCWlmICgocmV2IDwgMHgzQikgJiYgKHJldiA+PSAw
eDMwKSkgeworCQlkZXYtPmRldl9mbGFncyB8PSBQQ0lfREVWX0ZMQUdTX01TSV9JTlRYX0RJU0FC
TEVfQlVHOworCX0KK30KIERFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfQlJP
QURDT00sCiAJCQlQQ0lfREVWSUNFX0lEX1RJR09OM181NzgwLAogCQkJcXVpcmtfbXNpX2ludHhf
ZGlzYWJsZV9idWcpOwpAQCAtMTcyOSwxNyArMTc0NywxNSBAQAogCQkJcXVpcmtfbXNpX2ludHhf
ZGlzYWJsZV9idWcpOwogCiBERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0FU
SSwgMHg0MzkwLAotCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9idWcpOworCQkJcXVpcmtfbXNp
X2ludHhfZGlzYWJsZV9hdGlfYnVnKTsKIERFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5E
T1JfSURfQVRJLCAweDQzOTEsCi0JCQlxdWlya19tc2lfaW50eF9kaXNhYmxlX2J1Zyk7CisJCQlx
dWlya19tc2lfaW50eF9kaXNhYmxlX2F0aV9idWcpOwogREVDTEFSRV9QQ0lfRklYVVBfRklOQUwo
UENJX1ZFTkRPUl9JRF9BVEksIDB4NDM5MiwKLQkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVn
KTsKKwkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYXRpX2J1Zyk7CiBERUNMQVJFX1BDSV9GSVhV
UF9GSU5BTChQQ0lfVkVORE9SX0lEX0FUSSwgMHg0MzkzLAotCQkJcXVpcmtfbXNpX2ludHhfZGlz
YWJsZV9idWcpOworCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9hdGlfYnVnKTsKIERFQ0xBUkVf
UENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfQVRJLCAweDQzOTQsCi0JCQlxdWlya19tc2lf
aW50eF9kaXNhYmxlX2J1Zyk7Ci1ERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lE
X0FUSSwgMHg0Mzk1LAotCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9idWcpOworCQkJcXVpcmtf
bXNpX2ludHhfZGlzYWJsZV9hdGlfYnVnKTsKIAogREVDTEFSRV9QQ0lfRklYVVBfRklOQUwoUENJ
X1ZFTkRPUl9JRF9BVEksIDB4NDM3MywKIAkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsK

------_=_NextPart_001_01C85F02.06B2AE2B--


