Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZBBKMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZBBKMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZBBKLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:11:51 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:14042 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZBBKLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:11:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BZi/3478oVVuik6dTz8n0XNv0c/IDoRYp0ft2oRGWvjVZosLQJpNyOITmKLygAsVg3
         oQRi5NorkF1YqO+VkZ4/pH9Uks7EC+FKe5QE+VPwyODRlQQNdBNLmlKHeEac+svJk7Ci
         2ULfPi2rZWtU6XFYsOsaYXZuY5wMTL/EK4CVA=
MIME-Version: 1.0
In-Reply-To: <20090131155147.GU12431@fluff.org.uk>
References: <498464ED.3010607@gmail.com> <20090131155147.GU12431@fluff.org.uk>
Date: Mon, 2 Feb 2009 18:11:48 +0800
Message-ID: <f17812d70902020211u63d7e510k81926f45ff672323@mail.gmail.com>
Subject: Re: [PATCH 2/2 RESEND] platform: introduce module id table for 
	platform devices
From: Eric Miao <eric.y.miao@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: multipart/mixed; boundary=000e0cd2bd5256177b0461ecc84d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2bd5256177b0461ecc84d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>
> surely you mean PLATFORM_NAME_SIZE in this struct?

Indeed, patch updated below (and as attached):

>From 644208887dbdb51a3394588be69c88867be5c98e Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Tue, 30 Dec 2008 14:20:59 +0800
Subject: [PATCH] platform: introduce module id table for platform devices

Now platform_device is being widely used on SoC processors where the
peripherals are attached to the system bus, which is simple enough.

However, silicon IPs for these SoCs are usually shared heavily across
a family of processors, even products from different companies.  This
makes the original simple driver name based matching insufficient, or
simply not straight-forward.

Introduce a module id table for platform devices, and makes it clear
that a platform driver is able to support some shared IP and handle
slight differences across different platforms (by 'driver_data').
Module alias is handled automatically when a MODULE_DEVICE_TABLE()
is defined.

To not disturb the current platform drivers too much, the matched id
entry is recorded and can be retrieved by platform_get_device_id().

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/base/platform.c         |   21 ++++++++++++++++++++-
 include/linux/mod_devicetable.h |    9 +++++++++
 include/linux/platform_device.h |    6 ++++++
 scripts/mod/file2alias.c        |   12 ++++++++++++
 4 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index d0591f0..45bdc37 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -587,7 +587,8 @@ static int platform_uevent(struct device *dev,
struct kobj_uevent_env *env)
 {
 	struct platform_device	*pdev = to_platform_device(dev);

-	add_uevent_var(env, "MODALIAS=platform:%s", pdev->name);
+	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
+		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
 	return 0;
 }

@@ -604,10 +605,28 @@ static int platform_uevent(struct device *dev,
struct kobj_uevent_env *env)
  * and compare it against the name of the driver. Return whether they match
  * or not.
  */
