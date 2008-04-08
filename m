Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYDHV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYDHV4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYDHV4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:56:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23743 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYDHV4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sbG0qhqIvRye0/b4FGGJ1SPwoPEW4xVYClOd0qJqDVwXc/eeygiJdXjlbF0NVizIDtbRwZM2HwRdUZl1iqT6LQ7z+kthSnIcSTRjf4rOt4/8h9BvLt77NtuyfJLhXL0tLBDFXIPyWml0KKWfEtRaqFUi5kduweUfM/jyWe+GtJY=
Message-ID: <47FBEA09.6090507@gmail.com>
Date: Tue, 08 Apr 2008 23:56:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org,
       Paul Hardwick <p.hardwick@option.com>
Subject: Re: [PATCH] tty/serial: Lay the foundations for the next set of reworks
References: <20080408165839.47df4517@core>
In-Reply-To: <20080408165839.47df4517@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2008 05:58 PM, Alan Cox wrote:
> - Remove private put_char method that does a write call for one char - we
> have that anyway

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/nozomi.c linux-2.6.25-rc8-mm1/drivers/char/nozomi.c
> --- linux.vanilla-2.6.25-rc8-mm1/drivers/char/nozomi.c	2008-04-08 11:34:51.000000000 +0100
> +++ linux-2.6.25-rc8-mm1/drivers/char/nozomi.c	2008-04-08 11:44:09.000000000 +0100
> @@ -1724,6 +1724,8 @@
>  	const struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
>  	const struct ctrl_ul *ctrl_ul = &port->ctrl_ul;
>  
> +	/* Note: these could change under us but it is not clear this
> +	   matters if so */
>  	return	(ctrl_ul->RTS ? TIOCM_RTS : 0) |
>  		(ctrl_ul->DTR ? TIOCM_DTR : 0) |
>  		(ctrl_dl->DCD ? TIOCM_CAR : 0) |
> @@ -1849,16 +1851,6 @@
>  	spin_unlock_irqrestore(&dc->spin_mutex, flags);
>  }
>  
> -/* just to discard single character writes */
> -static void ntty_put_char(struct tty_struct *tty, unsigned char c)
> -{
> -	/*
> -	 * card does not react correct when we write single chars
> -	 * to the card, so we discard them
> -	 */
> -	DBG2("PUT CHAR Function: %c", c);
> -}
> -
>  /* Returns number of chars in buffer, called by tty layer */
>  static s32 ntty_chars_in_buffer(struct tty_struct *tty)
>  {
> @@ -1892,7 +1884,6 @@
>  	.unthrottle = ntty_unthrottle,
>  	.throttle = ntty_throttle,
>  	.chars_in_buffer = ntty_chars_in_buffer,
> -	.put_char = ntty_put_char,
>  	.tiocmget = ntty_tiocmget,
>  	.tiocmset = ntty_tiocmset,
>  };

Well, how exactly the card behaves on 1 byte write? And how did the .write 
protect against it?

