Return-Path: <linux-kernel-owner+w=401wt.eu-S1030195AbXAZOUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195AbXAZOUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030226AbXAZOUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:20:43 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:59796 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030195AbXAZOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:20:42 -0500
Date: Fri, 26 Jan 2007 09:20:41 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070126142041.GD7584@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125151639.GH7582@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 10:16:39AM -0500, Lennart Sorensen wrote:
> I am now trying this, which so far seem to help (I had a printk in there
> earlier and managed to trigger that).
> 
> --- ori/drivers/char/tty_io.c	2007-01-24 18:02:48.000000000 -0500
> +++ new/drivers/char/tty_io.c	2007-01-25 09:50:02.000000000 -0500
> @@ -2774,6 +2778,14 @@
>  	spin_lock_irqsave(&tty->buf.lock, flags);
>  	while((tbuf = tty->buf.head) != NULL) {
>  		while ((count = tbuf->commit - tbuf->read) != 0) {
> +			if (!tty->receive_room) {
> +				schedule_delayed_work(&tty->buf.work, 1);
> +				spin_unlock_irqrestore(&tty->buf.lock, flags);
> +				goto out;
> +			}
> +			if (count > tty->receive_room) {
> +				count = tty->receive_room;
> +			}
>  			char_buf = tbuf->char_buf_ptr + tbuf->read;
>  			flag_buf = tbuf->flag_buf_ptr + tbuf->read;
>  			tbuf->read += count;
> 
> This appeared to be (essentially) the key change in 2.6.18 related to
> the check of tty->receive_room.
> 
> I will now run a bunch more tests to see if it manages to keep it from
> having any more character losses.
> 
> Thank you for the suggestion of where to look.

Well it turns out that didn't help.  Neither does 2.6.18 (that one was
the easiest newer one to try).  It does seem as if the error rate is
lower with 2.6.18 than with 2.6.16, so perhaps there was more than one
place that could cause losses in the tty buffering.  I had only 2
failures in 15 hours with 2.6.18, rather than a whole lot of failures
with 2.6.16.  I guess I will have to try 2.6.19 or even something newer.

--
Len Sorensen