+static const struct platform_device_id *platform_match_id(
+			const struct platform_device_id *id,
+			struct platform_device *pdev)
+{
+	while (id->name[0]) {
+		if (strcmp(pdev->name, id->name) == 0)
+			return (pdev->id_entry = id);
+		id++;
+	}
+	return NULL;
+}
+
 static int platform_match(struct device *dev, struct device_driver *drv)
 {
 	struct platform_device *pdev = to_platform_device(dev);
+	struct platform_driver *pdrv = to_platform_driver(drv);
+
+	/* match against the id table first */
+	if (pdrv->id_table)
+		return platform_match_id(pdrv->id_table, pdev) != NULL;

+	/* fall-back to driver name match */
 	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
 }

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 97b91d1..05542d3 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -447,4 +447,13 @@ struct dmi_system_id {

 #define DMI_MATCH(a, b)	{ a, b }

+#define PLATFORM_NAME_SIZE	20
+#define PLATFORM_MODULE_PREFIX	"platform:"
+
+struct platform_device_id {
+	char name[PLATFORM_NAME_SIZE];
+	kernel_ulong_t driver_data
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 4b8cc6a..7edc570 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -12,6 +12,7 @@
 #define _PLATFORM_DEVICE_H_

 #include <linux/device.h>
+#include <linux/mod_devicetable.h>

 struct platform_device {
 	const char	* name;
@@ -19,8 +20,12 @@ struct platform_device {
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
+
+	struct platform_device_id	*id_entry;
 };

+#define platform_get_device_id(pdev)	((pdev)->id_entry)
+
 #define to_platform_device(x) container_of((x), struct platform_device, dev)

 extern int platform_device_register(struct platform_device *);
@@ -57,6 +62,7 @@ struct platform_driver {
 	int (*resume)(struct platform_device *);
 	struct pm_ext_ops *pm;
 	struct device_driver driver;
+	struct platform_device_id *id_table;
 };

 extern int platform_driver_register(struct platform_driver *);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d4dc222..f71f5e6 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -696,6 +696,14 @@ static int do_dmi_entry(const char *filename,
struct dmi_system_id *id,
 	strcat(alias, ":");
 	return 1;
 }
+
+static int do_platform_entry(const char *filename,
+			     struct platform_device_id *id, char *alias)
+{
+	sprintf(alias, PLATFORM_MODULE_PREFIX "%s", id->name);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -835,6 +843,10 @@ void handle_moddevtable(struct module *mod,
struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct dmi_system_id), "dmi",
 			 do_dmi_entry, mod);
+	else if (sym_is(symname, "__mod_platform_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct platform_device_id), "platform",
+			 do_platform_entry, mod);
 	free(zeros);
 }

-- 
1.6.0.4

--000e0cd2bd5256177b0461ecc84d
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0002-platform-introduce-module-id-table-for-platform-dev.patch"
Content-Disposition: attachment; 
	filename="0002-platform-introduce-module-id-table-for-platform-dev.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fqozed2q0

RnJvbSA2NDQyMDg4ODdkYmRiNTFhMzM5NDU4OGJlNjljODg4NjdiZTVjOThlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogVHVlLCAzMCBEZWMgMjAwOCAxNDoyMDo1OSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHBsYXRm
b3JtOiBpbnRyb2R1Y2UgbW9kdWxlIGlkIHRhYmxlIGZvciBwbGF0Zm9ybSBkZXZpY2VzCgpOb3cg
cGxhdGZvcm1fZGV2aWNlIGlzIGJlaW5nIHdpZGVseSB1c2VkIG9uIFNvQyBwcm9jZXNzb3JzIHdo
ZXJlIHRoZQpwZXJpcGhlcmFscyBhcmUgYXR0YWNoZWQgdG8gdGhlIHN5c3RlbSBidXMsIHdoaWNo
IGlzIHNpbXBsZSBlbm91Z2guCgpIb3dldmVyLCBzaWxpY29uIElQcyBmb3IgdGhlc2UgU29DcyBh
cmUgdXN1YWxseSBzaGFyZWQgaGVhdmlseSBhY3Jvc3MKYSBmYW1pbHkgb2YgcHJvY2Vzc29ycywg
ZXZlbiBwcm9kdWN0cyBmcm9tIGRpZmZlcmVudCBjb21wYW5pZXMuICBUaGlzCm1ha2VzIHRoZSBv
cmlnaW5hbCBzaW1wbGUgZHJpdmVyIG5hbWUgYmFzZWQgbWF0Y2hpbmcgaW5zdWZmaWNpZW50LCBv
cgpzaW1wbHkgbm90IHN0cmFpZ2h0LWZvcndhcmQuCgpJbnRyb2R1Y2UgYSBtb2R1bGUgaWQgdGFi
bGUgZm9yIHBsYXRmb3JtIGRldmljZXMsIGFuZCBtYWtlcyBpdCBjbGVhcgp0aGF0IGEgcGxhdGZv
cm0gZHJpdmVyIGlzIGFibGUgdG8gc3VwcG9ydCBzb21lIHNoYXJlZCBJUCBhbmQgaGFuZGxlCnNs
aWdodCBkaWZmZXJlbmNlcyBhY3Jvc3MgZGlmZmVyZW50IHBsYXRmb3JtcyAoYnkgJ2RyaXZlcl9k
YXRhJykuCk1vZHVsZSBhbGlhcyBpcyBoYW5kbGVkIGF1dG9tYXRpY2FsbHkgd2hlbiBhIE1PRFVM
RV9ERVZJQ0VfVEFCTEUoKQppcyBkZWZpbmVkLgoKVG8gbm90IGRpc3R1cmIgdGhlIGN1cnJlbnQg
cGxhdGZvcm0gZHJpdmVycyB0b28gbXVjaCwgdGhlIG1hdGNoZWQgaWQKZW50cnkgaXMgcmVjb3Jk
ZWQgYW5kIGNhbiBiZSByZXRyaWV2ZWQgYnkgcGxhdGZvcm1fZ2V0X2RldmljZV9pZCgpLgoKU2ln
bmVkLW9mZi1ieTogRXJpYyBNaWFvIDxlcmljLm1pYW9AbWFydmVsbC5jb20+Ci0tLQogZHJpdmVy
cy9iYXNlL3BsYXRmb3JtLmMgICAgICAgICB8ICAgMjEgKysrKysrKysrKysrKysrKysrKystCiBp
bmNsdWRlL2xpbnV4L21vZF9kZXZpY2V0YWJsZS5oIHwgICAgOSArKysrKysrKysKIGluY2x1ZGUv
bGludXgvcGxhdGZvcm1fZGV2aWNlLmggfCAgICA2ICsrKysrKwogc2NyaXB0cy9tb2QvZmlsZTJh
bGlhcy5jICAgICAgICB8ICAgMTIgKysrKysrKysrKysrCiA0IGZpbGVzIGNoYW5nZWQsIDQ3IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9iYXNlL3Bs
YXRmb3JtLmMgYi9kcml2ZXJzL2Jhc2UvcGxhdGZvcm0uYwppbmRleCBkMDU5MWYwLi40NWJkYzM3
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jhc2UvcGxhdGZvcm0uYworKysgYi9kcml2ZXJzL2Jhc2Uv
cGxhdGZvcm0uYwpAQCAtNTg3LDcgKzU4Nyw4IEBAIHN0YXRpYyBpbnQgcGxhdGZvcm1fdWV2ZW50
KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGtvYmpfdWV2ZW50X2VudiAqZW52KQogewogCXN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UJKnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2UoZGV2KTsKIAot
CWFkZF91ZXZlbnRfdmFyKGVudiwgIk1PREFMSUFTPXBsYXRmb3JtOiVzIiwgcGRldi0+bmFtZSk7
CisJYWRkX3VldmVudF92YXIoZW52LCAiTU9EQUxJQVM9JXMlcyIsIFBMQVRGT1JNX01PRFVMRV9Q
UkVGSVgsCisJCShwZGV2LT5pZF9lbnRyeSkgPyBwZGV2LT5pZF9lbnRyeS0+bmFtZSA6IHBkZXYt
Pm5hbWUpOwogCXJldHVybiAwOwogfQogCkBAIC02MDQsMTAgKzYwNSwyOCBAQCBzdGF0aWMgaW50
IHBsYXRmb3JtX3VldmVudChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBrb2JqX3VldmVudF9l
bnYgKmVudikKICAqIGFuZCBjb21wYXJlIGl0IGFnYWluc3QgdGhlIG5hbWUgb2YgdGhlIGRyaXZl
ci4gUmV0dXJuIHdoZXRoZXIgdGhleSBtYXRjaAogICogb3Igbm90LgogICovCitzdGF0aWMgY29u
c3Qgc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZCAqcGxhdGZvcm1fbWF0Y2hfaWQoCisJCQljb25z
dCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlX2lkICppZCwKKwkJCXN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpCit7CisJd2hpbGUgKGlkLT5uYW1lWzBdKSB7CisJCWlmIChzdHJjbXAocGRldi0+
bmFtZSwgaWQtPm5hbWUpID09IDApCisJCQlyZXR1cm4gKHBkZXYtPmlkX2VudHJ5ID0gaWQpOwor
CQlpZCsrOworCX0KKwlyZXR1cm4gTlVMTDsKK30KKwogc3RhdGljIGludCBwbGF0Zm9ybV9tYXRj
aChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkcnYpCiB7CiAJc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiA9IHRvX3BsYXRmb3JtX2RldmljZShkZXYpOworCXN0
cnVjdCBwbGF0Zm9ybV9kcml2ZXIgKnBkcnYgPSB0b19wbGF0Zm9ybV9kcml2ZXIoZHJ2KTsKKwor
CS8qIG1hdGNoIGFnYWluc3QgdGhlIGlkIHRhYmxlIGZpcnN0ICovCisJaWYgKHBkcnYtPmlkX3Rh
YmxlKQorCQlyZXR1cm4gcGxhdGZvcm1fbWF0Y2hfaWQocGRydi0+aWRfdGFibGUsIHBkZXYpICE9
IE5VTEw7CiAKKwkvKiBmYWxsLWJhY2sgdG8gZHJpdmVyIG5hbWUgbWF0Y2ggKi8KIAlyZXR1cm4g
KHN0cm5jbXAocGRldi0+bmFtZSwgZHJ2LT5uYW1lLCBCVVNfSURfU0laRSkgPT0gMCk7CiB9CiAK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW9kX2RldmljZXRhYmxlLmggYi9pbmNsdWRlL2xp
bnV4L21vZF9kZXZpY2V0YWJsZS5oCmluZGV4IDk3YjkxZDEuLjA1NTQyZDMgMTAwNjQ0Ci0tLSBh
L2luY2x1ZGUvbGludXgvbW9kX2RldmljZXRhYmxlLmgKKysrIGIvaW5jbHVkZS9saW51eC9tb2Rf
ZGV2aWNldGFibGUuaApAQCAtNDQ3LDQgKzQ0NywxMyBAQCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCB7
CiAKICNkZWZpbmUgRE1JX01BVENIKGEsIGIpCXsgYSwgYiB9CiAKKyNkZWZpbmUgUExBVEZPUk1f
TkFNRV9TSVpFCTIwCisjZGVmaW5lIFBMQVRGT1JNX01PRFVMRV9QUkVGSVgJInBsYXRmb3JtOiIK
Kworc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZCB7CisJY2hhciBuYW1lW1BMQVRGT1JNX05BTUVf
U0laRV07CisJa2VybmVsX3Vsb25nX3QgZHJpdmVyX2RhdGEKKwkJCV9fYXR0cmlidXRlX18oKGFs
aWduZWQoc2l6ZW9mKGtlcm5lbF91bG9uZ190KSkpKTsKK307CisKICNlbmRpZiAvKiBMSU5VWF9N
T0RfREVWSUNFVEFCTEVfSCAqLwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wbGF0Zm9ybV9k
ZXZpY2UuaCBiL2luY2x1ZGUvbGludXgvcGxhdGZvcm1fZGV2aWNlLmgKaW5kZXggNGI4Y2M2YS4u
N2VkYzU3MCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9wbGF0Zm9ybV9kZXZpY2UuaAorKysg
Yi9pbmNsdWRlL2xpbnV4L3BsYXRmb3JtX2RldmljZS5oCkBAIC0xMiw2ICsxMiw3IEBACiAjZGVm
aW5lIF9QTEFURk9STV9ERVZJQ0VfSF8KIAogI2luY2x1ZGUgPGxpbnV4L2RldmljZS5oPgorI2lu
Y2x1ZGUgPGxpbnV4L21vZF9kZXZpY2V0YWJsZS5oPgogCiBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
IHsKIAljb25zdCBjaGFyCSogbmFtZTsKQEAgLTE5LDggKzIwLDEyIEBAIHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgewogCXN0cnVjdCBkZXZpY2UJZGV2OwogCXUzMgkJbnVtX3Jlc291cmNlczsKIAlz
dHJ1Y3QgcmVzb3VyY2UJKiByZXNvdXJjZTsKKworCXN0cnVjdCBwbGF0Zm9ybV9kZXZpY2VfaWQJ
KmlkX2VudHJ5OwogfTsKIAorI2RlZmluZSBwbGF0Zm9ybV9nZXRfZGV2aWNlX2lkKHBkZXYpCSgo
cGRldiktPmlkX2VudHJ5KQorCiAjZGVmaW5lIHRvX3BsYXRmb3JtX2RldmljZSh4KSBjb250YWlu
ZXJfb2YoKHgpLCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlLCBkZXYpCiAKIGV4dGVybiBpbnQgcGxh
dGZvcm1fZGV2aWNlX3JlZ2lzdGVyKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKik7CkBAIC01Nyw2
ICs2Miw3IEBAIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgewogCWludCAoKnJlc3VtZSkoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqKTsKIAlzdHJ1Y3QgcG1fZXh0X29wcyAqcG07CiAJc3RydWN0IGRl
dmljZV9kcml2ZXIgZHJpdmVyOworCXN0cnVjdCBwbGF0Zm9ybV9kZXZpY2VfaWQgKmlkX3RhYmxl
OwogfTsKIAogZXh0ZXJuIGludCBwbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXIoc3RydWN0IHBsYXRm
b3JtX2RyaXZlciAqKTsKZGlmZiAtLWdpdCBhL3NjcmlwdHMvbW9kL2ZpbGUyYWxpYXMuYyBiL3Nj
cmlwdHMvbW9kL2ZpbGUyYWxpYXMuYwppbmRleCBkNGRjMjIyLi5mNzFmNWU2IDEwMDY0NAotLS0g
YS9zY3JpcHRzL21vZC9maWxlMmFsaWFzLmMKKysrIGIvc2NyaXB0cy9tb2QvZmlsZTJhbGlhcy5j
CkBAIC02OTYsNiArNjk2LDE0IEBAIHN0YXRpYyBpbnQgZG9fZG1pX2VudHJ5KGNvbnN0IGNoYXIg
KmZpbGVuYW1lLCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCAqaWQsCiAJc3RyY2F0KGFsaWFzLCAiOiIp
OwogCXJldHVybiAxOwogfQorCitzdGF0aWMgaW50IGRvX3BsYXRmb3JtX2VudHJ5KGNvbnN0IGNo
YXIgKmZpbGVuYW1lLAorCQkJICAgICBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlX2lkICppZCwgY2hh
ciAqYWxpYXMpCit7CisJc3ByaW50ZihhbGlhcywgUExBVEZPUk1fTU9EVUxFX1BSRUZJWCAiJXMi
LCBpZC0+bmFtZSk7CisJcmV0dXJuIDE7Cit9CisKIC8qIElnbm9yZSBhbnkgcHJlZml4LCBlZy4g
c29tZSBhcmNoaXRlY3R1cmVzIHByZXBlbmQgXyAqLwogc3RhdGljIGlubGluZSBpbnQgc3ltX2lz
KGNvbnN0IGNoYXIgKnN5bWJvbCwgY29uc3QgY2hhciAqbmFtZSkKIHsKQEAgLTgzNSw2ICs4NDMs
MTAgQEAgdm9pZCBoYW5kbGVfbW9kZGV2dGFibGUoc3RydWN0IG1vZHVsZSAqbW9kLCBzdHJ1Y3Qg
ZWxmX2luZm8gKmluZm8sCiAJCWRvX3RhYmxlKHN5bXZhbCwgc3ltLT5zdF9zaXplLAogCQkJIHNp
emVvZihzdHJ1Y3QgZG1pX3N5c3RlbV9pZCksICJkbWkiLAogCQkJIGRvX2RtaV9lbnRyeSwgbW9k
KTsKKwllbHNlIGlmIChzeW1faXMoc3ltbmFtZSwgIl9fbW9kX3BsYXRmb3JtX2RldmljZV90YWJs
ZSIpKQorCQlkb190YWJsZShzeW12YWwsIHN5bS0+c3Rfc2l6ZSwKKwkJCSBzaXplb2Yoc3RydWN0
IHBsYXRmb3JtX2RldmljZV9pZCksICJwbGF0Zm9ybSIsCisJCQkgZG9fcGxhdGZvcm1fZW50cnks
IG1vZCk7CiAJZnJlZSh6ZXJvcyk7CiB9CiAKLS0gCjEuNi4wLjQKCg==
--000e0cd2bd5256177b0461ecc84d--
