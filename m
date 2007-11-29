Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbXK2AQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbXK2AQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXK2AQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:16:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49575 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755355AbXK2AQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:16:13 -0500
Date: Thu, 29 Nov 2007 00:12:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tcsetattr(fd, TCSAFLUSH) on an O_ASYNC pts device always fails
Message-ID: <20071129001236.4ac069bd@the-village.bc.nu>
In-Reply-To: <20071127185321.GA8546@c2.user-mode-linux.org>
References: <20071127185321.GA8546@c2.user-mode-linux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 13:53:21 -0500
Jeff Dike <jdike@addtoit.com> wrote:

> tcsetattr(fd, TCSAFLUSH) will always return -EINTR on a pts device
> when O_ASYNC has been set.  This is demonstrated by the test program
> below - just compile and follow the instructions.  You'll get an
> infinite stream of SIGIOs and -EINTRs.

Cute. This appears to be entirely standards compliant but I agree its not
sane or expected behaviour.

> static void pty_unthrottle(struct tty_struct * tty)
> {
> 	...
> 	tty_wakeup(o_tty);
> 	set_bit(TTY_THROTTLED, &tty->flags);
> }

My first thought would be to only do the tty_wakeup if there is data
pending.

> I'd love to get rid of the set_bit(TTY_THROTTLED, &tty->flags) in
> pty_unthrottle, but it's protected by this comment:
> 
> /* For PTY's, the TTY_THROTTLED
>  * flag is always set, to force the line discipline to always call the
>  * unthrottle routine when there are fewer than TTY_THRESHOLD_UNTHROTTLE 
>  * characters in the queue.  This is necessary since each time this
>  * happens, we need to wake up any sleeping processes that could be
>  * (1) trying to send data to the pty, or (2) waiting in wait_until_sent()
>  * for the pty buffer to be drained.
>  */
> 
> Failing that, there should be a relevant state change in the device
> before it will deliver a SIGIO.  I just have no idea where to put it.

Unfortunately neither am I. If the wakeup can be deferred if there is no
data pending then I think that will do the trick ?
