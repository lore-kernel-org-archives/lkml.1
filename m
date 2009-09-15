Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZIOXoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZIOXoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZIOXoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:44:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:39761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZIOXn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:43:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,392,1249282800"; 
   d="scan'208";a="727283775"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Tue, 15 Sep 2009 16:44:00 -0700
Subject: [PATCH] enabling ACS P2P upstream forwarding
Thread-Topic: [PATCH] enabling ACS P2P upstream forwarding
Thread-Index: Aco2XmYuZc+AbPOeSZalXlU/4fRy/w==
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_57C9024A16AD2D4C97DC78E552063EA3E05DC218orsmsx505amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_57C9024A16AD2D4C97DC78E552063EA3E05DC218orsmsx505amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


This patch enables P2P upstream forwarding in ACS capable PCIe switches.  T=
his solves two potential problems in virtualization environment where a PCI=
e device is assigned to a guest domain using a HW iommu such as VT-d:

1) Unintentional failure caused by guest physical address programmed into t=
he device's DMA that happens to match the memory address range of other dow=
nstream ports in the same PCIe switch.  This causes the PCI transaction to =
go to the matching downstream port instead of go to the root complex to get=
 translated by VT-d as it should be.

2) Malicious guest software intentionally attacks another downstream PCIe d=
evice by programming the DMA address into the assigned device that matches =
memory address range of the downstream PCIe port.

We are in process of implementing device filtering software in KVM/XEN mana=
gement software to allow device assignment of PCIe devices behind a PCIe sw=
itch only if it has ACS capability and with the P2P upstream forwarding bit=
s enabled.  This patch is intended to work for both KVM and Xen environment=
s.

Signed-off-by: Allen Kay allen.m.kay@intel.com

---

 drivers/pci/pci.c        |   37 +++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    1 +
 drivers/pci/probe.c      |    3 +++
 include/linux/pci_regs.h |   14 ++++++++++++++
 4 files changed, 55 insertions(+)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7b70312..e70abde 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1513,6 +1513,49 @@ void pci_enable_ari(struct pci_dev *dev)
 }
=20
 /**
+ * pci_acs_enable - enable ACS if hardware support it
+ * @dev: the PCI device
+ */
+#define ACS_ENABLED (PCI_EXP_ACS_V|PCI_EXP_ACS_R|PCI_EXP_ACS_C|PCI_EXP_ACS=
_U)
+void pci_acs_init(struct pci_dev *dev)
+{
+	int pos;
+	u16 cap;
+	u16 ctrl;
+
+	if (!dev->is_pcie)
+		return;
+
+	pos =3D pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		return;
+
+	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
+	if ((cap & ACS_ENABLED) !=3D ACS_ENABLED)
+		dev_info(&dev->dev, "ACS P2P upstream not supported\n");
+
+	pci_read_config_word(dev, pos + PCI_ACS_CTRL, &ctrl);
+
+	/* Source Validation */
+	if (cap & PCI_EXP_ACS_V)
+		ctrl |=3D PCI_EXP_ACS_V;
+
+	/* P2P Request Redirect */
+	if (cap & PCI_EXP_ACS_R)
+		ctrl |=3D PCI_EXP_ACS_R;
+
+	/* P2P Completion Redirect */
+	if (cap & PCI_EXP_ACS_C)
+		ctrl |=3D PCI_EXP_ACS_C;
+
+	/* Upstream Forwarding */
+	if (cap & PCI_EXP_ACS_U)
+		ctrl |=3D PCI_EXP_ACS_U;
+
+	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
+}
+
+/**
  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
  * @dev: the PCI device
  * @pin: the INTx pin (1=3DINTA, 2=3DINTB, 3=3DINTD, 4=3DINTD)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5ff4d25..1d8976d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -202,6 +202,7 @@ static inline int pci_ari_enabled(struct pci_bus *bus)
 {
 	return bus->self && bus->self->ari_enabled;
 }
+extern void pci_acs_init(struct pci_dev *dev);
=20
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_is_reassigndev(struct pci_dev *dev);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 40e75f6..4a5ec9e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -991,6 +991,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
=20
 	/* Single Root I/O Virtualization */
 	pci_iov_init(dev);
+
+	/* Access Control Service */
+	pci_acs_init(dev);
 }
=20
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index fcaee42..90014ad 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -492,6 +492,14 @@
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
 #define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
