Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbXFISST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbXFISST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXFISSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:18:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:37866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751681AbXFISSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:18:08 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19wljdg1RJwmp7rOwBQL0eV4vx4DmsMadKg/WClkz
	2zco8J6ul+BQkQ
Date: Sat, 9 Jun 2007 20:18:05 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] tty restore locked ioctl file op
Message-ID: <20070609181805.GA2771@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Paul Fulghum <paulkf@microgate.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Nicolas Mailhot <nicolas.mailhot@laposte.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
	Christoph Lameter <clameter@sgi.com>
References: <1179098742.7322.5.camel@rousalka.dyndns.org> <1179396003.31796.4.camel@rousalka.dyndns.org> <20070517094557.c96f7e54.randy.dunlap@oracle.com> <1179421196.5000.5.camel@rousalka.dyndns.org> <1180206615.3430.8.camel@rousalka.dyndns.org> <20070608030629.GA18493@atjola.homenet> <1181315809.4811.5.camel@x2.microgate.com> <1181330448.5365.7.camel@amdx2.microgate.com> <20070608123350.5cc53c10.akpm@linux-foundation.org> <1181334857.3408.0.camel@x2.microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1181334857.3408.0.camel@x2.microgate.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.08 15:34:17 -0500, Paul Fulghum wrote:
> Restore tty locked ioctl handler which was replaced with
> an unlocked ioctl handler in hung_up_tty_fops by the patch:
> 
> commit e10cc1df1d2014f68a4bdcf73f6dd122c4561f94
> Author: Paul Fulghum <paulkf@microgate.com>
> Date:   Thu May 10 22:22:50 2007 -0700
> 
>     tty: add compat_ioctl
> 
> This was reported in:
> [Bug 8473] New: Oops: 0010 [1] SMP
> 
> The bug is caused by switching to hung_up_tty_fops in do_tty_hangup.
> An ioctl call can be waiting on BLK after testing for existence of
> the locked ioctl handler in the normal tty fops, but before calling
> the locked ioctl handler. If a hangup occurs at that point, the
> locked ioctl fop is NULL and an oops occurs.

Sorry for the delay, your mails didn't make it into my inbox, and I
usually just mark threads on which I'm Cc'ed as read in my lkml mailbox,
thus I didn't notice it earlier. Any traces of the lost mails on your
side?

The patch works as expected, no Oops in sight. Regarding the
reproducability, it might be that it was easier to trigger on rc1. When
I retried today with rc4, I only got 2 Oopses in a minute, while the
first test had spitten out about 20 Oopses in 10 seconds (not sure if I
really had rc1 running back then, though).

Thanks,
Björn

> Signed-off-by: Paul Fulghum <paulkf@microgate.com>
> 
> --- a/drivers/char/tty_io.c	2007-06-08 14:26:10.000000000 -0500
> +++ b/drivers/char/tty_io.c	2007-06-08 14:28:58.000000000 -0500
> @@ -1173,8 +1173,14 @@ static unsigned int hung_up_tty_poll(str
>  	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
>  }
>  
> -static long hung_up_tty_ioctl(struct file * file,
> -			      unsigned int cmd, unsigned long arg)
> +static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
> +			     unsigned int cmd, unsigned long arg)
> +{
> +	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
> +}
> +
> +static long hung_up_tty_compat_ioctl(struct file * file,
> +				     unsigned int cmd, unsigned long arg)
>  {
>  	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
>  }
> @@ -1222,8 +1228,8 @@ static const struct file_operations hung
>  	.read		= hung_up_tty_read,
>  	.write		= hung_up_tty_write,
>  	.poll		= hung_up_tty_poll,
> -	.unlocked_ioctl = hung_up_tty_ioctl,
> -	.compat_ioctl	= hung_up_tty_ioctl,
> +	.ioctl		= hung_up_tty_ioctl,
> +	.compat_ioctl	= hung_up_tty_compat_ioctl,
>  	.release	= tty_release,
>  };
>  
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
