Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZDTTBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZDTTBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZDTTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:01:04 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:33888 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752219AbZDTTBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:01:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9C1EA.5689ACA7"
Subject: [PATCH] gpiolib: Introduce a GPIO "port" concept
Date: Mon, 20 Apr 2009 15:00:56 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9464@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpiolib: Introduce a GPIO "port" concept
Thread-Index: AcnB6lXTWN0C1AAPRXCiOe8VNr2q4Q==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 20 Apr 2009 19:00:57.0768 (UTC) FILETIME=[56B06A80:01C9C1EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9C1EA.5689ACA7
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

gpiolib: Introduce a GPIO "port" concept.

Some drivers will use all the GPIOs in a given GPIOLIB chip as
a port.  Allow them to request/free these GPIOs with a single
call.  For both functions any valid GPIO in the chip needs to
be passed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..cd16e83 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -49,6 +49,7 @@ struct gpio_desc {
 #define FLAG_RESERVED	2
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control
*/
+#define FLAG_IS_PORT	5
=20
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -859,6 +860,84 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
=20
+int gpio_port_request(unsigned gpio, const char *label)
+{
+	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
+	int			status =3D -EINVAL;
+	unsigned long		flags;
+	unsigned		_gpio;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+	desc =3D &gpio_desc[gpio];
+	chip =3D desc->chip;
+	if (chip =3D=3D NULL)
+		goto done;
+
+	for (_gpio =3D chip->base; _gpio < chip->base + chip->ngpio;
_gpio++) {
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		status =3D gpio_request(_gpio, label);
+		if (status < 0)
+			goto err;
+		spin_lock_irqsave(&gpio_lock, flags);
+
+		desc =3D &gpio_desc[_gpio];
+		set_bit(FLAG_IS_PORT, &desc->flags);
+	}
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return 0;
+
+err:
+	/* free any GPIOs that may have been successfully requested */
+	for ( ; _gpio >=3D chip->base; _gpio--)
+		gpio_free(_gpio);
+	spin_lock_irqsave(&gpio_lock, flags);
+done:
+	pr_debug("gpio_port_request: gpio-%d (%s) status %d\n",
+		gpio, label ? : "?", status);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_port_request);
+
+void gpio_port_free(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
+	unsigned		_gpio;
+
+	might_sleep();
+
+	if (!gpio_is_valid(gpio)) {
+		WARN_ON(extra_checks);
+		return;
+	}
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	desc =3D &gpio_desc[gpio];
+	chip =3D desc->chip;
+
+	for (_gpio =3D chip->base; _gpio < chip->base + chip->ngpio;
_gpio++) {
+		desc =3D &gpio_desc[_gpio];
+		if (!test_bit(FLAG_IS_PORT, &desc->flags))
+			WARN_ON(extra_checks);
+
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		gpio_free(_gpio);
+		spin_lock_irqsave(&gpio_lock, flags);
+
+		clear_bit(FLAG_IS_PORT, &desc->flags);
+	}
+	spin_unlock_irqrestore(&gpio_lock, flags);
+}
+EXPORT_SYMBOL_GPL(gpio_port_free);
+
=20
 /**
  * gpiochip_is_requested - return string iff signal was requested
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..9f7ebd5 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -116,6 +116,9 @@ extern int __must_check gpiochip_remove(struct
gpio_chip *chip);
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
=20
+extern int gpio_port_request(unsigned gpio, const char *label);
+extern void gpio_port_free(unsigned gpio);
+
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 =20

------_=_NextPart_001_01C9C1EA.5689ACA7
Content-Type: application/octet-stream;
	name="gpiolib_ports.patch"
Content-Transfer-Encoding: base64
Content-Description: gpiolib_ports.patch
Content-Disposition: attachment;
	filename="gpiolib_ports.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3Bpby9ncGlvbGliLmMgYi9kcml2ZXJzL2dwaW8vZ3Bpb2xp
Yi5jCmluZGV4IDUxYThkNDEuLmNkMTZlODMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3Bpby9ncGlv
bGliLmMKKysrIGIvZHJpdmVycy9ncGlvL2dwaW9saWIuYwpAQCAtNDksNiArNDksNyBAQCBzdHJ1
Y3QgZ3Bpb19kZXNjIHsKICNkZWZpbmUgRkxBR19SRVNFUlZFRAkyCiAjZGVmaW5lIEZMQUdfRVhQ
T1JUCTMJLyogcHJvdGVjdGVkIGJ5IHN5c2ZzX2xvY2sgKi8KICNkZWZpbmUgRkxBR19TWVNGUwk0
CS8qIGV4cG9ydGVkIHZpYSAvc3lzL2NsYXNzL2dwaW8vY29udHJvbCAqLworI2RlZmluZSBGTEFH
X0lTX1BPUlQJNQogCiAjaWZkZWYgQ09ORklHX0RFQlVHX0ZTCiAJY29uc3QgY2hhcgkJKmxhYmVs
OwpAQCAtODU5LDYgKzg2MCw4NCBAQCB2b2lkIGdwaW9fZnJlZSh1bnNpZ25lZCBncGlvKQogfQog
RVhQT1JUX1NZTUJPTF9HUEwoZ3Bpb19mcmVlKTsKIAoraW50IGdwaW9fcG9ydF9yZXF1ZXN0KHVu
c2lnbmVkIGdwaW8sIGNvbnN0IGNoYXIgKmxhYmVsKQoreworCXN0cnVjdCBncGlvX2Rlc2MJKmRl
c2M7CisJc3RydWN0IGdwaW9fY2hpcAkqY2hpcDsKKwlpbnQJCQlzdGF0dXMgPSAtRUlOVkFMOwor
CXVuc2lnbmVkIGxvbmcJCWZsYWdzOworCXVuc2lnbmVkCQlfZ3BpbzsKKworCXNwaW5fbG9ja19p
cnFzYXZlKCZncGlvX2xvY2ssIGZsYWdzKTsKKworCWlmICghZ3Bpb19pc192YWxpZChncGlvKSkK
KwkJZ290byBkb25lOworCWRlc2MgPSAmZ3Bpb19kZXNjW2dwaW9dOworCWNoaXAgPSBkZXNjLT5j
aGlwOworCWlmIChjaGlwID09IE5VTEwpCisJCWdvdG8gZG9uZTsKKworCWZvciAoX2dwaW8gPSBj
aGlwLT5iYXNlOyBfZ3BpbyA8IGNoaXAtPmJhc2UgKyBjaGlwLT5uZ3BpbzsgX2dwaW8rKykgewor
CQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZncGlvX2xvY2ssIGZsYWdzKTsKKwkJc3RhdHVzID0g
Z3Bpb19yZXF1ZXN0KF9ncGlvLCBsYWJlbCk7CisJCWlmIChzdGF0dXMgPCAwKQorCQkJZ290byBl
cnI7CisJCXNwaW5fbG9ja19pcnFzYXZlKCZncGlvX2xvY2ssIGZsYWdzKTsKKworCQlkZXNjID0g
JmdwaW9fZGVzY1tfZ3Bpb107CisJCXNldF9iaXQoRkxBR19JU19QT1JULCAmZGVzYy0+ZmxhZ3Mp
OworCX0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZncGlvX2xvY2ssIGZsYWdzKTsKKworCXJl
dHVybiAwOworCitlcnI6CisJLyogZnJlZSBhbnkgR1BJT3MgdGhhdCBtYXkgaGF2ZSBiZWVuIHN1
Y2Nlc3NmdWxseSByZXF1ZXN0ZWQgKi8KKwlmb3IgKCA7IF9ncGlvID49IGNoaXAtPmJhc2U7IF9n
cGlvLS0pCisJCWdwaW9fZnJlZShfZ3Bpbyk7CisJc3Bpbl9sb2NrX2lycXNhdmUoJmdwaW9fbG9j
aywgZmxhZ3MpOworZG9uZToKKwlwcl9kZWJ1ZygiZ3Bpb19wb3J0X3JlcXVlc3Q6IGdwaW8tJWQg
KCVzKSBzdGF0dXMgJWRcbiIsCisJCWdwaW8sIGxhYmVsID8gOiAiPyIsIHN0YXR1cyk7CisJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZSgmZ3Bpb19sb2NrLCBmbGFncyk7CisJcmV0dXJuIHN0YXR1czsK
K30KK0VYUE9SVF9TWU1CT0xfR1BMKGdwaW9fcG9ydF9yZXF1ZXN0KTsKKwordm9pZCBncGlvX3Bv
cnRfZnJlZSh1bnNpZ25lZCBncGlvKQoreworCXVuc2lnbmVkIGxvbmcJCWZsYWdzOworCXN0cnVj
dCBncGlvX2Rlc2MJKmRlc2M7CisJc3RydWN0IGdwaW9fY2hpcAkqY2hpcDsKKwl1bnNpZ25lZAkJ
X2dwaW87CisKKwltaWdodF9zbGVlcCgpOworCisJaWYgKCFncGlvX2lzX3ZhbGlkKGdwaW8pKSB7
CisJCVdBUk5fT04oZXh0cmFfY2hlY2tzKTsKKwkJcmV0dXJuOworCX0KKworCXNwaW5fbG9ja19p
cnFzYXZlKCZncGlvX2xvY2ssIGZsYWdzKTsKKworCWRlc2MgPSAmZ3Bpb19kZXNjW2dwaW9dOwor
CWNoaXAgPSBkZXNjLT5jaGlwOworCisJZm9yIChfZ3BpbyA9IGNoaXAtPmJhc2U7IF9ncGlvIDwg
Y2hpcC0+YmFzZSArIGNoaXAtPm5ncGlvOyBfZ3BpbysrKSB7CisJCWRlc2MgPSAmZ3Bpb19kZXNj
W19ncGlvXTsKKwkJaWYgKCF0ZXN0X2JpdChGTEFHX0lTX1BPUlQsICZkZXNjLT5mbGFncykpCisJ
CQlXQVJOX09OKGV4dHJhX2NoZWNrcyk7CisKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZ3Bp
b19sb2NrLCBmbGFncyk7CisJCWdwaW9fZnJlZShfZ3Bpbyk7CisJCXNwaW5fbG9ja19pcnFzYXZl
KCZncGlvX2xvY2ssIGZsYWdzKTsKKworCQljbGVhcl9iaXQoRkxBR19JU19QT1JULCAmZGVzYy0+
ZmxhZ3MpOworCX0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZncGlvX2xvY2ssIGZsYWdzKTsK
K30KK0VYUE9SVF9TWU1CT0xfR1BMKGdwaW9fcG9ydF9mcmVlKTsKKwogCiAvKioKICAqIGdwaW9j
aGlwX2lzX3JlcXVlc3RlZCAtIHJldHVybiBzdHJpbmcgaWZmIHNpZ25hbCB3YXMgcmVxdWVzdGVk
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1nZW5lcmljL2dwaW8uaCBiL2luY2x1ZGUvYXNtLWdl
bmVyaWMvZ3Bpby5oCmluZGV4IGQ2YzM3OWQuLjlmN2ViZDUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
YXNtLWdlbmVyaWMvZ3Bpby5oCisrKyBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvZ3Bpby5oCkBAIC0x
MTYsNiArMTE2LDkgQEAgZXh0ZXJuIGludCBfX211c3RfY2hlY2sgZ3Bpb2NoaXBfcmVtb3ZlKHN0
cnVjdCBncGlvX2NoaXAgKmNoaXApOwogZXh0ZXJuIGludCBncGlvX3JlcXVlc3QodW5zaWduZWQg
Z3BpbywgY29uc3QgY2hhciAqbGFiZWwpOwogZXh0ZXJuIHZvaWQgZ3Bpb19mcmVlKHVuc2lnbmVk
IGdwaW8pOwogCitleHRlcm4gaW50IGdwaW9fcG9ydF9yZXF1ZXN0KHVuc2lnbmVkIGdwaW8sIGNv
bnN0IGNoYXIgKmxhYmVsKTsKK2V4dGVybiB2b2lkIGdwaW9fcG9ydF9mcmVlKHVuc2lnbmVkIGdw
aW8pOworCiBleHRlcm4gaW50IGdwaW9fZGlyZWN0aW9uX2lucHV0KHVuc2lnbmVkIGdwaW8pOwog
ZXh0ZXJuIGludCBncGlvX2RpcmVjdGlvbl9vdXRwdXQodW5zaWduZWQgZ3BpbywgaW50IHZhbHVl
KTsKIAo=

------_=_NextPart_001_01C9C1EA.5689ACA7--