=20
+#define  PCI_EXP_ACS_V		0x01	/* Source Validation */
+#define  PCI_EXP_ACS_B		0x02	/* Translation Blocking */
+#define  PCI_EXP_ACS_R		0x04	/* P2P Request Redirect */
+#define  PCI_EXP_ACS_C		0x08	/* P2P Completion Redirect */
+#define  PCI_EXP_ACS_U		0x10	/* Upstream Forwarding */
+#define  PCI_EXP_ACS_E		0x20	/* P2P Egress Control */
+#define  PCI_EXP_ACS_T		0x40	/* Direct Translated P2P */
+
 /* Extended Capabilities (PCI-X 2.0 and Express) */
 #define PCI_EXT_CAP_ID(header)		(header & 0x0000ffff)
 #define PCI_EXT_CAP_VER(header)		((header >> 16) & 0xf)
@@ -501,6 +509,7 @@
 #define PCI_EXT_CAP_ID_VC	2
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
+#define PCI_EXT_CAP_ID_ACS	13
 #define PCI_EXT_CAP_ID_ARI	14
 #define PCI_EXT_CAP_ID_ATS	15
 #define PCI_EXT_CAP_ID_SRIOV	16
@@ -661,4 +670,9 @@
 #define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
 #define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
=20
+/* Access Control Service */
+#define PCI_ACS_CAP		0x04	/* ACS Capability Register */
+#define PCI_ACS_CTRL		0x06	/* ACS Control Register */
+#define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
+
 #endif /* LINUX_PCI_REGS_H */

--_002_57C9024A16AD2D4C97DC78E552063EA3E05DC218orsmsx505amrcor_
Content-Type: application/octet-stream; name="acs0915.patch"
Content-Description: acs0915.patch
Content-Disposition: attachment; filename="acs0915.patch"; size=3564;
	creation-date="Tue, 15 Sep 2009 16:36:50 GMT";
	modification-date="Tue, 15 Sep 2009 16:36:50 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMKaW5kZXgg
