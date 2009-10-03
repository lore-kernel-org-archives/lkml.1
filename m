Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZJCN3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZJCN3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZJCN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:29:34 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:56181 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbZJCN3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:29:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Date: Sat, 3 Oct 2009 15:31:18 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20090924154023.GA27480@localhost> <200910031411.41543.oliver@neukum.org> <20091003122848.GD605@localhost>
In-Reply-To: <20091003122848.GD605@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910031531.19224.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 3. Oktober 2009 14:28:48 schrieb Johan Hovold:
> +void ftdi_unthrottle(struct tty_struct *tty)
[..]
> +       spin_lock_irqsave(&port->lock, flags);
> +       was_throttled = port->throttled;
> +       port->throttled = port->throttle_req = 0;
> +       spin_unlock_irqrestore(&port->lock, flags);
>  
> -       if (actually_throttled)
> -               schedule_delayed_work(&priv->rx_work, 0);
> +       if (was_throttled && !test_bit(ASYNCB_CLOSING, &port->port.flags))
> +               ftdi_submit_read_urb(port, GFP_KERNEL);
>  }

Did you check whether this races with resume()?
If so, you'll need to submit with the spinlock held.

	Regards
		Oliver

