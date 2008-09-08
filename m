Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYIHN2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYIHN2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYIHN2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:28:07 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59752 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYIHN2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=s5vN01zmhfq3Eulf6At0IMuS+PxYWYBreftUuXdjw4+hppSkKMD47SZcsYb2a56an1
         tGbkUZTJ1rkRTtFCC1jmq7IzRTRAbn3B8EV9cLfH46TWIPgJtoraaeFlgOa8C3g4VQGI
         /iVLQc0rIeNxU+X+QPnFZJqBxyfgu5539vnbw=
Message-ID: <5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
Date: Mon, 8 Sep 2008 14:28:00 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <20080907123832.5ba79c12@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12632_24217171.1220880480907"
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	 <20080907123832.5ba79c12@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12632_24217171.1220880480907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/9/7 Pierre Ossman <drzeus-mmc@drzeus.cx>:
>
> This actually isn't fully correct for SD either as it only specifies
> that 250 ms is the upper bound on the timeout.
>
> I believe the proper way of solving this is to have mmc_spi respect the
> timeouts set in the request structure. Modify mmc_set_data_timeout() if
> necessary.
>

You're right, I changed the patch accordingly (I also fixed the read
timeout path).

>From 03b2d04b2e597ec073f2ff61224df1d3dee3b9de Mon Sep 17 00:00:00 2001
From: Matthew Fleming <matthew.fleming@imgtec.com>
Date: Mon, 8 Sep 2008 14:10:14 +0100
Subject: [PATCH] MMC: Use timeout values from CSR

Currently, the MMC/SD over SPI code has a hard-coded timeout value of
250ms on writes and 100ms on reads. This is correct for SDHC cards
and is specified in the spec, but it is not correct for MMC/SD cards.

For MMC cards the values that are read from the CSR should be used.
For SD cards the values from the CSR should be used as long as they
do not exceed 250ms for writes and 100ms for reads.

Signed-off-by: Matthew Fleming <matthew.fleming@imgtec.com>
---
 drivers/mmc/host/mmc_spi.c |   56 +++++++++++++++++++++++++++++++++----------
 1 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7503b81..35f18f5 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -34,6 +34,7 @@

 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>             /* for R1_SPI_* bit values */
+#include <linux/mmc/card.h>

 #include <linux/spi/spi.h>
 #include <linux/spi/mmc_spi.h>
@@ -89,14 +90,12 @@
 #define MMC_SPI_BLOCKSIZE      512


-/* These fixed timeouts come from the latest SD specs, which say to ignore
- * the CSD values.  The R1B value is for card erase (e.g. the "I forgot the
+/*
+ * The R1B value is for card erase (e.g. the "I forgot the
  * card's password" scenario); it's mostly applied to STOP_TRANSMISSION after
  * reads which takes nowhere near that long.  Older cards may be able to use
  * shorter timeouts ... but why bother?
  */
-#define readblock_timeout      ktime_set(0, 100 * 1000 * 1000)
-#define writeblock_timeout     ktime_set(0, 250 * 1000 * 1000)
 #define r1b_timeout            ktime_set(3, 0)


@@ -214,15 +213,44 @@ mmc_spi_skip(struct mmc_spi_host *host, ktime_t
timeout, unsigned n, u8 byte)
        return -ETIMEDOUT;
 }

+/*
+ * Return the timeout value for this card.
+ */
+static ktime_t
+mmc_get_timeout(struct mmc_spi_host *host, struct mmc_data *data)
+{
+       unsigned int timeout_ns;
+
+       /* If card hasn't been initialised, use default timeouts. */
+       if (!host->mmc->card) {
+               if (data->flags & MMC_DATA_WRITE)
+                       timeout_ns = 250000000;
+               else
+                       timeout_ns = 100000000;
+       } else {
+               timeout_ns = data->timeout_ns;
+               timeout_ns += data->timeout_clks * 1000  * 1000 /
+                       (host->mmc->card->host->ios.clock);
+       }
+
+       /*
+        * The reason we're adding 0 and a nanosecond value here is because
+        * the timeout_ns value may be greater than one second, which
+        * ktime_set() does not handle properly. The correct logic to handle
+        * this overflow is in ktime_add_ns() however.
+        */
+       return ktime_add_ns(ktime_set(0, 0), timeout_ns);
+}
+
 static inline int
 mmc_spi_wait_unbusy(struct mmc_spi_host *host, ktime_t timeout)
 {
        return mmc_spi_skip(host, timeout, sizeof(host->data->status), 0);
 }

