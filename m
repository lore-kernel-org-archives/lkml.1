Return-Path: <linux-kernel-owner+w=401wt.eu-S1764684AbXEWAdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764684AbXEWAdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbXEWAdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:33:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:15154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369AbXEWAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=JxEbxKMIZM5hZn/a9kmapS1JsWDEC3FV0NAtjYeqdVw2UsdZJhLwKV0+nzNCZOXjaJEjuekdaLp5GaynawlCPULsRBvrBaXI8UxQcSGVdcnLlpH3DaoNpWA6Gi1AcvzsawSzptkwEeK4Eu/65xA5yZ8Xvp7plm/YVL4eLkv3nGw=
Message-ID: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
Date: Wed, 23 May 2007 01:33:14 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] joydev.c automatic re-calibration
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_72343_26917240.1179880394408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_72343_26917240.1179880394408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This small patch adds the automatic recalibration feature without
spoiling previously calibrated devices. It's a fix for those joysticks
that report faulty range, specially Saitek Cyborg Evo Force.

File: drivers/input/joydev.c
Fix:
 - extracted code from joydev_connect to method
joydev_calculate_correction to be able to call it from both
joydev_event upon recalibration and joydev_connect during first
connection.
 - on joydev_connect check ranges and zero calibration if found out of range
 - on joydev_event, every time found out of range, update min/max and
recalculate the correction

Patch below and attached.

cheers,
--renato

== PATCH BEGIN ==

--- joydev.c.original   2007-05-22 22:23:43.000000000 +0100
+++ joydev.c    2007-05-23 01:24:04.000000000 +0100
@@ -53,6 +53,8 @@
        __u8 absmap[ABS_MAX + 1];
        __u8 abspam[ABS_MAX + 1];
        __s16 abs[ABS_MAX + 1];
