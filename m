Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbXIKQwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbXIKQwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXIKQvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:51:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40218 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbXIKQvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:51:53 -0400
Subject: Re: Do not deprecate binary semaphore or do allow mutex in
	software interrupt contexts
From: Peter Zijlstra <peterz@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       arjan <arjan@infradead.org>
In-Reply-To: <36061.50670.qm@web52002.mail.re2.yahoo.com>
References: <36061.50670.qm@web52002.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 18:50:54 +0200
Message-Id: <1189529454.21778.78.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[re-adding CCs, please do not drop these]

On Tue, 2007-09-11 at 09:20 -0700, Matti Linnanvuori wrote:
> Arjan van de Ven:
> > what do you do if the trylock fails?
> 
> Just do not read the status variable now but modify the timer to run later.
> 
> > to be honest, the scenario describe really smells of broken locking, in
> > fact it really sounds like it wants to use spinlocks instead 
> 
> No, I don't think it is broken.

Yes it is.

> Spinlocks can be used, but I don't see them being obviously better in all cases.
> If access takes a long time, it is better to sleep during it.
> And if you sleep, you might just end up creating a new mutex
> implementation with a spinlock.

If you have to wait a long time in an atomic context you've done
something wrong. If you're only reading it from an atomic context you
might consider storing a copy that can be quickly updated and protect
that using a spinlock.

do_update ()
{
  mutex_lock(&my_device_mutex);
  my_device_frob_state(&my_state); /* <-- this takes a _long_ while */
  spin_lock_irq(&my_shadow_state_lock);
  my_shadow_state = state; /* <-- this is a quick memcopy */
  spin_unlock_irq(&my_shadow_state_lock);
  mutex_unlock(&my_device_mutex);
}

do_read()
{
  spin_lock_irq(&my_shadow_state);
  do_something_with_shadow_state(&mt_shadow_state);
  spin_unlock_irq(&my_shadow_state);

  return foo;
}

> Alan Cox:
> > For polling and timer based code its often simpler to do
> >
> >    del_timer_sync(&my_timer);
> >    FrobStuff
> >    add_timer(&my_timer);
> >
> > especially if "FrobStuff" is likely to change when you next need to poll.
> 
> In the scenario I presented, the timer modifies itself to run later.
> Therefore, simply calling del_timer_sync is not enough but you have to
> set an atomic variable to prevent the timer from adding itself again.

Not being too familiar with the timer stuff, it smells wrong what you
say.

As for the whole polling method, consider what Alan said, don't do it if
you don't need to. You'll annoy people at no end. Try to push state
changes where possible.

