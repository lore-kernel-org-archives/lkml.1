Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0CDHmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 02:42:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:62877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab0CDHmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 02:42:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,580,1262592000"; 
   d="scan'208";a="497656657"
From: "Wang, Shane" <shane.wang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Date: Thu, 4 Mar 2010 15:41:56 +0800
Subject: [PATCH v2] intel_txt: fix section warning messages from tboot when
 "allyesconfig" is set on i386
Thread-Topic: [PATCH v2] intel_txt: fix section warning messages from tboot
 when "allyesconfig" is set on i386
Thread-Index: Acq7W9xKQsgxkN7ASTqYXVNyvjm+rAAERLWQ
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690F@shsmsx501.ccr.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817@shsmsx501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690Fshsmsx501ccrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690Fshsmsx501ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<Please use this one.=20
I put tboot_probe() below tboot_setup_sleep() in this patch
instead of put tboot_setup_sleep() above tboot_probe() in the previous patc=
h.
It looks like more reasonable.>

This patch is to fix the warning messages related to tboot when "allyesconf=
ig" is set on i386.

Signed-off-by: Shane Wang <shane.wang@intel.com>
ACKed by: Joseph Cihula <joseph.cihula@intel.com>

 arch/x86/kernel/tboot.c |  108 +++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 59 deletions(-)

diff -r d5d64753146c arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Mon Mar 01 09:47:50 2010 -0500
+++ b/arch/x86/kernel/tboot.c	Thu Mar 04 09:36:37 2010 -0500
@@ -54,51 +54,6 @@ struct tboot *tboot __read_mostly;
 #define pr_fmt(fmt)	"tboot: " fmt
=20
 static u8 tboot_uuid[16] __initdata =3D TBOOT_UUID;
-
-void __init tboot_probe(void)
-{
-	/* Look for valid page-aligned address for shared page. */
-	if (!boot_params.tboot_addr)
-		return;
-	/*
-	 * also verify that it is mapped as we expect it before calling
-	 * set_fixmap(), to reduce chance of garbage value causing crash
-	 */
-	if (!e820_any_mapped(boot_params.tboot_addr,
-			     boot_params.tboot_addr, E820_RESERVED)) {
-		pr_warning("non-0 tboot_addr but it is not of type E820_RESERVED\n");
-		return;
-	}
-
-	/* only a natively booted kernel should be using TXT */
-	if (paravirt_enabled()) {
-		pr_warning("non-0 tboot_addr but pv_ops is enabled\n");
-		return;
-	}
-
-	/* Map and check for tboot UUID. */
-	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
-	tboot =3D (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
-	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
-		pr_warning("tboot at 0x%llx is invalid\n",
-			   boot_params.tboot_addr);
-		tboot =3D NULL;
-		return;
-	}
-	if (tboot->version < 5) {
-		pr_warning("tboot version is invalid: %u\n", tboot->version);
-		tboot =3D NULL;
-		return;
-	}
-
-	pr_info("found shared page at phys addr 0x%llx:\n",
-		boot_params.tboot_addr);
-	pr_debug("version: %d\n", tboot->version);
-	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
-	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
-	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
-	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
-}
=20
 static pgd_t *tboot_pg_dir;
 static struct mm_struct tboot_mm =3D {
@@ -182,7 +137,7 @@ static void add_mac_region(phys_addr_t s
 	}
 }
=20
-static int tboot_setup_sleep(void)
+static void __init tboot_setup_sleep(void)
 {
 	tboot->num_mac_regions =3D 0;
=20
@@ -198,20 +153,60 @@ static int tboot_setup_sleep(void)
 	add_mac_region(virt_to_phys(_text), _end - _text);
=20
 	tboot->acpi_sinfo.kernel_s3_resume_vector =3D acpi_wakeup_address;
-
-	return 0;
 }
=20
 #else /* no CONFIG_ACPI_SLEEP */
=20
-static int tboot_setup_sleep(void)
-{
-	/* S3 shutdown requested, but S3 not supported by the kernel... */
-	BUG();
-	return -1;
-}
+static void tboot_setup_sleep(void)     {}
=20
 #endif
