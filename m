Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZH0JQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZH0JQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZH0JQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:16:43 -0400
Received: from mga12.intel.com ([143.182.124.36]:32812 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751920AbZH0JQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="180896813"
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer
	dereference at 0000000000000008
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
References: <m163cjhwa4.fsf@fess.ebiederm.org>
	 <m1skfnggrb.fsf@fess.ebiederm.org>
	 <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain>
	 <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain>
	 <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Aug 2009 17:15:34 +0800
Message-Id: <1251364534.2606.16.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 17:09 -0700, Linus Torvalds wrote:
> 
> On Mon, 24 Aug 2009, Linus Torvalds wrote:
> > 
> > But I wanted to let people know that the patch is clearly not the "last 
> > word" on this. It's a useful thing to try, but we need something better.
> 
> This may be better (this is a replacement for the previous patch).
> 
> Instead of using 'cancel_delayed_work_sync()', it makes tty_ldisc_hangup() 
> do a 'flush_scheduled_work()' afterwards, like the other callers already 
> do.
> 
> And like 'tty_ldisc_release()' already does, it does this all before even 
> getting the ldisc_mutex, avoiding the deadlock.
> 
> I'm not 100% happy with this patch either, but my remaining unhappiness is 
> more with the tty locking in general that causes this all. I suspect this 
> patch in itself is not any worse than the other hacks we have.
> 
> Oh, and in case you didn't guess - this is _STILL_ totally untested. It 
> compiles for me, but that's all I'm going to guarantee. I'm just looking 
> at the code (and getting pretty fed up with it ;)
> 
> And as already mentioned: I doubt the deadlock on tty->ldisc_mutex is 
> anything that would be hit in practice. And even if it can be triggered, 
> the previous patch I sent out is still interesting in a "does it make the 
> problem go away" sense. Because if it doesn't (with or without a new 
> deadlock), then I'm looking at all the wrong places.
> 
> 		Linus
> 
I traced kernel and the root cause is really that the process doesn't wait for
the work to be complete. So a new process picks up the released tty/work to
use it. After the new process deletes the timer but before releasing the tty,
the old scheduled work is started to add timer. Then, the new process releases
the tty struct, including work/timer. So later on when the timer rearmed by the old
scheduled work expires, kernel panic.

> ---
>  drivers/char/tty_ldisc.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
> index 1733d34..f893d18 100644
> --- a/drivers/char/tty_ldisc.c
> +++ b/drivers/char/tty_ldisc.c
> @@ -508,8 +508,9 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
>   *	be obtained while the delayed work queue halt ensures that no more
>   *	data is fed to the ldisc.
>   *
> - *	In order to wait for any existing references to complete see
> - *	tty_ldisc_wait_idle.
> + *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex
> + *	in order to make sure any currently executing ldisc work is also
> + *	flushed.
>   */
>  
>  static int tty_ldisc_halt(struct tty_struct *tty)
> @@ -753,11 +754,14 @@ void tty_ldisc_hangup(struct tty_struct *tty)
>  	 * N_TTY.
>  	 */
>  	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
> +		/* Make sure the old ldisc is quiescent */
> +		tty_ldisc_halt(tty);
> +		flush_scheduled_work();
Perhaps it's better with below:
	int ret = ﻿tty_ldisc_halt(tty);
	if (!ret)
		﻿flush_scheduled_work();


