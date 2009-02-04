Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZBDDwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZBDDwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBDDwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:52:42 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:32998 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBDDwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:52:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K0L3zVWkU7Y8CrERVRgoz5bi036zYyPgjkHd1t2qIw/KU4SNsrGN2XJ8xapUuWDXQM
         yxccNxJPhu/yJK9xSCY5pDp9E2Zqj9iyCgA23XB+rAmGyHWOqudoTu9gqPvE8yBLP+6a
         H3WJZwDD+yLEeinLH8rNmq7TmlOkSEoRSZi9Y=
MIME-Version: 1.0
In-Reply-To: <20090204011640.GC17622@kroah.com>
References: <498464ED.3010607@gmail.com> <20090131155147.GU12431@fluff.org.uk>
	 <f17812d70902020211u63d7e510k81926f45ff672323@mail.gmail.com>
	 <20090204011640.GC17622@kroah.com>
Date: Wed, 4 Feb 2009 11:52:40 +0800
Message-ID: <f17812d70902031952x2fecef8bsb30e84ce6685f572@mail.gmail.com>
Subject: Re: [PATCH 2/2 RESEND] platform: introduce module id table for 
	platform devices
From: Eric Miao <eric.y.miao@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: multipart/mixed; boundary=000e0cd2176c27c37d04620fb860
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2176c27c37d04620fb860
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Wed, Feb 4, 2009 at 9:16 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Feb 02, 2009 at 06:11:48PM +0800, Eric Miao wrote:
>> >
>> > surely you mean PLATFORM_NAME_SIZE in this struct?
>>
>> Indeed, patch updated below (and as attached):
>
> With this patch, I get the following warning:
>        drivers/base/platform.c:598: warning: assignment discards qualifiers from pointer target type
>
> Also, don't put platform_match_id() underneath the comments for
> platform_match(), that will only confuse the kernel-doc scripts and any
> developer looking at the code.
>
> Care to fix it up and resend?
>

OK, updated patch below:

>From 2dfe47b26ba0bf72974ae4ca2bb86b211a78596b Mon Sep 17 00:00:00 2001
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
 drivers/base/platform.c         |   23 ++++++++++++++++++++++-
 include/linux/mod_devicetable.h |    9 +++++++++
 include/linux/platform_device.h |    6 ++++++
 scripts/mod/file2alias.c        |   12 ++++++++++++
 4 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index d0591f0..ae65607 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -587,10 +587,25 @@ static int platform_uevent(struct device *dev,
struct kobj_uevent_env *env)
 {
 	struct platform_device	*pdev = to_platform_device(dev);

-	add_uevent_var(env, "MODALIAS=platform:%s", pdev->name);
+	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
+		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
 	return 0;
 }

