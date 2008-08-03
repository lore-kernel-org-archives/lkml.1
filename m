Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYHCHW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYHCHW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYHCHWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:22:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:57365 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYHCHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=XCNZVR6vNePE3eIrcQbtDFrCXCyXTa+DEZutfT7gOZc2S/+89dQ/pF/weKrnFFCybu
         3gJNbKYaAR8YArgHneyrYSXy4glcLt4hW7ajshwox+E1f477nXjntI21elfx8S2HiaTr
         ViWaIFzg6DKdFHUtRvS3NtJ7HEikJeLHWf7jI=
Message-ID: <82e4877d0808030022l796d12e6x92256550eebd4760@mail.gmail.com>
Date: Sun, 3 Aug 2008 03:22:16 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix Bug #11231: gspca_zc3xx oops - 2.6.27-rc1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "akpm@osdl.org" <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       mxhaard@users.sourceforge.net
In-Reply-To: <200808030313.07227.parag.warudkar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_21110_8685755.1217748136082"
References: <200808030313.07227.parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_21110_8685755.1217748136082
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[Resend - previous one bounced from vger due to HTML ]

This patch fixes couple of NULL pointer dereferences in zc3xx .
Without this patch my machine oopses as soon as I open Kopete-kde4 .
Patch tested to work fine (no detectable differences in image rendered
by camera - as crappy as ever, no more oopses ;) on x86 with a
Creative Webcam Notebook.

OOPS Analysis
-------------------
http://marc.info/?l=linux-kernel&m=121769418920774&w=4

4575.306109] Code: 83 ec 04 0f b6 90 da 07 00 00 8b a8 04 02 00 00 0f
b6 80 d9 07 00 00 8b 3c 95 f4 dc 15 f9 8b 14 95 d8 dc 15 f9 83 c0 80
89 14 24 <0f> b6 37 0f af f0 8d b6 00 00 00 00 0f b6 83 00 dc 15 f9 0f
af
[ 4575.306133] EIP: [<f915c2d4>] setcontrast+0x34/0xf0 [gspca_zc3xx]
SS:ESP 0068:da81bd64

Which corresponds to -

1374: 0f b6 37 movzbl (%edi),%esi
--^^-- Faulting instruction
1377: 0f af f0 imul %eax,%esi
137a: 8d b6 00 00 00 00 lea 0x0(%esi),%esi

That is this code in zc3xx.c -
k = (sd->contrast - 128) /* -128 / 128 */
                    * Tgamma[0];

Where Tgamma = gamma_tb[sd->gamma];

For sd->gamma=0 Tgamma is NULL -

