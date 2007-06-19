Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbXFSHmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbXFSHmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbXFSHmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:42:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:33685 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbXFSHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mh/NXKN9OmoCeq7LopDyje18q3ED/FnLUSaA6D4dsfTAEQpP5/WHhymeNRYAkC0jI4w5jPUXtw1y6d8u8EP/tZtfjXIk/Fznbi8gVN31C+rwHH5J6xevPG+g7YrJLLtsDDrlNrtxavooWGFdUxs2UcI2+Z3mmqQn5Lm3FPqsytI=
Message-ID: <467788D0.4060802@gmail.com>
Date: Tue, 19 Jun 2007 09:42:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Ingo Korb <ml@akana.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: istallion, init+locking fixes
References: <uir9l9e1j.fsf@dragon.akana.de>
In-Reply-To: <uir9l9e1j.fsf@dragon.akana.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Korb napsal(a):
> Move brdp->iosize assignment in stli_initecp up a few lines to stop the
> driver from requesting an I/O region of length 0.
> 
> Remove spin_lock_irqsave/spin_unlock_irqrestore from __stli_sendcmd as
> all users of that function take the lock already.
> 
> Signed-off-by: Ingo Korb <ml@akana.de>
> ---
> One thing I dislike about this driver: It polls its cards every jiffy to
> look for new data. The cards are able to use interrupts (some of the
> drivers for other OSes use them), but as far as I know there is no open
> documentation. Unfortunately the DOS driver (probably easiest to
> analyze) also uses polling. =(
> 
> 
> diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
> index 7b279d1..0bc1c37 100644
> --- a/drivers/char/istallion.c
> +++ b/drivers/char/istallion.c
> @@ -2168,8 +2168,6 @@ static void __stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigne
>  	unsigned char __iomem *bits;
>  	unsigned long flags;

Remove the flags and you will see the bug, you introduced ;).

> -	spin_lock_irqsave(&brd_lock, flags);
> -
>  	if (test_bit(ST_CMDING, &portp->state)) {
>  		printk(KERN_ERR "STALLION: command already busy, cmd=%x!\n",
>  				(int) cmd);
> @@ -2194,7 +2192,6 @@ static void __stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigne
>  	writeb(readb(bits) | portp->portbit, bits);
>  	set_bit(ST_CMDING, &portp->state);
>  	EBRDDISABLE(brdp);
> -	spin_unlock_irqrestore(&brd_lock, flags);
>  }


regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
