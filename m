Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZB0Dak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZB0Dak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZB0DaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:30:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:25563 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbZB0DaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:30:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=QnpVevelfngcxruKRBl72k8cC83qyxceqNkvygb5fG/cu5YWBLbU3elZP1JZpDfLZ2
         Qg+p2I1/CbLM8nT1v/50ihZg6ld5SfpjEhHEKr0U66cI/d/ClTVWKtiGvETVWB32AIT1
         Xc2BrU6f3gMKhGqq8L/F9W8wRZDnAzUIErnII=
MIME-Version: 1.0
Date: Fri, 27 Feb 2009 11:30:05 +0800
Message-ID: <f17812d70902261930p2365644by28584df1010774bf@mail.gmail.com>
Subject: [PATCH] input: ads7846: introduce platform specific way to 
	synchronize sampling
From: Eric Miao <eric.y.miao@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Content-Type: multipart/mixed; boundary=000e0cd17244c1946f0463de15b7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd17244c1946f0463de15b7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>From 2e5b6e31cf0f3a2addafe9aaebcd6ddcebe30e4c Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Fri, 6 Feb 2009 16:26:52 +0800
Subject: [PATCH] input: ads7846: introduce platform specific way to
synchronize sampling

Noices can be introduced when LCD signals are being driven, some platforms
provide a signal to assist the synchronization of this sampling procedure.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: David Brownell <david-b@pacbell.net>
---
 drivers/input/touchscreen/ads7846.c |   10 ++++++++++
 include/linux/spi/ads7846.h         |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c
b/drivers/input/touchscreen/ads7846.c
index 7c27c8b..e18775a 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -127,6 +127,8 @@ struct ads7846 {
 	void			(*filter_cleanup)(void *data);
 	int			(*get_pendown_state)(void);
 	int			gpio_pendown;
+
+	void			(*wait_for_sync)(void);
 };

 /* leave chip selected when we're done, for quicker re-select? */
@@ -511,6 +513,10 @@ static int get_pendown_state(struct ads7846 *ts)
 	return !gpio_get_value(ts->gpio_pendown);
 }

+static void null_wait_for_sync(void)
+{
+}
+
 /*
  * PENIRQ only kicks the timer.  The timer only reissues the SPI transfer,
  * to retrieve touchscreen status.
@@ -686,6 +692,7 @@ static void ads7846_rx_val(void *ads)
 	default:
 		BUG();
 	}
+	ts->wait_for_sync();
 	status = spi_async(ts->spi, m);
 	if (status)
 		dev_err(&ts->spi->dev, "spi_async --> %d\n",
@@ -723,6 +730,7 @@ static enum hrtimer_restart ads7846_timer(struct
hrtimer *handle)
 	} else {
 		/* pen is still down, continue with the measurement */
 		ts->msg_idx = 0;
+		ts->wait_for_sync();
 		status = spi_async(ts->spi, &ts->msg[0]);
 		if (status)
 			dev_err(&ts->spi->dev, "spi_async --> %d\n", status);
@@ -947,6 +955,8 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 		ts->penirq_recheck_delay_usecs =
 				pdata->penirq_recheck_delay_usecs;

+	ts->wait_for_sync = (pdata->wait_for_sync) ? : null_wait_for_sync;
+
 	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", dev_name(&spi->dev));

 	input_dev->name = "ADS784x Touchscreen";
diff --git a/include/linux/spi/ads7846.h b/include/linux/spi/ads7846.h
index 05eab2f..186c5aa 100644
--- a/include/linux/spi/ads7846.h
+++ b/include/linux/spi/ads7846.h
@@ -51,5 +51,7 @@ struct ads7846_platform_data {
 				 void **filter_data);
 	int	(*filter)	(void *filter_data, int data_idx, int *val);
 	void	(*filter_cleanup)(void *filter_data);
+
+	void	(*wait_for_sync)(void);
 };

-- 
1.6.0.4

