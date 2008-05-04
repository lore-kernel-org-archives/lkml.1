Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYEDP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYEDP1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYEDP10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:27:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:17429 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYEDP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sXHjgiezvg75CwvUOSC8WTNz8CLskswSTCRU6GCvlDThZg1txRvFHAr5dAV17Wwjnnl9Ja1W/FQ1zkMI8/U84c9tDPKjvAcv8HXhnfUEHtV1Z62szSUA6HaCkCuOEqOf9YAzrDbCwfip2gJuQYaU3OGYsPOZ1eZ3p1lFjkSSQtk=
Message-ID: <386072610805040827w7a606ee2ld24e6752a6c745c7@mail.gmail.com>
Date: Sun, 4 May 2008 23:27:24 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Blackfin Serial Driver: Enable IR function when user application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline N_IRDA
Cc: "Yang, Graf" <Graf.Yang@analog.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080425105545.77b8c5e8@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804241929.m3OJToSE021045@hera.kernel.org>
	 <20080424215004.34517136@the-village.bc.nu>
	 <0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
	 <20080425105545.77b8c5e8@core>
X-Google-Sender-Auth: 07b40eadf53e3842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 5:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Blackfin serial driver register as a UART driver, which will call tty_set_operations(...,&uart_ops), while uart_ops hasn't set_ldisc function.
>  > Do you mean I should declare a tty_ops and call tty_set_operations(..., &tty_ops) in bfin_5xx.c to register my set_ldisc?
>
>  Then we need to add a set_ldisc to uart_ops. I'll do that in todays
>  hacking.
>

Oh, I got the compile failure now:
--
  CC      drivers/serial/bfin_5xx.o
drivers/serial/bfin_5xx.c: In function 'bfin_serial_init':
drivers/serial/bfin_5xx.c:1281: error: 'struct tty_driver' has no
member named 'set_ldisc'
make[2]: *** [drivers/serial/bfin_5xx.o] Error 1
make[1]: *** [drivers/serial] Error 2
make: *** [drivers] Error 2
--

Obviously, it is no way to change code like this for passing compiling:
-- 
-             bfin_serial_reg.tty_driver->set_ldisc = bfin_set_ldisc;
+             bfin_serial_reg.tty_driver->ops->set_ldisc = bfin_set_ldisc;
--
Because the ops uart_ops is const and does not include the set_ldisc.

IMO, adding set_ldisc to uart_ops is useless for Graf's IrDA request,
because this function is specific for Blackfin, not shared by other
UART drivers. Maybe the only way is to create a new tty_operations
named bfin_uart_ops based on uart_ops like below:
--
static const struct tty_operations bfin_uart_ops = {
        .open           = uart_open,
        .close          = uart_close,
        .write          = uart_write,
        .put_char       = uart_put_char,
        .flush_chars    = uart_flush_chars,
        .write_room     = uart_write_room,
        .chars_in_buffer= uart_chars_in_buffer,
        .flush_buffer   = uart_flush_buffer,
        .ioctl          = uart_ioctl,
        .throttle       = uart_throttle,
        .unthrottle     = uart_unthrottle,
        .send_xchar     = uart_send_xchar,
        .set_termios    = uart_set_termios,
        .stop           = uart_stop,
        .start          = uart_start,
        .hangup         = uart_hangup,
        .break_ctl      = uart_break_ctl,
        .wait_until_sent= uart_wait_until_sent,
#ifdef CONFIG_PROC_FS
        .read_proc      = uart_read_proc,
#endif
        .tiocmget       = uart_tiocmget,
        .tiocmset       = uart_tiocmset,
#ifdef CONFIG_CONSOLE_POLL
        .poll_init      = uart_poll_init,
        .poll_get_char  = uart_poll_get_char,
        .poll_put_char  = uart_poll_put_char,
#endif
        .set_ldisc         = bfin_set_ldisc,
};
--

But it looks like funny as copying a whole structure for just one
simple function member assignment.
Alan, do you have any other suggestion for this issue? maybe we can
remove 'const' from struct tty_operations, then we can simply set the
set_ldisc for bfin_set_ldisc on the fly.

Thanks a lot
-Bryan Wu
