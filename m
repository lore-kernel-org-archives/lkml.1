Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYL3HEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYL3HEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYL3HDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:03:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:1890 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYL3HDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:03:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=BCg6+pot/eMZQLc0adxfC7O9FGOjRDl0iKFs1nodW2sqOnIGn4genoJ+i9Dc01VIHe
         oh7r4e88XIKwlLRFa57YvGVqRCY+ZCs5A4dSJmzfeX6cs4KGdQJ91139CneYAx6SVYux
         sk9DNHbNKhINtHt7n9S6uKTsqlxP8subbvLeE=
Message-ID: <f17812d70812292303r16039849l469a75baa722cc40@mail.gmail.com>
Date: Tue, 30 Dec 2008 15:03:50 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] platform: introduce module id table for platform devices
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_126039_21498746.1230620630120"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_126039_21498746.1230620630120
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

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
index 97b91d1..5201491 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -447,4 +447,13 @@ struct dmi_system_id {

 #define DMI_MATCH(a, b)	{ a, b }

+#define PLATFORM_NAME_SIZE	20
+#define PLATFORM_MODULE_PREFIX	"platform:"
+
+struct platform_device_id {
+	char name[I2C_NAME_SIZE];
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

------=_Part_126039_21498746.1230620630120
Content-Type: text/x-diff;
 name=0002-platform-introduce-module-id-table-for-platform-dev.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpc7qbak0
Content-Disposition: attachment;
 filename=0002-platform-introduce-module-id-table-for-platform-dev.patch

RnJvbSAzMzQ3NDFiZjI3NjhhOThlN2JhYmRlNmMyNzk1MTUxYmZhMGQ1N2Y2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogVHVlLCAzMCBEZWMgMjAwOCAxNDoyMDo1OSArMDgwMApTdWJqZWN0OiBwbGF0Zm9ybTogaW50
cm9kdWNlIG1vZHVsZSBpZCB0YWJsZSBmb3IgcGxhdGZvcm0gZGV2aWNlcwoKTm93IHBsYXRmb3Jt
X2RldmljZSBpcyBiZWluZyB3aWRlbHkgdXNlZCBvbiBTb0MgcHJvY2Vzc29ycyB3aGVyZSB0aGUK
cGVyaXBoZXJhbHMgYXJlIGF0dGFjaGVkIHRvIHRoZSBzeXN0ZW0gYnVzLCB3aGljaCBpcyBzaW1w
bGUgZW5vdWdoLgoKSG93ZXZlciwgc2lsaWNvbiBJUHMgZm9yIHRoZXNlIFNvQ3MgYXJlIHVzdWFs
bHkgc2hhcmVkIGhlYXZpbHkgYWNyb3NzCmEgZmFtaWx5IG9mIHByb2Nlc3NvcnMsIGV2ZW4gcHJv
ZHVjdHMgZnJvbSBkaWZmZXJlbnQgY29tcGFuaWVzLiAgVGhpcwptYWtlcyB0aGUgb3JpZ2luYWwg
c2ltcGxlIGRyaXZlciBuYW1lIGJhc2VkIG1hdGNoaW5nIGluc3VmZmljaWVudCwgb3IKc2ltcGx5
IG5vdCBzdHJhaWdodC1mb3J3YXJkLgoKSW50cm9kdWNlIGEgbW9kdWxlIGlkIHRhYmxlIGZvciBw
bGF0Zm9ybSBkZXZpY2VzLCBhbmQgbWFrZXMgaXQgY2xlYXIKdGhhdCBhIHBsYXRmb3JtIGRyaXZl
ciBpcyBhYmxlIHRvIHN1cHBvcnQgc29tZSBzaGFyZWQgSVAgYW5kIGhhbmRsZQpzbGlnaHQgZGlm
ZmVyZW5jZXMgYWNyb3NzIGRpZmZlcmVudCBwbGF0Zm9ybXMgKGJ5ICdkcml2ZXJfZGF0YScpLgpN
b2R1bGUgYWxpYXMgaXMgaGFuZGxlZCBhdXRvbWF0aWNhbGx5IHdoZW4gYSBNT0RVTEVfREVWSUNF
X1RBQkxFKCkKaXMgZGVmaW5lZC4KClRvIG5vdCBkaXN0dXJiIHRoZSBjdXJyZW50IHBsYXRmb3Jt
IGRyaXZlcnMgdG9vIG11Y2gsIHRoZSBtYXRjaGVkIGlkCmVudHJ5IGlzIHJlY29yZGVkIGFuZCBj
YW4gYmUgcmV0cmlldmVkIGJ5IHBsYXRmb3JtX2dldF9kZXZpY2VfaWQoKS4KClNpZ25lZC1vZmYt
Ynk6IEVyaWMgTWlhbyA8ZXJpYy5taWFvQG1hcnZlbGwuY29tPgotLS0KIGRyaXZlcnMvYmFzZS9w
bGF0Zm9ybS5jICAgICAgICAgfCAgIDIxICsrKysrKysrKysrKysrKysrKysrLQogaW5jbHVkZS9s
aW51eC9tb2RfZGV2aWNldGFibGUuaCB8ICAgIDkgKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L3Bs
YXRmb3JtX2RldmljZS5oIHwgICAgNiArKysrKysKIHNjcmlwdHMvbW9kL2ZpbGUyYWxpYXMuYyAg
ICAgICAgfCAgIDEyICsrKysrKysrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCA0NyBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFzZS9wbGF0Zm9ybS5j
IGIvZHJpdmVycy9iYXNlL3BsYXRmb3JtLmMKaW5kZXggZDA1OTFmMC4uNDViZGMzNyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9iYXNlL3BsYXRmb3JtLmMKKysrIGIvZHJpdmVycy9iYXNlL3BsYXRmb3Jt
LmMKQEAgLTU4Nyw3ICs1ODcsOCBAQCBzdGF0aWMgaW50IHBsYXRmb3JtX3VldmVudChzdHJ1Y3Qg
ZGV2aWNlICpkZXYsIHN0cnVjdCBrb2JqX3VldmVudF9lbnYgKmVudikKIHsKIAlzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlCSpwZGV2ID0gdG9fcGxhdGZvcm1fZGV2aWNlKGRldik7CiAKLQlhZGRfdWV2
ZW50X3ZhcihlbnYsICJNT0RBTElBUz1wbGF0Zm9ybTolcyIsIHBkZXYtPm5hbWUpOworCWFkZF91
ZXZlbnRfdmFyKGVudiwgIk1PREFMSUFTPSVzJXMiLCBQTEFURk9STV9NT0RVTEVfUFJFRklYLAor
CQkocGRldi0+aWRfZW50cnkpID8gcGRldi0+aWRfZW50cnktPm5hbWUgOiBwZGV2LT5uYW1lKTsK
IAlyZXR1cm4gMDsKIH0KIApAQCAtNjA0LDEwICs2MDUsMjggQEAgc3RhdGljIGludCBwbGF0Zm9y
bV91ZXZlbnQoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3Qga29ial91ZXZlbnRfZW52ICplbnYp
CiAgKiBhbmQgY29tcGFyZSBpdCBhZ2FpbnN0IHRoZSBuYW1lIG9mIHRoZSBkcml2ZXIuIFJldHVy
biB3aGV0aGVyIHRoZXkgbWF0Y2gKICAqIG9yIG5vdC4KICAqLworc3RhdGljIGNvbnN0IHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2VfaWQgKnBsYXRmb3JtX21hdGNoX2lkKAorCQkJY29uc3Qgc3RydWN0
IHBsYXRmb3JtX2RldmljZV9pZCAqaWQsCisJCQlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQoreworCXdoaWxlIChpZC0+bmFtZVswXSkgeworCQlpZiAoc3RyY21wKHBkZXYtPm5hbWUsIGlk
LT5uYW1lKSA9PSAwKQorCQkJcmV0dXJuIChwZGV2LT5pZF9lbnRyeSA9IGlkKTsKKwkJaWQrKzsK
Kwl9CisJcmV0dXJuIE5VTEw7Cit9CisKIHN0YXRpYyBpbnQgcGxhdGZvcm1fbWF0Y2goc3RydWN0
IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2RyaXZlciAqZHJ2KQogewogCXN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2UoZGV2KTsKKwlzdHJ1Y3QgcGxh
dGZvcm1fZHJpdmVyICpwZHJ2ID0gdG9fcGxhdGZvcm1fZHJpdmVyKGRydik7CisKKwkvKiBtYXRj
aCBhZ2FpbnN0IHRoZSBpZCB0YWJsZSBmaXJzdCAqLworCWlmIChwZHJ2LT5pZF90YWJsZSkKKwkJ
cmV0dXJuIHBsYXRmb3JtX21hdGNoX2lkKHBkcnYtPmlkX3RhYmxlLCBwZGV2KSAhPSBOVUxMOwog
CisJLyogZmFsbC1iYWNrIHRvIGRyaXZlciBuYW1lIG1hdGNoICovCiAJcmV0dXJuIChzdHJuY21w
KHBkZXYtPm5hbWUsIGRydi0+bmFtZSwgQlVTX0lEX1NJWkUpID09IDApOwogfQogCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L21vZF9kZXZpY2V0YWJsZS5oIGIvaW5jbHVkZS9saW51eC9tb2Rf
ZGV2aWNldGFibGUuaAppbmRleCA5N2I5MWQxLi41MjAxNDkxIDEwMDY0NAotLS0gYS9pbmNsdWRl
L2xpbnV4L21vZF9kZXZpY2V0YWJsZS5oCisrKyBiL2luY2x1ZGUvbGludXgvbW9kX2RldmljZXRh
YmxlLmgKQEAgLTQ0Nyw0ICs0NDcsMTMgQEAgc3RydWN0IGRtaV9zeXN0ZW1faWQgewogCiAjZGVm
aW5lIERNSV9NQVRDSChhLCBiKQl7IGEsIGIgfQogCisjZGVmaW5lIFBMQVRGT1JNX05BTUVfU0la
RQkyMAorI2RlZmluZSBQTEFURk9STV9NT0RVTEVfUFJFRklYCSJwbGF0Zm9ybToiCisKK3N0cnVj
dCBwbGF0Zm9ybV9kZXZpY2VfaWQgeworCWNoYXIgbmFtZVtJMkNfTkFNRV9TSVpFXTsKKwlrZXJu
ZWxfdWxvbmdfdCBkcml2ZXJfZGF0YQorCQkJX19hdHRyaWJ1dGVfXygoYWxpZ25lZChzaXplb2Yo
a2VybmVsX3Vsb25nX3QpKSkpOworfTsKKwogI2VuZGlmIC8qIExJTlVYX01PRF9ERVZJQ0VUQUJM
RV9IICovCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3BsYXRmb3JtX2RldmljZS5oIGIvaW5j
bHVkZS9saW51eC9wbGF0Zm9ybV9kZXZpY2UuaAppbmRleCA0YjhjYzZhLi43ZWRjNTcwIDEwMDY0
NAotLS0gYS9pbmNsdWRlL2xpbnV4L3BsYXRmb3JtX2RldmljZS5oCisrKyBiL2luY2x1ZGUvbGlu
dXgvcGxhdGZvcm1fZGV2aWNlLmgKQEAgLTEyLDYgKzEyLDcgQEAKICNkZWZpbmUgX1BMQVRGT1JN
X0RFVklDRV9IXwogCiAjaW5jbHVkZSA8bGludXgvZGV2aWNlLmg+CisjaW5jbHVkZSA8bGludXgv
bW9kX2RldmljZXRhYmxlLmg+CiAKIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgewogCWNvbnN0IGNo
YXIJKiBuYW1lOwpAQCAtMTksOCArMjAsMTIgQEAgc3RydWN0IHBsYXRmb3JtX2RldmljZSB7CiAJ
c3RydWN0IGRldmljZQlkZXY7CiAJdTMyCQludW1fcmVzb3VyY2VzOwogCXN0cnVjdCByZXNvdXJj
ZQkqIHJlc291cmNlOworCisJc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZAkqaWRfZW50cnk7CiB9
OwogCisjZGVmaW5lIHBsYXRmb3JtX2dldF9kZXZpY2VfaWQocGRldikJKChwZGV2KS0+aWRfZW50
cnkpCisKICNkZWZpbmUgdG9fcGxhdGZvcm1fZGV2aWNlKHgpIGNvbnRhaW5lcl9vZigoeCksIHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UsIGRldikKIAogZXh0ZXJuIGludCBwbGF0Zm9ybV9kZXZpY2Vf
cmVnaXN0ZXIoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqKTsKQEAgLTU3LDYgKzYyLDcgQEAgc3Ry
dWN0IHBsYXRmb3JtX2RyaXZlciB7CiAJaW50ICgqcmVzdW1lKShzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICopOwogCXN0cnVjdCBwbV9leHRfb3BzICpwbTsKIAlzdHJ1Y3QgZGV2aWNlX2RyaXZlciBk
cml2ZXI7CisJc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZCAqaWRfdGFibGU7CiB9OwogCiBleHRl
cm4gaW50IHBsYXRmb3JtX2RyaXZlcl9yZWdpc3RlcihzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyICop
OwpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9tb2QvZmlsZTJhbGlhcy5jIGIvc2NyaXB0cy9tb2QvZmls
ZTJhbGlhcy5jCmluZGV4IGQ0ZGMyMjIuLmY3MWY1ZTYgMTAwNjQ0Ci0tLSBhL3NjcmlwdHMvbW9k
L2ZpbGUyYWxpYXMuYworKysgYi9zY3JpcHRzL21vZC9maWxlMmFsaWFzLmMKQEAgLTY5Niw2ICs2
OTYsMTQgQEAgc3RhdGljIGludCBkb19kbWlfZW50cnkoY29uc3QgY2hhciAqZmlsZW5hbWUsIHN0
cnVjdCBkbWlfc3lzdGVtX2lkICppZCwKIAlzdHJjYXQoYWxpYXMsICI6Iik7CiAJcmV0dXJuIDE7
CiB9CisKK3N0YXRpYyBpbnQgZG9fcGxhdGZvcm1fZW50cnkoY29uc3QgY2hhciAqZmlsZW5hbWUs
CisJCQkgICAgIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2VfaWQgKmlkLCBjaGFyICphbGlhcykKK3sK
KwlzcHJpbnRmKGFsaWFzLCBQTEFURk9STV9NT0RVTEVfUFJFRklYICIlcyIsIGlkLT5uYW1lKTsK
KwlyZXR1cm4gMTsKK30KKwogLyogSWdub3JlIGFueSBwcmVmaXgsIGVnLiBzb21lIGFyY2hpdGVj
dHVyZXMgcHJlcGVuZCBfICovCiBzdGF0aWMgaW5saW5lIGludCBzeW1faXMoY29uc3QgY2hhciAq
c3ltYm9sLCBjb25zdCBjaGFyICpuYW1lKQogewpAQCAtODM1LDYgKzg0MywxMCBAQCB2b2lkIGhh
bmRsZV9tb2RkZXZ0YWJsZShzdHJ1Y3QgbW9kdWxlICptb2QsIHN0cnVjdCBlbGZfaW5mbyAqaW5m
bywKIAkJZG9fdGFibGUoc3ltdmFsLCBzeW0tPnN0X3NpemUsCiAJCQkgc2l6ZW9mKHN0cnVjdCBk
bWlfc3lzdGVtX2lkKSwgImRtaSIsCiAJCQkgZG9fZG1pX2VudHJ5LCBtb2QpOworCWVsc2UgaWYg
KHN5bV9pcyhzeW1uYW1lLCAiX19tb2RfcGxhdGZvcm1fZGV2aWNlX3RhYmxlIikpCisJCWRvX3Rh
YmxlKHN5bXZhbCwgc3ltLT5zdF9zaXplLAorCQkJIHNpemVvZihzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlX2lkKSwgInBsYXRmb3JtIiwKKwkJCSBkb19wbGF0Zm9ybV9lbnRyeSwgbW9kKTsKIAlmcmVl
KHplcm9zKTsKIH0KIAotLSAKMS42LjAuNAoK
------=_Part_126039_21498746.1230620630120--
