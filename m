Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZBJOhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZBJOhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZBJOhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:37:08 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54725 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZBJOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=ijYxSCAg7cSaWDdYoznpNCCG5V8f+2MpilmylbCgLa++SPezaPDVmqAADTsisq/eWA
         VT/8QuLtgic6hRiNuNx7d1BZ+wt+VJd93ExK6Iq1/FPacFqGMOhL8Y5a5c9i15XVPNX3
         XOlX1tRxgk6m41brK+fzJ76D16CMSvTBhyPfY=
Date: Tue, 10 Feb 2009 15:36:14 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PATCH - Update s1d13xxxfb to differ between revisions and
 production ids
Message-Id: <20090210153614.9938559c.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Feb_2009_15_36_14_+0100_z8XatTsiC5UC262O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Feb_2009_15_36_14_+0100_z8XatTsiC5UC262O
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__10_Feb_2009_15_36_14_+0100_ElIYGYOQehK1wR3."


--Multipart=_Tue__10_Feb_2009_15_36_14_+0100_ElIYGYOQehK1wR3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


The s1d13xxx chip provides two values of identification value.
The Production id (e.g 13506/13505/13806..)
and a revision number 0,1,2,3). Together these
can help us to differ between similiar setups.

This patch adds the proper way of grabbing both
those values and save them for future
reference (=3D in order to decide what functions
a card supports, e.g acceleration).

We also move away from the concept of
all s1d13xxx =3D s1d13806 when we really
support alot more.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com

diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index a7b01d2..38ece73 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -50,9 +50,22 @@
 #define dbg(fmt, args...) do { } while (0)
 #endif
=20
-static const int __devinitconst s1d13xxxfb_revisions[] =3D {
-	S1D13506_CHIP_REV,	/* Rev.4 on HP Jornada 7xx S1D13506 */
-	S1D13806_CHIP_REV,	/* Rev.7 on .. */
+/*
+ * List of card production ids
+ */
+static const int s1d13xxxfb_prod_ids[] =3D {
+	S1D13505_PROD_ID,
+	S1D13506_PROD_ID,
+	S1D13806_PROD_ID,
+};
+
+/*
+ * List of card strings
+ */
+static const char *s1d13xxxfb_prod_names[] =3D {
+	"S1D13505",
+	"S1D13506",
+	"S1D13806",
 };
=20
 /*
@@ -377,7 +390,6 @@ s1d13xxxfb_pan_display(struct fb_var_screeninfo *var, s=
truct fb_info *info)
 	return 0;
 }
=20
-
 /* framebuffer information structures */
=20
 static struct fb_ops s1d13xxxfb_fbops =3D {
@@ -544,7 +556,7 @@ s1d13xxxfb_probe(struct platform_device *pdev)
 	struct s1d13xxxfb_pdata *pdata =3D NULL;
 	int ret =3D 0;
 	int i;
-	u8 revision;
+	u8 revision,prod_id;
=20
 	dbg("probe called: device is %p\n", pdev);
=20
@@ -613,19 +625,31 @@ s1d13xxxfb_probe(struct platform_device *pdev)
 		goto bail;
 	}
=20
-	revision =3D s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) >> 2;
-
+	/* production id is top 6 bits */
+	prod_id =3D s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) >> 2;
+	/* revision id is lower 2 bits */
+	revision =3D s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) & 0x3;
 	ret =3D -ENODEV;
