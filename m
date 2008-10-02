Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYJBL4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYJBL4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYJBL4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:56:33 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60958 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYJBL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=mR8SPGOl3XLYm6DRb08fLXc+MsLSGFcrMdPpd3BBRPwfNVxjK3nkPvYMkbrq83uoFX
         rjX2dRmFtZqdKT+gqIfoQYycr1HKhflaprVDjLFgUAOoTQpXsZ+0fUakUfVPqSZ2OyNb
         stGiK75/m1yYOnsLmg8Khz1wyC6lETGcJMAbc=
Message-ID: <5ff4a1e50810020456vd9ede5ewfe15ff1b44987263@mail.gmail.com>
Date: Thu, 2 Oct 2008 12:56:32 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: linux-kernel@vger.kernel.org, "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: [PATCH 1/2] MMC: Use timeout values from CSR
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_207_22383583.1222948592223"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_207_22383583.1222948592223
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From 6c6e19a6554753edc4e25827cd0873ad512192e4 Mon Sep 17 00:00:00 2001
From: Matthew Fleming <matthew.fleming@imgtec.com>
Date: Thu, 2 Oct 2008 12:21:42 +0100
Subject: [PATCH 1/2] MMC: Use timeout values from CSR

Hard-coded timeout values of 250ms for writes and 100ms for reads are
currently used for MMC transactions over SPI. The spec states that the
timeout values from the card should be used.

Signed-off-by: Matthew Fleming <matthew.fleming@imgtec.com>
---
 drivers/mmc/host/mmc_spi.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7503b81..07faf54 100644
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
+       ktime_t timeout)
 {
        struct spi_device       *spi = host->spi;
        int                     status, i;
@@ -673,7 +672,7 @@ mmc_spi_writeblock(struct mmc_spi_host *host,
struct spi_transfer *t)
                if (scratch->status[i] != 0)
                        return 0;
        }
-       return mmc_spi_wait_unbusy(host, writeblock_timeout);
+       return mmc_spi_wait_unbusy(host, timeout);
 }

 /*
@@ -693,7 +692,8 @@ mmc_spi_writeblock(struct mmc_spi_host *host,
struct spi_transfer *t)
  * STOP_TRANSMISSION command.
  */
 static int
-mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t)
+mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
+       ktime_t timeout)
 {
        struct spi_device       *spi = host->spi;
        int                     status;
@@ -707,7 +707,7 @@ mmc_spi_readblock(struct mmc_spi_host *host,
struct spi_transfer *t)
                return status;
        status = scratch->status[0];
        if (status == 0xff || status == 0)
-               status = mmc_spi_readtoken(host);
+               status = mmc_spi_readtoken(host, timeout);

        if (status == SPI_TOKEN_SINGLE) {
                if (host->dma_dev) {
@@ -778,6 +778,8 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
        struct scatterlist      *sg;
        unsigned                n_sg;
        int                     multiple = (data->blocks > 1);
+       u32                     clock_rate;
+       ktime_t                 timeout;

        if (data->flags & MMC_DATA_READ)
                direction = DMA_FROM_DEVICE;
@@ -786,6 +788,14 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
        mmc_spi_setup_data_message(host, multiple, direction);
        t = &host->t;

+       if (t->speed_hz)
+               clock_rate = t->speed_hz;
+       else
+               clock_rate = spi->max_speed_hz;
+
+       timeout = ktime_add_ns(ktime_set(0, 0), data->timeout_ns +
+                       data->timeout_clks * 1000000 / clock_rate);
+
        /* Handle scatterlist segments one at a time, with synch for
         * each 512-byte block
         */
@@ -832,9 +842,9 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                                t->len);

                        if (direction == DMA_TO_DEVICE)
-                               status = mmc_spi_writeblock(host, t);
+                               status = mmc_spi_writeblock(host, t, timeout);
                        else
-                               status = mmc_spi_readblock(host, t);
+                               status = mmc_spi_readblock(host, t, timeout);
                        if (status < 0)
                                break;

@@ -917,7 +927,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
mmc_command *cmd,
                        if (scratch->status[tmp] != 0)
                                return;
                }
-               tmp = mmc_spi_wait_unbusy(host, writeblock_timeout);
+               tmp = mmc_spi_wait_unbusy(host, timeout);
                if (tmp < 0 && !data->error)
                        data->error = tmp;
        }