N2I3MDMxMi4uZTcwYWJkZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMKKysrIGIvZHJp
dmVycy9wY2kvcGNpLmMKQEAgLTE1MTMsNiArMTUxMyw0OSBAQCB2b2lkIHBjaV9lbmFibGVfYXJp
KHN0cnVjdCBwY2lfZGV2ICpkZXYpCiB9CiAKIC8qKgorICogcGNpX2Fjc19lbmFibGUgLSBlbmFi
bGUgQUNTIGlmIGhhcmR3YXJlIHN1cHBvcnQgaXQKKyAqIEBkZXY6IHRoZSBQQ0kgZGV2aWNlCisg
Ki8KKyNkZWZpbmUgQUNTX0VOQUJMRUQgKFBDSV9FWFBfQUNTX1Z8UENJX0VYUF9BQ1NfUnxQQ0lf
RVhQX0FDU19DfFBDSV9FWFBfQUNTX1UpCit2b2lkIHBjaV9hY3NfaW5pdChzdHJ1Y3QgcGNpX2Rl
diAqZGV2KQoreworCWludCBwb3M7CisJdTE2IGNhcDsKKwl1MTYgY3RybDsKKworCWlmICghZGV2
LT5pc19wY2llKQorCQlyZXR1cm47CisKKwlwb3MgPSBwY2lfZmluZF9leHRfY2FwYWJpbGl0eShk
ZXYsIFBDSV9FWFRfQ0FQX0lEX0FDUyk7CisJaWYgKCFwb3MpCisJCXJldHVybjsKKworCXBjaV9y
ZWFkX2NvbmZpZ193b3JkKGRldiwgcG9zICsgUENJX0FDU19DQVAsICZjYXApOworCWlmICgoY2Fw
ICYgQUNTX0VOQUJMRUQpICE9IEFDU19FTkFCTEVEKQorCQlkZXZfaW5mbygmZGV2LT5kZXYsICJB
Q1MgUDJQIHVwc3RyZWFtIG5vdCBzdXBwb3J0ZWRcbiIpOworCisJcGNpX3JlYWRfY29uZmlnX3dv
cmQoZGV2LCBwb3MgKyBQQ0lfQUNTX0NUUkwsICZjdHJsKTsKKworCS8qIFNvdXJjZSBWYWxpZGF0
aW9uICovCisJaWYgKGNhcCAmIFBDSV9FWFBfQUNTX1YpCisJCWN0cmwgfD0gUENJX0VYUF9BQ1Nf
VjsKKworCS8qIFAyUCBSZXF1ZXN0IFJlZGlyZWN0ICovCisJaWYgKGNhcCAmIFBDSV9FWFBfQUNT
X1IpCisJCWN0cmwgfD0gUENJX0VYUF9BQ1NfUjsKKworCS8qIFAyUCBDb21wbGV0aW9uIFJlZGly
ZWN0ICovCisJaWYgKGNhcCAmIFBDSV9FWFBfQUNTX0MpCisJCWN0cmwgfD0gUENJX0VYUF9BQ1Nf
QzsKKworCS8qIFVwc3RyZWFtIEZvcndhcmRpbmcgKi8KKwlpZiAoY2FwICYgUENJX0VYUF9BQ1Nf
VSkKKwkJY3RybCB8PSBQQ0lfRVhQX0FDU19VOworCisJcGNpX3dyaXRlX2NvbmZpZ193b3JkKGRl
diwgcG9zICsgUENJX0FDU19DVFJMLCBjdHJsKTsKK30KKworLyoqCiAgKiBwY2lfc3dpenpsZV9p
bnRlcnJ1cHRfcGluIC0gc3dpenpsZSBJTlR4IGZvciBkZXZpY2UgYmVoaW5kIGJyaWRnZQogICog
QGRldjogdGhlIFBDSSBkZXZpY2UKICAqIEBwaW46IHRoZSBJTlR4IHBpbiAoMT1JTlRBLCAyPUlO
VEIsIDM9SU5URCwgND1JTlREKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcGNpLmggYi9kcml2
ZXJzL3BjaS9wY2kuaAppbmRleCA1ZmY0ZDI1Li4xZDg5NzZkIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3BjaS9wY2kuaAorKysgYi9kcml2ZXJzL3BjaS9wY2kuaApAQCAtMjAyLDYgKzIwMiw3IEBAIHN0
YXRpYyBpbmxpbmUgaW50IHBjaV9hcmlfZW5hYmxlZChzdHJ1Y3QgcGNpX2J1cyAqYnVzKQogewog
CXJldHVybiBidXMtPnNlbGYgJiYgYnVzLT5zZWxmLT5hcmlfZW5hYmxlZDsKIH0KK2V4dGVybiB2
b2lkIHBjaV9hY3NfaW5pdChzdHJ1Y3QgcGNpX2RldiAqZGV2KTsKIAogI2lmZGVmIENPTkZJR19Q
Q0lfUVVJUktTCiBleHRlcm4gaW50IHBjaV9pc19yZWFzc2lnbmRldihzdHJ1Y3QgcGNpX2RldiAq
ZGV2KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3Byb2JlLmMgYi9kcml2ZXJzL3BjaS9wcm9i
ZS5jCmluZGV4IDQwZTc1ZjYuLjRhNWVjOWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL3Byb2Jl
LmMKKysrIGIvZHJpdmVycy9wY2kvcHJvYmUuYwpAQCAtOTkxLDYgKzk5MSw5IEBAIHN0YXRpYyB2
b2lkIHBjaV9pbml0X2NhcGFiaWxpdGllcyhzdHJ1Y3QgcGNpX2RldiAqZGV2KQogCiAJLyogU2lu
Z2xlIFJvb3QgSS9PIFZpcnR1YWxpemF0aW9uICovCiAJcGNpX2lvdl9pbml0KGRldik7CisKKwkv
KiBBY2Nlc3MgQ29udHJvbCBTZXJ2aWNlICovCisJcGNpX2Fjc19pbml0KGRldik7CiB9CiAKIHZv
aWQgcGNpX2RldmljZV9hZGQoc3RydWN0IHBjaV9kZXYgKmRldiwgc3RydWN0IHBjaV9idXMgKmJ1
cykKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGNpX3JlZ3MuaCBiL2luY2x1ZGUvbGludXgv
cGNpX3JlZ3MuaAppbmRleCBmY2FlZTQyLi45MDAxNGFkIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xp
bnV4L3BjaV9yZWdzLmgKKysrIGIvaW5jbHVkZS9saW51eC9wY2lfcmVncy5oCkBAIC00OTIsNiAr
NDkyLDE0IEBACiAjZGVmaW5lIFBDSV9FWFBfTE5LQ1RMMgkJNDgJLyogTGluayBDb250cm9sIDIg
Ki8KICNkZWZpbmUgUENJX0VYUF9TTFRDVEwyCQk1NgkvKiBTbG90IENvbnRyb2wgMiAqLwogCisj
ZGVmaW5lICBQQ0lfRVhQX0FDU19WCQkweDAxCS8qIFNvdXJjZSBWYWxpZGF0aW9uICovCisjZGVm
aW5lICBQQ0lfRVhQX0FDU19CCQkweDAyCS8qIFRyYW5zbGF0aW9uIEJsb2NraW5nICovCisjZGVm
aW5lICBQQ0lfRVhQX0FDU19SCQkweDA0CS8qIFAyUCBSZXF1ZXN0IFJlZGlyZWN0ICovCisjZGVm
aW5lICBQQ0lfRVhQX0FDU19DCQkweDA4CS8qIFAyUCBDb21wbGV0aW9uIFJlZGlyZWN0ICovCisj
ZGVmaW5lICBQQ0lfRVhQX0FDU19VCQkweDEwCS8qIFVwc3RyZWFtIEZvcndhcmRpbmcgKi8KKyNk
ZWZpbmUgIFBDSV9FWFBfQUNTX0UJCTB4MjAJLyogUDJQIEVncmVzcyBDb250cm9sICovCisjZGVm
aW5lICBQQ0lfRVhQX0FDU19UCQkweDQwCS8qIERpcmVjdCBUcmFuc2xhdGVkIFAyUCAqLworCiAv
KiBFeHRlbmRlZCBDYXBhYmlsaXRpZXMgKFBDSS1YIDIuMCBhbmQgRXhwcmVzcykgKi8KICNkZWZp
bmUgUENJX0VYVF9DQVBfSUQoaGVhZGVyKQkJKGhlYWRlciAmIDB4MDAwMGZmZmYpCiAjZGVmaW5l
IFBDSV9FWFRfQ0FQX1ZFUihoZWFkZXIpCQkoKGhlYWRlciA+PiAxNikgJiAweGYpCkBAIC01MDEs
NiArNTA5LDcgQEAKICNkZWZpbmUgUENJX0VYVF9DQVBfSURfVkMJMgogI2RlZmluZSBQQ0lfRVhU
X0NBUF9JRF9EU04JMwogI2RlZmluZSBQQ0lfRVhUX0NBUF9JRF9QV1IJNAorI2RlZmluZSBQQ0lf
RVhUX0NBUF9JRF9BQ1MJMTMKICNkZWZpbmUgUENJX0VYVF9DQVBfSURfQVJJCTE0CiAjZGVmaW5l
IFBDSV9FWFRfQ0FQX0lEX0FUUwkxNQogI2RlZmluZSBQQ0lfRVhUX0NBUF9JRF9TUklPVgkxNgpA
QCAtNjYxLDQgKzY3MCw5IEBACiAjZGVmaW5lICBQQ0lfU1JJT1ZfVkZNX01PCTB4MgkvKiBBY3Rp
dmUuTWlncmF0ZU91dCAqLwogI2RlZmluZSAgUENJX1NSSU9WX1ZGTV9BVgkweDMJLyogQWN0aXZl
LkF2YWlsYWJsZSAqLwogCisvKiBBY2Nlc3MgQ29udHJvbCBTZXJ2aWNlICovCisjZGVmaW5lIFBD
SV9BQ1NfQ0FQCQkweDA0CS8qIEFDUyBDYXBhYmlsaXR5IFJlZ2lzdGVyICovCisjZGVmaW5lIFBD
SV9BQ1NfQ1RSTAkJMHgwNgkvKiBBQ1MgQ29udHJvbCBSZWdpc3RlciAqLworI2RlZmluZSBQQ0lf
QUNTX0VHUkVTU19DVExfVgkweDA4CS8qIEFDUyBFZ3Jlc3MgQ29udHJvbCBWZWN0b3IgKi8KKwog
I2VuZGlmIC8qIExJTlVYX1BDSV9SRUdTX0ggKi8K

--_002_57C9024A16AD2D4C97DC78E552063EA3E05DC218orsmsx505amrcor_--
