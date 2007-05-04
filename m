Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbXEDNlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbXEDNlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbXEDNlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:41:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbXEDNll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:41:41 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: "Antonino Ingargiola" <tritemio@gmail.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Fri, 4 May 2007 15:41:28 +0200
User-Agent: KMail/1.9.1
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com> <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com> <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
In-Reply-To: <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041541.29731.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > How do you flush the buffers? Simply reading them out?
> 
> Nope. In python I use the flushInput() method of the serial object
> defined by the pyserial library[0]. The method does just this system
> call:
> 
>     termios.tcflush(self.fd, TERMIOS.TCIFLUSH)

		case TCFLSH:
			retval = tty_check_change(tty);
			if (retval)
				return retval;
				
			ld = tty_ldisc_ref(tty);
			switch (arg) {
			case TCIFLUSH:
				if (ld && ld->flush_buffer)
					ld->flush_buffer(tty);
				break;
			case TCIOFLUSH:
				if (ld && ld->flush_buffer)
					ld->flush_buffer(tty);
				/* fall through */
			case TCOFLUSH:
				if (tty->driver->flush_buffer)
					tty->driver->flush_buffer(tty);
				break;
			default:
				tty_ldisc_deref(ld);
				return -EINVAL;
			}
			tty_ldisc_deref(ld);
			return 0;

Most likely you were using n_tty.

static void n_tty_flush_buffer(struct tty_struct * tty)
{
	/* clear everything and unthrottle the driver */
	reset_buffer_flags(tty);
	
	if (!tty->link)
		return;

	if (tty->link->packet) {
		tty->ctrl_status |= TIOCPKT_FLUSHREAD;
		wake_up_interruptible(&tty->link->read_wait);
	}
}

It sets TIOCPKT_FLUSHREAD, which is used nowhere else in the kernel.
And I am confused. Could somebody who has some experience in the
tty layer comment on that?

	Regards
		Oliver