--000e0cd17244c1946f0463de15b7
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-input-ads7846-introduce-platform-specific-way-to-s.patch"
Content-Disposition: attachment; 
	filename="0001-input-ads7846-introduce-platform-specific-way-to-s.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_frob0ps60

RnJvbSAyZTViNmUzMWNmMGYzYTJhZGRhZmU5YWFlYmNkNmRkY2ViZTMwZTRjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogRnJpLCA2IEZlYiAyMDA5IDE2OjI2OjUyICswODAwClN1YmplY3Q6IFtQQVRDSF0gaW5wdXQ6
IGFkczc4NDY6IGludHJvZHVjZSBwbGF0Zm9ybSBzcGVjaWZpYyB3YXkgdG8gc3luY2hyb25pemUg
c2FtcGxpbmcKCk5vaWNlcyBjYW4gYmUgaW50cm9kdWNlZCB3aGVuIExDRCBzaWduYWxzIGFyZSBi
ZWluZyBkcml2ZW4sIHNvbWUgcGxhdGZvcm1zCnByb3ZpZGUgYSBzaWduYWwgdG8gYXNzaXN0IHRo
ZSBzeW5jaHJvbml6YXRpb24gb2YgdGhpcyBzYW1wbGluZyBwcm9jZWR1cmUuCgpTaWduZWQtb2Zm
LWJ5OiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KQ2M6IERhdmlkIEJyb3duZWxs
IDxkYXZpZC1iQHBhY2JlbGwubmV0PgotLS0KIGRyaXZlcnMvaW5wdXQvdG91Y2hzY3JlZW4vYWRz
Nzg0Ni5jIHwgICAxMCArKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L3NwaS9hZHM3ODQ2LmggICAg
ICAgICB8ICAgIDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lucHV0L3RvdWNoc2NyZWVuL2Fkczc4NDYu
YyBiL2RyaXZlcnMvaW5wdXQvdG91Y2hzY3JlZW4vYWRzNzg0Ni5jCmluZGV4IDdjMjdjOGIuLmUx
ODc3NWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5wdXQvdG91Y2hzY3JlZW4vYWRzNzg0Ni5jCisr
KyBiL2RyaXZlcnMvaW5wdXQvdG91Y2hzY3JlZW4vYWRzNzg0Ni5jCkBAIC0xMjcsNiArMTI3LDgg
QEAgc3RydWN0IGFkczc4NDYgewogCXZvaWQJCQkoKmZpbHRlcl9jbGVhbnVwKSh2b2lkICpkYXRh
KTsKIAlpbnQJCQkoKmdldF9wZW5kb3duX3N0YXRlKSh2b2lkKTsKIAlpbnQJCQlncGlvX3BlbmRv
d247CisKKwl2b2lkCQkJKCp3YWl0X2Zvcl9zeW5jKSh2b2lkKTsKIH07CiAKIC8qIGxlYXZlIGNo
aXAgc2VsZWN0ZWQgd2hlbiB3ZSdyZSBkb25lLCBmb3IgcXVpY2tlciByZS1zZWxlY3Q/ICovCkBA
IC01MTEsNiArNTEzLDEwIEBAIHN0YXRpYyBpbnQgZ2V0X3BlbmRvd25fc3RhdGUoc3RydWN0IGFk
czc4NDYgKnRzKQogCXJldHVybiAhZ3Bpb19nZXRfdmFsdWUodHMtPmdwaW9fcGVuZG93bik7CiB9
CiAKK3N0YXRpYyB2b2lkIG51bGxfd2FpdF9mb3Jfc3luYyh2b2lkKQoreworfQorCiAvKgogICog
UEVOSVJRIG9ubHkga2lja3MgdGhlIHRpbWVyLiAgVGhlIHRpbWVyIG9ubHkgcmVpc3N1ZXMgdGhl
IFNQSSB0cmFuc2ZlciwKICAqIHRvIHJldHJpZXZlIHRvdWNoc2NyZWVuIHN0YXR1cy4KQEAgLTY4
Niw2ICs2OTIsNyBAQCBzdGF0aWMgdm9pZCBhZHM3ODQ2X3J4X3ZhbCh2b2lkICphZHMpCiAJZGVm
YXVsdDoKIAkJQlVHKCk7CiAJfQorCXRzLT53YWl0X2Zvcl9zeW5jKCk7CiAJc3RhdHVzID0gc3Bp
X2FzeW5jKHRzLT5zcGksIG0pOwogCWlmIChzdGF0dXMpCiAJCWRldl9lcnIoJnRzLT5zcGktPmRl
diwgInNwaV9hc3luYyAtLT4gJWRcbiIsCkBAIC03MjMsNiArNzMwLDcgQEAgc3RhdGljIGVudW0g
aHJ0aW1lcl9yZXN0YXJ0IGFkczc4NDZfdGltZXIoc3RydWN0IGhydGltZXIgKmhhbmRsZSkKIAl9
IGVsc2UgewogCQkvKiBwZW4gaXMgc3RpbGwgZG93biwgY29udGludWUgd2l0aCB0aGUgbWVhc3Vy
ZW1lbnQgKi8KIAkJdHMtPm1zZ19pZHggPSAwOworCQl0cy0+d2FpdF9mb3Jfc3luYygpOwogCQlz
dGF0dXMgPSBzcGlfYXN5bmModHMtPnNwaSwgJnRzLT5tc2dbMF0pOwogCQlpZiAoc3RhdHVzKQog
CQkJZGV2X2VycigmdHMtPnNwaS0+ZGV2LCAic3BpX2FzeW5jIC0tPiAlZFxuIiwgc3RhdHVzKTsK
QEAgLTk0Nyw2ICs5NTUsOCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhZHM3ODQ2X3Byb2JlKHN0
cnVjdCBzcGlfZGV2aWNlICpzcGkpCiAJCXRzLT5wZW5pcnFfcmVjaGVja19kZWxheV91c2VjcyA9
CiAJCQkJcGRhdGEtPnBlbmlycV9yZWNoZWNrX2RlbGF5X3VzZWNzOwogCisJdHMtPndhaXRfZm9y
X3N5bmMgPSAocGRhdGEtPndhaXRfZm9yX3N5bmMpID8gOiBudWxsX3dhaXRfZm9yX3N5bmM7CisK
IAlzbnByaW50Zih0cy0+cGh5cywgc2l6ZW9mKHRzLT5waHlzKSwgIiVzL2lucHV0MCIsIGRldl9u
YW1lKCZzcGktPmRldikpOwogCiAJaW5wdXRfZGV2LT5uYW1lID0gIkFEUzc4NHggVG91Y2hzY3Jl
ZW4iOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zcGkvYWRzNzg0Ni5oIGIvaW5jbHVkZS9s
aW51eC9zcGkvYWRzNzg0Ni5oCmluZGV4IDA1ZWFiMmYuLjE4NmM1YWEgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbGludXgvc3BpL2Fkczc4NDYuaAorKysgYi9pbmNsdWRlL2xpbnV4L3NwaS9hZHM3ODQ2
LmgKQEAgLTUxLDUgKzUxLDcgQEAgc3RydWN0IGFkczc4NDZfcGxhdGZvcm1fZGF0YSB7CiAJCQkJ
IHZvaWQgKipmaWx0ZXJfZGF0YSk7CiAJaW50CSgqZmlsdGVyKQkodm9pZCAqZmlsdGVyX2RhdGEs
IGludCBkYXRhX2lkeCwgaW50ICp2YWwpOwogCXZvaWQJKCpmaWx0ZXJfY2xlYW51cCkodm9pZCAq
ZmlsdGVyX2RhdGEpOworCisJdm9pZAkoKndhaXRfZm9yX3N5bmMpKHZvaWQpOwogfTsKIAotLSAK
MS42LjAuNAoK
--000e0cd17244c1946f0463de15b7--
