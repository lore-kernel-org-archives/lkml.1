Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYIXLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYIXLQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYIXLQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:16:06 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:59793 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYIXLQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=b7MEOMQv2wU6O7zY+uetQgURKmFQKlm6w2OzDqN2dCSqRGXB3iylaARfkmiP+vZd2g
         ftdEtQmQgDeiWvEYRFAYF7m+5IxJsPfLmtVjSTWzLffX9ILgVq2Eigk3kn9M+tk/GyGa
         s80DK27oZk3+xDfXLyPo4cTek9mfMS5WSWb+U=
Message-ID: <5ff4a1e50809240416p3c51587fs320bc9ebff7733c7@mail.gmail.com>
Date: Wed, 24 Sep 2008 12:16:02 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080920130652.05f3da6d@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6528_8533823.1222254962977"
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	 <5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	 <20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
	 <5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
	 <5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
	 <20080914154817.3d618e67@mjolnir.drzeus.cx>
	 <5ff4a1e50809150103v1e250e0x4192e2fe901750a6@mail.gmail.com>
	 <20080915103821.2b618bba@mjolnir.drzeus.cx>
	 <5ff4a1e50809150224o600fd9fhb29e986bdb618464@mail.gmail.com>
	 <20080920130652.05f3da6d@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6528_8533823.1222254962977
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/9/20 Pierre Ossman <drzeus-mmc@drzeus.cx>:
>
> It shouldn't take that long to write the more proper solution, so get
> to it and it should be possible to get in even for .27.
>

OK, attached is the latest attempt at this patch. Because a lot of
host drivers manipulate timeout_ns and timeout_clks I decided not
touch them at all. So, I created a new member of the mmc_data struct
that has the timeout value as a ktime_t. I'm still unsure of how
exactly to tackle the mmc_send_cid and mmc_send_csd() cases, the
timeout value used in the spec is Ncr, where can I find this value?


diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 044d84e..b5c6f5f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -249,8 +249,10 @@ void mmc_set_data_timeout(struct mmc_data *data,
const struct mmc_card *card)
         * SDIO cards only define an upper 1 s limit on access.
         */
        if (mmc_card_sdio(card)) {
-               data->timeout_ns = 1000000000;
-               data->timeout_clks = 0;
+               if (data->timeout_ns > 1000000000) {
+                       data->timeout_ns = 1000000000;
+                       data->timeout_clks = 0;
+               }
                return;
        }

@@ -269,6 +271,11 @@ void mmc_set_data_timeout(struct mmc_data *data,
const struct mmc_card *card)
        data->timeout_ns = card->csd.tacc_ns * mult;
        data->timeout_clks = card->csd.tacc_clks * mult;

+       data->ktimeout = ktime_set(0, 0);
+       data->ktimeout = ktime_add_ns(data->ktimeout, data->timeout_ns);
+       data->ktimeout = ktime_add_ns(data->ktimeout,
+               data->timeout_clks * 1000000 / card->host->ios.clock);
+
        /*
         * SD cards also have an upper limit on the timeout.
         */
@@ -290,6 +297,8 @@ void mmc_set_data_timeout(struct mmc_data *data,
const struct mmc_card *card)
                if (timeout_us > limit_us || mmc_card_blockaddr(card)) {
                        data->timeout_ns = limit_us * 1000;
                        data->timeout_clks = 0;
+                       data->ktimeout = ktime_add_ns(ktime_set(0, 0),
+                                               data->timeout_ns);
                }
        }
 }
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7503b81..cdeb2e5 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -95,8 +95,6 @@
  * reads which takes nowhere near that long.  Older cards may be able to use
  * shorter timeouts ... but why bother?
  */
-#define readblock_timeout      ktime_set(0, 100 * 1000 * 1000)
-#define writeblock_timeout     ktime_set(0, 250 * 1000 * 1000)
 #define r1b_timeout            ktime_set(3, 0)


@@ -220,9 +218,9 @@ mmc_spi_wait_unbusy(struct mmc_spi_host *host,
ktime_t timeout)
        return mmc_spi_skip(host, timeout, sizeof(host->data->status), 0);
 }