--
1.5.5.2

------=_Part_207_22383583.1222948592223
Content-Type: text/x-diff; name=0001-MMC-Use-timeout-values-from-CSR.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fltbznwv0
Content-Disposition: attachment;
 filename=0001-MMC-Use-timeout-values-from-CSR.patch

RnJvbSA2YzZlMTlhNjU1NDc1M2VkYzRlMjU4MjdjZDA4NzNhZDUxMjE5MmU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0aGV3IEZsZW1pbmcgPG1hdHRoZXcuZmxlbWluZ0BpbWd0
ZWMuY29tPgpEYXRlOiBUaHUsIDIgT2N0IDIwMDggMTI6MjE6NDIgKzAxMDAKU3ViamVjdDogW1BB
VENIIDEvMl0gTU1DOiBVc2UgdGltZW91dCB2YWx1ZXMgZnJvbSBDU1IKCkhhcmQtY29kZWQgdGlt
ZW91dCB2YWx1ZXMgb2YgMjUwbXMgZm9yIHdyaXRlcyBhbmQgMTAwbXMgZm9yIHJlYWRzIGFyZQpj
dXJyZW50bHkgdXNlZCBmb3IgTU1DIHRyYW5zYWN0aW9ucyBvdmVyIFNQSS4gVGhlIHNwZWMgc3Rh
dGVzIHRoYXQgdGhlCnRpbWVvdXQgdmFsdWVzIGZyb20gdGhlIGNhcmQgc2hvdWxkIGJlIHVzZWQu
CgpTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IEZsZW1pbmcgPG1hdHRoZXcuZmxlbWluZ0BpbWd0ZWMu
Y29tPgotLS0KIGRyaXZlcnMvbW1jL2hvc3QvbW1jX3NwaS5jIHwgICAzMiArKysrKysrKysrKysr
KysrKysrKystLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCAx
MSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21tYy9ob3N0L21tY19zcGkuYyBi
L2RyaXZlcnMvbW1jL2hvc3QvbW1jX3NwaS5jCmluZGV4IDc1MDNiODEuLjA3ZmFmNTQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbW1jL2hvc3QvbW1jX3NwaS5jCisrKyBiL2RyaXZlcnMvbW1jL2hvc3Qv
bW1jX3NwaS5jCkBAIC05NSw4ICs5NSw2IEBACiAgKiByZWFkcyB3aGljaCB0YWtlcyBub3doZXJl
IG5lYXIgdGhhdCBsb25nLiAgT2xkZXIgY2FyZHMgbWF5IGJlIGFibGUgdG8gdXNlCiAgKiBzaG9y
dGVyIHRpbWVvdXRzIC4uLiBidXQgd2h5IGJvdGhlcj8KICAqLwotI2RlZmluZSByZWFkYmxvY2tf
dGltZW91dAlrdGltZV9zZXQoMCwgMTAwICogMTAwMCAqIDEwMDApCi0jZGVmaW5lIHdyaXRlYmxv
Y2tfdGltZW91dAlrdGltZV9zZXQoMCwgMjUwICogMTAwMCAqIDEwMDApCiAjZGVmaW5lIHIxYl90
aW1lb3V0CQlrdGltZV9zZXQoMywgMCkKIAogCkBAIC0yMjAsOSArMjE4LDkgQEAgbW1jX3NwaV93
YWl0X3VuYnVzeShzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBrdGltZV90IHRpbWVvdXQpCiAJ
cmV0dXJuIG1tY19zcGlfc2tpcChob3N0LCB0aW1lb3V0LCBzaXplb2YoaG9zdC0+ZGF0YS0+c3Rh
dHVzKSwgMCk7CiB9CiAKLXN0YXRpYyBpbnQgbW1jX3NwaV9yZWFkdG9rZW4oc3RydWN0IG1tY19z
cGlfaG9zdCAqaG9zdCkKK3N0YXRpYyBpbnQgbW1jX3NwaV9yZWFkdG9rZW4oc3RydWN0IG1tY19z
cGlfaG9zdCAqaG9zdCwga3RpbWVfdCB0aW1lb3V0KQogewotCXJldHVybiBtbWNfc3BpX3NraXAo
aG9zdCwgcmVhZGJsb2NrX3RpbWVvdXQsIDEsIDB4ZmYpOworCXJldHVybiBtbWNfc3BpX3NraXAo
aG9zdCwgdGltZW91dCwgMSwgMHhmZik7CiB9CiAKIApAQCAtNjA1LDcgKzYwMyw4IEBAIG1tY19z
cGlfc2V0dXBfZGF0YV9tZXNzYWdlKAogICogUmV0dXJuIG5lZ2F0aXZlIGVycm5vLCBlbHNlIHN1
Y2Nlc3MuCiAgKi8KIHN0YXRpYyBpbnQKLW1tY19zcGlfd3JpdGVibG9jayhzdHJ1Y3QgbW1jX3Nw
aV9ob3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQorbW1jX3NwaV93cml0ZWJsb2Nr
KHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVjdCBzcGlfdHJhbnNmZXIgKnQsCisJa3Rp
bWVfdCB0aW1lb3V0KQogewogCXN0cnVjdCBzcGlfZGV2aWNlCSpzcGkgPSBob3N0LT5zcGk7CiAJ
aW50CQkJc3RhdHVzLCBpOwpAQCAtNjczLDcgKzY3Miw3IEBAIG1tY19zcGlfd3JpdGVibG9jayhz
dHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQogCQlpZiAo
c2NyYXRjaC0+c3RhdHVzW2ldICE9IDApCiAJCQlyZXR1cm4gMDsKIAl9Ci0JcmV0dXJuIG1tY19z
cGlfd2FpdF91bmJ1c3koaG9zdCwgd3JpdGVibG9ja190aW1lb3V0KTsKKwlyZXR1cm4gbW1jX3Nw
aV93YWl0X3VuYnVzeShob3N0LCB0aW1lb3V0KTsKIH0KIAogLyoKQEAgLTY5Myw3ICs2OTIsOCBA
QCBtbWNfc3BpX3dyaXRlYmxvY2soc3RydWN0IG1tY19zcGlfaG9zdCAqaG9zdCwgc3RydWN0IHNw
aV90cmFuc2ZlciAqdCkKICAqIFNUT1BfVFJBTlNNSVNTSU9OIGNvbW1hbmQuCiAgKi8KIHN0YXRp
YyBpbnQKLW1tY19zcGlfcmVhZGJsb2NrKHN0cnVjdCBtbWNfc3BpX2hvc3QgKmhvc3QsIHN0cnVj
dCBzcGlfdHJhbnNmZXIgKnQpCittbWNfc3BpX3JlYWRibG9jayhzdHJ1Y3QgbW1jX3NwaV9ob3N0
ICpob3N0LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0LAorCWt0aW1lX3QgdGltZW91dCkKIHsKIAlz
dHJ1Y3Qgc3BpX2RldmljZQkqc3BpID0gaG9zdC0+c3BpOwogCWludAkJCXN0YXR1czsKQEAgLTcw
Nyw3ICs3MDcsNyBAQCBtbWNfc3BpX3JlYWRibG9jayhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0
LCBzdHJ1Y3Qgc3BpX3RyYW5zZmVyICp0KQogCQlyZXR1cm4gc3RhdHVzOwogCXN0YXR1cyA9IHNj
cmF0Y2gtPnN0YXR1c1swXTsKIAlpZiAoc3RhdHVzID09IDB4ZmYgfHwgc3RhdHVzID09IDApCi0J
CXN0YXR1cyA9IG1tY19zcGlfcmVhZHRva2VuKGhvc3QpOworCQlzdGF0dXMgPSBtbWNfc3BpX3Jl
YWR0b2tlbihob3N0LCB0aW1lb3V0KTsKIAogCWlmIChzdGF0dXMgPT0gU1BJX1RPS0VOX1NJTkdM
RSkgewogCQlpZiAoaG9zdC0+ZG1hX2RldikgewpAQCAtNzc4LDYgKzc3OCw4IEBAIG1tY19zcGlf
ZGF0YV9kbyhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3QgbW1jX2NvbW1hbmQgKmNt
ZCwKIAlzdHJ1Y3Qgc2NhdHRlcmxpc3QJKnNnOwogCXVuc2lnbmVkCQluX3NnOwogCWludAkJCW11
bHRpcGxlID0gKGRhdGEtPmJsb2NrcyA+IDEpOworCXUzMgkJCWNsb2NrX3JhdGU7CisJa3RpbWVf
dAkJCXRpbWVvdXQ7CiAKIAlpZiAoZGF0YS0+ZmxhZ3MgJiBNTUNfREFUQV9SRUFEKQogCQlkaXJl
Y3Rpb24gPSBETUFfRlJPTV9ERVZJQ0U7CkBAIC03ODYsNiArNzg4LDE0IEBAIG1tY19zcGlfZGF0
YV9kbyhzdHJ1Y3QgbW1jX3NwaV9ob3N0ICpob3N0LCBzdHJ1Y3QgbW1jX2NvbW1hbmQgKmNtZCwK
IAltbWNfc3BpX3NldHVwX2RhdGFfbWVzc2FnZShob3N0LCBtdWx0aXBsZSwgZGlyZWN0aW9uKTsK
IAl0ID0gJmhvc3QtPnQ7CiAKKwlpZiAodC0+c3BlZWRfaHopCisJCWNsb2NrX3JhdGUgPSB0LT5z
cGVlZF9oejsKKwllbHNlCisJCWNsb2NrX3JhdGUgPSBzcGktPm1heF9zcGVlZF9oejsKKworCXRp
bWVvdXQgPSBrdGltZV9hZGRfbnMoa3RpbWVfc2V0KDAsIDApLCBkYXRhLT50aW1lb3V0X25zICsK
KwkJCWRhdGEtPnRpbWVvdXRfY2xrcyAqIDEwMDAwMDAgLyBjbG9ja19yYXRlKTsKKwogCS8qIEhh
bmRsZSBzY2F0dGVybGlzdCBzZWdtZW50cyBvbmUgYXQgYSB0aW1lLCB3aXRoIHN5bmNoIGZvcgog
CSAqIGVhY2ggNTEyLWJ5dGUgYmxvY2sKIAkgKi8KQEAgLTgzMiw5ICs4NDIsOSBAQCBtbWNfc3Bp
X2RhdGFfZG8oc3RydWN0IG1tY19zcGlfaG9zdCAqaG9zdCwgc3RydWN0IG1tY19jb21tYW5kICpj
bWQsCiAJCQkJdC0+bGVuKTsKIAogCQkJaWYgKGRpcmVjdGlvbiA9PSBETUFfVE9fREVWSUNFKQot
CQkJCXN0YXR1cyA9IG1tY19zcGlfd3JpdGVibG9jayhob3N0LCB0KTsKKwkJCQlzdGF0dXMgPSBt
bWNfc3BpX3dyaXRlYmxvY2soaG9zdCwgdCwgdGltZW91dCk7CiAJCQllbHNlCi0JCQkJc3RhdHVz
ID0gbW1jX3NwaV9yZWFkYmxvY2soaG9zdCwgdCk7CisJCQkJc3RhdHVzID0gbW1jX3NwaV9yZWFk
YmxvY2soaG9zdCwgdCwgdGltZW91dCk7CiAJCQlpZiAoc3RhdHVzIDwgMCkKIAkJCQlicmVhazsK
IApAQCAtOTE3LDcgKzkyNyw3IEBAIG1tY19zcGlfZGF0YV9kbyhzdHJ1Y3QgbW1jX3NwaV9ob3N0
ICpob3N0LCBzdHJ1Y3QgbW1jX2NvbW1hbmQgKmNtZCwKIAkJCWlmIChzY3JhdGNoLT5zdGF0dXNb
dG1wXSAhPSAwKQogCQkJCXJldHVybjsKIAkJfQotCQl0bXAgPSBtbWNfc3BpX3dhaXRfdW5idXN5
KGhvc3QsIHdyaXRlYmxvY2tfdGltZW91dCk7CisJCXRtcCA9IG1tY19zcGlfd2FpdF91bmJ1c3ko
aG9zdCwgdGltZW91dCk7CiAJCWlmICh0bXAgPCAwICYmICFkYXRhLT5lcnJvcikKIAkJCWRhdGEt
PmVycm9yID0gdG1wOwogCX0KLS0gCjEuNS41LjIKCg==
------=_Part_207_22383583.1222948592223--