-static int mmc_spi_readtoken(struct mmc_spi_host *host)
+static int mmc_spi_readtoken(struct mmc_spi_host *host, ktime_t timeout)
 {
-       return mmc_spi_skip(host, readblock_timeout, 1, 0xff);
+       return mmc_spi_skip(host, timeout, 1, 0xff);
 }


@@ -605,7 +633,8 @@ mmc_spi_setup_data_message(
  * Return negative errno, else success.
  */
 static int
-mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t)
+mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
+       struct mmc_data *data)
 {
        struct spi_device       *spi = host->spi;
        int                     status, i;
@@ -673,7 +702,7 @@ mmc_spi_writeblock(struct mmc_spi_host *host,
struct spi_transfer *t)
                if (scratch->status[i] != 0)
                        return 0;
        }
-       return mmc_spi_wait_unbusy(host, writeblock_timeout);
+       return mmc_spi_wait_unbusy(host, mmc_get_timeout(host, data));
 }

 /*
@@ -693,7 +722,8 @@ mmc_spi_writeblock(struct mmc_spi_host *host,
struct spi_transfer *t)
  * STOP_TRANSMISSION command.
  */
 static int
-mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t)
+mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
+       struct mmc_data *data)
 {
        struct spi_device       *spi = host->spi;
        int                     status;
@@ -707,7 +737,7 @@ mmc_spi_readblock(struct mmc_spi_host *host,
struct spi_transfer *t)
                return status;
        status = scratch->status[0];
        if (status == 0xff || status == 0)
-               status = mmc_spi_readtoken(host);
+               status = mmc_spi_readtoken(host, mmc_get_timeout(host, data));

        if (status == SPI_TOKEN_SINGLE) {
                if (host->dma_dev) {
@@ -832,9 +862,9 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                                t->len);

                        if (direction == DMA_TO_DEVICE)
-                               status = mmc_spi_writeblock(host, t);
+                               status = mmc_spi_writeblock(host, t, data);
                        else
-                               status = mmc_spi_readblock(host, t);
+                               status = mmc_spi_readblock(host, t, data);
                        if (status < 0)
                                break;

@@ -917,7 +947,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                        if (scratch->status[tmp] != 0)
                                return;
                }
-               tmp = mmc_spi_wait_unbusy(host, writeblock_timeout);
+               tmp = mmc_spi_wait_unbusy(host, mmc_get_timeout(host, data));
                if (tmp < 0 && !data->error)
                        data->error = tmp;
        }
--
1.5.5.2

------=_Part_12632_24217171.1220880480907
Content-Type: text/x-diff; name=0001-MMC-Use-timeout-values-from-CSR.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkv4pfk30
Content-Disposition: attachment;
 filename=0001-MMC-Use-timeout-values-from-CSR.patch