+
+void __init tboot_probe(void)
+{
+	/* Look for valid page-aligned address for shared page. */
+	if (!boot_params.tboot_addr)
+		return;
+	/*
+	 * also verify that it is mapped as we expect it before calling
+	 * set_fixmap(), to reduce chance of garbage value causing crash
+	 */
+	if (!e820_any_mapped(boot_params.tboot_addr,
+			boot_params.tboot_addr, E820_RESERVED)) {
+		pr_warning("non-0 tboot_addr but it is not of type E820_RESERVED\n");
+		return;
+	}
+
+	/* only a natively booted kernel should be using TXT */
+	if (paravirt_enabled()) {
+		pr_warning("non-0 tboot_addr but pv_ops is enabled\n");
+		return;
+	}
+
+	/* Map and check for tboot UUID. */
+	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
+	tboot =3D (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
+	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
+		pr_warning("tboot at 0x%llx is invalid\n",
+			boot_params.tboot_addr);
+		tboot =3D NULL;
+		return;
+	}
+	if (tboot->version < 5) {
+		pr_warning("tboot version is invalid: %u\n", tboot->version);
+		tboot =3D NULL;
+		return;
+	}
+
+	pr_info("found shared page at phys addr 0x%llx:\n",
+		boot_params.tboot_addr);
+	pr_debug("version: %d\n", tboot->version);
+	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
+	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
+	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
+	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
+
+	tboot_setup_sleep();
+}
=20
 void tboot_shutdown(u32 shutdown_type)
 {
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
=20
Wang, Shane wrote:
> This patch is to fix the warning messages related to tboot when
> "allyesconfig" is set on i386.=20
>=20
> Signed-off-by: Shane Wang <shane.wang@intel.com>=

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690Fshsmsx501ccrcor_
Content-Type: application/octet-stream; name="fix_warning.patch"
Content-Description: fix_warning.patch
Content-Disposition: attachment; filename="fix_warning.patch"; size=4373;
	creation-date="Thu, 04 Mar 2010 07:31:00 GMT";
	modification-date="Thu, 04 Mar 2010 07:31:00 GMT"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBpcyB0byBmaXggdGhlIHdhcm5pbmcgbWVzc2FnZXMgcmVsYXRlZCB0byB0Ym9v
dCB3aGVuICJhbGx5ZXNjb25maWciIGlzIHNldCBvbiBpMzg2LgoKU2lnbmVkLW9mZi1ieTogU2hh
bmUgV2FuZyA8c2hhbmUud2FuZ0BpbnRlbC5jb20+CkFDS2VkIGJ5OiBKb3NlcGggQ2lodWxhIDxq
b3NlcGguY2lodWxhQGludGVsLmNvbT4KCmRpZmYgLXIgZDVkNjQ3NTMxNDZjIGFyY2gveDg2L2tl
cm5lbC90Ym9vdC5jCi0tLSBhL2FyY2gveDg2L2tlcm5lbC90Ym9vdC5jCU1vbiBNYXIgMDEgMDk6
NDc6NTAgMjAxMCAtMDUwMAorKysgYi9hcmNoL3g4Ni9rZXJuZWwvdGJvb3QuYwlUaHUgTWFyIDA0
IDA5OjM2OjM3IDIwMTAgLTA1MDAKQEAgLTU0LDUxICs1NCw2IEBAIHN0cnVjdCB0Ym9vdCAqdGJv
b3QgX19yZWFkX21vc3RseTsKICNkZWZpbmUgcHJfZm10KGZtdCkJInRib290OiAiIGZtdAogCiBz
dGF0aWMgdTggdGJvb3RfdXVpZFsxNl0gX19pbml0ZGF0YSA9IFRCT09UX1VVSUQ7Ci0KLXZvaWQg
X19pbml0IHRib290X3Byb2JlKHZvaWQpCi17Ci0JLyogTG9vayBmb3IgdmFsaWQgcGFnZS1hbGln
bmVkIGFkZHJlc3MgZm9yIHNoYXJlZCBwYWdlLiAqLwotCWlmICghYm9vdF9wYXJhbXMudGJvb3Rf
YWRkcikKLQkJcmV0dXJuOwotCS8qCi0JICogYWxzbyB2ZXJpZnkgdGhhdCBpdCBpcyBtYXBwZWQg
YXMgd2UgZXhwZWN0IGl0IGJlZm9yZSBjYWxsaW5nCi0JICogc2V0X2ZpeG1hcCgpLCB0byByZWR1
Y2UgY2hhbmNlIG9mIGdhcmJhZ2UgdmFsdWUgY2F1c2luZyBjcmFzaAotCSAqLwotCWlmICghZTgy
MF9hbnlfbWFwcGVkKGJvb3RfcGFyYW1zLnRib290X2FkZHIsCi0JCQkgICAgIGJvb3RfcGFyYW1z
LnRib290X2FkZHIsIEU4MjBfUkVTRVJWRUQpKSB7Ci0JCXByX3dhcm5pbmcoIm5vbi0wIHRib290
X2FkZHIgYnV0IGl0IGlzIG5vdCBvZiB0eXBlIEU4MjBfUkVTRVJWRURcbiIpOwotCQlyZXR1cm47
Ci0JfQotCi0JLyogb25seSBhIG5hdGl2ZWx5IGJvb3RlZCBrZXJuZWwgc2hvdWxkIGJlIHVzaW5n
IFRYVCAqLwotCWlmIChwYXJhdmlydF9lbmFibGVkKCkpIHsKLQkJcHJfd2FybmluZygibm9uLTAg
dGJvb3RfYWRkciBidXQgcHZfb3BzIGlzIGVuYWJsZWRcbiIpOwotCQlyZXR1cm47Ci0JfQotCi0J
LyogTWFwIGFuZCBjaGVjayBmb3IgdGJvb3QgVVVJRC4gKi8KLQlzZXRfZml4bWFwKEZJWF9UQk9P
VF9CQVNFLCBib290X3BhcmFtcy50Ym9vdF9hZGRyKTsKLQl0Ym9vdCA9IChzdHJ1Y3QgdGJvb3Qg
KilmaXhfdG9fdmlydChGSVhfVEJPT1RfQkFTRSk7Ci0JaWYgKG1lbWNtcCgmdGJvb3RfdXVpZCwg
JnRib290LT51dWlkLCBzaXplb2YodGJvb3QtPnV1aWQpKSkgewotCQlwcl93YXJuaW5nKCJ0Ym9v
dCBhdCAweCVsbHggaXMgaW52YWxpZFxuIiwKLQkJCSAgIGJvb3RfcGFyYW1zLnRib290X2FkZHIp
OwotCQl0Ym9vdCA9IE5VTEw7Ci0JCXJldHVybjsKLQl9Ci0JaWYgKHRib290LT52ZXJzaW9uIDwg
NSkgewotCQlwcl93YXJuaW5nKCJ0Ym9vdCB2ZXJzaW9uIGlzIGludmFsaWQ6ICV1XG4iLCB0Ym9v
dC0+dmVyc2lvbik7Ci0JCXRib290ID0gTlVMTDsKLQkJcmV0dXJuOwotCX0KLQotCXByX2luZm8o
ImZvdW5kIHNoYXJlZCBwYWdlIGF0IHBoeXMgYWRkciAweCVsbHg6XG4iLAotCQlib290X3BhcmFt
cy50Ym9vdF9hZGRyKTsKLQlwcl9kZWJ1ZygidmVyc2lvbjogJWRcbiIsIHRib290LT52ZXJzaW9u
KTsKLQlwcl9kZWJ1ZygibG9nX2FkZHI6IDB4JTA4eFxuIiwgdGJvb3QtPmxvZ19hZGRyKTsKLQlw
cl9kZWJ1Zygic2h1dGRvd25fZW50cnk6IDB4JXhcbiIsIHRib290LT5zaHV0ZG93bl9lbnRyeSk7
Ci0JcHJfZGVidWcoInRib290X2Jhc2U6IDB4JTA4eFxuIiwgdGJvb3QtPnRib290X2Jhc2UpOwot
CXByX2RlYnVnKCJ0Ym9vdF9zaXplOiAweCV4XG4iLCB0Ym9vdC0+dGJvb3Rfc2l6ZSk7Ci19CiAK
IHN0YXRpYyBwZ2RfdCAqdGJvb3RfcGdfZGlyOwogc3RhdGljIHN0cnVjdCBtbV9zdHJ1Y3QgdGJv
b3RfbW0gPSB7CkBAIC0xODIsNyArMTM3LDcgQEAgc3RhdGljIHZvaWQgYWRkX21hY19yZWdpb24o
cGh5c19hZGRyX3QgcwogCX0KIH0KIAotc3RhdGljIGludCB0Ym9vdF9zZXR1cF9zbGVlcCh2b2lk
KQorc3RhdGljIHZvaWQgX19pbml0IHRib290X3NldHVwX3NsZWVwKHZvaWQpCiB7CiAJdGJvb3Qt
Pm51bV9tYWNfcmVnaW9ucyA9IDA7CiAKQEAgLTE5OCwyMCArMTUzLDYwIEBAIHN0YXRpYyBpbnQg
dGJvb3Rfc2V0dXBfc2xlZXAodm9pZCkKIAlhZGRfbWFjX3JlZ2lvbih2aXJ0X3RvX3BoeXMoX3Rl
eHQpLCBfZW5kIC0gX3RleHQpOwogCiAJdGJvb3QtPmFjcGlfc2luZm8ua2VybmVsX3MzX3Jlc3Vt
ZV92ZWN0b3IgPSBhY3BpX3dha2V1cF9hZGRyZXNzOwotCi0JcmV0dXJuIDA7CiB9CiAKICNlbHNl
IC8qIG5vIENPTkZJR19BQ1BJX1NMRUVQICovCiAKLXN0YXRpYyBpbnQgdGJvb3Rfc2V0dXBfc2xl
ZXAodm9pZCkKLXsKLQkvKiBTMyBzaHV0ZG93biByZXF1ZXN0ZWQsIGJ1dCBTMyBub3Qgc3VwcG9y
dGVkIGJ5IHRoZSBrZXJuZWwuLi4gKi8KLQlCVUcoKTsKLQlyZXR1cm4gLTE7Ci19CitzdGF0aWMg
dm9pZCB0Ym9vdF9zZXR1cF9zbGVlcCh2b2lkKSAgICAge30KIAogI2VuZGlmCisKK3ZvaWQgX19p
bml0IHRib290X3Byb2JlKHZvaWQpCit7CisJLyogTG9vayBmb3IgdmFsaWQgcGFnZS1hbGlnbmVk
IGFkZHJlc3MgZm9yIHNoYXJlZCBwYWdlLiAqLworCWlmICghYm9vdF9wYXJhbXMudGJvb3RfYWRk
cikKKwkJcmV0dXJuOworCS8qCisJICogYWxzbyB2ZXJpZnkgdGhhdCBpdCBpcyBtYXBwZWQgYXMg
d2UgZXhwZWN0IGl0IGJlZm9yZSBjYWxsaW5nCisJICogc2V0X2ZpeG1hcCgpLCB0byByZWR1Y2Ug
Y2hhbmNlIG9mIGdhcmJhZ2UgdmFsdWUgY2F1c2luZyBjcmFzaAorCSAqLworCWlmICghZTgyMF9h
bnlfbWFwcGVkKGJvb3RfcGFyYW1zLnRib290X2FkZHIsCisJCQlib290X3BhcmFtcy50Ym9vdF9h
ZGRyLCBFODIwX1JFU0VSVkVEKSkgeworCQlwcl93YXJuaW5nKCJub24tMCB0Ym9vdF9hZGRyIGJ1
dCBpdCBpcyBub3Qgb2YgdHlwZSBFODIwX1JFU0VSVkVEXG4iKTsKKwkJcmV0dXJuOworCX0KKwor
CS8qIG9ubHkgYSBuYXRpdmVseSBib290ZWQga2VybmVsIHNob3VsZCBiZSB1c2luZyBUWFQgKi8K
KwlpZiAocGFyYXZpcnRfZW5hYmxlZCgpKSB7CisJCXByX3dhcm5pbmcoIm5vbi0wIHRib290X2Fk
ZHIgYnV0IHB2X29wcyBpcyBlbmFibGVkXG4iKTsKKwkJcmV0dXJuOworCX0KKworCS8qIE1hcCBh
bmQgY2hlY2sgZm9yIHRib290IFVVSUQuICovCisJc2V0X2ZpeG1hcChGSVhfVEJPT1RfQkFTRSwg
Ym9vdF9wYXJhbXMudGJvb3RfYWRkcik7CisJdGJvb3QgPSAoc3RydWN0IHRib290ICopZml4X3Rv
X3ZpcnQoRklYX1RCT09UX0JBU0UpOworCWlmIChtZW1jbXAoJnRib290X3V1aWQsICZ0Ym9vdC0+
dXVpZCwgc2l6ZW9mKHRib290LT51dWlkKSkpIHsKKwkJcHJfd2FybmluZygidGJvb3QgYXQgMHgl
bGx4IGlzIGludmFsaWRcbiIsCisJCQlib290X3BhcmFtcy50Ym9vdF9hZGRyKTsKKwkJdGJvb3Qg
PSBOVUxMOworCQlyZXR1cm47CisJfQorCWlmICh0Ym9vdC0+dmVyc2lvbiA8IDUpIHsKKwkJcHJf
d2FybmluZygidGJvb3QgdmVyc2lvbiBpcyBpbnZhbGlkOiAldVxuIiwgdGJvb3QtPnZlcnNpb24p
OworCQl0Ym9vdCA9IE5VTEw7CisJCXJldHVybjsKKwl9CisKKwlwcl9pbmZvKCJmb3VuZCBzaGFy
ZWQgcGFnZSBhdCBwaHlzIGFkZHIgMHglbGx4OlxuIiwKKwkJYm9vdF9wYXJhbXMudGJvb3RfYWRk
cik7CisJcHJfZGVidWcoInZlcnNpb246ICVkXG4iLCB0Ym9vdC0+dmVyc2lvbik7CisJcHJfZGVi
dWcoImxvZ19hZGRyOiAweCUwOHhcbiIsIHRib290LT5sb2dfYWRkcik7CisJcHJfZGVidWcoInNo
dXRkb3duX2VudHJ5OiAweCV4XG4iLCB0Ym9vdC0+c2h1dGRvd25fZW50cnkpOworCXByX2RlYnVn
KCJ0Ym9vdF9iYXNlOiAweCUwOHhcbiIsIHRib290LT50Ym9vdF9iYXNlKTsKKwlwcl9kZWJ1Zygi
dGJvb3Rfc2l6ZTogMHgleFxuIiwgdGJvb3QtPnRib290X3NpemUpOworCisJdGJvb3Rfc2V0dXBf
c2xlZXAoKTsKK30KIAogdm9pZCB0Ym9vdF9zaHV0ZG93bih1MzIgc2h1dGRvd25fdHlwZSkKIHsK
QEAgLTIyNywxMSArMjIyLDYgQEAgdm9pZCB0Ym9vdF9zaHV0ZG93bih1MzIgc2h1dGRvd25fdHlw
ZSkKIAkgKi8KIAlpZiAoIXRib290X3BnX2RpcikKIAkJcmV0dXJuOwotCi0JLyogaWYgdGhpcyBp
cyBTMyB0aGVuIHNldCByZWdpb25zIHRvIE1BQyAqLwotCWlmIChzaHV0ZG93bl90eXBlID09IFRC
X1NIVVRET1dOX1MzKQotCQlpZiAodGJvb3Rfc2V0dXBfc2xlZXAoKSkKLQkJCXJldHVybjsKIAog
CXRib290LT5zaHV0ZG93bl90eXBlID0gc2h1dGRvd25fdHlwZTsKIAo=

--_002_D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690Fshsmsx501ccrcor_--
