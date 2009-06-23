Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZFWPe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZFWPe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761063AbZFWPeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:34:14 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:49773 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761015AbZFWPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=FVzzFV02gp+Eng4cr7Oakk4W9JyqkSPpcinej4GESETaQZGH2lAklv/tpJ/esbFCjr
         o7hmTyo7vdtOvD0HSY3u55nyyNxQF3HxlmgXs0oAlMUjLxGjxILhHPBt1FeYFSjVbC6e
         3U6BN08rz7kmI1JpkTAqHMceeACJr9ydo9DpI=
Subject: [PATCH 4/4] MFD/PCAP: fix irq bottom handler
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tgc4hscGhLnpIvWczUZu"
Date: Tue, 23 Jun 2009 12:34:13 -0300
Message-Id: <1245771253.7750.44.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tgc4hscGhLnpIvWczUZu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Mask interrupts before servicing them and loop while pcap asserts the inter=
rupt
line.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/mfd/ezx-pcap.c |   49 ++++++++++++++++++++++++++------------------=
---
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index c512202..732664f 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -17,6 +17,7 @@
 #include <linux/irq.h>
 #include <linux/mfd/ezx-pcap.h>
 #include <linux/spi/spi.h>
+#include <linux/gpio.h>
=20
 #define PCAP_ADC_MAXQ		8
 struct pcap_adc_request {
@@ -155,34 +156,38 @@ static void pcap_isr_work(struct work_struct *work)
 	u32 msr, isr, int_sel, service;
 	int irq;
=20
-	ezx_pcap_read(pcap, PCAP_REG_MSR, &msr);
-	ezx_pcap_read(pcap, PCAP_REG_ISR, &isr);
+	do {
+		ezx_pcap_read(pcap, PCAP_REG_MSR, &msr);
+		ezx_pcap_read(pcap, PCAP_REG_ISR, &isr);
=20
-	/* We cant service/ack irqs that are assigned to port 2 */
-	if (!(pdata->config & PCAP_SECOND_PORT)) {
-		ezx_pcap_read(pcap, PCAP_REG_INT_SEL, &int_sel);
-		isr &=3D ~int_sel;
-	}
-	ezx_pcap_write(pcap, PCAP_REG_ISR, isr);
+		/* We cant service/ack irqs that are assigned to port 2 */
+		if (!(pdata->config & PCAP_SECOND_PORT)) {
+			ezx_pcap_read(pcap, PCAP_REG_INT_SEL, &int_sel);
+			isr &=3D ~int_sel;
+		}
=20
-	local_irq_disable();
-	service =3D isr & ~msr;
+		ezx_pcap_write(pcap, PCAP_REG_MSR, isr | msr);
+		ezx_pcap_write(pcap, PCAP_REG_ISR, isr);
=20
-	for (irq =3D pcap->irq_base; service; service >>=3D 1, irq++) {
-		if (service & 1) {
-			struct irq_desc *desc =3D irq_to_desc(irq);
+		local_irq_disable();
+		service =3D isr & ~msr;
+		for (irq =3D pcap->irq_base; service; service >>=3D 1, irq++) {
+			if (service & 1) {
+				struct irq_desc *desc =3D irq_to_desc(irq);
=20
-			if (WARN(!desc, KERN_WARNING
-					"Invalid PCAP IRQ %d\n", irq))
-				break;
+				if (WARN(!desc, KERN_WARNING
+						"Invalid PCAP IRQ %d\n", irq))
+					break;
=20
-			if (desc->status & IRQ_DISABLED)
-				note_interrupt(irq, desc, IRQ_NONE);
-			else
-				desc->handle_irq(irq, desc);
+				if (desc->status & IRQ_DISABLED)
+					note_interrupt(irq, desc, IRQ_NONE);
+				else
+					desc->handle_irq(irq, desc);
+			}
 		}
-	}
-	local_irq_enable();
+		local_irq_enable();
+		ezx_pcap_write(pcap, PCAP_REG_MSR, pcap->msr);
+	} while (gpio_get_value(irq_to_gpio(pcap->spi->irq)));
 }
=20
 static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
--=20
tg: (524551c..) pcap/fix-irq-handler (depends on: pcap/set_ts_bits)

--=20
Daniel Ribeiro

--=-tgc4hscGhLnpIvWczUZu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpA9fUACgkQw3OYl0G0liQmEACeIxJOtwfX0uogvCrW32WsHND8
B04AnjjVpMTa9P6o8kgC0ILjBDeARJHn
=lN1q
-----END PGP SIGNATURE-----

--=-tgc4hscGhLnpIvWczUZu--

