Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZJCMJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZJCMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 08:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZJCMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 08:09:57 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46798 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZJCMJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 08:09:56 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Date: Sat, 3 Oct 2009 14:11:40 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20090924154023.GA27480@localhost> <20091002173308.6158d734@lxorguk.ukuu.org.uk> <20091003114229.GB605@localhost>
In-Reply-To: <20091003114229.GB605@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910031411.41543.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 3. Oktober 2009 13:42:29 schrieb Johan Hovold:
> +       spin_lock_irqsave(&port->lock, flags);
> +       if (!port->throttled) {
> +               spin_unlock_irqrestore(&port->lock, flags);
> +               ftdi_submit_read_urb(port, GFP_ATOMIC);
> +       } else
> +               spin_unlock_irqrestore(&port->lock, flags);
> +}
>  
>  static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
>  {
> @@ -2605,33 +2467,30 @@ static int ftdi_ioctl(struct tty_struct *tty,
> struct file *file, static void ftdi_throttle(struct tty_struct *tty)
[..]
> +       spin_lock_irqsave(&port->lock, flags);
> +       port->throttled = 1;
> +       spin_unlock_irqrestore(&port->lock, flags);
>  }
>  
> -
> -static void ftdi_unthrottle(struct tty_struct *tty)
> +void ftdi_unthrottle(struct tty_struct *tty)
[..]
> +       spin_lock_irqsave(&port->lock, flags);
> +       was_throttled = port->throttled;
> +       port->throttled = 0;
> +       spin_unlock_irqrestore(&port->lock, flags);
>  
> -       if (actually_throttled)
> -               schedule_delayed_work(&priv->rx_work, 0);
> +       if (was_throttled && !test_bit(ASYNCB_CLOSING, &port->port.flags))
> +               ftdi_submit_read_urb(port, GFP_KERNEL);
>  }

This unfortunately is incorrect. If an unthrottling happens before the read
callback runs you submit a running URB.

	Regards
		Oliver
 