=20
-	for (i =3D 0; i < ARRAY_SIZE(s1d13xxxfb_revisions); i++) {
-		if (revision =3D=3D s1d13xxxfb_revisions[i])
+	for (i =3D 0; i < ARRAY_SIZE(s1d13xxxfb_prod_ids); i++) {
+		if (prod_id =3D=3D s1d13xxxfb_prod_ids[i]) {
+			/* looks like we got it in our list */
+			default_par->prod_id =3D prod_id;
+			default_par->revision =3D revision;
 			ret =3D 0;
+		}
+
+		/* jump ship if we find something */
+		if (!ret)
+			break;
 	}
=20
-	if (!ret)
+	if (!ret) {
+		printk(KERN_INFO PFX "chip production id %i =3D %s\n", prod_id, s1d13xxx=
fb_prod_names[i]);
 		printk(KERN_INFO PFX "chip revision %i\n", revision);
-	else {
-		printk(KERN_INFO PFX "unknown chip revision %i\n", revision);
+	} else {
+		printk(KERN_INFO PFX "unknown chip production id %i, revision %i\n", pro=
d_id, revision);
+		printk(KERN_INFO PFX "please contant maintainer\n");
 		goto bail;
 	}
=20


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Multipart=_Tue__10_Feb_2009_15_36_14_+0100_ElIYGYOQehK1wR3.
Content-Type: application/octet-stream;
 name="s1d13xxxfb_prodid_rev.patch"
Content-Disposition: attachment;
 filename="s1d13xxxfb_prodid_rev.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vczFkMTN4eHhmYi5jIGIvZHJpdmVycy92aWRlby9z
MWQxM3h4eGZiLmMKaW5kZXggYTdiMDFkMi4uMzhlY2U3MyAxMDA2NDQKLS0tIGEvZHJpdmVycy92
aWRlby9zMWQxM3h4eGZiLmMKKysrIGIvZHJpdmVycy92aWRlby9zMWQxM3h4eGZiLmMKQEAgLTUw
LDkgKzUwLDIyIEBACiAjZGVmaW5lIGRiZyhmbXQsIGFyZ3MuLi4pIGRvIHsgfSB3aGlsZSAoMCkK
ICNlbmRpZgogCi1zdGF0aWMgY29uc3QgaW50IF9fZGV2aW5pdGNvbnN0IHMxZDEzeHh4ZmJfcmV2
aXNpb25zW10gPSB7Ci0JUzFEMTM1MDZfQ0hJUF9SRVYsCS8qIFJldi40IG9uIEhQIEpvcm5hZGEg
N3h4IFMxRDEzNTA2ICovCi0JUzFEMTM4MDZfQ0hJUF9SRVYsCS8qIFJldi43IG9uIC4uICovCisv
KgorICogTGlzdCBvZiBjYXJkIHByb2R1Y3Rpb24gaWRzCisgKi8KK3N0YXRpYyBjb25zdCBpbnQg
czFkMTN4eHhmYl9wcm9kX2lkc1tdID0geworCVMxRDEzNTA1X1BST0RfSUQsCisJUzFEMTM1MDZf
UFJPRF9JRCwKKwlTMUQxMzgwNl9QUk9EX0lELAorfTsKKworLyoKKyAqIExpc3Qgb2YgY2FyZCBz
dHJpbmdzCisgKi8KK3N0YXRpYyBjb25zdCBjaGFyICpzMWQxM3h4eGZiX3Byb2RfbmFtZXNbXSA9
IHsKKwkiUzFEMTM1MDUiLAorCSJTMUQxMzUwNiIsCisJIlMxRDEzODA2IiwKIH07CiAKIC8qCkBA
IC0zNzcsNyArMzkwLDYgQEAgczFkMTN4eHhmYl9wYW5fZGlzcGxheShzdHJ1Y3QgZmJfdmFyX3Nj
cmVlbmluZm8gKnZhciwgc3RydWN0IGZiX2luZm8gKmluZm8pCiAJcmV0dXJuIDA7CiB9CiAKLQog
LyogZnJhbWVidWZmZXIgaW5mb3JtYXRpb24gc3RydWN0dXJlcyAqLwogCiBzdGF0aWMgc3RydWN0
IGZiX29wcyBzMWQxM3h4eGZiX2Zib3BzID0gewpAQCAtNTQ0LDcgKzU1Niw3IEBAIHMxZDEzeHh4
ZmJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAlzdHJ1Y3QgczFkMTN4eHhm
Yl9wZGF0YSAqcGRhdGEgPSBOVUxMOwogCWludCByZXQgPSAwOwogCWludCBpOwotCXU4IHJldmlz
aW9uOworCXU4IHJldmlzaW9uLHByb2RfaWQ7CiAKIAlkYmcoInByb2JlIGNhbGxlZDogZGV2aWNl
IGlzICVwXG4iLCBwZGV2KTsKIApAQCAtNjEzLDE5ICs2MjUsMzEgQEAgczFkMTN4eHhmYl9wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCQlnb3RvIGJhaWw7CiAJfQogCi0JcmV2
aXNpb24gPSBzMWQxM3h4eGZiX3JlYWRyZWcoZGVmYXVsdF9wYXIsIFMxRFJFR19SRVZfQ09ERSkg
Pj4gMjsKLQorCS8qIHByb2R1Y3Rpb24gaWQgaXMgdG9wIDYgYml0cyAqLworCXByb2RfaWQgPSBz
MWQxM3h4eGZiX3JlYWRyZWcoZGVmYXVsdF9wYXIsIFMxRFJFR19SRVZfQ09ERSkgPj4gMjsKKwkv
KiByZXZpc2lvbiBpZCBpcyBsb3dlciAyIGJpdHMgKi8KKwlyZXZpc2lvbiA9IHMxZDEzeHh4ZmJf
cmVhZHJlZyhkZWZhdWx0X3BhciwgUzFEUkVHX1JFVl9DT0RFKSAmIDB4MzsKIAlyZXQgPSAtRU5P
REVWOwogCi0JZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoczFkMTN4eHhmYl9yZXZpc2lvbnMp
OyBpKyspIHsKLQkJaWYgKHJldmlzaW9uID09IHMxZDEzeHh4ZmJfcmV2aXNpb25zW2ldKQorCWZv
ciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHMxZDEzeHh4ZmJfcHJvZF9pZHMpOyBpKyspIHsKKwkJ
aWYgKHByb2RfaWQgPT0gczFkMTN4eHhmYl9wcm9kX2lkc1tpXSkgeworCQkJLyogbG9va3MgbGlr
ZSB3ZSBnb3QgaXQgaW4gb3VyIGxpc3QgKi8KKwkJCWRlZmF1bHRfcGFyLT5wcm9kX2lkID0gcHJv
ZF9pZDsKKwkJCWRlZmF1bHRfcGFyLT5yZXZpc2lvbiA9IHJldmlzaW9uOwogCQkJcmV0ID0gMDsK
KwkJfQorCisJCS8qIGp1bXAgc2hpcCBpZiB3ZSBmaW5kIHNvbWV0aGluZyAqLworCQlpZiAoIXJl
dCkKKwkJCWJyZWFrOwogCX0KIAotCWlmICghcmV0KQorCWlmICghcmV0KSB7CisJCXByaW50ayhL
RVJOX0lORk8gUEZYICJjaGlwIHByb2R1Y3Rpb24gaWQgJWkgPSAlc1xuIiwgcHJvZF9pZCwgczFk
MTN4eHhmYl9wcm9kX25hbWVzW2ldKTsKIAkJcHJpbnRrKEtFUk5fSU5GTyBQRlggImNoaXAgcmV2
aXNpb24gJWlcbiIsIHJldmlzaW9uKTsKLQllbHNlIHsKLQkJcHJpbnRrKEtFUk5fSU5GTyBQRlgg
InVua25vd24gY2hpcCByZXZpc2lvbiAlaVxuIiwgcmV2aXNpb24pOworCX0gZWxzZSB7CisJCXBy
aW50ayhLRVJOX0lORk8gUEZYICJ1bmtub3duIGNoaXAgcHJvZHVjdGlvbiBpZCAlaSwgcmV2aXNp
b24gJWlcbiIsIHByb2RfaWQsIHJldmlzaW9uKTsKKwkJcHJpbnRrKEtFUk5fSU5GTyBQRlggInBs
ZWFzZSBjb250YW50IG1haW50YWluZXJcbiIpOwogCQlnb3RvIGJhaWw7CiAJfQogCg==

--Multipart=_Tue__10_Feb_2009_15_36_14_+0100_ElIYGYOQehK1wR3.--

--Signature=_Tue__10_Feb_2009_15_36_14_+0100_z8XatTsiC5UC262O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmRkN4ACgkQPQls10ERAGcqNACgtMCCui0YEugDpewqhEj4qFi6
oGUAn3ZfRvO2xI3wS/AqFB9Rx/y95J1D
=Nynj
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Feb_2009_15_36_14_+0100_z8XatTsiC5UC262O--
