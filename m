Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYIIJHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYIIJHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYIIJHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:07:43 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44777 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbYIIJHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=eINmvFJ9cdvXUF4z6dikHlL9hIXaPGnNac5lLRK9AAVqViHpvjRRXZX1uADWUUWfgo
         Tuj2HPiihOeULZabzdakRZtvlPEivxQxmV5AKTdW1iYAA8jxCLdJQzlY3ZbIwXBvwjMH
         a98aQNLc/H+PVA2z19ndQIwFghVKySiN4/gMM=
Message-ID: <5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
Date: Tue, 9 Sep 2008 10:07:41 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_24530_14899448.1220951261365"
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	 <20080907123832.5ba79c12@mjolnir.drzeus.cx>
	 <5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
	 <20080909092216.46a6eba1@mjolnir.drzeus.cx>
	 <5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
	 <20080909094438.6423b8ef@mjolnir.drzeus.cx>
	 <5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	 <20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_24530_14899448.1220951261365
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/9/9 Pierre Ossman <drzeus-mmc@drzeus.cx>:
> On Tue, 9 Sep 2008 08:59:11 +0100
> "Matt Fleming" <mattjfleming@googlemail.com> wrote:
>
>>
>> OK, just to be clear, where are those fields not used? They are used
>> in the new mmc_get_timeout() function.
>>
>
> Sorry, you're right. I just noticed the !host->mmc->card part and
> assumed you had your own logic in there.
>

No worries.

> Why do you have that part though? What case have you found where you
> need the timeouts and do not have properly set timeout fields?
>

This check was put in place because the function was being called
before the card structure was setup properly. I didn't actually work
out the call path but it stopped the kmmcd thread oopsing :)

How does this patch look for the SDIO case?


diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 044d84e..5ebfe35 100644
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

------=_Part_24530_14899448.1220951261365
Content-Type: text/x-diff; name=mmc-sdio-use-csr-timeout.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkwatiqt0
Content-Disposition: attachment; filename=mmc-sdio-use-csr-timeout.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2NvcmUvY29yZS5jIGIvZHJpdmVycy9tbWMvY29yZS9j
b3JlLmMKaW5kZXggMDQ0ZDg0ZS4uNWViZmUzNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tbWMvY29y
ZS9jb3JlLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9jb3JlLmMKQEAgLTI0OSw4ICsyNDksMTAg
QEAgdm9pZCBtbWNfc2V0X2RhdGFfdGltZW91dChzdHJ1Y3QgbW1jX2RhdGEgKmRhdGEsIGNvbnN0
IHN0cnVjdCBtbWNfY2FyZCAqY2FyZCkKIAkgKiBTRElPIGNhcmRzIG9ubHkgZGVmaW5lIGFuIHVw
cGVyIDEgcyBsaW1pdCBvbiBhY2Nlc3MuCiAJICovCiAJaWYgKG1tY19jYXJkX3NkaW8oY2FyZCkp
IHsKLQkJZGF0YS0+dGltZW91dF9ucyA9IDEwMDAwMDAwMDA7Ci0JCWRhdGEtPnRpbWVvdXRfY2xr
cyA9IDA7CisJCWlmIChkYXRhLT50aW1lb3V0X25zID4gMTAwMDAwMDAwMCkgeworCQkJZGF0YS0+
dGltZW91dF9ucyA9IDEwMDAwMDAwMDA7CisJCQlkYXRhLT50aW1lb3V0X2Nsa3MgPSAwOworCQl9
CiAJCXJldHVybjsKIAl9CiAK
------=_Part_24530_14899448.1220951261365--