+static const struct platform_device_id *platform_match_id(
+			struct platform_device_id *id,
+			struct platform_device *pdev)
+{
+	while (id->name[0]) {
+		if (strcmp(pdev->name, id->name) == 0) {
+			pdev->id_entry = id;
+			return id;
+		}
+		id++;
+	}
+	return NULL;
+}
+
 /**
  * platform_match - bind platform device to platform driver.
  * @dev: device.
@@ -607,7 +622,13 @@ static int platform_uevent(struct device *dev,
struct kobj_uevent_env *env)
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

--000e0cd2176c27c37d04620fb860
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0002-platform-introduce-module-id-table-for-platform-dev.patch"
Content-Disposition: attachment; 
	filename="0002-platform-introduce-module-id-table-for-platform-dev.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fqrgq1kd0

RnJvbSAyZGZlNDdiMjZiYTBiZjcyOTc0YWU0Y2EyYmI4NmIyMTFhNzg1OTZiIE1vbiBTZXAgMTcg
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
cy9iYXNlL3BsYXRmb3JtLmMgICAgICAgICB8ICAgMjMgKysrKysrKysrKysrKysrKysrKysrKy0K
IGluY2x1ZGUvbGludXgvbW9kX2RldmljZXRhYmxlLmggfCAgICA5ICsrKysrKysrKwogaW5jbHVk
ZS9saW51eC9wbGF0Zm9ybV9kZXZpY2UuaCB8ICAgIDYgKysrKysrCiBzY3JpcHRzL21vZC9maWxl
MmFsaWFzLmMgICAgICAgIHwgICAxMiArKysrKysrKysrKysKIDQgZmlsZXMgY2hhbmdlZCwgNDkg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jhc2Uv
cGxhdGZvcm0uYyBiL2RyaXZlcnMvYmFzZS9wbGF0Zm9ybS5jCmluZGV4IGQwNTkxZjAuLmFlNjU2
MDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYmFzZS9wbGF0Zm9ybS5jCisrKyBiL2RyaXZlcnMvYmFz
ZS9wbGF0Zm9ybS5jCkBAIC01ODcsMTAgKzU4NywyNSBAQCBzdGF0aWMgaW50IHBsYXRmb3JtX3Vl
dmVudChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBrb2JqX3VldmVudF9lbnYgKmVudikKIHsK
IAlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlCSpwZGV2ID0gdG9fcGxhdGZvcm1fZGV2aWNlKGRldik7
CiAKLQlhZGRfdWV2ZW50X3ZhcihlbnYsICJNT0RBTElBUz1wbGF0Zm9ybTolcyIsIHBkZXYtPm5h
bWUpOworCWFkZF91ZXZlbnRfdmFyKGVudiwgIk1PREFMSUFTPSVzJXMiLCBQTEFURk9STV9NT0RV
TEVfUFJFRklYLAorCQkocGRldi0+aWRfZW50cnkpID8gcGRldi0+aWRfZW50cnktPm5hbWUgOiBw
ZGV2LT5uYW1lKTsKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGNvbnN0IHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2VfaWQgKnBsYXRmb3JtX21hdGNoX2lkKAorCQkJc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZV9pZCAqaWQsCisJCQlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQoreworCXdoaWxlIChp
ZC0+bmFtZVswXSkgeworCQlpZiAoc3RyY21wKHBkZXYtPm5hbWUsIGlkLT5uYW1lKSA9PSAwKSB7
CisJCQlwZGV2LT5pZF9lbnRyeSA9IGlkOworCQkJcmV0dXJuIGlkOworCQl9CisJCWlkKys7CisJ
fQorCXJldHVybiBOVUxMOworfQorCiAvKioKICAqIHBsYXRmb3JtX21hdGNoIC0gYmluZCBwbGF0
Zm9ybSBkZXZpY2UgdG8gcGxhdGZvcm0gZHJpdmVyLgogICogQGRldjogZGV2aWNlLgpAQCAtNjA3
LDcgKzYyMiwxMyBAQCBzdGF0aWMgaW50IHBsYXRmb3JtX3VldmVudChzdHJ1Y3QgZGV2aWNlICpk
ZXYsIHN0cnVjdCBrb2JqX3VldmVudF9lbnYgKmVudikKIHN0YXRpYyBpbnQgcGxhdGZvcm1fbWF0
Y2goc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2RyaXZlciAqZHJ2KQogewogCXN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2UoZGV2KTsKKwlz
dHJ1Y3QgcGxhdGZvcm1fZHJpdmVyICpwZHJ2ID0gdG9fcGxhdGZvcm1fZHJpdmVyKGRydik7CisK
KwkvKiBtYXRjaCBhZ2FpbnN0IHRoZSBpZCB0YWJsZSBmaXJzdCAqLworCWlmIChwZHJ2LT5pZF90
YWJsZSkKKwkJcmV0dXJuIHBsYXRmb3JtX21hdGNoX2lkKHBkcnYtPmlkX3RhYmxlLCBwZGV2KSAh
PSBOVUxMOwogCisJLyogZmFsbC1iYWNrIHRvIGRyaXZlciBuYW1lIG1hdGNoICovCiAJcmV0dXJu
IChzdHJuY21wKHBkZXYtPm5hbWUsIGRydi0+bmFtZSwgQlVTX0lEX1NJWkUpID09IDApOwogfQog
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21vZF9kZXZpY2V0YWJsZS5oIGIvaW5jbHVkZS9s
aW51eC9tb2RfZGV2aWNldGFibGUuaAppbmRleCA5N2I5MWQxLi4wNTU0MmQzIDEwMDY0NAotLS0g
YS9pbmNsdWRlL2xpbnV4L21vZF9kZXZpY2V0YWJsZS5oCisrKyBiL2luY2x1ZGUvbGludXgvbW9k
X2RldmljZXRhYmxlLmgKQEAgLTQ0Nyw0ICs0NDcsMTMgQEAgc3RydWN0IGRtaV9zeXN0ZW1faWQg
ewogCiAjZGVmaW5lIERNSV9NQVRDSChhLCBiKQl7IGEsIGIgfQogCisjZGVmaW5lIFBMQVRGT1JN
X05BTUVfU0laRQkyMAorI2RlZmluZSBQTEFURk9STV9NT0RVTEVfUFJFRklYCSJwbGF0Zm9ybToi
CisKK3N0cnVjdCBwbGF0Zm9ybV9kZXZpY2VfaWQgeworCWNoYXIgbmFtZVtQTEFURk9STV9OQU1F
X1NJWkVdOworCWtlcm5lbF91bG9uZ190IGRyaXZlcl9kYXRhCisJCQlfX2F0dHJpYnV0ZV9fKChh
bGlnbmVkKHNpemVvZihrZXJuZWxfdWxvbmdfdCkpKSk7Cit9OworCiAjZW5kaWYgLyogTElOVVhf
TU9EX0RFVklDRVRBQkxFX0ggKi8KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGxhdGZvcm1f
ZGV2aWNlLmggYi9pbmNsdWRlL2xpbnV4L3BsYXRmb3JtX2RldmljZS5oCmluZGV4IDRiOGNjNmEu
LjdlZGM1NzAgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcGxhdGZvcm1fZGV2aWNlLmgKKysr
IGIvaW5jbHVkZS9saW51eC9wbGF0Zm9ybV9kZXZpY2UuaApAQCAtMTIsNiArMTIsNyBAQAogI2Rl
ZmluZSBfUExBVEZPUk1fREVWSUNFX0hfCiAKICNpbmNsdWRlIDxsaW51eC9kZXZpY2UuaD4KKyNp
bmNsdWRlIDxsaW51eC9tb2RfZGV2aWNldGFibGUuaD4KIAogc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZSB7CiAJY29uc3QgY2hhcgkqIG5hbWU7CkBAIC0xOSw4ICsyMCwxMiBAQCBzdHJ1Y3QgcGxhdGZv
cm1fZGV2aWNlIHsKIAlzdHJ1Y3QgZGV2aWNlCWRldjsKIAl1MzIJCW51bV9yZXNvdXJjZXM7CiAJ
c3RydWN0IHJlc291cmNlCSogcmVzb3VyY2U7CisKKwlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlX2lk
CSppZF9lbnRyeTsKIH07CiAKKyNkZWZpbmUgcGxhdGZvcm1fZ2V0X2RldmljZV9pZChwZGV2KQko
KHBkZXYpLT5pZF9lbnRyeSkKKwogI2RlZmluZSB0b19wbGF0Zm9ybV9kZXZpY2UoeCkgY29udGFp
bmVyX29mKCh4KSwgc3RydWN0IHBsYXRmb3JtX2RldmljZSwgZGV2KQogCiBleHRlcm4gaW50IHBs
YXRmb3JtX2RldmljZV9yZWdpc3RlcihzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICopOwpAQCAtNTcs
NiArNjIsNyBAQCBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIHsKIAlpbnQgKCpyZXN1bWUpKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKik7CiAJc3RydWN0IHBtX2V4dF9vcHMgKnBtOwogCXN0cnVjdCBk
ZXZpY2VfZHJpdmVyIGRyaXZlcjsKKwlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlX2lkICppZF90YWJs
ZTsKIH07CiAKIGV4dGVybiBpbnQgcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKHN0cnVjdCBwbGF0
Zm9ybV9kcml2ZXIgKik7CmRpZmYgLS1naXQgYS9zY3JpcHRzL21vZC9maWxlMmFsaWFzLmMgYi9z
Y3JpcHRzL21vZC9maWxlMmFsaWFzLmMKaW5kZXggZDRkYzIyMi4uZjcxZjVlNiAxMDA2NDQKLS0t
IGEvc2NyaXB0cy9tb2QvZmlsZTJhbGlhcy5jCisrKyBiL3NjcmlwdHMvbW9kL2ZpbGUyYWxpYXMu
YwpAQCAtNjk2LDYgKzY5NiwxNCBAQCBzdGF0aWMgaW50IGRvX2RtaV9lbnRyeShjb25zdCBjaGFy
ICpmaWxlbmFtZSwgc3RydWN0IGRtaV9zeXN0ZW1faWQgKmlkLAogCXN0cmNhdChhbGlhcywgIjoi
KTsKIAlyZXR1cm4gMTsKIH0KKworc3RhdGljIGludCBkb19wbGF0Zm9ybV9lbnRyeShjb25zdCBj
aGFyICpmaWxlbmFtZSwKKwkJCSAgICAgc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZCAqaWQsIGNo
YXIgKmFsaWFzKQoreworCXNwcmludGYoYWxpYXMsIFBMQVRGT1JNX01PRFVMRV9QUkVGSVggIiVz
IiwgaWQtPm5hbWUpOworCXJldHVybiAxOworfQorCiAvKiBJZ25vcmUgYW55IHByZWZpeCwgZWcu
IHNvbWUgYXJjaGl0ZWN0dXJlcyBwcmVwZW5kIF8gKi8KIHN0YXRpYyBpbmxpbmUgaW50IHN5bV9p
cyhjb25zdCBjaGFyICpzeW1ib2wsIGNvbnN0IGNoYXIgKm5hbWUpCiB7CkBAIC04MzUsNiArODQz
LDEwIEBAIHZvaWQgaGFuZGxlX21vZGRldnRhYmxlKHN0cnVjdCBtb2R1bGUgKm1vZCwgc3RydWN0
IGVsZl9pbmZvICppbmZvLAogCQlkb190YWJsZShzeW12YWwsIHN5bS0+c3Rfc2l6ZSwKIAkJCSBz
aXplb2Yoc3RydWN0IGRtaV9zeXN0ZW1faWQpLCAiZG1pIiwKIAkJCSBkb19kbWlfZW50cnksIG1v
ZCk7CisJZWxzZSBpZiAoc3ltX2lzKHN5bW5hbWUsICJfX21vZF9wbGF0Zm9ybV9kZXZpY2VfdGFi
bGUiKSkKKwkJZG9fdGFibGUoc3ltdmFsLCBzeW0tPnN0X3NpemUsCisJCQkgc2l6ZW9mKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2VfaWQpLCAicGxhdGZvcm0iLAorCQkJIGRvX3BsYXRmb3JtX2VudHJ5
LCBtb2QpOwogCWZyZWUoemVyb3MpOwogfQogCi0tIAoxLjYuMC40Cgo=
--000e0cd2176c27c37d04620fb860--
