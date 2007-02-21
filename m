Return-Path: <linux-kernel-owner+w=401wt.eu-S1422692AbXBURCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422692AbXBURCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422693AbXBURCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:02:45 -0500
Received: from mba.ocn.ne.jp ([210.190.142.172]:60829 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422692AbXBURCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:02:44 -0500
Date: Thu, 22 Feb 2007 02:02:42 +0900 (JST)
Message-Id: <20070222.020242.51866797.anemo@mba.ocn.ne.jp>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ralf@linux-mips.org
Subject: Re: [PATCH 2.6.21-rc1] serial: serial_txx9 driver update
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070221164826.61d0b5ea@lxorguk.ukuu.org.uk>
References: <20070222.003142.106263613.anemo@mba.ocn.ne.jp>
	<20070221164826.61d0b5ea@lxorguk.ukuu.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 16:48:26 +0000, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > +#ifdef CONFIG_CPU_TX49XX
> > +	/* TX4925 BUG WORKAROUND.  Accessing SIOC register
> > +	 * immediately after soft reset causes bus error. */
> > +	iob();
> > +	udelay(1);
> > +#endif
> 
> Given this costs 1uS in a path that is not performance critical is it
> worth putting the #ifdef/#endif in instead of having one set of code that
> works for all ?

Thank you for review.  I'll drop the #ifdef.  Also I'll replace iob()
with mmiowb() since it is MIPS specific.

> > +	while (sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST)
> > +		;
> 
> Suppose it doesn't clear ? Should also use cpu_relax() in busy loops
> so any processor variant with power management can do the right thing.

Then I'll put udelay() and a timeout counter for it.  If udelay() was
in the busy loop, cpu_relax() is still recommended?

Here is a patch on top of the previous one.  If this was OK I'll fold
it into one patch.

--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -277,16 +277,15 @@ static void serial_txx9_enable_ms(struct
 static void serial_txx9_initialize(struct uart_port *port)
 {
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	unsigned int tmout = 10000;
 
 	sio_out(up, TXX9_SIFCR, TXX9_SIFCR_SWRST);
-#ifdef CONFIG_CPU_TX49XX
 	/* TX4925 BUG WORKAROUND.  Accessing SIOC register
 	 * immediately after soft reset causes bus error. */
-	iob();
+	mmiowb();
 	udelay(1);
-#endif
-	while (sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST)
-		;
+	while ((sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST) && --tmout)
+		udelay(1);
 	/* TX Int by FIFO Empty, RX Int by Receiving 1 char. */
 	sio_set(up, TXX9_SIFCR,
 		TXX9_SIFCR_TDIL_MAX | TXX9_SIFCR_RDIL_1);
