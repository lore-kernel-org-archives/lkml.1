Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZAIOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZAIOrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 09:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZAIOrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 09:47:00 -0500
Received: from rv-out-0708.google.com ([209.85.198.250]:58578 "EHLO
	rv-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZAIOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 09:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=U9w36LnfQVdcfdyzqqfLRfOy/nxbIMFd29AXlcSSTLqMSb+pO5qHj9PH08D5YR6nGC
         4h8BXO/OKwBoDBGX0Snl62/Sx1DozmHGQfWjT9rMB5LqN4078I0rYx9rprJ0qIv18DoG
         e0V8g9gKvUjRXaURBW9NvB4QNcfLYPULbU3cI=
Message-ID: <f17812d70901090646x9180dbaj55e057b7e0a6a5b2@mail.gmail.com>
Date: Fri, 9 Jan 2009 22:46:57 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH 1/2] platform: make better use of to_platform_{device,driver}() macros
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <f17812d70812292303s1ef2a59cw23467353ab652df6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14141_4779847.1231512417220"
References: <f17812d70812292303s1ef2a59cw23467353ab652df6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14141_4779847.1231512417220
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This helps the code look more consistent and cleaner.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/base/platform.c            |   21 +++++++++------------
 drivers/block/floppy.c             |    3 +--
 drivers/isdn/gigaset/ser-gigaset.c |    3 +--
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..d0591f0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -606,9 +606,8 @@ static int platform_uevent(struct device *dev,
struct kobj_uevent_env *env)
 */
 static int platform_match(struct device *dev, struct device_driver *drv)
 {
-       struct platform_device *pdev;
+       struct platform_device *pdev = to_platform_device(dev);

-       pdev = container_of(dev, struct platform_device, dev);
       return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
 }

@@ -626,26 +625,24 @@ static int platform_legacy_suspend(struct device
*dev, pm_message_t mesg)

 static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 {
-       struct platform_driver *drv = to_platform_driver(dev->driver);
-       struct platform_device *pdev;
+       struct platform_driver *pdrv = to_platform_driver(dev->driver);
+       struct platform_device *pdev = to_platform_device(dev);
       int ret = 0;

-       pdev = container_of(dev, struct platform_device, dev);
-       if (dev->driver && drv->suspend_late)
-               ret = drv->suspend_late(pdev, mesg);
+       if (dev->driver && pdrv->suspend_late)
+               ret = pdrv->suspend_late(pdev, mesg);

       return ret;
 }

 static int platform_legacy_resume_early(struct device *dev)
 {
-       struct platform_driver *drv = to_platform_driver(dev->driver);
-       struct platform_device *pdev;
+       struct platform_driver *pdrv = to_platform_driver(dev->driver);
+       struct platform_device *pdev = to_platform_device(dev);
       int ret = 0;

-       pdev = container_of(dev, struct platform_device, dev);
-       if (dev->driver && drv->resume_early)
-               ret = drv->resume_early(pdev);
+       if (dev->driver && pdrv->resume_early)
+               ret = pdrv->resume_early(pdev);

       return ret;
 }
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf29cc4..9c3c5c7 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4133,10 +4133,9 @@ static int have_no_fdc = -ENODEV;
 static ssize_t floppy_cmos_show(struct device *dev,
                               struct device_attribute *attr, char *buf)
 {
-       struct platform_device *p;
+       struct platform_device *p = to_platform_device(dev);
       int drive;

-       p = container_of(dev, struct platform_device,dev);
       drive = p->id;
       return sprintf(buf, "%X\n", UDP->cmos);
 }
