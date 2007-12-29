Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbXL2Biw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbXL2Biw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXL2Bio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:38:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46982 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXL2Bio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:38:44 -0500
Date: Sat, 29 Dec 2007 02:38:43 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: chripell@gmail.com
cc: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>
Subject: Re: [PATCH RESEND] max3100 driver
In-Reply-To: <11988468663187-git-send-email-chripell@gmail.com>
Message-ID: <Pine.LNX.4.64.0712290233060.29013@fbirervta.pbzchgretzou.qr>
References: <11988468663187-git-send-email-chripell@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 28 2007 14:01, chripell@gmail.com wrote:
>+
>+ * The initial minor number is 128 to prevent clashes with ttyS:
>+ * mknod /dev/ttyMAX0 c 4 128
>+ */

[4:128] is taken by ttyS64. Please look into Documentation/devices.txt.

>+struct max3100_port_s {
>+	struct uart_port port;
>+	struct spi_device *spi;
>+	struct tty_struct 	*tty;
>+
>+	struct mutex   spi_txrx;/* protects access to the hw */
>+
>+	int rts;		/* rts status, can be MAX3100_RTS or 0 */

possibly be bool then, if it only takes on two values?

>+	int conf;		/* configuration for the MAX31000
>+				 * (bits 0-7, bits 8-11 are irqs) */
>+	int last_cts_rx;	/* last CTS received for flow ctrl */
>+
>+	int tx_buf_cur;	        /* current char to tx */
>+	int tx_buf_tot;		/* current number of chars in tx buf */

Probably unsigned?

>+static int max3100_do_parity(struct max3100_port_s *s, u16 c)
>+{
>+	int parity;
>+	int i, n;
>+
>+	if (s->parity & MAX3100_PARITY_ODD)
>+		parity = 0;
>+	else
>+		parity = 1;

Or
	parity = !!(s->parity & MAX3100_PARITY_ODD);
	n = (s->parity & MAX3100_7BIT) ? 7 : 8;
(up to you)

>+	for (i = 0; i < n; i++)
>+		parity = parity ^ ((c>>i) & 1);

		parity ^= (c >> i) & 1;

>+	return parity;
>+}
>+
>+	if (s->loopback) {
>+		if ((tx & MAX3100_CMD) == MAX3100_RC)
>+			tx |= 1;
>+	}

	if (s->loopback && (tx & MAX3100_CMD) == MAX3100_RC)
		tx |= 1;

>+MODULE_DESCRIPTION("MAX3100 driver");
>+MODULE_LICENSE("GPL");

I notice a steep increase in serial drivers. Everyone got their
new chips for xmas, eh? :)

