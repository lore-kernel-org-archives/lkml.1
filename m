Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYIAPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYIAPMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYIAPMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:12:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:51523 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYIAPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=F8rMMlZawUZ32mPak6CFTi8yS+/zsgG1NYvUhH5wk36JEhyD2kmE3LjN6HrYENy13H
         1vOZvrF8ZhRDCMlEzcpar0TLS+DDLXeI7tiKMdrw8epq8hc19wzuBDo5R5d2z4g32qGs
         95nxSaqdB8e0k9hV1aPfID7OFGbL3b6btE/II=
Message-ID: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
Date: Mon, 1 Sep 2008 16:12:03 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       dbrownell@users.sourceforge.net
Subject: [RFC][PATCH] MMC: Use write timeout value as read from CSR
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8437_2018082.1220281923513"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8437_2018082.1220281923513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Currently, the MMC/SD over SPI code has a hard-coded timeout value of
250ms on writes. This is correct for SD cards and is specified in the
spec, but it is not correct for MMC cards. For MMC cards the values
that is read from the CSR should be used.

There is already code to ensure that the write timeout value for SD
cards does not exceed 250ms, this patch only affects the MMC case.

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7503b81..2818837 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -34,6 +34,7 @@

 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>             /* for R1_SPI_* bit values */
+#include <linux/mmc/card.h>

 #include <linux/spi/spi.h>
 #include <linux/spi/mmc_spi.h>
@@ -96,7 +97,6 @@
  * shorter timeouts ... but why bother?
  */
 #define readblock_timeout      ktime_set(0, 100 * 1000 * 1000)
-#define writeblock_timeout     ktime_set(0, 250 * 1000 * 1000)
 #define r1b_timeout            ktime_set(3, 0)


@@ -225,6 +225,20 @@ static int mmc_spi_readtoken(struct mmc_spi_host *host)
        return mmc_spi_skip(host, readblock_timeout, 1, 0xff);
 }

+/*
+ * Return the write timeout value (in nanoseconds) for this card.
+ */
+static inline unsigned int
+mmc_get_write_timeout(struct mmc_spi_host *host, struct mmc_data *data)
+{
+       unsigned int timeout_ns;
+
+       timeout_ns = data->timeout_ns;
+       timeout_ns += data->timeout_clks * 1000  * 1000 /
+               (host->mmc->card->host->ios.clock);
+
+       return timeout_ns;
+}

 /*
  * Note that for SPI, cmd->resp[0] is not the same data as "native" protocol
@@ -605,11 +619,13 @@ mmc_spi_setup_data_message(
  * Return negative errno, else success.
  */
 static int
-mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t)
+mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
+       struct mmc_data *data)
 {
        struct spi_device       *spi = host->spi;
        int                     status, i;
        struct scratch          *scratch = host->data;
+       unsigned int            timeout_ns;

        if (host->mmc->use_spi_crc)
                scratch->crc_val = cpu_to_be16(
@@ -673,7 +689,11 @@ mmc_spi_writeblock(struct mmc_spi_host *host,
struct spi_transfer *t)
                if (scratch->status[i] != 0)
                        return 0;
        }
-       return mmc_spi_wait_unbusy(host, writeblock_timeout);
+
+       timeout_ns = mmc_get_write_timeout(host, data);
+
+       return mmc_spi_wait_unbusy(host,
+               ktime_add_ns(ktime_set(0, 0), timeout_ns));
 }

 /*
@@ -832,7 +852,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                                t->len);

                        if (direction == DMA_TO_DEVICE)
-                               status = mmc_spi_writeblock(host, t);
+                               status = mmc_spi_writeblock(host, t, data);
                        else
                                status = mmc_spi_readblock(host, t);
                        if (status < 0)
@@ -872,6 +892,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                struct scratch  *scratch = host->data;
                int             tmp;
                const unsigned  statlen = sizeof(scratch->status);
+               unsigned int    timeout_ns;

                dev_dbg(&spi->dev, "    mmc_spi: STOP_TRAN\n");

@@ -917,7 +938,9 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                        if (scratch->status[tmp] != 0)
                                return;
                }
-               tmp = mmc_spi_wait_unbusy(host, writeblock_timeout);
+               timeout_ns = mmc_get_write_timeout(host, data);
+               tmp = mmc_spi_wait_unbusy(host,
+                       ktime_add_ns(ktime_set(0, 0), timeout_ns));
                if (tmp < 0 && !data->error)
                        data->error = tmp;
        }

------=_Part_8437_2018082.1220281923513
Content-Type: text/x-diff; name=mmc-spi-use-timeout-from-card.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkl8bqrk0
Content-Disposition: attachment;
 filename=mmc-spi-use-timeout-from-card.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2hvc3QvbW1jX3NwaS5jIGIvZHJpdmVycy9tbWMvaG9z
dC9tbWNfc3BpLmMKaW5kZXggNzUwM2I4MS4uMjgxODgzNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
bWMvaG9zdC9tbWNfc3BpLmMKKysrIGIvZHJpdmVycy9tbWMvaG9zdC9tbWNfc3BpLmMKQEAgLTM0
LDYgKzM0LDcgQEAKIAogI2luY2x1ZGUgPGxpbnV4L21tYy9ob3N0Lmg+CiAjaW5jbHVkZSA8bGlu
dXgvbW1jL21tYy5oPgkJLyogZm9yIFIxX1NQSV8qIGJpdCB2YWx1ZXMgKi8KKyNpbmNsdWRlIDxs
aW51eC9tbWMvY2FyZC5oPgogCiAjaW5jbHVkZSA8bGludXgvc3BpL3NwaS5oPgogI2luY2x1ZGUg
PGxpbnV4L3NwaS9tbWNfc3BpLmg+CkBAIC05Niw3ICs5Nyw2IEBACiAgKiBzaG9ydGVyIHRpbWVv
dXRzIC4uLiBidXQgd2h5IGJvdGhlcj8KICAqLwogI2RlZmluZSByZWFkYmxvY2tfdGltZW91dAlr
dGltZV9zZXQoMCwgMTAwICogMTAwMCAqIDEwMDApCi0jZGVmaW5lIHdyaXRlYmxvY2tfdGltZW91
dAlrdGltZV9zZXQoMCwgMjUwICogMTAwMCAqIDEwMDApCiAjZGVmaW5lIHIxYl90aW1lb3V0CQlr
dGltZV9zZXQoMywgMCkKIAogCkBAIC0yMjUsNiArMjI1LDIwIEBAIHN0YXRpYyBpbnQgbW1jX3Nw
aV9yZWFkdG9rZW4oc3RydWN0IG1tY19zcGlfaG9zdCAqaG9zdCkKIAlyZXR1cm4gbW1jX3NwaV9z
a2lwKGhvc3QsIHJlYWRibG9ja190aW1lb3V0LCAxLCAweGZmKTsKIH0KIAorLyoKKyAqIFJldHVy
biB0aGUgd3JpdGUgdGltZW91dCB2YWx1ZSAoaW4gbmFub3NlY29uZHMpIGZvciB0aGlzIGNhcmQu
CisgKi8KK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50CittbWNfZ2V0X3dyaXRlX3RpbWVvdXQo
c3RydWN0IG1tY19zcGlfaG9zdCAqaG9zdCwgc3RydWN0IG1tY19kYXRhICpkYXRhKQoreworCXVu
c2lnbmVkIGludCB0aW1lb3V0X25zOworCisJdGltZW91dF9ucyA9IGRhdGEtPnRpbWVvdXRfbnM7
CisJdGltZW91dF9ucyArPSBkYXRhLT50aW1lb3V0X2Nsa3MgKiAxMDAwICAqIDEwMDAgLworCQko
aG9zdC0+bW1jLT5jYXJkLT5ob3N0LT5pb3MuY2xvY2spOworCisJcmV0dXJuIHRpbWVvdXRfbnM7
Cit9CiAKIC8qCiAgKiBOb3RlIHRoYXQgZm9yIFNQSSwgY21kLT5yZXNwWzBdIGlzIG5vdCB0aGUg
c2FtZSBkYXRhIGFzICJuYXRpdmUiIHByb3RvY29sCkBAIC02MDUsMTEgKzYxOSwxMyBAQCBtbWNf
c3BpX3NldHVwX2RhdGFfbWVzc2FnZSgKICAqIFJldHVybiBuZWdhdGl2ZSBlcnJubywgZWxzZSBz
dWNjZXNzLgogICovCiBzdGF0aWMgaW50Ci1tbWNfc3BpX3dyaXRlYmxvY2soc3RydWN0IG1tY19z
cGlfaG9zdCAqaG9zdCwgc3RydWN0IHNwaV90cmFuc2ZlciAqdCkKK21tY19zcGlfd3JpdGVibG9j
ayhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0LAorCXN0
cnVjdCBtbWNfZGF0YSAqZGF0YSkKIHsKIAlzdHJ1Y3Qgc3BpX2RldmljZQkqc3BpID0gaG9zdC0+
c3BpOwogCWludAkJCXN0YXR1cywgaTsKIAlzdHJ1Y3Qgc2NyYXRjaAkJKnNjcmF0Y2ggPSBob3N0
LT5kYXRhOworCXVuc2lnbmVkIGludAkJdGltZW91dF9uczsKIAogCWlmIChob3N0LT5tbWMtPnVz
ZV9zcGlfY3JjKQogCQlzY3JhdGNoLT5jcmNfdmFsID0gY3B1X3RvX2JlMTYoCkBAIC02NzMsNyAr
Njg5LDExIEBAIG1tY19zcGlfd3JpdGVibG9jayhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBz
dHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQogCQlpZiAoc2NyYXRjaC0+c3RhdHVzW2ldICE9IDApCiAJ
CQlyZXR1cm4gMDsKIAl9Ci0JcmV0dXJuIG1tY19zcGlfd2FpdF91bmJ1c3koaG9zdCwgd3JpdGVi
bG9ja190aW1lb3V0KTsKKworCXRpbWVvdXRfbnMgPSBtbWNfZ2V0X3dyaXRlX3RpbWVvdXQoaG9z
dCwgZGF0YSk7CisKKwlyZXR1cm4gbW1jX3NwaV93YWl0X3VuYnVzeShob3N0LAorCQlrdGltZV9h
ZGRfbnMoa3RpbWVfc2V0KDAsIDApLCB0aW1lb3V0X25zKSk7CiB9CiAKIC8qCkBAIC04MzIsNyAr
ODUyLDcgQEAgbW1jX3NwaV9kYXRhX2RvKHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVj
dCBtbWNfY29tbWFuZCAqY21kLAogCQkJCXQtPmxlbik7CiAKIAkJCWlmIChkaXJlY3Rpb24gPT0g
RE1BX1RPX0RFVklDRSkKLQkJCQlzdGF0dXMgPSBtbWNfc3BpX3dyaXRlYmxvY2soaG9zdCwgdCk7
CisJCQkJc3RhdHVzID0gbW1jX3NwaV93cml0ZWJsb2NrKGhvc3QsIHQsIGRhdGEpOwogCQkJZWxz
ZQogCQkJCXN0YXR1cyA9IG1tY19zcGlfcmVhZGJsb2NrKGhvc3QsIHQpOwogCQkJaWYgKHN0YXR1
cyA8IDApCkBAIC04NzIsNiArODkyLDcgQEAgbW1jX3NwaV9kYXRhX2RvKHN0cnVjdCBtbWNfc3Bp
X2hvc3QgKmhvc3QsIHN0cnVjdCBtbWNfY29tbWFuZCAqY21kLAogCQlzdHJ1Y3Qgc2NyYXRjaAkq
c2NyYXRjaCA9IGhvc3QtPmRhdGE7CiAJCWludAkJdG1wOwogCQljb25zdCB1bnNpZ25lZAlzdGF0
bGVuID0gc2l6ZW9mKHNjcmF0Y2gtPnN0YXR1cyk7CisJCXVuc2lnbmVkIGludAl0aW1lb3V0X25z
OwogCiAJCWRldl9kYmcoJnNwaS0+ZGV2LCAiICAgIG1tY19zcGk6IFNUT1BfVFJBTlxuIik7CiAK
QEAgLTkxNyw3ICs5MzgsOSBAQCBtbWNfc3BpX2RhdGFfZG8oc3RydWN0IG1tY19zcGlfaG9zdCAq
aG9zdCwgc3RydWN0IG1tY19jb21tYW5kICpjbWQsCiAJCQlpZiAoc2NyYXRjaC0+c3RhdHVzW3Rt
cF0gIT0gMCkKIAkJCQlyZXR1cm47CiAJCX0KLQkJdG1wID0gbW1jX3NwaV93YWl0X3VuYnVzeSho
b3N0LCB3cml0ZWJsb2NrX3RpbWVvdXQpOworCQl0aW1lb3V0X25zID0gbW1jX2dldF93cml0ZV90
aW1lb3V0KGhvc3QsIGRhdGEpOworCQl0bXAgPSBtbWNfc3BpX3dhaXRfdW5idXN5KGhvc3QsCisJ
CQlrdGltZV9hZGRfbnMoa3RpbWVfc2V0KDAsIDApLCB0aW1lb3V0X25zKSk7CiAJCWlmICh0bXAg
PCAwICYmICFkYXRhLT5lcnJvcikKIAkJCWRhdGEtPmVycm9yID0gdG1wOwogCX0K
------=_Part_8437_2018082.1220281923513--
