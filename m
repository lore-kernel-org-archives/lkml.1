Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbYKTPBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbYKTPBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbYKTOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:47:30 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:55907 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbYKTOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:47:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=bzBgRaE1/OnuYAG7KgMT73dKyeCG+hPXqf58z7GWGbd90mhIKT89NibdnPfdOImCTx
         azkBiek2FmUPyrXe15grf4sJkv2JU7OOtvN1gyEFA+0PVzwHdpPAgJuIMONGGtocRudN
         LGDuE9ya7YLDJdAyW7V7CpuoMgNWQ8RAQpn58=
Message-ID: <87a5b0800811200647i69360d29v8304e290c9fd9cf0@mail.gmail.com>
Date: Thu, 20 Nov 2008 14:47:26 +0000
From: "Will Newton" <will.newton@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char/tty_io.c: Avoid panic when no console is configured.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_71200_14691654.1227192446134"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_71200_14691654.1227192446134
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When no console is configured tty_open tries to call kref_get on a NULL
pointer, return ENODEV instead.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/char/tty_io.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 59f4721..1412a8d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1795,12 +1795,15 @@ retry_open:
 	}
 #endif
 	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
-		driver = tty_driver_kref_get(console_device(&index));
-		if (driver) {
-			/* Don't let /dev/console block */
-			filp->f_flags |= O_NONBLOCK;
-			noctty = 1;
-			goto got_driver;
+		struct tty_driver *console_driver = console_device(&index);
+		if (console_driver) {
+			driver = tty_driver_kref_get(console_driver);
+			if (driver) {
+				/* Don't let /dev/console block */
+				filp->f_flags |= O_NONBLOCK;
+				noctty = 1;
+				goto got_driver;
+			}
 		}
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
-- 
1.5.5.2

------=_Part_71200_14691654.1227192446134
Content-Type: text/x-patch;
 name=0001-drivers-char-tty_io.c-Avoid-panic-when-no-console-i.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnrinb8d0
Content-Disposition: attachment;
 filename=0001-drivers-char-tty_io.c-Avoid-panic-when-no-console-i.patch

RnJvbSA1MjM5OWQ0ZGRiZTkyMDg3NDAwOWNmNGRmZjgwYThiMDhiMDcxMTY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBUaHUsIDIwIE5vdiAyMDA4IDE0OjE5OjA1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gZHJp
dmVycy9jaGFyL3R0eV9pby5jOiBBdm9pZCBwYW5pYyB3aGVuIG5vIGNvbnNvbGUgaXMgY29uZmln
dXJlZC4KCldoZW4gbm8gY29uc29sZSBpcyBjb25maWd1cmVkIHR0eV9vcGVuIHRyaWVzIHRvIGNh
bGwga3JlZl9nZXQgb24gYSBOVUxMCnBvaW50ZXIsIHJldHVybiBFTk9ERVYgaW5zdGVhZC4KClNp
Z25lZC1vZmYtYnk6IFdpbGwgTmV3dG9uIDx3aWxsLm5ld3RvbkBnbWFpbC5jb20+Ci0tLQogZHJp
dmVycy9jaGFyL3R0eV9pby5jIHwgICAxNSArKysrKysrKystLS0tLS0KIDEgZmlsZXMgY2hhbmdl
ZCwgOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y2hhci90dHlfaW8uYyBiL2RyaXZlcnMvY2hhci90dHlfaW8uYwppbmRleCA1OWY0NzIxLi4xNDEy
YThkIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NoYXIvdHR5X2lvLmMKKysrIGIvZHJpdmVycy9jaGFy
L3R0eV9pby5jCkBAIC0xNzk1LDEyICsxNzk1LDE1IEBAIHJldHJ5X29wZW46CiAJfQogI2VuZGlm
CiAJaWYgKGRldmljZSA9PSBNS0RFVihUVFlBVVhfTUFKT1IsIDEpKSB7Ci0JCWRyaXZlciA9IHR0
eV9kcml2ZXJfa3JlZl9nZXQoY29uc29sZV9kZXZpY2UoJmluZGV4KSk7Ci0JCWlmIChkcml2ZXIp
IHsKLQkJCS8qIERvbid0IGxldCAvZGV2L2NvbnNvbGUgYmxvY2sgKi8KLQkJCWZpbHAtPmZfZmxh
Z3MgfD0gT19OT05CTE9DSzsKLQkJCW5vY3R0eSA9IDE7Ci0JCQlnb3RvIGdvdF9kcml2ZXI7CisJ
CXN0cnVjdCB0dHlfZHJpdmVyICpjb25zb2xlX2RyaXZlciA9IGNvbnNvbGVfZGV2aWNlKCZpbmRl
eCk7CisJCWlmIChjb25zb2xlX2RyaXZlcikgeworCQkJZHJpdmVyID0gdHR5X2RyaXZlcl9rcmVm
X2dldChjb25zb2xlX2RyaXZlcik7CisJCQlpZiAoZHJpdmVyKSB7CisJCQkJLyogRG9uJ3QgbGV0
IC9kZXYvY29uc29sZSBibG9jayAqLworCQkJCWZpbHAtPmZfZmxhZ3MgfD0gT19OT05CTE9DSzsK
KwkJCQlub2N0dHkgPSAxOworCQkJCWdvdG8gZ290X2RyaXZlcjsKKwkJCX0KIAkJfQogCQltdXRl
eF91bmxvY2soJnR0eV9tdXRleCk7CiAJCXJldHVybiAtRU5PREVWOwotLSAKMS41LjUuMgoK
------=_Part_71200_14691654.1227192446134--
