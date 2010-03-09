Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0CIIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:52:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:54110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0CIIwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:52:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,607,1262592000"; 
   d="scan'208";a="602621050"
From: "Wang, Shane" <shane.wang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "andi@firstfloor.org" <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Date: Tue, 9 Mar 2010 16:52:04 +0800
Subject: [PATCH v2] intel_txt: add support for S3 memory integrity
 protection within Intel(R) TXT launched kernel
Thread-Topic: [PATCH v2] intel_txt: add support for S3 memory integrity
 protection within Intel(R) TXT launched kernel
Thread-Index: AcpFJKulI4VaMumtT6yJkLui35CqzARsdbpwGiNv9mA=
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FA@shsmsx501.ccr.corp.intel.com>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com>
 <20091004185801.GC1378@ucw.cz> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FAshsmsx501ccrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FAshsmsx501ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

v2: Based on a complexity analysis and tradeoff, we moved all MAC'ing into =
tboot.

This patch adds support for S3 memory integrity protection within an Intel(=
R) TXT launched kernel, for all kernel and userspace memory.  All RAM used =
by the kernel and userspace, as indicated by memory ranges of type E820_RAM=
 and E820_RESERVED_KERN in the e820 table, will be integrity protected.

The MAINTAINERS file is also updated to reflect the maintainers of the TXT-=
related code.

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

 Documentation/intel_txt.txt |   14 +++++++-------
 MAINTAINERS                 |   11 +++++++++++
 arch/x86/include/asm/e820.h |    7 ++++++-
 arch/x86/kernel/tboot.c     |   17 ++++++++---------
 4 files changed, 32 insertions(+), 17 deletions(-)

diff -r d2911aa1461d Documentation/intel_txt.txt
--- a/Documentation/intel_txt.txt	Thu Mar 04 09:37:53 2010 -0500
+++ b/Documentation/intel_txt.txt	Tue Mar 09 10:40:17 2010 -0500
@@ -161,13 +161,13 @@ o  In order to put a system into any of=20
       has been restored, it will restore the TPM PCRs and then
       transfer control back to the kernel's S3 resume vector.
       In order to preserve system integrity across S3, the kernel
-      provides tboot with a set of memory ranges (kernel
-      code/data/bss, S3 resume code, and AP trampoline) that tboot
-      will calculate a MAC (message authentication code) over and then
-      seal with the TPM.  On resume and once the measured environment
-      has been re-established, tboot will re-calculate the MAC and
-      verify it against the sealed value.  Tboot's policy determines
-      what happens if the verification fails.
+      provides tboot with a set of memory ranges (RAM and RESERVED_KERN
+      in the e820 table, but not any memory that BIOS might alter over
+      the S3 transition) that tboot will calculate a MAC (message
+      authentication code) over and then seal with the TPM. On resume
+      and once the measured environment has been re-established, tboot
+      will re-calculate the MAC and verify it against the sealed value.
+      Tboot's policy determines what happens if the verification fails.
=20
 That's pretty much it for TXT support.
=20
diff -r d2911aa1461d MAINTAINERS
--- a/MAINTAINERS	Thu Mar 04 09:37:53 2010 -0500
+++ b/MAINTAINERS	Tue Mar 09 10:40:17 2010 -0500
@@ -2891,6 +2891,17 @@ F:	Documentation/networking/README.ipw22
 F:	Documentation/networking/README.ipw2200
 F:	drivers/net/wireless/ipw2x00/ipw2200.*
=20
+INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
+M:	Joseph Cihula <joseph.cihula@intel.com>
+M:	Shane Wang <shane.wang@intel.com>
+L:	tboot-devel@lists.sourceforge.net
+W:	http://tboot.sourceforge.net
+T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg
+S:	Supported
+F:	Documentation/intel_txt.txt
+F:	include/linux/tboot.h
+F:	arch/x86/kernel/tboot.c
+
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
diff -r d2911aa1461d arch/x86/include/asm/e820.h
--- a/arch/x86/include/asm/e820.h	Thu Mar 04 09:37:53 2010 -0500
+++ b/arch/x86/include/asm/e820.h	Tue Mar 09 10:40:17 2010 -0500
@@ -45,7 +45,12 @@
 #define E820_NVS	4
 #define E820_UNUSABLE	5
