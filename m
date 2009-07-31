Return-Path: <linux-kernel-owner+w=401wt.eu-S1751774AbZGaI3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbZGaI3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZGaI3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:29:03 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:56359 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZGaI3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=A09P1bZJlnPRzvVfgISUz16N+mwHki6o+cB0uw5yoi+R3vMpwlDs9GgS4H7i4KEuAQ
         4lTgMmdzk/cPb4u/h7Ly0d0J4Aj/zkW6pUvSPGNAQ8CFzV24rqJdfJLSkt33yK28yejx
         U+UpDnD/gE63EdqCHqgHfFdlZmo0GVh55vPMQ=
MIME-Version: 1.0
Date: Fri, 31 Jul 2009 16:29:01 +0800
Message-ID: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
Subject: [RFC patch] return early if all dmar HW unit ignored
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd20c025e1163046ffc36cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd20c025e1163046ffc36cc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello list,

When debugging an IOMMU problem, I noticed it should be much more safe
to return early than late if all remapping HW unit are ignored.
To figure out what device causes the iommu problem on my linux box:
hp-compaq dc7800, I tried to mark all dmar HW
unit ignored,but still got a lot of unxepcted dmar_fault. So I think
the proposed patch make sense. The next step is to
add a boot option to make dmar HW units selectable enable/disable individually.

Please review.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming


Signed-off-by: Yu Luming <luming.yu@intel.com>

 intel-iommu.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index ebc9b8d..713e206 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2994,9 +2994,10 @@ static void __init iommu_exit_mempool(void)

 }

-static void __init init_no_remapping_devices(void)
+static int __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
+	int drhd_total = 0,drhd_ignored = 0;

 	for_each_drhd_unit(drhd) {
 		if (!drhd->include_all) {
@@ -3008,32 +3009,34 @@ static void __init init_no_remapping_devices(void)
 			if (i == drhd->devices_cnt)
 				drhd->ignored = 1;
 		}
+		drhd_total++;
 	}
-
-	if (dmar_map_gfx)
-		return;
-
 	for_each_drhd_unit(drhd) {
 		int i;
-		if (drhd->ignored || drhd->include_all)
+		if (drhd->ignored)
+			drhd_ignored++;
+		if (drhd->ignored || drhd->include_all) {
+			continue;
+		}
+		if (dmar_map_gfx)
 			continue;
-
 		for (i = 0; i < drhd->devices_cnt; i++)
 			if (drhd->devices[i] &&
 				!IS_GFX_DEVICE(drhd->devices[i]))
 				break;
-
 		if (i < drhd->devices_cnt)
 			continue;

 		/* bypass IOMMU if it is just for gfx devices */
 		drhd->ignored = 1;
+		drhd_ignored++;
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
 			drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
+	return (drhd_total == drhd_ignored);
 }

 #ifdef CONFIG_SUSPEND
@@ -3200,7 +3203,12 @@ int __init intel_iommu_init(void)
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();

