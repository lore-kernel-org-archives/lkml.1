Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0CDFbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:31:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:31590 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab0CDFbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:31:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,579,1262592000"; 
   d="scan'208";a="601173080"
From: "Wang, Shane" <shane.wang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Date: Thu, 4 Mar 2010 13:30:54 +0800
Subject: [PATCH] intel_txt: fix section warning messages from tboot when
 "allyesconfig" is set on i386
Thread-Topic: [PATCH] intel_txt: fix section warning messages from tboot
 when "allyesconfig" is set on i386
Thread-Index: Acq7W9xKQsgxkN7ASTqYXVNyvjm+rA==
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817@shsmsx501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817shsmsx501ccrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817shsmsx501ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch is to fix the warning messages related to tboot when "allyesconf=
ig" is set on i386.

Signed-off-by: Shane Wang <shane.wang@intel.com>

 arch/x86/kernel/tboot.c |   90 ++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

diff -r d5d64753146c arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Mon Mar 01 09:47:50 2010 -0500
+++ b/arch/x86/kernel/tboot.c	Tue Mar 02 05:23:32 2010 -0500
@@ -55,6 +55,44 @@ struct tboot *tboot __read_mostly;
=20
 static u8 tboot_uuid[16] __initdata =3D TBOOT_UUID;
=20
+#ifdef CONFIG_ACPI_SLEEP
+
+static void add_mac_region(phys_addr_t start, unsigned long size)
+{
+	struct tboot_mac_region *mr;
+	phys_addr_t end =3D start + size;
+
+	if (start && size) {
+		mr =3D &tboot->mac_regions[tboot->num_mac_regions++];
+		mr->start =3D round_down(start, PAGE_SIZE);
+		mr->size  =3D round_up(end, PAGE_SIZE) - mr->start;
+	}
+}
+
+static void __init tboot_setup_sleep(void)
+{
+	tboot->num_mac_regions =3D 0;
+
+	/* S3 resume code */
+	add_mac_region(acpi_wakeup_address, WAKEUP_SIZE);
+
+#ifdef CONFIG_X86_TRAMPOLINE
+	/* AP trampoline code */
+	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
+#endif
+
+	/* kernel code + data + bss */
+	add_mac_region(virt_to_phys(_text), _end - _text);
+
+	tboot->acpi_sinfo.kernel_s3_resume_vector =3D acpi_wakeup_address;
+}
+
+#else /* no CONFIG_ACPI_SLEEP */
+
+static void tboot_setup_sleep(void)	{}
+
+#endif
+
 void __init tboot_probe(void)
 {
 	/* Look for valid page-aligned address for shared page. */
@@ -98,6 +136,8 @@ void __init tboot_probe(void)
 	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
 	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
 	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
+
+	tboot_setup_sleep();
 }
=20
 static pgd_t *tboot_pg_dir;
@@ -168,51 +208,6 @@ static void tboot_create_trampoline(void
 		      map_base, map_size);
 }