static const __u8 *gamma_tb[] = {
NULL, ...

Kopete seems to trigger the zero gamma on ioctl and we happily oops in
that case .
Fix this by detecting the zero gamma case while trying to preserve
intended effect of zero gamma .
On reviewing the code, the exact same problem exists for Tgradient
where it is dereferenced when NULL. Fix that too.

Patch also attached.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/media/video/gspca/zc3xx.c	2008-07-29
23:26:21.000000000 -0400
+++ linux-2.6-wk/drivers/media/video/gspca/zc3xx.c	2008-08-03
02:17:29.000000000 -0400
@@ -6476,12 +6476,15 @@
 	Tgamma = gamma_tb[sd->gamma];
 	Tgradient = gradient_tb[sd->gamma];

-	k = (sd->contrast - 128)		/* -128 / 128 */
+	if(!Tgamma)
+		k = 0;
+	else
+		k = (sd->contrast - 128)		/* -128 / 128 */
 			* Tgamma[0];
 	PDEBUG(D_CONF, "gamma:%d contrast:%d gamma coeff: %d/128",
 		sd->gamma, sd->contrast, k);
 	for (i = 0; i < 16; i++) {
-		g = Tgamma[i] + kgamma_tb[i] * k / 128;
+		g = (Tgamma ? Tgamma[i] : 0) + kgamma_tb[i] * k / 128;
 		if (g > 0xff)
 			g = 0xff;
 		else if (g <= 0)
@@ -6497,7 +6500,7 @@
 	PDEBUG(D_CONF, "    %02x %02x %02x %02x %02x %02x %02x %02x",
 		v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15]);
 	for (i = 0; i < 16; i++) {
-		g = Tgradient[i] - kgrad_tb[i] * k / 128;
+		g = (Tgradient ? Tgradient[i] : 0) - kgrad_tb[i] * k / 128;
 		if (g > 0xff)
 			g = 0xff;
 		else if (g <= 0) {

------=_Part_21110_8685755.1217748136082
Content-Type: text/x-diff; name=gspca-zc3xx.c.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjfbqc4z0
Content-Disposition: attachment; filename=gspca-zc3xx.c.patch

LS0tIGxpbnV4LTIuNi9kcml2ZXJzL21lZGlhL3ZpZGVvL2dzcGNhL3pjM3h4LmMJMjAwOC0wNy0y
OSAyMzoyNjoyMS4wMDAwMDAwMDAgLTA0MDAKKysrIGxpbnV4LTIuNi13ay9kcml2ZXJzL21lZGlh
L3ZpZGVvL2dzcGNhL3pjM3h4LmMJMjAwOC0wOC0wMyAwMjoxNzoyOS4wMDAwMDAwMDAgLTA0MDAK
QEAgLTY0NzYsMTIgKzY0NzYsMTUgQEAKIAlUZ2FtbWEgPSBnYW1tYV90YltzZC0+Z2FtbWFdOwog
CVRncmFkaWVudCA9IGdyYWRpZW50X3RiW3NkLT5nYW1tYV07CiAKLQlrID0gKHNkLT5jb250cmFz
dCAtIDEyOCkJCS8qIC0xMjggLyAxMjggKi8KKwlpZighVGdhbW1hKQorCQlrID0gMDsKKwllbHNl
CisJCWsgPSAoc2QtPmNvbnRyYXN0IC0gMTI4KQkJLyogLTEyOCAvIDEyOCAqLwogCQkJKiBUZ2Ft
bWFbMF07CiAJUERFQlVHKERfQ09ORiwgImdhbW1hOiVkIGNvbnRyYXN0OiVkIGdhbW1hIGNvZWZm
OiAlZC8xMjgiLAogCQlzZC0+Z2FtbWEsIHNkLT5jb250cmFzdCwgayk7CiAJZm9yIChpID0gMDsg
aSA8IDE2OyBpKyspIHsKLQkJZyA9IFRnYW1tYVtpXSArIGtnYW1tYV90YltpXSAqIGsgLyAxMjg7
CisJCWcgPSAoVGdhbW1hID8gVGdhbW1hW2ldIDogMCkgKyBrZ2FtbWFfdGJbaV0gKiBrIC8gMTI4
OwogCQlpZiAoZyA+IDB4ZmYpCiAJCQlnID0gMHhmZjsKIAkJZWxzZSBpZiAoZyA8PSAwKQpAQCAt
NjQ5Nyw3ICs2NTAwLDcgQEAKIAlQREVCVUcoRF9DT05GLCAiICAgICUwMnggJTAyeCAlMDJ4ICUw
MnggJTAyeCAlMDJ4ICUwMnggJTAyeCIsCiAJCXZbOF0sIHZbOV0sIHZbMTBdLCB2WzExXSwgdlsx
Ml0sIHZbMTNdLCB2WzE0XSwgdlsxNV0pOwogCWZvciAoaSA9IDA7IGkgPCAxNjsgaSsrKSB7Ci0J
CWcgPSBUZ3JhZGllbnRbaV0gLSBrZ3JhZF90YltpXSAqIGsgLyAxMjg7CisJCWcgPSAoVGdyYWRp
ZW50ID8gVGdyYWRpZW50W2ldIDogMCkgLSBrZ3JhZF90YltpXSAqIGsgLyAxMjg7CiAJCWlmIChn
ID4gMHhmZikKIAkJCWcgPSAweGZmOwogCQllbHNlIGlmIChnIDw9IDApIHsK
------=_Part_21110_8685755.1217748136082--
