Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZHYGRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZHYGRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZHYGRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:17:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:54049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbZHYGRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:17:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,270,1249282800"; 
   d="scan'208";a="544482317"
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer 
	dereference at 0000000000000008
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <7b6bb4a50908242008w12037fd4gf823c7de71971009@mail.gmail.com>
References: <m163cjhwa4.fsf@fess.ebiederm.org>
	 <m1skfnggrb.fsf@fess.ebiederm.org>
	 <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain>
	 <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain>
	 <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
	 <7b6bb4a50908242008w12037fd4gf823c7de71971009@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 14:16:33 +0800
Message-Id: <1251180994.2606.5.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:08 +0800, Xiaotian Feng wrote:
> On Tue, Aug 25, 2009 at 8:09 AM, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> >
> >
> > On Mon, 24 Aug 2009, Linus Torvalds wrote:
> >>
> >> But I wanted to let people know that the patch is clearly not the "last
> >> word" on this. It's a useful thing to try, but we need something better.
> >
> > This may be better (this is a replacement for the previous patch).
> >
> > Instead of using 'cancel_delayed_work_sync()', it makes tty_ldisc_hangup()
> > do a 'flush_scheduled_work()' afterwards, like the other callers already
> > do.
> >
> > And like 'tty_ldisc_release()' already does, it does this all before even
> > getting the ldisc_mutex, avoiding the deadlock.
> >
> > I'm not 100% happy with this patch either, but my remaining unhappiness is
> > more with the tty locking in general that causes this all. I suspect this
> > patch in itself is not any worse than the other hacks we have.
> >
> > Oh, and in case you didn't guess - this is _STILL_ totally untested. It
> > compiles for me, but that's all I'm going to guarantee. I'm just looking
> > at the code (and getting pretty fed up with it ;)
> >
> > And as already mentioned: I doubt the deadlock on tty->ldisc_mutex is
> > anything that would be hit in practice. And even if it can be triggered,
> > the previous patch I sent out is still interesting in a "does it make the
> > problem go away" sense. Because if it doesn't (with or without a new
> > deadlock), then I'm looking at all the wrong places.
> 
> I have run the test case for about 2 hours on my x86_64 machine, no
> panic happens.
I ran the test case and didn't hit the panic again. It seems the patch does work.
But I'm still curious. On my stoakley machine, most panic happens at
fn(data) in function run_timer_softirq=>__run_timers because the register which saves
fn is equal to NULL. I added a fn==NULL checking just before fn(data), and found
it's never equal to NULL which is quite different from the panic info.

> 
> >
> >                Linus
> >
> > ---
> >  drivers/char/tty_ldisc.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
> > index 1733d34..f893d18 100644
> > --- a/drivers/char/tty_ldisc.c
> > +++ b/drivers/char/tty_ldisc.c
> > @@ -508,8 +508,9 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
> >  *     be obtained while the delayed work queue halt ensures that no more
> >  *     data is fed to the ldisc.
> >  *
> > - *     In order to wait for any existing references to complete see
> > - *     tty_ldisc_wait_idle.
> > + *     You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex
> > + *     in order to make sure any currently executing ldisc work is also
> > + *     flushed.
> >  */
> >
> >  static int tty_ldisc_halt(struct tty_struct *tty)
> > @@ -753,11 +754,14 @@ void tty_ldisc_hangup(struct tty_struct *tty)
> >         * N_TTY.
> >         */
> >        if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
> > +               /* Make sure the old ldisc is quiescent */
> > +               tty_ldisc_halt(tty);
> > +               flush_scheduled_work();
> > +
> >                /* Avoid racing set_ldisc or tty_ldisc_release */
> >                mutex_lock(&tty->ldisc_mutex);
> >                if (tty->ldisc) {       /* Not yet closed */
> >                        /* Switch back to N_TTY */
> > -                       tty_ldisc_halt(tty);
> >                        tty_ldisc_reinit(tty);
> >                        /* At this point we have a closed ldisc and we want to
> >                           reopen it. We could defer this to the next open but
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