-static int mmc_spi_readtoken(struct mmc_spi_host *host)
+static int mmc_spi_readtoken(struct mmc_spi_host *host, ktime_t timeout)
 {
-       return mmc_spi_skip(host, readblock_timeout, 1, 0xff);
+       return mmc_spi_skip(host, timeout, 1, 0xff);
 }


@@ -605,7 +603,8 @@ mmc_spi_setup_data_message(
  * Return negative errno, else success.
  */
 static int
-mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t)
+mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
+       ktime_t writeblock_timeout)
 {
        struct spi_device       *spi = host->spi;
        int                     status, i;
@@ -693,7 +692,8 @@ mmc_spi_writeblock(struct mmc_spi_host *host,
struct spi_transfer *t)
  * STOP_TRANSMISSION command.
  */
 static int
-mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t)
+mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
+       ktime_t readblock_timeout)
 {
        struct spi_device       *spi = host->spi;
        int                     status;
@@ -707,7 +707,7 @@ mmc_spi_readblock(struct mmc_spi_host *host,
struct spi_transfer *t)
                return status;
        status = scratch->status[0];
        if (status == 0xff || status == 0)
-               status = mmc_spi_readtoken(host);
+               status = mmc_spi_readtoken(host, readblock_timeout);

        if (status == SPI_TOKEN_SINGLE) {
                if (host->dma_dev) {
@@ -832,9 +832,11 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                                t->len);

                        if (direction == DMA_TO_DEVICE)
-                               status = mmc_spi_writeblock(host, t);
+                               status = mmc_spi_writeblock(host, t,
+                                               data->ktimeout);
                        else
-                               status = mmc_spi_readblock(host, t);
+                               status = mmc_spi_readblock(host, t,
+                                               data->ktimeout);
                        if (status < 0)
                                break;

@@ -917,7 +919,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                        if (scratch->status[tmp] != 0)
                                return;
                }
-               tmp = mmc_spi_wait_unbusy(host, writeblock_timeout);
+               tmp = mmc_spi_wait_unbusy(host, data->ktimeout);
                if (tmp < 0 && !data->error)
                        data->error = tmp;
        }
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 143cebf..e518391 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -10,6 +10,7 @@

 #include <linux/interrupt.h>
 #include <linux/device.h>
+#include <linux/ktime.h>

 struct request;
 struct mmc_data;