RnJvbSAwM2IyZDA0YjJlNTk3ZWMwNzNmMmZmNjEyMjRkZjFkM2RlZTNiOWRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0aGV3IEZsZW1pbmcgPG1hdHRoZXcuZmxlbWluZ0BpbWd0
ZWMuY29tPgpEYXRlOiBNb24sIDggU2VwIDIwMDggMTQ6MTA6MTQgKzAxMDAKU3ViamVjdDogW1BB
VENIXSBNTUM6IFVzZSB0aW1lb3V0IHZhbHVlcyBmcm9tIENTUgoKQ3VycmVudGx5LCB0aGUgTU1D
L1NEIG92ZXIgU1BJIGNvZGUgaGFzIGEgaGFyZC1jb2RlZCB0aW1lb3V0IHZhbHVlIG9mCjI1MG1z
IG9uIHdyaXRlcyBhbmQgMTAwbXMgb24gcmVhZHMuIFRoaXMgaXMgY29ycmVjdCBmb3IgU0RIQyBj
YXJkcwphbmQgaXMgc3BlY2lmaWVkIGluIHRoZSBzcGVjLCBidXQgaXQgaXMgbm90IGNvcnJlY3Qg
Zm9yIE1NQy9TRCBjYXJkcy4KCkZvciBNTUMgY2FyZHMgdGhlIHZhbHVlcyB0aGF0IGFyZSByZWFk
IGZyb20gdGhlIENTUiBzaG91bGQgYmUgdXNlZC4KRm9yIFNEIGNhcmRzIHRoZSB2YWx1ZXMgZnJv
bSB0aGUgQ1NSIHNob3VsZCBiZSB1c2VkIGFzIGxvbmcgYXMgdGhleQpkbyBub3QgZXhjZWVkIDI1
MG1zIGZvciB3cml0ZXMgYW5kIDEwMG1zIGZvciByZWFkcy4KClNpZ25lZC1vZmYtYnk6IE1hdHRo
ZXcgRmxlbWluZyA8bWF0dGhldy5mbGVtaW5nQGltZ3RlYy5jb20+Ci0tLQogZHJpdmVycy9tbWMv
aG9zdC9tbWNfc3BpLmMgfCAgIDU2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9tbWNfc3BpLmMgYi9kcml2ZXJzL21t
Yy9ob3N0L21tY19zcGkuYwppbmRleCA3NTAzYjgxLi4zNWYxOGY1IDEwMDY0NAotLS0gYS9kcml2
ZXJzL21tYy9ob3N0L21tY19zcGkuYworKysgYi9kcml2ZXJzL21tYy9ob3N0L21tY19zcGkuYwpA
QCAtMzQsNiArMzQsNyBAQAogCiAjaW5jbHVkZSA8bGludXgvbW1jL2hvc3QuaD4KICNpbmNsdWRl
IDxsaW51eC9tbWMvbW1jLmg+CQkvKiBmb3IgUjFfU1BJXyogYml0IHZhbHVlcyAqLworI2luY2x1
ZGUgPGxpbnV4L21tYy9jYXJkLmg+CiAKICNpbmNsdWRlIDxsaW51eC9zcGkvc3BpLmg+CiAjaW5j
bHVkZSA8bGludXgvc3BpL21tY19zcGkuaD4KQEAgLTg5LDE0ICs5MCwxMiBAQAogI2RlZmluZSBN
TUNfU1BJX0JMT0NLU0laRQk1MTIKIAogCi0vKiBUaGVzZSBmaXhlZCB0aW1lb3V0cyBjb21lIGZy
b20gdGhlIGxhdGVzdCBTRCBzcGVjcywgd2hpY2ggc2F5IHRvIGlnbm9yZQotICogdGhlIENTRCB2
YWx1ZXMuICBUaGUgUjFCIHZhbHVlIGlzIGZvciBjYXJkIGVyYXNlIChlLmcuIHRoZSAiSSBmb3Jn
b3QgdGhlCisvKgorICogVGhlIFIxQiB2YWx1ZSBpcyBmb3IgY2FyZCBlcmFzZSAoZS5nLiB0aGUg
IkkgZm9yZ290IHRoZQogICogY2FyZCdzIHBhc3N3b3JkIiBzY2VuYXJpbyk7IGl0J3MgbW9zdGx5
IGFwcGxpZWQgdG8gU1RPUF9UUkFOU01JU1NJT04gYWZ0ZXIKICAqIHJlYWRzIHdoaWNoIHRha2Vz
IG5vd2hlcmUgbmVhciB0aGF0IGxvbmcuICBPbGRlciBjYXJkcyBtYXkgYmUgYWJsZSB0byB1c2UK
ICAqIHNob3J0ZXIgdGltZW91dHMgLi4uIGJ1dCB3aHkgYm90aGVyPwogICovCi0jZGVmaW5lIHJl
YWRibG9ja190aW1lb3V0CWt0aW1lX3NldCgwLCAxMDAgKiAxMDAwICogMTAwMCkKLSNkZWZpbmUg
d3JpdGVibG9ja190aW1lb3V0CWt0aW1lX3NldCgwLCAyNTAgKiAxMDAwICogMTAwMCkKICNkZWZp
bmUgcjFiX3RpbWVvdXQJCWt0aW1lX3NldCgzLCAwKQogCiAKQEAgLTIxNCwxNSArMjEzLDQ0IEBA
IG1tY19zcGlfc2tpcChzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBrdGltZV90IHRpbWVvdXQs
IHVuc2lnbmVkIG4sIHU4IGJ5dGUpCiAJcmV0dXJuIC1FVElNRURPVVQ7CiB9CiAKKy8qCisgKiBS
ZXR1cm4gdGhlIHRpbWVvdXQgdmFsdWUgZm9yIHRoaXMgY2FyZC4KKyAqLworc3RhdGljIGt0aW1l
X3QKK21tY19nZXRfdGltZW91dChzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3QgbW1j
X2RhdGEgKmRhdGEpCit7CisJdW5zaWduZWQgaW50IHRpbWVvdXRfbnM7CisKKwkvKiBJZiBjYXJk
IGhhc24ndCBiZWVuIGluaXRpYWxpc2VkLCB1c2UgZGVmYXVsdCB0aW1lb3V0cy4gKi8KKwlpZiAo
IWhvc3QtPm1tYy0+Y2FyZCkgeworCQlpZiAoZGF0YS0+ZmxhZ3MgJiBNTUNfREFUQV9XUklURSkK
KwkJCXRpbWVvdXRfbnMgPSAyNTAwMDAwMDA7CisJCWVsc2UKKwkJCXRpbWVvdXRfbnMgPSAxMDAw
MDAwMDA7CisJfSBlbHNlIHsKKwkJdGltZW91dF9ucyA9IGRhdGEtPnRpbWVvdXRfbnM7CisJCXRp
bWVvdXRfbnMgKz0gZGF0YS0+dGltZW91dF9jbGtzICogMTAwMCAgKiAxMDAwIC8KKwkJCShob3N0
LT5tbWMtPmNhcmQtPmhvc3QtPmlvcy5jbG9jayk7CisJfQorCisJLyogCisJICogVGhlIHJlYXNv
biB3ZSdyZSBhZGRpbmcgMCBhbmQgYSBuYW5vc2Vjb25kIHZhbHVlIGhlcmUgaXMgYmVjYXVzZQor
CSAqIHRoZSB0aW1lb3V0X25zIHZhbHVlIG1heSBiZSBncmVhdGVyIHRoYW4gb25lIHNlY29uZCwg
d2hpY2ggCisJICoga3RpbWVfc2V0KCkgZG9lcyBub3QgaGFuZGxlIHByb3Blcmx5LiBUaGUgY29y
cmVjdCBsb2dpYyB0byBoYW5kbGUKKwkgKiB0aGlzIG92ZXJmbG93IGlzIGluIGt0aW1lX2FkZF9u
cygpIGhvd2V2ZXIuCisJICovCisJcmV0dXJuIGt0aW1lX2FkZF9ucyhrdGltZV9zZXQoMCwgMCks
IHRpbWVvdXRfbnMpOworfQorCiBzdGF0aWMgaW5saW5lIGludAogbW1jX3NwaV93YWl0X3VuYnVz
eShzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBrdGltZV90IHRpbWVvdXQpCiB7CiAJcmV0dXJu
IG1tY19zcGlfc2tpcChob3N0LCB0aW1lb3V0LCBzaXplb2YoaG9zdC0+ZGF0YS0+c3RhdHVzKSwg
MCk7CiB9CiAKLXN0YXRpYyBpbnQgbW1jX3NwaV9yZWFkdG9rZW4oc3RydWN0IG1tY19zcGlfaG9z
dCAqaG9zdCkKK3N0YXRpYyBpbnQgbW1jX3NwaV9yZWFkdG9rZW4oc3RydWN0IG1tY19zcGlfaG9z
dCAqaG9zdCwga3RpbWVfdCB0aW1lb3V0KQogewotCXJldHVybiBtbWNfc3BpX3NraXAoaG9zdCwg
cmVhZGJsb2NrX3RpbWVvdXQsIDEsIDB4ZmYpOworCXJldHVybiBtbWNfc3BpX3NraXAoaG9zdCwg
dGltZW91dCwgMSwgMHhmZik7CiB9CiAKIApAQCAtNjA1LDcgKzYzMyw4IEBAIG1tY19zcGlfc2V0
dXBfZGF0YV9tZXNzYWdlKAogICogUmV0dXJuIG5lZ2F0aXZlIGVycm5vLCBlbHNlIHN1Y2Nlc3Mu
CiAgKi8KIHN0YXRpYyBpbnQKLW1tY19zcGlfd3JpdGVibG9jayhzdHJ1Y3QgbW1jX3NwaV9ob3N0
ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQorbW1jX3NwaV93cml0ZWJsb2NrKHN0cnVj
dCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBzcGlfdHJhbnNmZXIgKnQsCisJc3RydWN0IG1t
Y19kYXRhICpkYXRhKQogewogCXN0cnVjdCBzcGlfZGV2aWNlCSpzcGkgPSBob3N0LT5zcGk7CiAJ
aW50CQkJc3RhdHVzLCBpOwpAQCAtNjczLDcgKzcwMiw3IEBAIG1tY19zcGlfd3JpdGVibG9jayhz
dHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQogCQlpZiAo
c2NyYXRjaC0+c3RhdHVzW2ldICE9IDApCiAJCQlyZXR1cm4gMDsKIAl9Ci0JcmV0dXJuIG1tY19z
cGlfd2FpdF91bmJ1c3koaG9zdCwgd3JpdGVibG9ja190aW1lb3V0KTsKKwlyZXR1cm4gbW1jX3Nw
aV93YWl0X3VuYnVzeShob3N0LCBtbWNfZ2V0X3RpbWVvdXQoaG9zdCwgZGF0YSkpOwogfQogCiAv
KgpAQCAtNjkzLDcgKzcyMiw4IEBAIG1tY19zcGlfd3JpdGVibG9jayhzdHJ1Y3QgbW1jX3NwaV9o
b3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQogICogU1RPUF9UUkFOU01JU1NJT04g
Y29tbWFuZC4KICAqLwogc3RhdGljIGludAotbW1jX3NwaV9yZWFkYmxvY2soc3RydWN0IG1tY19z
cGlfaG9zdCAqaG9zdCwgc3RydWN0IHNwaV90cmFuc2ZlciAqdCkKK21tY19zcGlfcmVhZGJsb2Nr
KHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBzcGlfdHJhbnNmZXIgKnQsCisJc3Ry
dWN0IG1tY19kYXRhICpkYXRhKQogewogCXN0cnVjdCBzcGlfZGV2aWNlCSpzcGkgPSBob3N0LT5z
cGk7CiAJaW50CQkJc3RhdHVzOwpAQCAtNzA3LDcgKzczNyw3IEBAIG1tY19zcGlfcmVhZGJsb2Nr
KHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBzcGlfdHJhbnNmZXIgKnQpCiAJCXJl
dHVybiBzdGF0dXM7CiAJc3RhdHVzID0gc2NyYXRjaC0+c3RhdHVzWzBdOwogCWlmIChzdGF0dXMg
PT0gMHhmZiB8fCBzdGF0dXMgPT0gMCkKLQkJc3RhdHVzID0gbW1jX3NwaV9yZWFkdG9rZW4oaG9z
dCk7CisJCXN0YXR1cyA9IG1tY19zcGlfcmVhZHRva2VuKGhvc3QsIG1tY19nZXRfdGltZW91dCho
b3N0LCBkYXRhKSk7CiAKIAlpZiAoc3RhdHVzID09IFNQSV9UT0tFTl9TSU5HTEUpIHsKIAkJaWYg
KGhvc3QtPmRtYV9kZXYpIHsKQEAgLTgzMiw5ICs4NjIsOSBAQCBtbWNfc3BpX2RhdGFfZG8oc3Ry
dWN0IG1tY19zcGlfaG9zdCAqaG9zdCwgc3RydWN0IG1tY19jb21tYW5kICpjbWQsCiAJCQkJdC0+
bGVuKTsKIAogCQkJaWYgKGRpcmVjdGlvbiA9PSBETUFfVE9fREVWSUNFKQotCQkJCXN0YXR1cyA9
IG1tY19zcGlfd3JpdGVibG9jayhob3N0LCB0KTsKKwkJCQlzdGF0dXMgPSBtbWNfc3BpX3dyaXRl
YmxvY2soaG9zdCwgdCwgZGF0YSk7CiAJCQllbHNlCi0JCQkJc3RhdHVzID0gbW1jX3NwaV9yZWFk
YmxvY2soaG9zdCwgdCk7CisJCQkJc3RhdHVzID0gbW1jX3NwaV9yZWFkYmxvY2soaG9zdCwgdCwg
ZGF0YSk7CiAJCQlpZiAoc3RhdHVzIDwgMCkKIAkJCQlicmVhazsKIApAQCAtOTE3LDcgKzk0Nyw3
IEBAIG1tY19zcGlfZGF0YV9kbyhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3QgbW1j
X2NvbW1hbmQgKmNtZCwKIAkJCWlmIChzY3JhdGNoLT5zdGF0dXNbdG1wXSAhPSAwKQogCQkJCXJl
dHVybjsKIAkJfQotCQl0bXAgPSBtbWNfc3BpX3dhaXRfdW5idXN5KGhvc3QsIHdyaXRlYmxvY2tf
dGltZW91dCk7CisJCXRtcCA9IG1tY19zcGlfd2FpdF91bmJ1c3koaG9zdCwgbW1jX2dldF90aW1l
b3V0KGhvc3QsIGRhdGEpKTsKIAkJaWYgKHRtcCA8IDAgJiYgIWRhdGEtPmVycm9yKQogCQkJZGF0
YS0+ZXJyb3IgPSB0bXA7CiAJfQotLSAKMS41LjUuMgoK
------=_Part_12632_24217171.1220880480907--
