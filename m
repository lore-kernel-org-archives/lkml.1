Return-Path: <linux-kernel-owner+w=401wt.eu-S932091Ab0AMJ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab0AMJ16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083Ab0AMJ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:27:56 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:39130 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab0AMJ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ez9gzhvtRploFAkpNJMS/7GZ9LKtmhuM3Sx7/JBRJvwYfdVMbUMSAX+bS3qQTE23iz
         ZXzd0sBSUNpgHwexuNkDxnxVXKEbBY63IPRfCuzub7M7YLfzC/KoOlXUAeMb15/5U7A3
         8q5IVR9bzYQIP6F6mBrWY42xfM65GZ0APGllA=
MIME-Version: 1.0
In-Reply-To: <20100113002939.2d2c489d.akpm@linux-foundation.org>
References: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com> 
	<f17812d71001072128g63361e74q74cf06ae1e1eb3d6@mail.gmail.com> 
	<20100112150952.aa224e20.akpm@linux-foundation.org> <f17812d71001121923k5a67c42flb92cf7bb2c8a0b5a@mail.gmail.com> 
	<f17812d71001130023n491879cakc02dfcf26ec0fe43@mail.gmail.com> 
	<20100113002939.2d2c489d.akpm@linux-foundation.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 13 Jan 2010 17:27:31 +0800
Message-ID: <f17812d71001130127r34eadb45jb7eadedc1586a944@mail.gmail.com>
Subject: Re: [PATCH] gpio: introduce gpio_request_one() and friends
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00151757461e79fbf8047d0862ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151757461e79fbf8047d0862ad
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 13, 2010 at 4:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 13 Jan 2010 16:23:35 +0800 Eric Miao <eric.y.miao@gmail.com> wrote:
>
>> Attached is the patch against Documentation/gpio.txt
>
> Thanks.
>
> I was thinking kerneldoc in the .c file actually - most/all of the
> other interface functions in gpiolib.c seem to be done that way.
>

OK, updated as follows (I've also make this an attached patch in
case gmail wraps my line again):

commit db30b9c15be3ee3ddcd914aadecfc8815c1a0170
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Fri Jan 8 12:16:28 2010 +0800

    gpio: introduce gpio_request_one() and friends

    gpio_request() without initial configuration of the GPIO is normally
    useless, introduce gpio_request_one() together with GPIOF_ flags for
    input/output direction and initial output level.

    gpio_{request,free}_array() for multiple GPIOs.

    Cc: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 1866c27..c2c6e9b 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -253,6 +253,70 @@ pin setup (e.g. controlling which pin the GPIO
uses, pullup/pulldown).
 Also note that it's your responsibility to have stopped using a GPIO
 before you free it.

+Considering in most cases GPIOs are actually configured right after they
+are claimed, three additional calls are defined:
+
+	/* request a single GPIO, with initial configuration specified by
+	 * 'flags', identical to gpio_request() wrt other arguments and
+	 * return value
+	 */
+	int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+
+	/* request multiple GPIOs in a single call
+	 */
+	int gpio_request_array(struct gpio *array, size_t num);
+
+	/* release multiple GPIOs in a single call
+	 */
+	void gpio_free_array(struct gpio *array, size_t num);
+
+where 'flags' is currently defined to specify the following properties:
+
+	* GPIOF_DIR_IN		- to configure direction as input
+	* GPIOF_DIR_OUT		- to configure direction as output
+
+	* GPIOF_INIT_LOW	- as output, set initial level to LOW
+	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
+
+since GPIOF_INIT_* are only valid when configured as output, so group valid
+combinations as:
+
+	* GPIOF_IN		- configure as input
+	* GPIOF_OUT_INIT_LOW	- configured as output, initial level LOW
+	* GPIOF_OUT_INIT_HIGH	- configured as output, initial level HIGH
+
+In the future, these flags can be extended to support more properties such
+as open-drain status.
+
+Further more, to ease the claim/release of multiple GPIOs, 'struct gpio' is
+introduced to encapsulate all three fields as:
+
+	struct gpio {
+		unsigned	gpio;
+		unsigned long	flags;
+		const char	*label;
+	};
+
+A typical example of usage:
+
+	static struct gpio leds_gpios[] = {
+		{ 32, GPIOF_OUT_INIT_HIGH, "Power LED" }, /* default to ON */
+		{ 33, GPIOF_OUT_INIT_LOW,  "Green LED" }, /* default to OFF */
+		{ 34, GPIOF_OUT_INIT_LOW,  "Red LED"   }, /* default to OFF */
+		{ 35, GPIOF_OUT_INIT_LOW,  "Blue LED"  }, /* default to OFF */
+		{ ... },
+	};
+
+	err = gpio_request_one(31, GPIOF_IN, "Reset Button");
+	if (err)
+		...
+
+	err = gpio_request_array(leds_gpios, ARRAY_SIZE(leds_gpios));
+	if (err)
+		...
+
+	gpio_free_array(leds_gpios, ARRAY_SIZE(leds_gpios));
+

 GPIOs mapped to IRQs
 --------------------
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a25ad28..0a81a1e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1239,6 +1239,64 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);