=20
-/* reserved RAM used by kernel itself */
+/*
+ * reserved RAM used by kernel itself
+ * if CONFIG_INTEL_TXT is enabled, memory of this type will be
+ * included in the S3 integrity calculation and so should not include
+ * any memory that BIOS might alter over the S3 transition
+ */
 #define E820_RESERVED_KERN        128
=20
 #ifndef __ASSEMBLY__
diff -r d2911aa1461d arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Thu Mar 04 09:37:53 2010 -0500
+++ b/arch/x86/kernel/tboot.c	Tue Mar 09 10:40:17 2010 -0500
@@ -139,18 +139,17 @@ static void add_mac_region(phys_addr_t s
=20
 static void __init tboot_setup_sleep(void)
 {
+	int i;
+
 	tboot->num_mac_regions =3D 0;
=20
-	/* S3 resume code */
-	add_mac_region(acpi_wakeup_address, WAKEUP_SIZE);
+	for (i =3D 0; i < e820.nr_map; i++) {
+		if ((e820.map[i].type !=3D E820_RAM)
+		 && (e820.map[i].type !=3D E820_RESERVED_KERN))
+			continue;
=20
-#ifdef CONFIG_X86_TRAMPOLINE
-	/* AP trampoline code */
-	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
-#endif
-
-	/* kernel code + data + bss */
-	add_mac_region(virt_to_phys(_text), _end - _text);
+		add_mac_region(e820.map[i].addr, e820.map[i].size);
+	}
=20
 	tboot->acpi_sinfo.kernel_s3_resume_vector =3D acpi_wakeup_address;
 }=

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FAshsmsx501ccrcor_
Content-Type: application/octet-stream; name="s3_memory_integrity.patch"
Content-Description: s3_memory_integrity.patch
Content-Disposition: attachment; filename="s3_memory_integrity.patch";
	size=4253; creation-date="Tue, 09 Mar 2010 08:33:00 GMT";
	modification-date="Tue, 09 Mar 2010 08:33:00 GMT"
Content-Transfer-Encoding: base64

djI6IEJhc2VkIG9uIGEgY29tcGxleGl0eSBhbmFseXNpcyBhbmQgdHJhZGVvZmYsIHdlIG1vdmVk
IGFsbCBNQUMnaW5nIGludG8gdGJvb3QuCgpUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBmb3IgUzMg
bWVtb3J5IGludGVncml0eSBwcm90ZWN0aW9uIHdpdGhpbiBhbiBJbnRlbChSKSBUWFQgbGF1bmNo
ZWQga2VybmVsLCBmb3IgYWxsIGtlcm5lbCBhbmQgdXNlcnNwYWNlIG1lbW9yeS4gIEFsbCBSQU0g
dXNlZCBieSB0aGUga2VybmVsIGFuZCB1c2Vyc3BhY2UsIGFzIGluZGljYXRlZCBieSBtZW1vcnkg
cmFuZ2VzIG9mIHR5cGUgRTgyMF9SQU0gYW5kIEU4MjBfUkVTRVJWRURfS0VSTiBpbiB0aGUgZTgy
MCB0YWJsZSwgd2lsbCBiZSBpbnRlZ3JpdHkgcHJvdGVjdGVkLgoKVGhlIE1BSU5UQUlORVJTIGZp
bGUgaXMgYWxzbyB1cGRhdGVkIHRvIHJlZmxlY3QgdGhlIG1haW50YWluZXJzIG9mIHRoZSBUWFQt
cmVsYXRlZCBjb2RlLgoKU2lnbmVkLW9mZi1ieTogU2hhbmUgV2FuZyA8c2hhbmUud2FuZ0BpbnRl
bC5jb20+ClNpZ25lZC1vZmYtYnk6IEpvc2VwaCBDaWh1bGEgPGpvc2VwaC5jaWh1bGFAaW50ZWwu
Y29tPgoKZGlmZiAtciBkMjkxMWFhMTQ2MWQgRG9jdW1lbnRhdGlvbi9pbnRlbF90eHQudHh0Ci0t
LSBhL0RvY3VtZW50YXRpb24vaW50ZWxfdHh0LnR4dAlUaHUgTWFyIDA0IDA5OjM3OjUzIDIwMTAg
LTA1MDAKKysrIGIvRG9jdW1lbnRhdGlvbi9pbnRlbF90eHQudHh0CVR1ZSBNYXIgMDkgMTA6NDA6
MTcgMjAxMCAtMDUwMApAQCAtMTYxLDEzICsxNjEsMTMgQEAgbyAgSW4gb3JkZXIgdG8gcHV0IGEg
c3lzdGVtIGludG8gYW55IG9mIAogICAgICAgaGFzIGJlZW4gcmVzdG9yZWQsIGl0IHdpbGwgcmVz
dG9yZSB0aGUgVFBNIFBDUnMgYW5kIHRoZW4KICAgICAgIHRyYW5zZmVyIGNvbnRyb2wgYmFjayB0
byB0aGUga2VybmVsJ3MgUzMgcmVzdW1lIHZlY3Rvci4KICAgICAgIEluIG9yZGVyIHRvIHByZXNl
cnZlIHN5c3RlbSBpbnRlZ3JpdHkgYWNyb3NzIFMzLCB0aGUga2VybmVsCi0gICAgICBwcm92aWRl
cyB0Ym9vdCB3aXRoIGEgc2V0IG9mIG1lbW9yeSByYW5nZXMgKGtlcm5lbAotICAgICAgY29kZS9k
YXRhL2JzcywgUzMgcmVzdW1lIGNvZGUsIGFuZCBBUCB0cmFtcG9saW5lKSB0aGF0IHRib290Ci0g
ICAgICB3aWxsIGNhbGN1bGF0ZSBhIE1BQyAobWVzc2FnZSBhdXRoZW50aWNhdGlvbiBjb2RlKSBv
dmVyIGFuZCB0aGVuCi0gICAgICBzZWFsIHdpdGggdGhlIFRQTS4gIE9uIHJlc3VtZSBhbmQgb25j
ZSB0aGUgbWVhc3VyZWQgZW52aXJvbm1lbnQKLSAgICAgIGhhcyBiZWVuIHJlLWVzdGFibGlzaGVk
LCB0Ym9vdCB3aWxsIHJlLWNhbGN1bGF0ZSB0aGUgTUFDIGFuZAotICAgICAgdmVyaWZ5IGl0IGFn
YWluc3QgdGhlIHNlYWxlZCB2YWx1ZS4gIFRib290J3MgcG9saWN5IGRldGVybWluZXMKLSAgICAg
IHdoYXQgaGFwcGVucyBpZiB0aGUgdmVyaWZpY2F0aW9uIGZhaWxzLgorICAgICAgcHJvdmlkZXMg
dGJvb3Qgd2l0aCBhIHNldCBvZiBtZW1vcnkgcmFuZ2VzIChSQU0gYW5kIFJFU0VSVkVEX0tFUk4K
KyAgICAgIGluIHRoZSBlODIwIHRhYmxlLCBidXQgbm90IGFueSBtZW1vcnkgdGhhdCBCSU9TIG1p
Z2h0IGFsdGVyIG92ZXIKKyAgICAgIHRoZSBTMyB0cmFuc2l0aW9uKSB0aGF0IHRib290IHdpbGwg
Y2FsY3VsYXRlIGEgTUFDIChtZXNzYWdlCisgICAgICBhdXRoZW50aWNhdGlvbiBjb2RlKSBvdmVy
IGFuZCB0aGVuIHNlYWwgd2l0aCB0aGUgVFBNLiBPbiByZXN1bWUKKyAgICAgIGFuZCBvbmNlIHRo
ZSBtZWFzdXJlZCBlbnZpcm9ubWVudCBoYXMgYmVlbiByZS1lc3RhYmxpc2hlZCwgdGJvb3QKKyAg
ICAgIHdpbGwgcmUtY2FsY3VsYXRlIHRoZSBNQUMgYW5kIHZlcmlmeSBpdCBhZ2FpbnN0IHRoZSBz
ZWFsZWQgdmFsdWUuCisgICAgICBUYm9vdCdzIHBvbGljeSBkZXRlcm1pbmVzIHdoYXQgaGFwcGVu
cyBpZiB0aGUgdmVyaWZpY2F0aW9uIGZhaWxzLgogCiBUaGF0J3MgcHJldHR5IG11Y2ggaXQgZm9y
IFRYVCBzdXBwb3J0LgogCmRpZmYgLXIgZDI5MTFhYTE0NjFkIE1BSU5UQUlORVJTCi0tLSBhL01B
SU5UQUlORVJTCVRodSBNYXIgMDQgMDk6Mzc6NTMgMjAxMCAtMDUwMAorKysgYi9NQUlOVEFJTkVS
UwlUdWUgTWFyIDA5IDEwOjQwOjE3IDIwMTAgLTA1MDAKQEAgLTI4OTEsNiArMjg5MSwxNyBAQCBG
OglEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvUkVBRE1FLmlwdzIyCiBGOglEb2N1bWVudGF0aW9u
L25ldHdvcmtpbmcvUkVBRE1FLmlwdzIyMDAKIEY6CWRyaXZlcnMvbmV0L3dpcmVsZXNzL2lwdzJ4
MDAvaXB3MjIwMC4qCiAKK0lOVEVMKFIpIFRSVVNURUQgRVhFQ1VUSU9OIFRFQ0hOT0xPR1kgKFRY
VCkKK006CUpvc2VwaCBDaWh1bGEgPGpvc2VwaC5jaWh1bGFAaW50ZWwuY29tPgorTToJU2hhbmUg
V2FuZyA8c2hhbmUud2FuZ0BpbnRlbC5jb20+CitMOgl0Ym9vdC1kZXZlbEBsaXN0cy5zb3VyY2Vm
b3JnZS5uZXQKK1c6CWh0dHA6Ly90Ym9vdC5zb3VyY2Vmb3JnZS5uZXQKK1Q6CU1lcmN1cmlhbCBo
dHRwOi8vd3d3LmJ1Z2hvc3Qub3JnL3JlcG9zLmhnL3Rib290LmhnCitTOglTdXBwb3J0ZWQKK0Y6
CURvY3VtZW50YXRpb24vaW50ZWxfdHh0LnR4dAorRjoJaW5jbHVkZS9saW51eC90Ym9vdC5oCitG
OglhcmNoL3g4Ni9rZXJuZWwvdGJvb3QuYworCiBJTlRFTCBXSVJFTEVTUyBXSU1BWCBDT05ORUNU
SU9OIDI0MDAKIE06CUluYWt5IFBlcmV6LUdvbnphbGV6IDxpbmFreS5wZXJlei1nb256YWxlekBp
bnRlbC5jb20+CiBNOglsaW51eC13aW1heEBpbnRlbC5jb20KZGlmZiAtciBkMjkxMWFhMTQ2MWQg
YXJjaC94ODYvaW5jbHVkZS9hc20vZTgyMC5oCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2U4
MjAuaAlUaHUgTWFyIDA0IDA5OjM3OjUzIDIwMTAgLTA1MDAKKysrIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20vZTgyMC5oCVR1ZSBNYXIgMDkgMTA6NDA6MTcgMjAxMCAtMDUwMApAQCAtNDUsNyArNDUs
MTIgQEAKICNkZWZpbmUgRTgyMF9OVlMJNAogI2RlZmluZSBFODIwX1VOVVNBQkxFCTUKIAotLyog
cmVzZXJ2ZWQgUkFNIHVzZWQgYnkga2VybmVsIGl0c2VsZiAqLworLyoKKyAqIHJlc2VydmVkIFJB
TSB1c2VkIGJ5IGtlcm5lbCBpdHNlbGYKKyAqIGlmIENPTkZJR19JTlRFTF9UWFQgaXMgZW5hYmxl
ZCwgbWVtb3J5IG9mIHRoaXMgdHlwZSB3aWxsIGJlCisgKiBpbmNsdWRlZCBpbiB0aGUgUzMgaW50
ZWdyaXR5IGNhbGN1bGF0aW9uIGFuZCBzbyBzaG91bGQgbm90IGluY2x1ZGUKKyAqIGFueSBtZW1v
cnkgdGhhdCBCSU9TIG1pZ2h0IGFsdGVyIG92ZXIgdGhlIFMzIHRyYW5zaXRpb24KKyAqLwogI2Rl
ZmluZSBFODIwX1JFU0VSVkVEX0tFUk4gICAgICAgIDEyOAogCiAjaWZuZGVmIF9fQVNTRU1CTFlf
XwpkaWZmIC1yIGQyOTExYWExNDYxZCBhcmNoL3g4Ni9rZXJuZWwvdGJvb3QuYwotLS0gYS9hcmNo
L3g4Ni9rZXJuZWwvdGJvb3QuYwlUaHUgTWFyIDA0IDA5OjM3OjUzIDIwMTAgLTA1MDAKKysrIGIv
YXJjaC94ODYva2VybmVsL3Rib290LmMJVHVlIE1hciAwOSAxMDo0MDoxNyAyMDEwIC0wNTAwCkBA
IC0xMzksMTggKzEzOSwxNyBAQCBzdGF0aWMgdm9pZCBhZGRfbWFjX3JlZ2lvbihwaHlzX2FkZHJf
dCBzCiAKIHN0YXRpYyB2b2lkIF9faW5pdCB0Ym9vdF9zZXR1cF9zbGVlcCh2b2lkKQogeworCWlu
dCBpOworCiAJdGJvb3QtPm51bV9tYWNfcmVnaW9ucyA9IDA7CiAKLQkvKiBTMyByZXN1bWUgY29k
ZSAqLwotCWFkZF9tYWNfcmVnaW9uKGFjcGlfd2FrZXVwX2FkZHJlc3MsIFdBS0VVUF9TSVpFKTsK
Kwlmb3IgKGkgPSAwOyBpIDwgZTgyMC5ucl9tYXA7IGkrKykgeworCQlpZiAoKGU4MjAubWFwW2ld
LnR5cGUgIT0gRTgyMF9SQU0pCisJCSAmJiAoZTgyMC5tYXBbaV0udHlwZSAhPSBFODIwX1JFU0VS
VkVEX0tFUk4pKQorCQkJY29udGludWU7CiAKLSNpZmRlZiBDT05GSUdfWDg2X1RSQU1QT0xJTkUK
LQkvKiBBUCB0cmFtcG9saW5lIGNvZGUgKi8KLQlhZGRfbWFjX3JlZ2lvbih2aXJ0X3RvX3BoeXMo
dHJhbXBvbGluZV9iYXNlKSwgVFJBTVBPTElORV9TSVpFKTsKLSNlbmRpZgotCi0JLyoga2VybmVs
IGNvZGUgKyBkYXRhICsgYnNzICovCi0JYWRkX21hY19yZWdpb24odmlydF90b19waHlzKF90ZXh0
KSwgX2VuZCAtIF90ZXh0KTsKKwkJYWRkX21hY19yZWdpb24oZTgyMC5tYXBbaV0uYWRkciwgZTgy
MC5tYXBbaV0uc2l6ZSk7CisJfQogCiAJdGJvb3QtPmFjcGlfc2luZm8ua2VybmVsX3MzX3Jlc3Vt
ZV92ZWN0b3IgPSBhY3BpX3dha2V1cF9hZGRyZXNzOwogfQo=

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FAshsmsx501ccrcor_--
