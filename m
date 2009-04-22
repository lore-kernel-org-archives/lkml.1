Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZDVUTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZDVUTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZDVUTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:19:21 -0400
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:56415 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752577AbZDVUTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:19:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9C387.9347B703"
Subject: RE: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Date: Wed, 22 Apr 2009 16:18:59 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165F065@mi8nycmail19.Mi8.com>
In-Reply-To: <20090422174212.GA18564@kroah.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Thread-Index: AcnDcjmLKJBBGbvxSSuGQ8tvtKO/bAAFFNVA
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com> <20090422055327.GF9009@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com> <20090422174212.GA18564@kroah.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2009 20:19:17.0264 (UTC) FILETIME=[9CA21900:01C9C387]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9C387.9347B703
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Fix sparse warnings in drivers/usb/host/ohci-hcd.c.

Four of the following sparse warning are seen when building on
ARM due do the macro raw_local_irq_save():

	warning: symbol 'temp' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

Patch is also attached in case of line-wrapping.


diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 25db704..7635acf 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -571,7 +571,7 @@ static int ohci_init (struct ohci_hcd *ohci)
  */
 static int ohci_run (struct ohci_hcd *ohci)
 {
-	u32			mask, temp;
+	u32			mask, val;
 	int			first =3D ohci->fminterval =3D=3D 0;
 	struct usb_hcd		*hcd =3D ohci_to_hcd(ohci);
=20
@@ -580,8 +580,8 @@ static int ohci_run (struct ohci_hcd *ohci)
 	/* boot firmware should have set this up (5.1.1.3.1) */
 	if (first) {
=20
-		temp =3D ohci_readl (ohci, &ohci->regs->fminterval);
-		ohci->fminterval =3D temp & 0x3fff;
+		val =3D ohci_readl (ohci, &ohci->regs->fminterval);
+		ohci->fminterval =3D val & 0x3fff;
 		if (ohci->fminterval !=3D FI)
 			ohci_dbg (ohci, "fminterval delta %d\n",
 				ohci->fminterval - FI);
@@ -600,25 +600,25 @@ static int ohci_run (struct ohci_hcd *ohci)
=20
 	switch (ohci->hc_control & OHCI_CTRL_HCFS) {
 	case OHCI_USB_OPER:
-		temp =3D 0;
+		val =3D 0;
 		break;
 	case OHCI_USB_SUSPEND:
 	case OHCI_USB_RESUME:
 		ohci->hc_control &=3D OHCI_CTRL_RWC;
 		ohci->hc_control |=3D OHCI_USB_RESUME;
-		temp =3D 10 /* msec wait */;
+		val =3D 10 /* msec wait */;
 		break;
 	// case OHCI_USB_RESET:
 	default:
 		ohci->hc_control &=3D OHCI_CTRL_RWC;
 		ohci->hc_control |=3D OHCI_USB_RESET;
-		temp =3D 50 /* msec wait */;
+		val =3D 50 /* msec wait */;
 		break;
 	}
 	ohci_writel (ohci, ohci->hc_control, &ohci->regs->control);
 	// flush the writes
 	(void) ohci_readl (ohci, &ohci->regs->control);
-	msleep(temp);
+	msleep(val);
=20
 	memset (ohci->hcca, 0, sizeof (struct ohci_hcca));
=20
@@ -628,9 +628,9 @@ static int ohci_run (struct ohci_hcd *ohci)
 retry:
 	/* HC Reset requires max 10 us delay */
 	ohci_writel (ohci, OHCI_HCR,  &ohci->regs->cmdstatus);
-	temp =3D 30;	/* ... allow extra time */
+	val =3D 30;	/* ... allow extra time */
 	while ((ohci_readl (ohci, &ohci->regs->cmdstatus) & OHCI_HCR) !=3D
0) {
-		if (--temp =3D=3D 0) {
+		if (--val =3D=3D 0) {
 			spin_unlock_irq (&ohci->lock);
 			ohci_err (ohci, "USB HC reset timed out!\n");
 			return -1;
@@ -699,23 +699,23 @@ retry:
 	ohci_writel (ohci, mask, &ohci->regs->intrenable);
=20
 	/* handle root hub init quirks ... */
-	temp =3D roothub_a (ohci);
-	temp &=3D ~(RH_A_PSM | RH_A_OCPM);
+	val =3D roothub_a (ohci);
+	val &=3D ~(RH_A_PSM | RH_A_OCPM);
 	if (ohci->flags & OHCI_QUIRK_SUPERIO) {
 		/* NSC 87560 and maybe others */
-		temp |=3D RH_A_NOCP;
-		temp &=3D ~(RH_A_POTPGT | RH_A_NPS);
-		ohci_writel (ohci, temp, &ohci->regs->roothub.a);
+		val |=3D RH_A_NOCP;
+		val &=3D ~(RH_A_POTPGT | RH_A_NPS);
+		ohci_writel (ohci, val, &ohci->regs->roothub.a);
 	} else if ((ohci->flags & OHCI_QUIRK_AMD756) ||
 			(ohci->flags & OHCI_QUIRK_HUB_POWER)) {
 		/* hub power always on; required for AMD-756 and some
 		 * Mac platforms.  ganged overcurrent reporting, if any.
 		 */
-		temp |=3D RH_A_NPS;
-		ohci_writel (ohci, temp, &ohci->regs->roothub.a);
+		val |=3D RH_A_NPS;
+		ohci_writel (ohci, val, &ohci->regs->roothub.a);
 	}
 	ohci_writel (ohci, RH_HS_LPSC, &ohci->regs->roothub.status);
-	ohci_writel (ohci, (temp & RH_A_NPS) ? 0 : RH_B_PPCM,
+	ohci_writel (ohci, (val & RH_A_NPS) ? 0 : RH_B_PPCM,
 						&ohci->regs->roothub.b);
 	// flush those writes
 	(void) ohci_readl (ohci, &ohci->regs->control);
@@ -724,7 +724,7 @@ retry:
 	spin_unlock_irq (&ohci->lock);
=20
 	// POTPGT delay is bits 24-31, in 2 ms units.
-	mdelay ((temp >> 23) & 0x1fe);
+	mdelay ((val >> 23) & 0x1fe);
 	hcd->state =3D HC_STATE_RUNNING;
=20
 	if (quirk_zfmicro(ohci)) {=20

------_=_NextPart_001_01C9C387.9347B703
Content-Type: application/octet-stream;
	name="usb_host_ohci-hcd_c_sparse.patch"
Content-Transfer-Encoding: base64
Content-Description: usb_host_ohci-hcd_c_sparse.patch
Content-Disposition: attachment;
	filename="usb_host_ohci-hcd_c_sparse.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3Qvb2hjaS1oY2QuYyBiL2RyaXZlcnMvdXNiL2hv
c3Qvb2hjaS1oY2QuYwppbmRleCAyNWRiNzA0Li43NjM1YWNmIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3VzYi9ob3N0L29oY2ktaGNkLmMKKysrIGIvZHJpdmVycy91c2IvaG9zdC9vaGNpLWhjZC5jCkBA
IC01NzEsNyArNTcxLDcgQEAgc3RhdGljIGludCBvaGNpX2luaXQgKHN0cnVjdCBvaGNpX2hjZCAq
b2hjaSkKICAqLwogc3RhdGljIGludCBvaGNpX3J1biAoc3RydWN0IG9oY2lfaGNkICpvaGNpKQog
ewotCXUzMgkJCW1hc2ssIHRlbXA7CisJdTMyCQkJbWFzaywgdmFsOwogCWludAkJCWZpcnN0ID0g
b2hjaS0+Zm1pbnRlcnZhbCA9PSAwOwogCXN0cnVjdCB1c2JfaGNkCQkqaGNkID0gb2hjaV90b19o
Y2Qob2hjaSk7CiAKQEAgLTU4MCw4ICs1ODAsOCBAQCBzdGF0aWMgaW50IG9oY2lfcnVuIChzdHJ1
Y3Qgb2hjaV9oY2QgKm9oY2kpCiAJLyogYm9vdCBmaXJtd2FyZSBzaG91bGQgaGF2ZSBzZXQgdGhp
cyB1cCAoNS4xLjEuMy4xKSAqLwogCWlmIChmaXJzdCkgewogCi0JCXRlbXAgPSBvaGNpX3JlYWRs
IChvaGNpLCAmb2hjaS0+cmVncy0+Zm1pbnRlcnZhbCk7Ci0JCW9oY2ktPmZtaW50ZXJ2YWwgPSB0
ZW1wICYgMHgzZmZmOworCQl2YWwgPSBvaGNpX3JlYWRsIChvaGNpLCAmb2hjaS0+cmVncy0+Zm1p
bnRlcnZhbCk7CisJCW9oY2ktPmZtaW50ZXJ2YWwgPSB2YWwgJiAweDNmZmY7CiAJCWlmIChvaGNp
LT5mbWludGVydmFsICE9IEZJKQogCQkJb2hjaV9kYmcgKG9oY2ksICJmbWludGVydmFsIGRlbHRh
ICVkXG4iLAogCQkJCW9oY2ktPmZtaW50ZXJ2YWwgLSBGSSk7CkBAIC02MDAsMjUgKzYwMCwyNSBA
QCBzdGF0aWMgaW50IG9oY2lfcnVuIChzdHJ1Y3Qgb2hjaV9oY2QgKm9oY2kpCiAKIAlzd2l0Y2gg
KG9oY2ktPmhjX2NvbnRyb2wgJiBPSENJX0NUUkxfSENGUykgewogCWNhc2UgT0hDSV9VU0JfT1BF
UjoKLQkJdGVtcCA9IDA7CisJCXZhbCA9IDA7CiAJCWJyZWFrOwogCWNhc2UgT0hDSV9VU0JfU1VT
UEVORDoKIAljYXNlIE9IQ0lfVVNCX1JFU1VNRToKIAkJb2hjaS0+aGNfY29udHJvbCAmPSBPSENJ
X0NUUkxfUldDOwogCQlvaGNpLT5oY19jb250cm9sIHw9IE9IQ0lfVVNCX1JFU1VNRTsKLQkJdGVt
cCA9IDEwIC8qIG1zZWMgd2FpdCAqLzsKKwkJdmFsID0gMTAgLyogbXNlYyB3YWl0ICovOwogCQli
cmVhazsKIAkvLyBjYXNlIE9IQ0lfVVNCX1JFU0VUOgogCWRlZmF1bHQ6CiAJCW9oY2ktPmhjX2Nv
bnRyb2wgJj0gT0hDSV9DVFJMX1JXQzsKIAkJb2hjaS0+aGNfY29udHJvbCB8PSBPSENJX1VTQl9S
RVNFVDsKLQkJdGVtcCA9IDUwIC8qIG1zZWMgd2FpdCAqLzsKKwkJdmFsID0gNTAgLyogbXNlYyB3
YWl0ICovOwogCQlicmVhazsKIAl9CiAJb2hjaV93cml0ZWwgKG9oY2ksIG9oY2ktPmhjX2NvbnRy
b2wsICZvaGNpLT5yZWdzLT5jb250cm9sKTsKIAkvLyBmbHVzaCB0aGUgd3JpdGVzCiAJKHZvaWQp
IG9oY2lfcmVhZGwgKG9oY2ksICZvaGNpLT5yZWdzLT5jb250cm9sKTsKLQltc2xlZXAodGVtcCk7
CisJbXNsZWVwKHZhbCk7CiAKIAltZW1zZXQgKG9oY2ktPmhjY2EsIDAsIHNpemVvZiAoc3RydWN0
IG9oY2lfaGNjYSkpOwogCkBAIC02MjgsOSArNjI4LDkgQEAgc3RhdGljIGludCBvaGNpX3J1biAo
c3RydWN0IG9oY2lfaGNkICpvaGNpKQogcmV0cnk6CiAJLyogSEMgUmVzZXQgcmVxdWlyZXMgbWF4
IDEwIHVzIGRlbGF5ICovCiAJb2hjaV93cml0ZWwgKG9oY2ksIE9IQ0lfSENSLCAgJm9oY2ktPnJl
Z3MtPmNtZHN0YXR1cyk7Ci0JdGVtcCA9IDMwOwkvKiAuLi4gYWxsb3cgZXh0cmEgdGltZSAqLwor
CXZhbCA9IDMwOwkvKiAuLi4gYWxsb3cgZXh0cmEgdGltZSAqLwogCXdoaWxlICgob2hjaV9yZWFk
bCAob2hjaSwgJm9oY2ktPnJlZ3MtPmNtZHN0YXR1cykgJiBPSENJX0hDUikgIT0gMCkgewotCQlp
ZiAoLS10ZW1wID09IDApIHsKKwkJaWYgKC0tdmFsID09IDApIHsKIAkJCXNwaW5fdW5sb2NrX2ly
cSAoJm9oY2ktPmxvY2spOwogCQkJb2hjaV9lcnIgKG9oY2ksICJVU0IgSEMgcmVzZXQgdGltZWQg
b3V0IVxuIik7CiAJCQlyZXR1cm4gLTE7CkBAIC02OTksMjMgKzY5OSwyMyBAQCByZXRyeToKIAlv
aGNpX3dyaXRlbCAob2hjaSwgbWFzaywgJm9oY2ktPnJlZ3MtPmludHJlbmFibGUpOwogCiAJLyog
aGFuZGxlIHJvb3QgaHViIGluaXQgcXVpcmtzIC4uLiAqLwotCXRlbXAgPSByb290aHViX2EgKG9o
Y2kpOwotCXRlbXAgJj0gfihSSF9BX1BTTSB8IFJIX0FfT0NQTSk7CisJdmFsID0gcm9vdGh1Yl9h
IChvaGNpKTsKKwl2YWwgJj0gfihSSF9BX1BTTSB8IFJIX0FfT0NQTSk7CiAJaWYgKG9oY2ktPmZs
YWdzICYgT0hDSV9RVUlSS19TVVBFUklPKSB7CiAJCS8qIE5TQyA4NzU2MCBhbmQgbWF5YmUgb3Ro
ZXJzICovCi0JCXRlbXAgfD0gUkhfQV9OT0NQOwotCQl0ZW1wICY9IH4oUkhfQV9QT1RQR1QgfCBS
SF9BX05QUyk7Ci0JCW9oY2lfd3JpdGVsIChvaGNpLCB0ZW1wLCAmb2hjaS0+cmVncy0+cm9vdGh1
Yi5hKTsKKwkJdmFsIHw9IFJIX0FfTk9DUDsKKwkJdmFsICY9IH4oUkhfQV9QT1RQR1QgfCBSSF9B
X05QUyk7CisJCW9oY2lfd3JpdGVsIChvaGNpLCB2YWwsICZvaGNpLT5yZWdzLT5yb290aHViLmEp
OwogCX0gZWxzZSBpZiAoKG9oY2ktPmZsYWdzICYgT0hDSV9RVUlSS19BTUQ3NTYpIHx8CiAJCQko
b2hjaS0+ZmxhZ3MgJiBPSENJX1FVSVJLX0hVQl9QT1dFUikpIHsKIAkJLyogaHViIHBvd2VyIGFs
d2F5cyBvbjsgcmVxdWlyZWQgZm9yIEFNRC03NTYgYW5kIHNvbWUKIAkJICogTWFjIHBsYXRmb3Jt
cy4gIGdhbmdlZCBvdmVyY3VycmVudCByZXBvcnRpbmcsIGlmIGFueS4KIAkJICovCi0JCXRlbXAg
fD0gUkhfQV9OUFM7Ci0JCW9oY2lfd3JpdGVsIChvaGNpLCB0ZW1wLCAmb2hjaS0+cmVncy0+cm9v
dGh1Yi5hKTsKKwkJdmFsIHw9IFJIX0FfTlBTOworCQlvaGNpX3dyaXRlbCAob2hjaSwgdmFsLCAm
b2hjaS0+cmVncy0+cm9vdGh1Yi5hKTsKIAl9CiAJb2hjaV93cml0ZWwgKG9oY2ksIFJIX0hTX0xQ
U0MsICZvaGNpLT5yZWdzLT5yb290aHViLnN0YXR1cyk7Ci0Jb2hjaV93cml0ZWwgKG9oY2ksICh0
ZW1wICYgUkhfQV9OUFMpID8gMCA6IFJIX0JfUFBDTSwKKwlvaGNpX3dyaXRlbCAob2hjaSwgKHZh
bCAmIFJIX0FfTlBTKSA/IDAgOiBSSF9CX1BQQ00sCiAJCQkJCQkmb2hjaS0+cmVncy0+cm9vdGh1
Yi5iKTsKIAkvLyBmbHVzaCB0aG9zZSB3cml0ZXMKIAkodm9pZCkgb2hjaV9yZWFkbCAob2hjaSwg
Jm9oY2ktPnJlZ3MtPmNvbnRyb2wpOwpAQCAtNzI0LDcgKzcyNCw3IEBAIHJldHJ5OgogCXNwaW5f
dW5sb2NrX2lycSAoJm9oY2ktPmxvY2spOwogCiAJLy8gUE9UUEdUIGRlbGF5IGlzIGJpdHMgMjQt
MzEsIGluIDIgbXMgdW5pdHMuCi0JbWRlbGF5ICgodGVtcCA+PiAyMykgJiAweDFmZSk7CisJbWRl
bGF5ICgodmFsID4+IDIzKSAmIDB4MWZlKTsKIAloY2QtPnN0YXRlID0gSENfU1RBVEVfUlVOTklO
RzsKIAogCWlmIChxdWlya196Zm1pY3JvKG9oY2kpKSB7Cg==

------_=_NextPart_001_01C9C387.9347B703--
