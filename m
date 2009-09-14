Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZINXfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZINXfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbZINXfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:35:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:42834 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495AbZINXfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:35:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,385,1249282800"; 
   d="scan'208";a="187578451"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "Barnes, Jesse" <jesse.barnes@intel.com>
Date: Mon, 14 Sep 2009 16:35:04 -0700
Subject: [RFC][PATCH] PCI ACS enabling
Thread-Topic: [RFC][PATCH] PCI ACS enabling
Thread-Index: AcozGsyYc1o1rBpNSRqC81eA/zJSSgCaaRog
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E05DB707@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_57C9024A16AD2D4C97DC78E552063EA3E05DB707orsmsx505amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_57C9024A16AD2D4C97DC78E552063EA3E05DB707orsmsx505amrcor_
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
gement software to allow device assignment of PCIe devices behind a PCIe wi=
tch only if it has ACS capability and with the P2P upstream forwarding bits=
 enabled.  This patch is intended to work for both KVM and Xen environments=
.

Signed-off-by: Allen Kay allen.m.kay@intel.com

---

 drivers/pci/pci.c        |   37 +++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    1 +
 drivers/pci/probe.c      |    3 +++
 include/linux/pci_regs.h |   14 ++++++++++++++
 4 files changed, 55 insertions(+)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c index 7b70312..8272835 1=
