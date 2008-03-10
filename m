Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYCJWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYCJWYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYCJWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:24:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:10088 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYCJWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=vmJzzC1SCFtlAD4t7tMfzleE9gl2QwcqTs9NMiKHF9pdlx+r8r8c7Grmhfx/diK0yyY4lJWA6hgFdqYEYf2iJPaX49zyj0LrwodqlkvpwXwY4HnWyuwZlO7yI7izhlTZO1oFPq67YjaevUD3gdDXttsla67lPcOFXESYcx4r4NY=
Message-ID: <47D5B504.6020909@gmail.com>
Date: Mon, 10 Mar 2008 23:24:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Soft carrier handling
References: <20080310215613.43c7acb0@core>
In-Reply-To: <20080310215613.43c7acb0@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2008 10:56 PM, Alan Cox wrote:
> First cut at moving the soft carrier handling knowledge entirely into the
> core code. One or two drivers still needed to snoop these functions to
> track CLOCAL internally. Instead make TIOCSSOFTCAR generate the same
> driver calls as other termios ioctls changing the clocal flag. This
> allows us to remove any driver knowledge and special casing. Also while
> we are at it we can fix the error handling.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c
> --- linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 12:57:53.000000000 +0000
> +++ linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 13:27:09.000000000 +0000
> @@ -753,6 +756,32 @@
[...]
> +static int tty_change_softcar(struct tty_struct *tty, int arg)
> +{
> +	int ret = 0;
> +	int bit = arg ? CLOCAL : 0;
> +	struct ktermios old = *tty->termios;

Maybe a dumb question, but shouldn't be the snapshot done in the critical 
section too?

> +	
> +	mutex_lock(&tty->termios_mutex);
> +	tty->termios->c_cflag &= ~CLOCAL;
> +	tty->termios->c_cflag |= bit;
> +	if (tty->driver->set_termios)
> +		tty->driver->set_termios(tty, &old);
> +	if ((tty->termios->c_cflag & CLOCAL) != bit)
> +		ret = -EINVAL;	
> +	mutex_unlock(&tty->termios_mutex);
> +	return ret;
> +}