+/**
+ * gpio_request_one - request a single GPIO with initial configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
+int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
+{
+	int err;
+
+	err = gpio_request(gpio, label);
+	if (err)
+		return err;
+
+	if (flags & GPIOF_DIR_IN)
+		err = gpio_direction_input(gpio);
+	else
+		err = gpio_direction_output(gpio,
+				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_one);
+
+/**
+ * gpio_request_array - request multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
+int gpio_request_array(struct gpio *array, size_t num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++, array++) {
+		err = gpio_request_one(array->gpio, array->flags, array->label);
+		if (err)
+			goto err_free;
+	}
+	return 0;
+
+err_free:
+	while (i--)
+		gpio_free((--array)->gpio);
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_array);
+
+/**
+ * gpio_free_array - release multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
+void gpio_free_array(struct gpio *array, size_t num)
+{
+	while (num--)
+		gpio_free((array++)->gpio);
+}
+EXPORT_SYMBOL_GPL(gpio_free_array);

 /**
  * gpiochip_is_requested - return string iff signal was requested
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 485eeb6..979c6a5 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -136,6 +136,32 @@ extern int __gpio_cansleep(unsigned gpio);

 extern int __gpio_to_irq(unsigned gpio);

+#define GPIOF_DIR_OUT	(0 << 0)
+#define GPIOF_DIR_IN	(1 << 0)
+
+#define GPIOF_INIT_LOW	(0 << 1)
+#define GPIOF_INIT_HIGH	(1 << 1)
+
+#define GPIOF_IN		(GPIOF_DIR_IN)
+#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
+#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
+
+/**
+ * struct gpio - a structure describing a GPIO with configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
+struct gpio {
+	unsigned	gpio;
+	unsigned long	flags;
+	const char	*label;
+};
+
+extern int gpio_request_one(unsigned gpio, unsigned long flags, const
char *label);
+extern int gpio_request_array(struct gpio *array, size_t num);
+extern void gpio_free_array(struct gpio *array, size_t num);
+
 #ifdef CONFIG_GPIO_SYSFS

 /*

--00151757461e79fbf8047d0862ad
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-gpio-introduce-gpio_request_one-and-friends.patch"
Content-Disposition: attachment; 
	filename="0001-gpio-introduce-gpio_request_one-and-friends.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4dwqlc90

RnJvbSBkYjMwYjljMTViZTNlZTNkZGNkOTE0YWFkZWNmYzg4MTVjMWEwMTcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMueS5taWFvQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCA4IEphbiAyMDEwIDEyOjE2OjI4ICswODAwClN1YmplY3Q6IFtQQVRDSF0gZ3Bpbzog
aW50cm9kdWNlIGdwaW9fcmVxdWVzdF9vbmUoKSBhbmQgZnJpZW5kcwoKZ3Bpb19yZXF1ZXN0KCkg
d2l0aG91dCBpbml0aWFsIGNvbmZpZ3VyYXRpb24gb2YgdGhlIEdQSU8gaXMgbm9ybWFsbHkKdXNl
bGVzcywgaW50cm9kdWNlIGdwaW9fcmVxdWVzdF9vbmUoKSB0b2dldGhlciB3aXRoIEdQSU9GXyBm
bGFncyBmb3IKaW5wdXQvb3V0cHV0IGRpcmVjdGlvbiBhbmQgaW5pdGlhbCBvdXRwdXQgbGV2ZWwu
CgpncGlvX3tyZXF1ZXN0LGZyZWV9X2FycmF5KCkgZm9yIG11bHRpcGxlIEdQSU9zLgoKQ2M6IERh
dmlkIEJyb3duZWxsIDxkYnJvd25lbGxAdXNlcnMuc291cmNlZm9yZ2UubmV0PgpTaWduZWQtb2Zm
LWJ5OiBFcmljIE1pYW8gPGVyaWMueS5taWFvQGdtYWlsLmNvbT4KLS0tCiBEb2N1bWVudGF0aW9u
L2dwaW8udHh0ICAgICB8ICAgNjQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysKIGRyaXZlcnMvZ3Bpby9ncGlvbGliLmMgICAgIHwgICA1OCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUvYXNtLWdlbmVyaWMvZ3Bpby5oIHwg
ICAyNiArKysrKysrKysrKysrKysrKysKIDMgZmlsZXMgY2hhbmdlZCwgMTQ4IGluc2VydGlvbnMo
KyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9ncGlvLnR4dCBi
L0RvY3VtZW50YXRpb24vZ3Bpby50eHQKaW5kZXggMTg2NmMyNy4uYzJjNmU5YiAxMDA2NDQKLS0t
IGEvRG9jdW1lbnRhdGlvbi9ncGlvLnR4dAorKysgYi9Eb2N1bWVudGF0aW9uL2dwaW8udHh0CkBA
IC0yNTMsNiArMjUzLDcwIEBAIHBpbiBzZXR1cCAoZS5nLiBjb250cm9sbGluZyB3aGljaCBwaW4g
dGhlIEdQSU8gdXNlcywgcHVsbHVwL3B1bGxkb3duKS4KIEFsc28gbm90ZSB0aGF0IGl0J3MgeW91
ciByZXNwb25zaWJpbGl0eSB0byBoYXZlIHN0b3BwZWQgdXNpbmcgYSBHUElPCiBiZWZvcmUgeW91
IGZyZWUgaXQuCiAKK0NvbnNpZGVyaW5nIGluIG1vc3QgY2FzZXMgR1BJT3MgYXJlIGFjdHVhbGx5
IGNvbmZpZ3VyZWQgcmlnaHQgYWZ0ZXIgdGhleQorYXJlIGNsYWltZWQsIHRocmVlIGFkZGl0aW9u
YWwgY2FsbHMgYXJlIGRlZmluZWQ6CisKKwkvKiByZXF1ZXN0IGEgc2luZ2xlIEdQSU8sIHdpdGgg
aW5pdGlhbCBjb25maWd1cmF0aW9uIHNwZWNpZmllZCBieQorCSAqICdmbGFncycsIGlkZW50aWNh
bCB0byBncGlvX3JlcXVlc3QoKSB3cnQgb3RoZXIgYXJndW1lbnRzIGFuZAorCSAqIHJldHVybiB2
YWx1ZQorCSAqLworCWludCBncGlvX3JlcXVlc3Rfb25lKHVuc2lnbmVkIGdwaW8sIHVuc2lnbmVk
IGxvbmcgZmxhZ3MsIGNvbnN0IGNoYXIgKmxhYmVsKTsKKworCS8qIHJlcXVlc3QgbXVsdGlwbGUg
R1BJT3MgaW4gYSBzaW5nbGUgY2FsbAorCSAqLworCWludCBncGlvX3JlcXVlc3RfYXJyYXkoc3Ry
dWN0IGdwaW8gKmFycmF5LCBzaXplX3QgbnVtKTsKKworCS8qIHJlbGVhc2UgbXVsdGlwbGUgR1BJ
T3MgaW4gYSBzaW5nbGUgY2FsbAorCSAqLworCXZvaWQgZ3Bpb19mcmVlX2FycmF5KHN0cnVjdCBn
cGlvICphcnJheSwgc2l6ZV90IG51bSk7CisKK3doZXJlICdmbGFncycgaXMgY3VycmVudGx5IGRl
ZmluZWQgdG8gc3BlY2lmeSB0aGUgZm9sbG93aW5nIHByb3BlcnRpZXM6CisKKwkqIEdQSU9GX0RJ
Ul9JTgkJLSB0byBjb25maWd1cmUgZGlyZWN0aW9uIGFzIGlucHV0CisJKiBHUElPRl9ESVJfT1VU
CQktIHRvIGNvbmZpZ3VyZSBkaXJlY3Rpb24gYXMgb3V0cHV0CisKKwkqIEdQSU9GX0lOSVRfTE9X
CS0gYXMgb3V0cHV0LCBzZXQgaW5pdGlhbCBsZXZlbCB0byBMT1cKKwkqIEdQSU9GX0lOSVRfSElH
SAktIGFzIG91dHB1dCwgc2V0IGluaXRpYWwgbGV2ZWwgdG8gSElHSAorCitzaW5jZSBHUElPRl9J
TklUXyogYXJlIG9ubHkgdmFsaWQgd2hlbiBjb25maWd1cmVkIGFzIG91dHB1dCwgc28gZ3JvdXAg
dmFsaWQKK2NvbWJpbmF0aW9ucyBhczoKKworCSogR1BJT0ZfSU4JCS0gY29uZmlndXJlIGFzIGlu
cHV0CisJKiBHUElPRl9PVVRfSU5JVF9MT1cJLSBjb25maWd1cmVkIGFzIG91dHB1dCwgaW5pdGlh
bCBsZXZlbCBMT1cKKwkqIEdQSU9GX09VVF9JTklUX0hJR0gJLSBjb25maWd1cmVkIGFzIG91dHB1
dCwgaW5pdGlhbCBsZXZlbCBISUdICisKK0luIHRoZSBmdXR1cmUsIHRoZXNlIGZsYWdzIGNhbiBi
ZSBleHRlbmRlZCB0byBzdXBwb3J0IG1vcmUgcHJvcGVydGllcyBzdWNoCithcyBvcGVuLWRyYWlu
IHN0YXR1cy4KKworRnVydGhlciBtb3JlLCB0byBlYXNlIHRoZSBjbGFpbS9yZWxlYXNlIG9mIG11
bHRpcGxlIEdQSU9zLCAnc3RydWN0IGdwaW8nIGlzCitpbnRyb2R1Y2VkIHRvIGVuY2Fwc3VsYXRl
IGFsbCB0aHJlZSBmaWVsZHMgYXM6CisKKwlzdHJ1Y3QgZ3BpbyB7CisJCXVuc2lnbmVkCWdwaW87
CisJCXVuc2lnbmVkIGxvbmcJZmxhZ3M7CisJCWNvbnN0IGNoYXIJKmxhYmVsOworCX07CisKK0Eg
dHlwaWNhbCBleGFtcGxlIG9mIHVzYWdlOgorCisJc3RhdGljIHN0cnVjdCBncGlvIGxlZHNfZ3Bp
b3NbXSA9IHsKKwkJeyAzMiwgR1BJT0ZfT1VUX0lOSVRfSElHSCwgIlBvd2VyIExFRCIgfSwgLyog
ZGVmYXVsdCB0byBPTiAqLworCQl7IDMzLCBHUElPRl9PVVRfSU5JVF9MT1csICAiR3JlZW4gTEVE
IiB9LCAvKiBkZWZhdWx0IHRvIE9GRiAqLworCQl7IDM0LCBHUElPRl9PVVRfSU5JVF9MT1csICAi
UmVkIExFRCIgICB9LCAvKiBkZWZhdWx0IHRvIE9GRiAqLworCQl7IDM1LCBHUElPRl9PVVRfSU5J
VF9MT1csICAiQmx1ZSBMRUQiICB9LCAvKiBkZWZhdWx0IHRvIE9GRiAqLworCQl7IC4uLiB9LAor
CX07CisKKwllcnIgPSBncGlvX3JlcXVlc3Rfb25lKDMxLCBHUElPRl9JTiwgIlJlc2V0IEJ1dHRv
biIpOworCWlmIChlcnIpCisJCS4uLgorCisJZXJyID0gZ3Bpb19yZXF1ZXN0X2FycmF5KGxlZHNf
Z3Bpb3MsIEFSUkFZX1NJWkUobGVkc19ncGlvcykpOworCWlmIChlcnIpCisJCS4uLgorCisJZ3Bp
b19mcmVlX2FycmF5KGxlZHNfZ3Bpb3MsIEFSUkFZX1NJWkUobGVkc19ncGlvcykpOworCiAKIEdQ
SU9zIG1hcHBlZCB0byBJUlFzCiAtLS0tLS0tLS0tLS0tLS0tLS0tLQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncGlvL2dwaW9saWIuYyBiL2RyaXZlcnMvZ3Bpby9ncGlvbGliLmMKaW5kZXggYTI1YWQy
OC4uMGE4MWExZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncGlvL2dwaW9saWIuYworKysgYi9kcml2
ZXJzL2dwaW8vZ3Bpb2xpYi5jCkBAIC0xMjM5LDYgKzEyMzksNjQgQEAgdm9pZCBncGlvX2ZyZWUo
dW5zaWduZWQgZ3BpbykKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKGdwaW9fZnJlZSk7CiAKKy8qKgor
ICogZ3Bpb19yZXF1ZXN0X29uZSAtIHJlcXVlc3QgYSBzaW5nbGUgR1BJTyB3aXRoIGluaXRpYWwg
Y29uZmlndXJhdGlvbgorICogQGdwaW86CXRoZSBHUElPIG51bWJlcgorICogQGZsYWdzOglHUElP
IGNvbmZpZ3VyYXRpb24gYXMgc3BlY2lmaWVkIGJ5IEdQSU9GXyoKKyAqIEBsYWJlbDoJYSBsaXRl
cmFsIGRlc2NyaXB0aW9uIHN0cmluZyBvZiB0aGlzIEdQSU8KKyAqLworaW50IGdwaW9fcmVxdWVz
dF9vbmUodW5zaWduZWQgZ3BpbywgdW5zaWduZWQgbG9uZyBmbGFncywgY29uc3QgY2hhciAqbGFi
ZWwpCit7CisJaW50IGVycjsKKworCWVyciA9IGdwaW9fcmVxdWVzdChncGlvLCBsYWJlbCk7CisJ
aWYgKGVycikKKwkJcmV0dXJuIGVycjsKKworCWlmIChmbGFncyAmIEdQSU9GX0RJUl9JTikKKwkJ
ZXJyID0gZ3Bpb19kaXJlY3Rpb25faW5wdXQoZ3Bpbyk7CisJZWxzZQorCQllcnIgPSBncGlvX2Rp
cmVjdGlvbl9vdXRwdXQoZ3BpbywKKwkJCQkoZmxhZ3MgJiBHUElPRl9JTklUX0hJR0gpID8gMSA6
IDApOworCisJcmV0dXJuIGVycjsKK30KK0VYUE9SVF9TWU1CT0xfR1BMKGdwaW9fcmVxdWVzdF9v
bmUpOworCisvKioKKyAqIGdwaW9fcmVxdWVzdF9hcnJheSAtIHJlcXVlc3QgbXVsdGlwbGUgR1BJ
T3MgaW4gYSBzaW5nbGUgY2FsbAorICogQGFycmF5OglhcnJheSBvZiB0aGUgJ3N0cnVjdCBncGlv
JworICogQG51bToJaG93IG1hbnkgR1BJT3MgaW4gdGhlIGFycmF5CisgKi8KK2ludCBncGlvX3Jl
cXVlc3RfYXJyYXkoc3RydWN0IGdwaW8gKmFycmF5LCBzaXplX3QgbnVtKQoreworCWludCBpLCBl
cnI7CisKKwlmb3IgKGkgPSAwOyBpIDwgbnVtOyBpKyssIGFycmF5KyspIHsKKwkJZXJyID0gZ3Bp
b19yZXF1ZXN0X29uZShhcnJheS0+Z3BpbywgYXJyYXktPmZsYWdzLCBhcnJheS0+bGFiZWwpOwor
CQlpZiAoZXJyKQorCQkJZ290byBlcnJfZnJlZTsKKwl9CisJcmV0dXJuIDA7CisKK2Vycl9mcmVl
OgorCXdoaWxlIChpLS0pCisJCWdwaW9fZnJlZSgoLS1hcnJheSktPmdwaW8pOworCXJldHVybiBl
cnI7Cit9CitFWFBPUlRfU1lNQk9MX0dQTChncGlvX3JlcXVlc3RfYXJyYXkpOworCisvKioKKyAq
IGdwaW9fZnJlZV9hcnJheSAtIHJlbGVhc2UgbXVsdGlwbGUgR1BJT3MgaW4gYSBzaW5nbGUgY2Fs
bAorICogQGFycmF5OglhcnJheSBvZiB0aGUgJ3N0cnVjdCBncGlvJworICogQG51bToJaG93IG1h
bnkgR1BJT3MgaW4gdGhlIGFycmF5CisgKi8KK3ZvaWQgZ3Bpb19mcmVlX2FycmF5KHN0cnVjdCBn
cGlvICphcnJheSwgc2l6ZV90IG51bSkKK3sKKwl3aGlsZSAobnVtLS0pCisJCWdwaW9fZnJlZSgo
YXJyYXkrKyktPmdwaW8pOworfQorRVhQT1JUX1NZTUJPTF9HUEwoZ3Bpb19mcmVlX2FycmF5KTsK
IAogLyoqCiAgKiBncGlvY2hpcF9pc19yZXF1ZXN0ZWQgLSByZXR1cm4gc3RyaW5nIGlmZiBzaWdu
YWwgd2FzIHJlcXVlc3RlZApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy9ncGlvLmgg
Yi9pbmNsdWRlL2FzbS1nZW5lcmljL2dwaW8uaAppbmRleCA0ODVlZWI2Li45NzljNmE1IDEwMDY0
NAotLS0gYS9pbmNsdWRlL2FzbS1nZW5lcmljL2dwaW8uaAorKysgYi9pbmNsdWRlL2FzbS1nZW5l
cmljL2dwaW8uaApAQCAtMTM2LDYgKzEzNiwzMiBAQCBleHRlcm4gaW50IF9fZ3Bpb19jYW5zbGVl
cCh1bnNpZ25lZCBncGlvKTsKIAogZXh0ZXJuIGludCBfX2dwaW9fdG9faXJxKHVuc2lnbmVkIGdw
aW8pOwogCisjZGVmaW5lIEdQSU9GX0RJUl9PVVQJKDAgPDwgMCkKKyNkZWZpbmUgR1BJT0ZfRElS
X0lOCSgxIDw8IDApCisKKyNkZWZpbmUgR1BJT0ZfSU5JVF9MT1cJKDAgPDwgMSkKKyNkZWZpbmUg
R1BJT0ZfSU5JVF9ISUdICSgxIDw8IDEpCisKKyNkZWZpbmUgR1BJT0ZfSU4JCShHUElPRl9ESVJf
SU4pCisjZGVmaW5lIEdQSU9GX09VVF9JTklUX0xPVwkoR1BJT0ZfRElSX09VVCB8IEdQSU9GX0lO
SVRfTE9XKQorI2RlZmluZSBHUElPRl9PVVRfSU5JVF9ISUdICShHUElPRl9ESVJfT1VUIHwgR1BJ
T0ZfSU5JVF9ISUdIKQorCisvKioKKyAqIHN0cnVjdCBncGlvIC0gYSBzdHJ1Y3R1cmUgZGVzY3Jp
YmluZyBhIEdQSU8gd2l0aCBjb25maWd1cmF0aW9uCisgKiBAZ3BpbzoJdGhlIEdQSU8gbnVtYmVy
CisgKiBAZmxhZ3M6CUdQSU8gY29uZmlndXJhdGlvbiBhcyBzcGVjaWZpZWQgYnkgR1BJT0ZfKgor
ICogQGxhYmVsOglhIGxpdGVyYWwgZGVzY3JpcHRpb24gc3RyaW5nIG9mIHRoaXMgR1BJTworICov
CitzdHJ1Y3QgZ3BpbyB7CisJdW5zaWduZWQJZ3BpbzsKKwl1bnNpZ25lZCBsb25nCWZsYWdzOwor
CWNvbnN0IGNoYXIJKmxhYmVsOworfTsKKworZXh0ZXJuIGludCBncGlvX3JlcXVlc3Rfb25lKHVu
c2lnbmVkIGdwaW8sIHVuc2lnbmVkIGxvbmcgZmxhZ3MsIGNvbnN0IGNoYXIgKmxhYmVsKTsKK2V4
dGVybiBpbnQgZ3Bpb19yZXF1ZXN0X2FycmF5KHN0cnVjdCBncGlvICphcnJheSwgc2l6ZV90IG51
bSk7CitleHRlcm4gdm9pZCBncGlvX2ZyZWVfYXJyYXkoc3RydWN0IGdwaW8gKmFycmF5LCBzaXpl
X3QgbnVtKTsKKwogI2lmZGVmIENPTkZJR19HUElPX1NZU0ZTCiAKIC8qCi0tIAoxLjYuMy4zCgo=
--00151757461e79fbf8047d0862ad--
