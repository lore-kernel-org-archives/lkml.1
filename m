Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbZFWPeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbZFWPeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761015AbZFWPdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:33:11 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:43852 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761024AbZFWPdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=ezAIXiGvR540yFDYOsZ+f7jnrVIeFscxhYdWjrpFQAE/z1QTtW71Wi9ZSbijpnrfxv
         2tGzy9Y9S2LoJmfXL+geehDaO/f/prg1groGwjBcd2tZEQfkDBQmKIZKtDxZyWe9OUHU
         P6y1CJkPhV8Mi510tFn3ZS+EtqMJW709IufCM=
Subject: [PATCH 3/4] MFD/PCAP: set_ts_bits()
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/IiiR6IhySq5pgfitKnj"
Date: Tue, 23 Jun 2009 12:33:10 -0300
Message-Id: <1245771190.7750.42.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/IiiR6IhySq5pgfitKnj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Some TS controller bits are on the same register as the ADC control, save=20
TS specific bits and export a set_ts_bits function so the TS driver can set
it with the adc_mutex lock held.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/mfd/ezx-pcap.c       |   22 ++++++++++++++++++----
 include/linux/mfd/ezx-pcap.h |    1 +
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index de7e637..c512202 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -195,6 +195,19 @@ static void pcap_irq_handler(unsigned int irq, struct =
irq_desc *desc)
 }
=20
 /* ADC */
+void pcap_set_ts_bits(struct pcap_chip *pcap, u32 bits)
+{
+	u32 tmp;
+
+	mutex_lock(&pcap->adc_mutex);
+	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);
+	tmp &=3D ~(PCAP_ADC_TS_M_MASK | PCAP_ADC_TS_REF_LOWPWR);
+	tmp |=3D bits & (PCAP_ADC_TS_M_MASK | PCAP_ADC_TS_REF_LOWPWR);
+	ezx_pcap_write(pcap, PCAP_REG_ADC, tmp);
+	mutex_unlock(&pcap->adc_mutex);
+}
+EXPORT_SYMBOL_GPL(pcap_set_ts_bits);
+
 static void pcap_disable_adc(struct pcap_chip *pcap)
 {
 	u32 tmp;
@@ -217,15 +230,16 @@ static void pcap_adc_trigger(struct pcap_chip *pcap)
 		mutex_unlock(&pcap->adc_mutex);
 		return;
 	}
-	mutex_unlock(&pcap->adc_mutex);
-
-	/* start conversion on requested bank */
-	tmp =3D pcap->adc_queue[head]->flags | PCAP_ADC_ADEN;
+	/* start conversion on requested bank, save TS_M bits */
+	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);
+	tmp &=3D (PCAP_ADC_TS_M_MASK | PCAP_ADC_TS_REF_LOWPWR);
+	tmp |=3D pcap->adc_queue[head]->flags | PCAP_ADC_ADEN;
=20
 	if (pcap->adc_queue[head]->bank =3D=3D PCAP_ADC_BANK_1)
 		tmp |=3D PCAP_ADC_AD_SEL1;
=20
 	ezx_pcap_write(pcap, PCAP_REG_ADC, tmp);
+	mutex_unlock(&pcap->adc_mutex);
 	ezx_pcap_write(pcap, PCAP_REG_ADR, PCAP_ADR_ASC);
 }
=20
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index 6296b49..b15caac 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -29,6 +29,7 @@ int pcap_to_irq(struct pcap_chip *, int);
 int irq_to_pcap(struct pcap_chip *, int);
 int pcap_adc_async(struct pcap_chip *, u8, u32, u8[], void *, void *);
 int pcap_adc_sync(struct pcap_chip *, u8, u32, u8[], u16[]);
+void pcap_set_ts_bits(struct pcap_chip *, u32);
=20
 #define PCAP_SECOND_PORT	1
 #define PCAP_CS_AH		2
--=20
tg: (bd75754..) pcap/set_ts_bits (depends on: pcap/irq_to_pcap)

--=20
Daniel Ribeiro

--=-/IiiR6IhySq5pgfitKnj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpA9bYACgkQw3OYl0G0liSwjwCdHS3kI/bFPhkxmYTLsPs7HCHL
9HAAn0Mrheh09KCmgD5ww8IKoXi8KB09
=bVZw
-----END PGP SIGNATURE-----

--=-/IiiR6IhySq5pgfitKnj--