-	init_no_remapping_devices();
+	if(init_no_remapping_devices()) {
+		printk(KERN_ERR "IOMMU: all dmar HW unit ignored\n");
+		put_iova_domain(&reserved_iova_list);
+		iommu_exit_mempool();
+		return ret;
+	}

 	ret = init_dmars();
 	if (ret) {

--000e0cd20c025e1163046ffc36cc
Content-Type: application/octet-stream; name="0.patch"
Content-Disposition: attachment; filename="0.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fxsnoajx0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2ludGVsLWlvbW11LmMgYi9kcml2ZXJzL3BjaS9pbnRl
bC1pb21tdS5jCmluZGV4IGViYzliOGQuLjcxM2UyMDYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNp
L2ludGVsLWlvbW11LmMKKysrIGIvZHJpdmVycy9wY2kvaW50ZWwtaW9tbXUuYwpAQCAtMjk5NCw5
ICsyOTk0LDEwIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpb21tdV9leGl0X21lbXBvb2wodm9pZCkK
IAogfQogCi1zdGF0aWMgdm9pZCBfX2luaXQgaW5pdF9ub19yZW1hcHBpbmdfZGV2aWNlcyh2b2lk
KQorc3RhdGljIGludCBfX2luaXQgaW5pdF9ub19yZW1hcHBpbmdfZGV2aWNlcyh2b2lkKQogewog
CXN0cnVjdCBkbWFyX2RyaGRfdW5pdCAqZHJoZDsKKwlpbnQgZHJoZF90b3RhbCA9IDAsZHJoZF9p
Z25vcmVkID0gMDsKIAogCWZvcl9lYWNoX2RyaGRfdW5pdChkcmhkKSB7CiAJCWlmICghZHJoZC0+
aW5jbHVkZV9hbGwpIHsKQEAgLTMwMDgsMzIgKzMwMDksMzQgQEAgc3RhdGljIHZvaWQgX19pbml0
IGluaXRfbm9fcmVtYXBwaW5nX2RldmljZXModm9pZCkKIAkJCWlmIChpID09IGRyaGQtPmRldmlj
ZXNfY250KQogCQkJCWRyaGQtPmlnbm9yZWQgPSAxOwogCQl9CisJCWRyaGRfdG90YWwrKzsKIAl9
Ci0KLQlpZiAoZG1hcl9tYXBfZ2Z4KQotCQlyZXR1cm47Ci0KIAlmb3JfZWFjaF9kcmhkX3VuaXQo
ZHJoZCkgewogCQlpbnQgaTsKLQkJaWYgKGRyaGQtPmlnbm9yZWQgfHwgZHJoZC0+aW5jbHVkZV9h
bGwpCisJCWlmIChkcmhkLT5pZ25vcmVkKQorCQkJZHJoZF9pZ25vcmVkKys7CisJCWlmIChkcmhk
LT5pZ25vcmVkIHx8IGRyaGQtPmluY2x1ZGVfYWxsKSB7CisJCQljb250aW51ZTsKKwkJfQorCQlp
ZiAoZG1hcl9tYXBfZ2Z4KQogCQkJY29udGludWU7Ci0KIAkJZm9yIChpID0gMDsgaSA8IGRyaGQt
PmRldmljZXNfY250OyBpKyspCiAJCQlpZiAoZHJoZC0+ZGV2aWNlc1tpXSAmJgogCQkJCSFJU19H
RlhfREVWSUNFKGRyaGQtPmRldmljZXNbaV0pKQogCQkJCWJyZWFrOwotCiAJCWlmIChpIDwgZHJo
ZC0+ZGV2aWNlc19jbnQpCiAJCQljb250aW51ZTsKIAogCQkvKiBieXBhc3MgSU9NTVUgaWYgaXQg
aXMganVzdCBmb3IgZ2Z4IGRldmljZXMgKi8KIAkJZHJoZC0+aWdub3JlZCA9IDE7CisJCWRyaGRf
aWdub3JlZCsrOwogCQlmb3IgKGkgPSAwOyBpIDwgZHJoZC0+ZGV2aWNlc19jbnQ7IGkrKykgewog
CQkJaWYgKCFkcmhkLT5kZXZpY2VzW2ldKQogCQkJCWNvbnRpbnVlOwogCQkJZHJoZC0+ZGV2aWNl
c1tpXS0+ZGV2LmFyY2hkYXRhLmlvbW11ID0gRFVNTVlfREVWSUNFX0RPTUFJTl9JTkZPOwogCQl9
CiAJfQorCXJldHVybiAoZHJoZF90b3RhbCA9PSBkcmhkX2lnbm9yZWQpOwogfQogCiAjaWZkZWYg
Q09ORklHX1NVU1BFTkQKQEAgLTMyMDAsNyArMzIwMywxMiBAQCBpbnQgX19pbml0IGludGVsX2lv
bW11X2luaXQodm9pZCkKIAlpb21tdV9pbml0X21lbXBvb2woKTsKIAlkbWFyX2luaXRfcmVzZXJ2
ZWRfcmFuZ2VzKCk7CiAKLQlpbml0X25vX3JlbWFwcGluZ19kZXZpY2VzKCk7CisJaWYoaW5pdF9u
b19yZW1hcHBpbmdfZGV2aWNlcygpKSB7CisJCXByaW50ayhLRVJOX0VSUiAiSU9NTVU6IGFsbCBk
bWFyIEhXIHVuaXQgaWdub3JlZFxuIik7CisJCXB1dF9pb3ZhX2RvbWFpbigmcmVzZXJ2ZWRfaW92
YV9saXN0KTsKKwkJaW9tbXVfZXhpdF9tZW1wb29sKCk7CisJCXJldHVybiByZXQ7CisJfQogCiAJ
cmV0ID0gaW5pdF9kbWFycygpOwogCWlmIChyZXQpIHsK
--000e0cd20c025e1163046ffc36cc--