+       __s16 absmin[ABS_MAX + 1];
+       __s16 absmax[ABS_MAX + 1];
 };

 struct joydev_list {
@@ -67,6 +69,19 @@

 static struct joydev *joydev_table[JOYDEV_MINORS];

+static void joydev_calculate_correction(int min, int max, int axis,
struct joydev *joydev)
+{
+       int t, j = joydev->abspam[axis];
+       int flat = joydev->handle.dev->absflat[j];
+
+       joydev->corr[axis].coef[0] = (max + min) / 2 - flat;
+       joydev->corr[axis].coef[1] = (max + min) / 2 + flat;
+       if (!(t = ((max - min) / 2 - 2 * flat)))
+               return;
+       joydev->corr[axis].coef[2] = (1 << 29) / t;
+       joydev->corr[axis].coef[3] = (1 << 29) / t;
+}
+
 static int joydev_correct(int value, struct js_corr *corr)
 {
        switch (corr->type) {
@@ -103,6 +118,14 @@
                case EV_ABS:
                        event.type = JS_EVENT_AXIS;
                        event.number = joydev->absmap[code];
+                       /* recalibration if needed */
+                       if (value < joydev->absmin[code]) {
+                               joydev->absmin[code] = value;
+                               joydev_calculate_correction(value,
joydev->absmax[code], code, joydev);
+                       } else if (value > joydev->absmax[code]) {
+                               joydev->absmax[code] = value;
+
joydev_calculate_correction(joydev->absmin[code], value, code,
joydev);
+                       }
                        event.value = joydev_correct(value,
joydev->corr + event.number);
                        if (event.value == joydev->abs[event.number])
                                return;
@@ -470,7 +493,7 @@
 {
        struct joydev *joydev;
        struct class_device *cdev;
-       int i, j, t, minor;
+       int i, j, minor;

        for (minor = 0; minor < JOYDEV_MINORS && joydev_table[minor]; minor++);
        if (minor == JOYDEV_MINORS) {
@@ -515,19 +538,21 @@

        for (i = 0; i < joydev->nabs; i++) {
                j = joydev->abspam[i];
-               if (dev->absmax[j] == dev->absmin[j]) {
+               joydev->absmin[i] = dev->absmin[j];
+               joydev->absmax[i] = dev->absmax[j];
+               if (joydev->absmax[i] == joydev->absmin[i]) {
                        joydev->corr[i].type = JS_CORR_NONE;
                        joydev->abs[i] = dev->abs[j];
                        continue;
                }
                joydev->corr[i].type = JS_CORR_BROKEN;
                joydev->corr[i].prec = dev->absfuzz[j];
-               joydev->corr[i].coef[0] = (dev->absmax[j] +
dev->absmin[j]) / 2 - dev->absflat[j];
-               joydev->corr[i].coef[1] = (dev->absmax[j] +
dev->absmin[j]) / 2 + dev->absflat[j];
-               if (!(t = ((dev->absmax[j] - dev->absmin[j]) / 2 - 2 *
dev->absflat[j])))
-                       continue;
-               joydev->corr[i].coef[2] = (1 << 29) / t;
-               joydev->corr[i].coef[3] = (1 << 29) / t;
+
+               if (dev->abs[j] > joydev->absmax[i] || dev->abs[j] <
joydev->absmin[i]) {
+                       printk("Joydev: Bad axis range, recalibrating
automatically\n");
+                       joydev_calculate_correction(0, 0, i, joydev);
+               } else
+                       joydev_calculate_correction(joydev->absmin[i],
joydev->absmax[i], i, joydev);

                joydev->abs[i] = joydev_correct(dev->abs[j], joydev->corr + i);
        }

== PATCH END ==

------=_Part_72343_26917240.1179880394408
Content-Type: text/x-patch; name=joydev.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2122uho
Content-Disposition: attachment; filename="joydev.patch"

LS0tIGpveWRldi5jLm9yaWdpbmFsCTIwMDctMDUtMjIgMjI6MjM6NDMuMDAwMDAwMDAwICswMTAw
CisrKyBqb3lkZXYuYwkyMDA3LTA1LTIzIDAxOjI0OjA0LjAwMDAwMDAwMCArMDEwMApAQCAtNTMs
NiArNTMsOCBAQAogCV9fdTggYWJzbWFwW0FCU19NQVggKyAxXTsKIAlfX3U4IGFic3BhbVtBQlNf
TUFYICsgMV07CiAJX19zMTYgYWJzW0FCU19NQVggKyAxXTsKKwlfX3MxNiBhYnNtaW5bQUJTX01B
WCArIDFdOworCV9fczE2IGFic21heFtBQlNfTUFYICsgMV07CiB9OwogCiBzdHJ1Y3Qgam95ZGV2
X2xpc3QgewpAQCAtNjcsNiArNjksMTkgQEAKIAogc3RhdGljIHN0cnVjdCBqb3lkZXYgKmpveWRl
dl90YWJsZVtKT1lERVZfTUlOT1JTXTsKIAorc3RhdGljIHZvaWQgam95ZGV2X2NhbGN1bGF0ZV9j
b3JyZWN0aW9uKGludCBtaW4sIGludCBtYXgsIGludCBheGlzLCBzdHJ1Y3Qgam95ZGV2ICpqb3lk
ZXYpCit7CisJaW50IHQsIGogPSBqb3lkZXYtPmFic3BhbVtheGlzXTsKKwlpbnQgZmxhdCA9IGpv
eWRldi0+aGFuZGxlLmRldi0+YWJzZmxhdFtqXTsKKworCWpveWRldi0+Y29ycltheGlzXS5jb2Vm
WzBdID0gKG1heCArIG1pbikgLyAyIC0gZmxhdDsKKwlqb3lkZXYtPmNvcnJbYXhpc10uY29lZlsx
XSA9IChtYXggKyBtaW4pIC8gMiArIGZsYXQ7CisJaWYgKCEodCA9ICgobWF4IC0gbWluKSAvIDIg
LSAyICogZmxhdCkpKQorCQlyZXR1cm47CisJam95ZGV2LT5jb3JyW2F4aXNdLmNvZWZbMl0gPSAo
MSA8PCAyOSkgLyB0OworCWpveWRldi0+Y29ycltheGlzXS5jb2VmWzNdID0gKDEgPDwgMjkpIC8g
dDsKK30KKwogc3RhdGljIGludCBqb3lkZXZfY29ycmVjdChpbnQgdmFsdWUsIHN0cnVjdCBqc19j
b3JyICpjb3JyKQogewogCXN3aXRjaCAoY29yci0+dHlwZSkgewpAQCAtMTAzLDYgKzExOCwxNCBA
QAogCQljYXNlIEVWX0FCUzoKIAkJCWV2ZW50LnR5cGUgPSBKU19FVkVOVF9BWElTOwogCQkJZXZl
bnQubnVtYmVyID0gam95ZGV2LT5hYnNtYXBbY29kZV07CisJCQkvKiByZWNhbGlicmF0aW9uIGlm
IG5lZWRlZCAqLworCQkJaWYgKHZhbHVlIDwgam95ZGV2LT5hYnNtaW5bY29kZV0pIHsKKwkJCQlq
b3lkZXYtPmFic21pbltjb2RlXSA9IHZhbHVlOworCQkJCWpveWRldl9jYWxjdWxhdGVfY29ycmVj
dGlvbih2YWx1ZSwgam95ZGV2LT5hYnNtYXhbY29kZV0sIGNvZGUsIGpveWRldik7CisJCQl9IGVs
c2UgaWYgKHZhbHVlID4gam95ZGV2LT5hYnNtYXhbY29kZV0pIHsKKwkJCQlqb3lkZXYtPmFic21h
eFtjb2RlXSA9IHZhbHVlOworCQkJCWpveWRldl9jYWxjdWxhdGVfY29ycmVjdGlvbihqb3lkZXYt
PmFic21pbltjb2RlXSwgdmFsdWUsIGNvZGUsIGpveWRldik7CisJCQl9CiAJCQlldmVudC52YWx1
ZSA9IGpveWRldl9jb3JyZWN0KHZhbHVlLCBqb3lkZXYtPmNvcnIgKyBldmVudC5udW1iZXIpOwog
CQkJaWYgKGV2ZW50LnZhbHVlID09IGpveWRldi0+YWJzW2V2ZW50Lm51bWJlcl0pCiAJCQkJcmV0
dXJuOwpAQCAtNDcwLDcgKzQ5Myw3IEBACiB7CiAJc3RydWN0IGpveWRldiAqam95ZGV2OwogCXN0
cnVjdCBjbGFzc19kZXZpY2UgKmNkZXY7Ci0JaW50IGksIGosIHQsIG1pbm9yOworCWludCBpLCBq
LCBtaW5vcjsKIAogCWZvciAobWlub3IgPSAwOyBtaW5vciA8IEpPWURFVl9NSU5PUlMgJiYgam95
ZGV2X3RhYmxlW21pbm9yXTsgbWlub3IrKyk7CiAJaWYgKG1pbm9yID09IEpPWURFVl9NSU5PUlMp
IHsKQEAgLTUxNSwxOSArNTM4LDIxIEBACiAKIAlmb3IgKGkgPSAwOyBpIDwgam95ZGV2LT5uYWJz
OyBpKyspIHsKIAkJaiA9IGpveWRldi0+YWJzcGFtW2ldOwotCQlpZiAoZGV2LT5hYnNtYXhbal0g
PT0gZGV2LT5hYnNtaW5bal0pIHsKKwkJam95ZGV2LT5hYnNtaW5baV0gPSBkZXYtPmFic21pbltq
XTsKKwkJam95ZGV2LT5hYnNtYXhbaV0gPSBkZXYtPmFic21heFtqXTsKKwkJaWYgKGpveWRldi0+
YWJzbWF4W2ldID09IGpveWRldi0+YWJzbWluW2ldKSB7CiAJCQlqb3lkZXYtPmNvcnJbaV0udHlw
ZSA9IEpTX0NPUlJfTk9ORTsKIAkJCWpveWRldi0+YWJzW2ldID0gZGV2LT5hYnNbal07CiAJCQlj
b250aW51ZTsKIAkJfQogCQlqb3lkZXYtPmNvcnJbaV0udHlwZSA9IEpTX0NPUlJfQlJPS0VOOwog
CQlqb3lkZXYtPmNvcnJbaV0ucHJlYyA9IGRldi0+YWJzZnV6eltqXTsKLQkJam95ZGV2LT5jb3Jy
W2ldLmNvZWZbMF0gPSAoZGV2LT5hYnNtYXhbal0gKyBkZXYtPmFic21pbltqXSkgLyAyIC0gZGV2
LT5hYnNmbGF0W2pdOwotCQlqb3lkZXYtPmNvcnJbaV0uY29lZlsxXSA9IChkZXYtPmFic21heFtq
XSArIGRldi0+YWJzbWluW2pdKSAvIDIgKyBkZXYtPmFic2ZsYXRbal07Ci0JCWlmICghKHQgPSAo
KGRldi0+YWJzbWF4W2pdIC0gZGV2LT5hYnNtaW5bal0pIC8gMiAtIDIgKiBkZXYtPmFic2ZsYXRb
al0pKSkKLQkJCWNvbnRpbnVlOwotCQlqb3lkZXYtPmNvcnJbaV0uY29lZlsyXSA9ICgxIDw8IDI5
KSAvIHQ7Ci0JCWpveWRldi0+Y29ycltpXS5jb2VmWzNdID0gKDEgPDwgMjkpIC8gdDsKKworCQlp
ZiAoZGV2LT5hYnNbal0gPiBqb3lkZXYtPmFic21heFtpXSB8fCBkZXYtPmFic1tqXSA8IGpveWRl
di0+YWJzbWluW2ldKSB7CisJCQlwcmludGsoIkpveWRldjogQmFkIGF4aXMgcmFuZ2UsIHJlY2Fs
aWJyYXRpbmcgYXV0b21hdGljYWxseVxuIik7CisJCQlqb3lkZXZfY2FsY3VsYXRlX2NvcnJlY3Rp
b24oMCwgMCwgaSwgam95ZGV2KTsKKwkJfSBlbHNlCisJCQlqb3lkZXZfY2FsY3VsYXRlX2NvcnJl
Y3Rpb24oam95ZGV2LT5hYnNtaW5baV0sIGpveWRldi0+YWJzbWF4W2ldLCBpLCBqb3lkZXYpOwog
CiAJCWpveWRldi0+YWJzW2ldID0gam95ZGV2X2NvcnJlY3QoZGV2LT5hYnNbal0sIGpveWRldi0+
Y29yciArIGkpOwogCX0K
------=_Part_72343_26917240.1179880394408--
