Return-Path: <linux-kernel-owner+w=401wt.eu-S935340AbZDBHn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340AbZDBHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZDBHnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:43:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:30653 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZDBHnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QrFR/IlDA7EOy2ugYzEIDLT6QxIPjYqLxuTAVgFRdwRDir/XesVLmfXBr8q4O3IXln
         GM+PcvnPG8bMZxngV2REnWTdLUmAFkZWVycBMovFGkYSNYj9oEckdoeW+x5qmoqK96Ac
         ksvPm70KDWYzmUuwITghfqgiD6bOR5nEwCez4=
MIME-Version: 1.0
In-Reply-To: <200904012159.n31Lx1QT009156@hera.kernel.org>
References: <200904012159.n31Lx1QT009156@hera.kernel.org>
Date: Thu, 2 Apr 2009 09:43:11 +0200
X-Google-Sender-Auth: f44d4d572b233b08
Message-ID: <10f740e80904020043l1f9afee9i88046826394c3d64@mail.gmail.com>
Subject: Re: serial: fixup /proc/tty/driver/serial after proc_fops conversion
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 23:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
>    serial: fixup /proc/tty/driver/serial after proc_fops conversion
>
>    "struct tty_driver *" lies in m->private not in v which is
>    SEQ_TOKEN_START which is 1 which is enough to trigger NULL dereference
>    next line:
>
>        BUG: unable to handle kernel NULL pointer dereference at 000000ad
>        IP: [<c040d689>] uart_proc_show+0xe/0x2b0
>
>    Noticed by Linus.
>
>    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/serial/serial_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index bf3c0e3..b0bb29d 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -1765,7 +1765,7 @@ static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
>
>  static int uart_proc_show(struct seq_file *m, void *v)
>  {
> -       struct tty_driver *ttydrv = v;
> +       struct tty_driver *ttydrv = m->private;
>        struct uart_driver *drv = ttydrv->driver_state;
>        int i;

Yeah, I've been bitten by this one in the past, too. It's very
confusing to have a `void *'
parameter in a callback whose registration (proc_create_data()) also
takes a `void *'.

What is this `v' parameter actually used for? I couldn't find any
users during a quick
(non-exhaustive) search?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
