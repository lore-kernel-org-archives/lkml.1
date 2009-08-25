Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZHYDju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZHYDju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 23:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZHYDjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 23:39:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:25102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZHYDjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 23:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mCXDZuTRoZ4DyIDjwX9sjCyl7uMnJEQfouutrdfGg35RnhacQy57LC6Anw1vg1lSyA
         AvJt2Aa8pAowUxGLxEvtebYSHQX64wYsn+nxy72zEHftwemTIpvAfY+mDaWZ6Wzsmrd6
         6w0tKyehzo54+/EQ77Scvo1afvSWQsHmaTGTc=
Date: Tue, 25 Aug 2009 05:39:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer
	dereference at 0000000000000008
Message-ID: <20090825033944.GA5227@nowhere>
References: <m163cjhwa4.fsf@fess.ebiederm.org> <m1skfnggrb.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain> <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain> <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:09:08PM -0700, Linus Torvalds wrote:
> 
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



Now that also makes the TTY_LDISC flag clearing unprotected by
tty->ldisc_mutex.

tty_set_ldisc() can play concurrently with these flags right?

tty_ldisc_halt() could remain protected by the mutex, so that the
flag is safely toggled. Once it is cleared, we can ensure no more
user can ref it and the lock can be relaxed while the pending
work is flushed.


> +		flush_scheduled_work();
> +
>  		/* Avoid racing set_ldisc or tty_ldisc_release */
>  		mutex_lock(&tty->ldisc_mutex);
>  		if (tty->ldisc) {	/* Not yet closed */
>  			/* Switch back to N_TTY */
> -			tty_ldisc_halt(tty);
>  			tty_ldisc_reinit(tty);
>  			/* At this point we have a closed ldisc and we want to
>  			   reopen it. We could defer this to the next open but
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