=20
-#ifdef CONFIG_ACPI_SLEEP
-
-static void add_mac_region(phys_addr_t start, unsigned long size)
-{
-	struct tboot_mac_region *mr;
-	phys_addr_t end =3D start + size;
-
-	if (start && size) {
-		mr =3D &tboot->mac_regions[tboot->num_mac_regions++];
-		mr->start =3D round_down(start, PAGE_SIZE);
-		mr->size  =3D round_up(end, PAGE_SIZE) - mr->start;
-	}
-}
-
-static int tboot_setup_sleep(void)
-{
-	tboot->num_mac_regions =3D 0;
-
-	/* S3 resume code */
-	add_mac_region(acpi_wakeup_address, WAKEUP_SIZE);
-
-#ifdef CONFIG_X86_TRAMPOLINE
-	/* AP trampoline code */
-	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
-#endif
-
-	/* kernel code + data + bss */
-	add_mac_region(virt_to_phys(_text), _end - _text);
-
-	tboot->acpi_sinfo.kernel_s3_resume_vector =3D acpi_wakeup_address;
-
-	return 0;
-}
-
-#else /* no CONFIG_ACPI_SLEEP */
-
-static int tboot_setup_sleep(void)
-{
-	/* S3 shutdown requested, but S3 not supported by the kernel... */
-	BUG();
-	return -1;
-}
-
-#endif
-
 void tboot_shutdown(u32 shutdown_type)
 {
 	void (*shutdown)(void);
@@ -227,11 +222,6 @@ void tboot_shutdown(u32 shutdown_type)
 	 */
 	if (!tboot_pg_dir)
 		return;
-
-	/* if this is S3 then set regions to MAC */
-	if (shutdown_type =3D=3D TB_SHUTDOWN_S3)
-		if (tboot_setup_sleep())
-			return;
=20
 	tboot->shutdown_type =3D shutdown_type;
 =

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817shsmsx501ccrcor_
Content-Type: application/octet-stream; name="fix_warning.patch"
Content-Description: fix_warning.patch
Content-Disposition: attachment; filename="fix_warning.patch"; size=3102;
	creation-date="Thu, 04 Mar 2010 05:23:00 GMT";
	modification-date="Thu, 04 Mar 2010 05:23:00 GMT"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBpcyB0byBmaXggdGhlIHdhcm5pbmcgbWVzc2FnZXMgcmVsYXRlZCB0byB0Ym9v
dCB3aGVuICJhbGx5ZXNjb25maWciIGlzIHNldCBvbiBpMzg2LgoKU2lnbmVkLW9mZi1ieTogU2hh
bmUgV2FuZyA8c2hhbmUud2FuZ0BpbnRlbC5jb20+CgpkaWZmIC1yIGQ1ZDY0NzUzMTQ2YyBhcmNo
L3g4Ni9rZXJuZWwvdGJvb3QuYwotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvdGJvb3QuYwlNb24gTWFy
IDAxIDA5OjQ3OjUwIDIwMTAgLTA1MDAKKysrIGIvYXJjaC94ODYva2VybmVsL3Rib290LmMJVHVl
IE1hciAwMiAwNToyMzozMiAyMDEwIC0wNTAwCkBAIC01NSw2ICs1NSw0NCBAQCBzdHJ1Y3QgdGJv
b3QgKnRib290IF9fcmVhZF9tb3N0bHk7CiAKIHN0YXRpYyB1OCB0Ym9vdF91dWlkWzE2XSBfX2lu
aXRkYXRhID0gVEJPT1RfVVVJRDsKIAorI2lmZGVmIENPTkZJR19BQ1BJX1NMRUVQCisKK3N0YXRp
YyB2b2lkIGFkZF9tYWNfcmVnaW9uKHBoeXNfYWRkcl90IHN0YXJ0LCB1bnNpZ25lZCBsb25nIHNp
emUpCit7CisJc3RydWN0IHRib290X21hY19yZWdpb24gKm1yOworCXBoeXNfYWRkcl90IGVuZCA9
IHN0YXJ0ICsgc2l6ZTsKKworCWlmIChzdGFydCAmJiBzaXplKSB7CisJCW1yID0gJnRib290LT5t
YWNfcmVnaW9uc1t0Ym9vdC0+bnVtX21hY19yZWdpb25zKytdOworCQltci0+c3RhcnQgPSByb3Vu
ZF9kb3duKHN0YXJ0LCBQQUdFX1NJWkUpOworCQltci0+c2l6ZSAgPSByb3VuZF91cChlbmQsIFBB
R0VfU0laRSkgLSBtci0+c3RhcnQ7CisJfQorfQorCitzdGF0aWMgdm9pZCBfX2luaXQgdGJvb3Rf
c2V0dXBfc2xlZXAodm9pZCkKK3sKKwl0Ym9vdC0+bnVtX21hY19yZWdpb25zID0gMDsKKworCS8q
IFMzIHJlc3VtZSBjb2RlICovCisJYWRkX21hY19yZWdpb24oYWNwaV93YWtldXBfYWRkcmVzcywg
V0FLRVVQX1NJWkUpOworCisjaWZkZWYgQ09ORklHX1g4Nl9UUkFNUE9MSU5FCisJLyogQVAgdHJh
bXBvbGluZSBjb2RlICovCisJYWRkX21hY19yZWdpb24odmlydF90b19waHlzKHRyYW1wb2xpbmVf
YmFzZSksIFRSQU1QT0xJTkVfU0laRSk7CisjZW5kaWYKKworCS8qIGtlcm5lbCBjb2RlICsgZGF0
YSArIGJzcyAqLworCWFkZF9tYWNfcmVnaW9uKHZpcnRfdG9fcGh5cyhfdGV4dCksIF9lbmQgLSBf
dGV4dCk7CisKKwl0Ym9vdC0+YWNwaV9zaW5mby5rZXJuZWxfczNfcmVzdW1lX3ZlY3RvciA9IGFj
cGlfd2FrZXVwX2FkZHJlc3M7Cit9CisKKyNlbHNlIC8qIG5vIENPTkZJR19BQ1BJX1NMRUVQICov
CisKK3N0YXRpYyB2b2lkIHRib290X3NldHVwX3NsZWVwKHZvaWQpCXt9CisKKyNlbmRpZgorCiB2
b2lkIF9faW5pdCB0Ym9vdF9wcm9iZSh2b2lkKQogewogCS8qIExvb2sgZm9yIHZhbGlkIHBhZ2Ut
YWxpZ25lZCBhZGRyZXNzIGZvciBzaGFyZWQgcGFnZS4gKi8KQEAgLTk4LDYgKzEzNiw4IEBAIHZv
aWQgX19pbml0IHRib290X3Byb2JlKHZvaWQpCiAJcHJfZGVidWcoInNodXRkb3duX2VudHJ5OiAw
eCV4XG4iLCB0Ym9vdC0+c2h1dGRvd25fZW50cnkpOwogCXByX2RlYnVnKCJ0Ym9vdF9iYXNlOiAw
eCUwOHhcbiIsIHRib290LT50Ym9vdF9iYXNlKTsKIAlwcl9kZWJ1ZygidGJvb3Rfc2l6ZTogMHgl
eFxuIiwgdGJvb3QtPnRib290X3NpemUpOworCisJdGJvb3Rfc2V0dXBfc2xlZXAoKTsKIH0KIAog
c3RhdGljIHBnZF90ICp0Ym9vdF9wZ19kaXI7CkBAIC0xNjgsNTEgKzIwOCw2IEBAIHN0YXRpYyB2
b2lkIHRib290X2NyZWF0ZV90cmFtcG9saW5lKHZvaWQKIAkJICAgICAgbWFwX2Jhc2UsIG1hcF9z
aXplKTsKIH0KIAotI2lmZGVmIENPTkZJR19BQ1BJX1NMRUVQCi0KLXN0YXRpYyB2b2lkIGFkZF9t
YWNfcmVnaW9uKHBoeXNfYWRkcl90IHN0YXJ0LCB1bnNpZ25lZCBsb25nIHNpemUpCi17Ci0Jc3Ry
dWN0IHRib290X21hY19yZWdpb24gKm1yOwotCXBoeXNfYWRkcl90IGVuZCA9IHN0YXJ0ICsgc2l6
ZTsKLQotCWlmIChzdGFydCAmJiBzaXplKSB7Ci0JCW1yID0gJnRib290LT5tYWNfcmVnaW9uc1t0
Ym9vdC0+bnVtX21hY19yZWdpb25zKytdOwotCQltci0+c3RhcnQgPSByb3VuZF9kb3duKHN0YXJ0
LCBQQUdFX1NJWkUpOwotCQltci0+c2l6ZSAgPSByb3VuZF91cChlbmQsIFBBR0VfU0laRSkgLSBt
ci0+c3RhcnQ7Ci0JfQotfQotCi1zdGF0aWMgaW50IHRib290X3NldHVwX3NsZWVwKHZvaWQpCi17
Ci0JdGJvb3QtPm51bV9tYWNfcmVnaW9ucyA9IDA7Ci0KLQkvKiBTMyByZXN1bWUgY29kZSAqLwot
CWFkZF9tYWNfcmVnaW9uKGFjcGlfd2FrZXVwX2FkZHJlc3MsIFdBS0VVUF9TSVpFKTsKLQotI2lm
ZGVmIENPTkZJR19YODZfVFJBTVBPTElORQotCS8qIEFQIHRyYW1wb2xpbmUgY29kZSAqLwotCWFk
ZF9tYWNfcmVnaW9uKHZpcnRfdG9fcGh5cyh0cmFtcG9saW5lX2Jhc2UpLCBUUkFNUE9MSU5FX1NJ
WkUpOwotI2VuZGlmCi0KLQkvKiBrZXJuZWwgY29kZSArIGRhdGEgKyBic3MgKi8KLQlhZGRfbWFj
X3JlZ2lvbih2aXJ0X3RvX3BoeXMoX3RleHQpLCBfZW5kIC0gX3RleHQpOwotCi0JdGJvb3QtPmFj
cGlfc2luZm8ua2VybmVsX3MzX3Jlc3VtZV92ZWN0b3IgPSBhY3BpX3dha2V1cF9hZGRyZXNzOwot
Ci0JcmV0dXJuIDA7Ci19Ci0KLSNlbHNlIC8qIG5vIENPTkZJR19BQ1BJX1NMRUVQICovCi0KLXN0
YXRpYyBpbnQgdGJvb3Rfc2V0dXBfc2xlZXAodm9pZCkKLXsKLQkvKiBTMyBzaHV0ZG93biByZXF1
ZXN0ZWQsIGJ1dCBTMyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSBrZXJuZWwuLi4gKi8KLQlCVUcoKTsK
LQlyZXR1cm4gLTE7Ci19Ci0KLSNlbmRpZgotCiB2b2lkIHRib290X3NodXRkb3duKHUzMiBzaHV0
ZG93bl90eXBlKQogewogCXZvaWQgKCpzaHV0ZG93bikodm9pZCk7CkBAIC0yMjcsMTEgKzIyMiw2
IEBAIHZvaWQgdGJvb3Rfc2h1dGRvd24odTMyIHNodXRkb3duX3R5cGUpCiAJICovCiAJaWYgKCF0
Ym9vdF9wZ19kaXIpCiAJCXJldHVybjsKLQotCS8qIGlmIHRoaXMgaXMgUzMgdGhlbiBzZXQgcmVn
aW9ucyB0byBNQUMgKi8KLQlpZiAoc2h1dGRvd25fdHlwZSA9PSBUQl9TSFVURE9XTl9TMykKLQkJ
aWYgKHRib290X3NldHVwX3NsZWVwKCkpCi0JCQlyZXR1cm47CiAKIAl0Ym9vdC0+c2h1dGRvd25f
dHlwZSA9IHNodXRkb3duX3R5cGU7CiAK

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817shsmsx501ccrcor_--