00644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1513,6 +1513,43 @@ void pci_enable_ari(struct pci_dev *dev)  }
=20
 /**
+ * pci_acs_enable - enable ACS if hardware support it
+ * @dev: the PCI device
+ */
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
+	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
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
+	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl); }
+
+/**
  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
  * @dev: the PCI device
  * @pin: the INTx pin (1=3DINTA, 2=3DINTB, 3=3DINTD, 4=3DINTD) diff --git =
a/drivers/pci/pci.h b/drivers/pci/pci.h index 5ff4d25..1d8976d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -202,6 +202,7 @@ static inline int pci_ari_enabled(struct pci_bus *bus) =
 {
 	return bus->self && bus->self->ari_enabled;  }
+extern void pci_acs_init(struct pci_dev *dev);
=20
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_is_reassigndev(struct pci_dev *dev); diff --git a/drivers/p=
ci/probe.c b/drivers/pci/probe.c index 40e75f6..4a5ec9e 100644
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
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus) diff --git a=
/include/linux/pci_regs.h b/include/linux/pci_regs.h index fcaee42..90014ad=
 100644
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

--_002_57C9024A16AD2D4C97DC78E552063EA3E05DB707orsmsx505amrcor_
Content-Type: application/octet-stream; name="acs09113.patch"
Content-Description: acs09113.patch
Content-Disposition: attachment; filename="acs09113.patch"; size=3323;
	creation-date="Fri, 11 Sep 2009 12:35:50 GMT";
	modification-date="Fri, 11 Sep 2009 12:35:50 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMKaW5kZXgg
N2I3MDMxMi4uODI3MjgzNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMKKysrIGIvZHJp
dmVycy9wY2kvcGNpLmMKQEAgLTE1MTMsNiArMTUxMyw0MyBAQCB2b2lkIHBjaV9lbmFibGVfYXJp
KHN0cnVjdCBwY2lfZGV2ICpkZXYpCiB9CiAKIC8qKgorICogcGNpX2Fjc19lbmFibGUgLSBlbmFi
bGUgQUNTIGlmIGhhcmR3YXJlIHN1cHBvcnQgaXQKKyAqIEBkZXY6IHRoZSBQQ0kgZGV2aWNlCisg
Ki8KK3ZvaWQgcGNpX2Fjc19pbml0KHN0cnVjdCBwY2lfZGV2ICpkZXYpCit7CisJaW50IHBvczsK
Kwl1MTYgY2FwOworCXUxNiBjdHJsOworCisJaWYgKCFkZXYtPmlzX3BjaWUpCisJCXJldHVybjsK
KworCXBvcyA9IHBjaV9maW5kX2V4dF9jYXBhYmlsaXR5KGRldiwgUENJX0VYVF9DQVBfSURfQUNT
KTsKKwlpZiAoIXBvcykKKwkJcmV0dXJuOworCXBjaV9yZWFkX2NvbmZpZ193b3JkKGRldiwgcG9z
ICsgUENJX0FDU19DQVAsICZjYXApOworCisJLyogU291cmNlIFZhbGlkYXRpb24gKi8KKwlpZiAo
Y2FwICYgUENJX0VYUF9BQ1NfVikKKwkJY3RybCB8PSBQQ0lfRVhQX0FDU19WOworCisJLyogUDJQ
IFJlcXVlc3QgUmVkaXJlY3QgKi8KKwlpZiAoY2FwICYgUENJX0VYUF9BQ1NfUikKKwkJY3RybCB8
PSBQQ0lfRVhQX0FDU19SOworCisJLyogUDJQIENvbXBsZXRpb24gUmVkaXJlY3QgKi8KKwlpZiAo
Y2FwICYgUENJX0VYUF9BQ1NfQykKKwkJY3RybCB8PSBQQ0lfRVhQX0FDU19DOworCisJLyogVXBz
dHJlYW0gRm9yd2FyZGluZyAqLworCWlmIChjYXAgJiBQQ0lfRVhQX0FDU19VKQorCQljdHJsIHw9
IFBDSV9FWFBfQUNTX1U7CisKKwlwY2lfd3JpdGVfY29uZmlnX3dvcmQoZGV2LCBwb3MgKyBQQ0lf
QUNTX0NUUkwsIGN0cmwpOworfQorCisvKioKICAqIHBjaV9zd2l6emxlX2ludGVycnVwdF9waW4g
LSBzd2l6emxlIElOVHggZm9yIGRldmljZSBiZWhpbmQgYnJpZGdlCiAgKiBAZGV2OiB0aGUgUENJ
IGRldmljZQogICogQHBpbjogdGhlIElOVHggcGluICgxPUlOVEEsIDI9SU5UQiwgMz1JTlRELCA0
PUlOVEQpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9wY2kuaCBiL2RyaXZlcnMvcGNpL3BjaS5o
CmluZGV4IDVmZjRkMjUuLjFkODk3NmQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL3BjaS5oCisr
KyBiL2RyaXZlcnMvcGNpL3BjaS5oCkBAIC0yMDIsNiArMjAyLDcgQEAgc3RhdGljIGlubGluZSBp
bnQgcGNpX2FyaV9lbmFibGVkKHN0cnVjdCBwY2lfYnVzICpidXMpCiB7CiAJcmV0dXJuIGJ1cy0+
c2VsZiAmJiBidXMtPnNlbGYtPmFyaV9lbmFibGVkOwogfQorZXh0ZXJuIHZvaWQgcGNpX2Fjc19p
bml0KHN0cnVjdCBwY2lfZGV2ICpkZXYpOwogCiAjaWZkZWYgQ09ORklHX1BDSV9RVUlSS1MKIGV4
dGVybiBpbnQgcGNpX2lzX3JlYXNzaWduZGV2KHN0cnVjdCBwY2lfZGV2ICpkZXYpOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9wY2kvcHJvYmUuYyBiL2RyaXZlcnMvcGNpL3Byb2JlLmMKaW5kZXggNDBl
NzVmNi4uNGE1ZWM5ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcHJvYmUuYworKysgYi9kcml2
ZXJzL3BjaS9wcm9iZS5jCkBAIC05OTEsNiArOTkxLDkgQEAgc3RhdGljIHZvaWQgcGNpX2luaXRf
Y2FwYWJpbGl0aWVzKHN0cnVjdCBwY2lfZGV2ICpkZXYpCiAKIAkvKiBTaW5nbGUgUm9vdCBJL08g
VmlydHVhbGl6YXRpb24gKi8KIAlwY2lfaW92X2luaXQoZGV2KTsKKworCS8qIEFjY2VzcyBDb250
cm9sIFNlcnZpY2UgKi8KKwlwY2lfYWNzX2luaXQoZGV2KTsKIH0KIAogdm9pZCBwY2lfZGV2aWNl
X2FkZChzdHJ1Y3QgcGNpX2RldiAqZGV2LCBzdHJ1Y3QgcGNpX2J1cyAqYnVzKQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9wY2lfcmVncy5oIGIvaW5jbHVkZS9saW51eC9wY2lfcmVncy5oCmlu
ZGV4IGZjYWVlNDIuLjkwMDE0YWQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcGNpX3JlZ3Mu
aAorKysgYi9pbmNsdWRlL2xpbnV4L3BjaV9yZWdzLmgKQEAgLTQ5Miw2ICs0OTIsMTQgQEAKICNk
ZWZpbmUgUENJX0VYUF9MTktDVEwyCQk0OAkvKiBMaW5rIENvbnRyb2wgMiAqLwogI2RlZmluZSBQ
Q0lfRVhQX1NMVENUTDIJCTU2CS8qIFNsb3QgQ29udHJvbCAyICovCiAKKyNkZWZpbmUgIFBDSV9F
WFBfQUNTX1YJCTB4MDEJLyogU291cmNlIFZhbGlkYXRpb24gKi8KKyNkZWZpbmUgIFBDSV9FWFBf
QUNTX0IJCTB4MDIJLyogVHJhbnNsYXRpb24gQmxvY2tpbmcgKi8KKyNkZWZpbmUgIFBDSV9FWFBf
QUNTX1IJCTB4MDQJLyogUDJQIFJlcXVlc3QgUmVkaXJlY3QgKi8KKyNkZWZpbmUgIFBDSV9FWFBf
QUNTX0MJCTB4MDgJLyogUDJQIENvbXBsZXRpb24gUmVkaXJlY3QgKi8KKyNkZWZpbmUgIFBDSV9F
WFBfQUNTX1UJCTB4MTAJLyogVXBzdHJlYW0gRm9yd2FyZGluZyAqLworI2RlZmluZSAgUENJX0VY
UF9BQ1NfRQkJMHgyMAkvKiBQMlAgRWdyZXNzIENvbnRyb2wgKi8KKyNkZWZpbmUgIFBDSV9FWFBf
QUNTX1QJCTB4NDAJLyogRGlyZWN0IFRyYW5zbGF0ZWQgUDJQICovCisKIC8qIEV4dGVuZGVkIENh
cGFiaWxpdGllcyAoUENJLVggMi4wIGFuZCBFeHByZXNzKSAqLwogI2RlZmluZSBQQ0lfRVhUX0NB
UF9JRChoZWFkZXIpCQkoaGVhZGVyICYgMHgwMDAwZmZmZikKICNkZWZpbmUgUENJX0VYVF9DQVBf
VkVSKGhlYWRlcikJCSgoaGVhZGVyID4+IDE2KSAmIDB4ZikKQEAgLTUwMSw2ICs1MDksNyBAQAog
I2RlZmluZSBQQ0lfRVhUX0NBUF9JRF9WQwkyCiAjZGVmaW5lIFBDSV9FWFRfQ0FQX0lEX0RTTgkz
CiAjZGVmaW5lIFBDSV9FWFRfQ0FQX0lEX1BXUgk0CisjZGVmaW5lIFBDSV9FWFRfQ0FQX0lEX0FD
UwkxMwogI2RlZmluZSBQQ0lfRVhUX0NBUF9JRF9BUkkJMTQKICNkZWZpbmUgUENJX0VYVF9DQVBf
SURfQVRTCTE1CiAjZGVmaW5lIFBDSV9FWFRfQ0FQX0lEX1NSSU9WCTE2CkBAIC02NjEsNCArNjcw
LDkgQEAKICNkZWZpbmUgIFBDSV9TUklPVl9WRk1fTU8JMHgyCS8qIEFjdGl2ZS5NaWdyYXRlT3V0
ICovCiAjZGVmaW5lICBQQ0lfU1JJT1ZfVkZNX0FWCTB4MwkvKiBBY3RpdmUuQXZhaWxhYmxlICov
CiAKKy8qIEFjY2VzcyBDb250cm9sIFNlcnZpY2UgKi8KKyNkZWZpbmUgUENJX0FDU19DQVAJCTB4
MDQJLyogQUNTIENhcGFiaWxpdHkgUmVnaXN0ZXIgKi8KKyNkZWZpbmUgUENJX0FDU19DVFJMCQkw
eDA2CS8qIEFDUyBDb250cm9sIFJlZ2lzdGVyICovCisjZGVmaW5lIFBDSV9BQ1NfRUdSRVNTX0NU
TF9WCTB4MDgJLyogQUNTIEVncmVzcyBDb250cm9sIFZlY3RvciAqLworCiAjZW5kaWYgLyogTElO
VVhfUENJX1JFR1NfSCAqLwo=

--_002_57C9024A16AD2D4C97DC78E552063EA3E05DB707orsmsx505amrcor_--
