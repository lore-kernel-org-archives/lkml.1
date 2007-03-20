Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbXCTVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbXCTVxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXCTVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:53:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59323 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbXCTVxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:53:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1: init hangs on tty_mutex
References: <Pine.LNX.4.64.0703201930060.14654@blonde.wat.veritas.com>
Date: Tue, 20 Mar 2007 15:53:26 -0600
In-Reply-To: <Pine.LNX.4.64.0703201930060.14654@blonde.wat.veritas.com> (Hugh
	Dickins's message of "Tue, 20 Mar 2007 19:42:54 +0000 (GMT)")
Message-ID: <m1vegvlgyx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> writes:

> I get a hang at startup or shutdown: tiocsctty() holds tty_mutex, and
> now with Eric's tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
> it can end up calling con_close(), which tries to take tty_mutex.
> So best revert that in hot-fixes, until Eric provides a better.

Well I'm confused I know I tested this, and I even added a printk and
saw it trigger a couple of times.

Hmm.  Looking at the code it is clearly not safe to hold the tty_mutex
when calling tty_vhangup.  I thought the other caller in tty_io.c was doing
that but on a second glance it is clearly not.  And the hangup and close
methods do seem to take the tty_mutex.

How this worked in my testing is beyond me..

I will see if I can generate a better patch later.

Acked-by: Eric W. Biederman <ebiederm@xmission.com>

>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>
> --- 2.6.21-rc4-mm1/drivers/char/tty_io.c 2007-03-20 12:49:34.000000000 +0000
> +++ linux/drivers/char/tty_io.c	2007-03-20 18:14:53.000000000 +0000
> @@ -2980,7 +2980,9 @@ static int tiocsctty(struct tty_struct *
>  			/*
>  			 * Steal it away
>  			 */
> -			tty_vhangup(tty);
> +			read_lock(&tasklist_lock);
> +			session_clear_tty(tty->session);
> +			read_unlock(&tasklist_lock);
>  		} else {
>  			ret = -EPERM;
>  			goto unlock;