@@ -99,6 +100,7 @@ struct mmc_command {
 struct mmc_data {
        unsigned int            timeout_ns;     /* data timeout (in
ns, max 80ms) */
        unsigned int            timeout_clks;   /* data timeout (in clocks) */
+       ktime_t                 ktimeout;       /* data timeout */
        unsigned int            blksz;          /* data block size */
        unsigned int            blocks;         /* number of blocks */
        unsigned int            error;          /* data error */

------=_Part_6528_8533823.1222254962977
Content-Type: text/x-diff; name=mmc-for-pierre-use-ktime.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flhv1dlx0
Content-Disposition: attachment; filename=mmc-for-pierre-use-ktime.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2NvcmUvY29yZS5jIGIvZHJpdmVycy9tbWMvY29yZS9j
b3JlLmMKaW5kZXggMDQ0ZDg0ZS4uYjVjNmY1ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tbWMvY29y
ZS9jb3JlLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9jb3JlLmMKQEAgLTI0OSw4ICsyNDksMTAg
QEAgdm9pZCBtbWNfc2V0X2RhdGFfdGltZW91dChzdHJ1Y3QgbW1jX2RhdGEgKmRhdGEsIGNvbnN0
IHN0cnVjdCBtbWNfY2FyZCAqY2FyZCkKIAkgKiBTRElPIGNhcmRzIG9ubHkgZGVmaW5lIGFuIHVw
cGVyIDEgcyBsaW1pdCBvbiBhY2Nlc3MuCiAJICovCiAJaWYgKG1tY19jYXJkX3NkaW8oY2FyZCkp
IHsKLQkJZGF0YS0+dGltZW91dF9ucyA9IDEwMDAwMDAwMDA7Ci0JCWRhdGEtPnRpbWVvdXRfY2xr
cyA9IDA7CisJCWlmIChkYXRhLT50aW1lb3V0X25zID4gMTAwMDAwMDAwMCkgeworCQkJZGF0YS0+
dGltZW91dF9ucyA9IDEwMDAwMDAwMDA7CisJCQlkYXRhLT50aW1lb3V0X2Nsa3MgPSAwOworCQl9
CiAJCXJldHVybjsKIAl9CiAKQEAgLTI2OSw2ICsyNzEsMTEgQEAgdm9pZCBtbWNfc2V0X2RhdGFf
dGltZW91dChzdHJ1Y3QgbW1jX2RhdGEgKmRhdGEsIGNvbnN0IHN0cnVjdCBtbWNfY2FyZCAqY2Fy
ZCkKIAlkYXRhLT50aW1lb3V0X25zID0gY2FyZC0+Y3NkLnRhY2NfbnMgKiBtdWx0OwogCWRhdGEt
PnRpbWVvdXRfY2xrcyA9IGNhcmQtPmNzZC50YWNjX2Nsa3MgKiBtdWx0OwogCisJZGF0YS0+a3Rp
bWVvdXQgPSBrdGltZV9zZXQoMCwgMCk7CisJZGF0YS0+a3RpbWVvdXQgPSBrdGltZV9hZGRfbnMo
ZGF0YS0+a3RpbWVvdXQsIGRhdGEtPnRpbWVvdXRfbnMpOworCWRhdGEtPmt0aW1lb3V0ID0ga3Rp
bWVfYWRkX25zKGRhdGEtPmt0aW1lb3V0LAorCQlkYXRhLT50aW1lb3V0X2Nsa3MgKiAxMDAwMDAw
IC8gY2FyZC0+aG9zdC0+aW9zLmNsb2NrKTsKKwogCS8qCiAJICogU0QgY2FyZHMgYWxzbyBoYXZl
IGFuIHVwcGVyIGxpbWl0IG9uIHRoZSB0aW1lb3V0LgogCSAqLwpAQCAtMjkwLDYgKzI5Nyw4IEBA
IHZvaWQgbW1jX3NldF9kYXRhX3RpbWVvdXQoc3RydWN0IG1tY19kYXRhICpkYXRhLCBjb25zdCBz
dHJ1Y3QgbW1jX2NhcmQgKmNhcmQpCiAJCWlmICh0aW1lb3V0X3VzID4gbGltaXRfdXMgfHwgbW1j
X2NhcmRfYmxvY2thZGRyKGNhcmQpKSB7CiAJCQlkYXRhLT50aW1lb3V0X25zID0gbGltaXRfdXMg
KiAxMDAwOwogCQkJZGF0YS0+dGltZW91dF9jbGtzID0gMDsKKwkJCWRhdGEtPmt0aW1lb3V0ID0g
a3RpbWVfYWRkX25zKGt0aW1lX3NldCgwLCAwKSwKKwkJCQkJCWRhdGEtPnRpbWVvdXRfbnMpOwog
CQl9CiAJfQogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9tbWNfc3BpLmMgYi9kcml2
ZXJzL21tYy9ob3N0L21tY19zcGkuYwppbmRleCA3NTAzYjgxLi5jZGViMmU1IDEwMDY0NAotLS0g
YS9kcml2ZXJzL21tYy9ob3N0L21tY19zcGkuYworKysgYi9kcml2ZXJzL21tYy9ob3N0L21tY19z
cGkuYwpAQCAtOTUsOCArOTUsNiBAQAogICogcmVhZHMgd2hpY2ggdGFrZXMgbm93aGVyZSBuZWFy
IHRoYXQgbG9uZy4gIE9sZGVyIGNhcmRzIG1heSBiZSBhYmxlIHRvIHVzZQogICogc2hvcnRlciB0
aW1lb3V0cyAuLi4gYnV0IHdoeSBib3RoZXI/CiAgKi8KLSNkZWZpbmUgcmVhZGJsb2NrX3RpbWVv
dXQJa3RpbWVfc2V0KDAsIDEwMCAqIDEwMDAgKiAxMDAwKQotI2RlZmluZSB3cml0ZWJsb2NrX3Rp
bWVvdXQJa3RpbWVfc2V0KDAsIDI1MCAqIDEwMDAgKiAxMDAwKQogI2RlZmluZSByMWJfdGltZW91
dAkJa3RpbWVfc2V0KDMsIDApCiAKIApAQCAtMjIwLDkgKzIxOCw5IEBAIG1tY19zcGlfd2FpdF91
bmJ1c3koc3RydWN0IG1tY19zcGlfaG9zdCAqaG9zdCwga3RpbWVfdCB0aW1lb3V0KQogCXJldHVy
biBtbWNfc3BpX3NraXAoaG9zdCwgdGltZW91dCwgc2l6ZW9mKGhvc3QtPmRhdGEtPnN0YXR1cyks
IDApOwogfQogCi1zdGF0aWMgaW50IG1tY19zcGlfcmVhZHRva2VuKHN0cnVjdCBtbWNfc3BpX2hv
c3QgKmhvc3QpCitzdGF0aWMgaW50IG1tY19zcGlfcmVhZHRva2VuKHN0cnVjdCBtbWNfc3BpX2hv
c3QgKmhvc3QsIGt0aW1lX3QgdGltZW91dCkKIHsKLQlyZXR1cm4gbW1jX3NwaV9za2lwKGhvc3Qs
IHJlYWRibG9ja190aW1lb3V0LCAxLCAweGZmKTsKKwlyZXR1cm4gbW1jX3NwaV9za2lwKGhvc3Qs
IHRpbWVvdXQsIDEsIDB4ZmYpOwogfQogCiAKQEAgLTYwNSw3ICs2MDMsOCBAQCBtbWNfc3BpX3Nl
dHVwX2RhdGFfbWVzc2FnZSgKICAqIFJldHVybiBuZWdhdGl2ZSBlcnJubywgZWxzZSBzdWNjZXNz
LgogICovCiBzdGF0aWMgaW50Ci1tbWNfc3BpX3dyaXRlYmxvY2soc3RydWN0IG1tY19zcGlfaG9z
dCAqaG9zdCwgc3RydWN0IHNwaV90cmFuc2ZlciAqdCkKK21tY19zcGlfd3JpdGVibG9jayhzdHJ1
Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0LAorCWt0aW1lX3Qg
d3JpdGVibG9ja190aW1lb3V0KQogewogCXN0cnVjdCBzcGlfZGV2aWNlCSpzcGkgPSBob3N0LT5z
cGk7CiAJaW50CQkJc3RhdHVzLCBpOwpAQCAtNjkzLDcgKzY5Miw4IEBAIG1tY19zcGlfd3JpdGVi
bG9jayhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQog
ICogU1RPUF9UUkFOU01JU1NJT04gY29tbWFuZC4KICAqLwogc3RhdGljIGludAotbW1jX3NwaV9y
ZWFkYmxvY2soc3RydWN0IG1tY19zcGlfaG9zdCAqaG9zdCwgc3RydWN0IHNwaV90cmFuc2ZlciAq
dCkKK21tY19zcGlfcmVhZGJsb2NrKHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBz
cGlfdHJhbnNmZXIgKnQsCisJa3RpbWVfdCByZWFkYmxvY2tfdGltZW91dCkKIHsKIAlzdHJ1Y3Qg
c3BpX2RldmljZQkqc3BpID0gaG9zdC0+c3BpOwogCWludAkJCXN0YXR1czsKQEAgLTcwNyw3ICs3
MDcsNyBAQCBtbWNfc3BpX3JlYWRibG9jayhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1
Y3Qgc3BpX3RyYW5zZmVyICp0KQogCQlyZXR1cm4gc3RhdHVzOwogCXN0YXR1cyA9IHNjcmF0Y2gt
PnN0YXR1c1swXTsKIAlpZiAoc3RhdHVzID09IDB4ZmYgfHwgc3RhdHVzID09IDApCi0JCXN0YXR1
cyA9IG1tY19zcGlfcmVhZHRva2VuKGhvc3QpOworCQlzdGF0dXMgPSBtbWNfc3BpX3JlYWR0b2tl
bihob3N0LCByZWFkYmxvY2tfdGltZW91dCk7CiAKIAlpZiAoc3RhdHVzID09IFNQSV9UT0tFTl9T
SU5HTEUpIHsKIAkJaWYgKGhvc3QtPmRtYV9kZXYpIHsKQEAgLTgzMiw5ICs4MzIsMTEgQEAgbW1j
X3NwaV9kYXRhX2RvKHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBtbWNfY29tbWFu
ZCAqY21kLAogCQkJCXQtPmxlbik7CiAKIAkJCWlmIChkaXJlY3Rpb24gPT0gRE1BX1RPX0RFVklD
RSkKLQkJCQlzdGF0dXMgPSBtbWNfc3BpX3dyaXRlYmxvY2soaG9zdCwgdCk7CisJCQkJc3RhdHVz
ID0gbW1jX3NwaV93cml0ZWJsb2NrKGhvc3QsIHQsCisJCQkJCQlkYXRhLT5rdGltZW91dCk7CiAJ
CQllbHNlCi0JCQkJc3RhdHVzID0gbW1jX3NwaV9yZWFkYmxvY2soaG9zdCwgdCk7CisJCQkJc3Rh
dHVzID0gbW1jX3NwaV9yZWFkYmxvY2soaG9zdCwgdCwKKwkJCQkJCWRhdGEtPmt0aW1lb3V0KTsK
IAkJCWlmIChzdGF0dXMgPCAwKQogCQkJCWJyZWFrOwogCkBAIC05MTcsNyArOTE5LDcgQEAgbW1j
X3NwaV9kYXRhX2RvKHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBtbWNfY29tbWFu
ZCAqY21kLAogCQkJaWYgKHNjcmF0Y2gtPnN0YXR1c1t0bXBdICE9IDApCiAJCQkJcmV0dXJuOwog
CQl9Ci0JCXRtcCA9IG1tY19zcGlfd2FpdF91bmJ1c3koaG9zdCwgd3JpdGVibG9ja190aW1lb3V0
KTsKKwkJdG1wID0gbW1jX3NwaV93YWl0X3VuYnVzeShob3N0LCBkYXRhLT5rdGltZW91dCk7CiAJ
CWlmICh0bXAgPCAwICYmICFkYXRhLT5lcnJvcikKIAkJCWRhdGEtPmVycm9yID0gdG1wOwogCX0K
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW1jL2NvcmUuaCBiL2luY2x1ZGUvbGludXgvbW1j
L2NvcmUuaAppbmRleCAxNDNjZWJmLi5lNTE4MzkxIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L21tYy9jb3JlLmgKKysrIGIvaW5jbHVkZS9saW51eC9tbWMvY29yZS5oCkBAIC0xMCw2ICsxMCw3
IEBACiAKICNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KICNpbmNsdWRlIDxsaW51eC9kZXZp
Y2UuaD4KKyNpbmNsdWRlIDxsaW51eC9rdGltZS5oPgogCiBzdHJ1Y3QgcmVxdWVzdDsKIHN0cnVj
dCBtbWNfZGF0YTsKQEAgLTk5LDYgKzEwMCw3IEBAIHN0cnVjdCBtbWNfY29tbWFuZCB7CiBzdHJ1
Y3QgbW1jX2RhdGEgewogCXVuc2lnbmVkIGludAkJdGltZW91dF9uczsJLyogZGF0YSB0aW1lb3V0
IChpbiBucywgbWF4IDgwbXMpICovCiAJdW5zaWduZWQgaW50CQl0aW1lb3V0X2Nsa3M7CS8qIGRh
dGEgdGltZW91dCAoaW4gY2xvY2tzKSAqLworCWt0aW1lX3QJCQlrdGltZW91dDsJLyogZGF0YSB0
aW1lb3V0ICovCiAJdW5zaWduZWQgaW50CQlibGtzejsJCS8qIGRhdGEgYmxvY2sgc2l6ZSAqLwog
CXVuc2lnbmVkIGludAkJYmxvY2tzOwkJLyogbnVtYmVyIG9mIGJsb2NrcyAqLwogCXVuc2lnbmVk
IGludAkJZXJyb3I7CQkvKiBkYXRhIGVycm9yICovCg==
------=_Part_6528_8533823.1222254962977--