diff --git a/drivers/isdn/gigaset/ser-gigaset.c
b/drivers/isdn/gigaset/ser-gigaset.c
index ac245e7..3071a52 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -389,8 +389,7 @@ static void gigaset_freecshw(struct cardstate *cs)

 static void gigaset_device_release(struct device *dev)
 {
-       struct platform_device *pdev =
-               container_of(dev, struct platform_device, dev);
+       struct platform_device *pdev = to_platform_device(dev);

       /* adapted from platform_device_release() in drivers/base/platform.c */
       //FIXME is this actually necessary?
--
1.6.0.4



-- 
Cheers
- eric

------=_Part_14141_4779847.1231512417220
Content-Type: text/x-diff;
 name=0001-platform-make-better-use-of-to_platform_-device-dri.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpc7pc2s0
Content-Disposition: attachment;
 filename=0001-platform-make-better-use-of-to_platform_-device-dri.patch

RnJvbSAwM2IzMWNlN2NjMjA0MzUzZTczYjM5YTJjMGYzYWJhNjhhYjA3ODgzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogVHVlLCAzMCBEZWMgMjAwOCAxMzo0OToxNyArMDgwMApTdWJqZWN0OiBwbGF0Zm9ybTogbWFr
ZSBiZXR0ZXIgdXNlIG9mIHRvX3BsYXRmb3JtX3tkZXZpY2UsZHJpdmVyfSgpIG1hY3JvcwoKVGhp
cyBoZWxwcyB0aGUgY29kZSBsb29rIG1vcmUgY29uc2lzdGVudCBhbmQgY2xlYW5lci4KClNpZ25l
ZC1vZmYtYnk6IEVyaWMgTWlhbyA8ZXJpYy5taWFvQG1hcnZlbGwuY29tPgotLS0KIGRyaXZlcnMv
YmFzZS9wbGF0Zm9ybS5jICAgICAgICAgICAgfCAgIDIxICsrKysrKysrKy0tLS0tLS0tLS0tLQog
ZHJpdmVycy9ibG9jay9mbG9wcHkuYyAgICAgICAgICAgICB8ICAgIDMgKy0tCiBkcml2ZXJzL2lz
ZG4vZ2lnYXNldC9zZXItZ2lnYXNldC5jIHwgICAgMyArLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTEg
aW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9iYXNl
L3BsYXRmb3JtLmMgYi9kcml2ZXJzL2Jhc2UvcGxhdGZvcm0uYwppbmRleCBkZmNiZmU1Li5kMDU5
MWYwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jhc2UvcGxhdGZvcm0uYworKysgYi9kcml2ZXJzL2Jh
c2UvcGxhdGZvcm0uYwpAQCAtNjA2LDkgKzYwNiw4IEBAIHN0YXRpYyBpbnQgcGxhdGZvcm1fdWV2
ZW50KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGtvYmpfdWV2ZW50X2VudiAqZW52KQogICov
CiBzdGF0aWMgaW50IHBsYXRmb3JtX21hdGNoKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRl
dmljZV9kcml2ZXIgKmRydikKIHsKLQlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2OworCXN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2UoZGV2KTsKIAot
CXBkZXYgPSBjb250YWluZXJfb2YoZGV2LCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlLCBkZXYpOwog
CXJldHVybiAoc3RybmNtcChwZGV2LT5uYW1lLCBkcnYtPm5hbWUsIEJVU19JRF9TSVpFKSA9PSAw
KTsKIH0KIApAQCAtNjI2LDI2ICs2MjUsMjQgQEAgc3RhdGljIGludCBwbGF0Zm9ybV9sZWdhY3lf
c3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXYsIHBtX21lc3NhZ2VfdCBtZXNnKQogCiBzdGF0aWMg
aW50IHBsYXRmb3JtX2xlZ2FjeV9zdXNwZW5kX2xhdGUoc3RydWN0IGRldmljZSAqZGV2LCBwbV9t
ZXNzYWdlX3QgbWVzZykKIHsKLQlzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyICpkcnYgPSB0b19wbGF0
Zm9ybV9kcml2ZXIoZGV2LT5kcml2ZXIpOwotCXN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXY7
CisJc3RydWN0IHBsYXRmb3JtX2RyaXZlciAqcGRydiA9IHRvX3BsYXRmb3JtX2RyaXZlcihkZXYt
PmRyaXZlcik7CisJc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiA9IHRvX3BsYXRmb3JtX2Rl
dmljZShkZXYpOwogCWludCByZXQgPSAwOwogCi0JcGRldiA9IGNvbnRhaW5lcl9vZihkZXYsIHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UsIGRldik7Ci0JaWYgKGRldi0+ZHJpdmVyICYmIGRydi0+c3Vz
cGVuZF9sYXRlKQotCQlyZXQgPSBkcnYtPnN1c3BlbmRfbGF0ZShwZGV2LCBtZXNnKTsKKwlpZiAo
ZGV2LT5kcml2ZXIgJiYgcGRydi0+c3VzcGVuZF9sYXRlKQorCQlyZXQgPSBwZHJ2LT5zdXNwZW5k
X2xhdGUocGRldiwgbWVzZyk7CiAKIAlyZXR1cm4gcmV0OwogfQogCiBzdGF0aWMgaW50IHBsYXRm
b3JtX2xlZ2FjeV9yZXN1bWVfZWFybHkoc3RydWN0IGRldmljZSAqZGV2KQogewotCXN0cnVjdCBw
bGF0Zm9ybV9kcml2ZXIgKmRydiA9IHRvX3BsYXRmb3JtX2RyaXZlcihkZXYtPmRyaXZlcik7Ci0J
c3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldjsKKwlzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyICpw
ZHJ2ID0gdG9fcGxhdGZvcm1fZHJpdmVyKGRldi0+ZHJpdmVyKTsKKwlzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpwZGV2ID0gdG9fcGxhdGZvcm1fZGV2aWNlKGRldik7CiAJaW50IHJldCA9IDA7CiAK
LQlwZGV2ID0gY29udGFpbmVyX29mKGRldiwgc3RydWN0IHBsYXRmb3JtX2RldmljZSwgZGV2KTsK
LQlpZiAoZGV2LT5kcml2ZXIgJiYgZHJ2LT5yZXN1bWVfZWFybHkpCi0JCXJldCA9IGRydi0+cmVz
dW1lX2Vhcmx5KHBkZXYpOworCWlmIChkZXYtPmRyaXZlciAmJiBwZHJ2LT5yZXN1bWVfZWFybHkp
CisJCXJldCA9IHBkcnYtPnJlc3VtZV9lYXJseShwZGV2KTsKIAogCXJldHVybiByZXQ7CiB9CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL2Zsb3BweS5jIGIvZHJpdmVycy9ibG9jay9mbG9wcHku
YwppbmRleCBjZjI5Y2M0Li45YzNjNWM3IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jsb2NrL2Zsb3Bw
eS5jCisrKyBiL2RyaXZlcnMvYmxvY2svZmxvcHB5LmMKQEAgLTQxMzMsMTAgKzQxMzMsOSBAQCBz
dGF0aWMgaW50IGhhdmVfbm9fZmRjID0gLUVOT0RFVjsKIHN0YXRpYyBzc2l6ZV90IGZsb3BweV9j
bW9zX3Nob3coc3RydWN0IGRldmljZSAqZGV2LAogCQkJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRl
ICphdHRyLCBjaGFyICpidWYpCiB7Ci0Jc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcDsKKwlzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpwID0gdG9fcGxhdGZvcm1fZGV2aWNlKGRldik7CiAJaW50IGRy
aXZlOwogCi0JcCA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UsZGV2
KTsKIAlkcml2ZSA9IHAtPmlkOwogCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVYXG4iLCBVRFAtPmNt
b3MpOwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pc2RuL2dpZ2FzZXQvc2VyLWdpZ2FzZXQuYyBi
L2RyaXZlcnMvaXNkbi9naWdhc2V0L3Nlci1naWdhc2V0LmMKaW5kZXggYWMyNDVlNy4uMzA3MWE1
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9pc2RuL2dpZ2FzZXQvc2VyLWdpZ2FzZXQuYworKysgYi9k
cml2ZXJzL2lzZG4vZ2lnYXNldC9zZXItZ2lnYXNldC5jCkBAIC0zODksOCArMzg5LDcgQEAgc3Rh
dGljIHZvaWQgZ2lnYXNldF9mcmVlY3NodyhzdHJ1Y3QgY2FyZHN0YXRlICpjcykKIAogc3RhdGlj
IHZvaWQgZ2lnYXNldF9kZXZpY2VfcmVsZWFzZShzdHJ1Y3QgZGV2aWNlICpkZXYpCiB7Ci0Jc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiA9Ci0JCWNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBw
bGF0Zm9ybV9kZXZpY2UsIGRldik7CisJc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiA9IHRv
X3BsYXRmb3JtX2RldmljZShkZXYpOwogCiAJLyogYWRhcHRlZCBmcm9tIHBsYXRmb3JtX2Rldmlj
ZV9yZWxlYXNlKCkgaW4gZHJpdmVycy9iYXNlL3BsYXRmb3JtLmMgKi8KIAkvL0ZJWE1FIGlzIHRo
aXMgYWN0dWFsbHkgbmVjZXNzYXJ5PwotLSAKMS42LjAuNAoK
------=_Part_14141_4779847.1231512417220--
