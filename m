Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZHYPFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZHYPFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZHYPFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:05:12 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60540 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbZHYPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LF6JoRQwUPO1FmUmkYe5Dzg+F8O4KprCqPxaYJNyJEweX7N0qdwgNVVbP5QgV5LGed
         s25T1kVB6+johCLAaKt5Azwizjt0zmae04rw+MvJt0UWe2KY/UijTslC+WIbSo0ZTAoR
         hohizyX73cPeSlciCIc12kh89Z8XtvY42+Plk=
Date: Tue, 25 Aug 2009 17:05:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer
	dereference at 0000000000000008
Message-ID: <20090825150506.GG6114@nowhere>
References: <m163cjhwa4.fsf@fess.ebiederm.org> <m1skfnggrb.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain> <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain> <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain> <20090825033944.GA5227@nowhere> <alpine.LFD.2.01.0908242043280.3218@localhost.localdomain> <alpine.LFD.2.01.0908242113540.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908242113540.3218@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 09:30:16PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 24 Aug 2009, Linus Torvalds wrote:
> > 
> > Anyway, I'll happily be shown wrong. I think the (second) patch I sent out 
> > is an acceptable hack in the presense of the current locking, but as I 
> > said, I'm not exactly happy about it, because I do think the locking is 
> > broken.
> 
> Btw, another solution to all this would be to just not have that 
> ldisc_mutex deadlock due to do_tty_hangup -> tty_ldisc_hangup at all.
> 
> The actual _flushing_ doesn't need the mutex - it's just that both 
> flushing and hangup is done with workqueues.



Yeah, it would be sad, but having the flushing done in a dedicated workqueue
would solve the need of relaxing the lock, because we would only wait
for the pending flush works, not the hangup works.

But it's sad to create a thread only for that.

 
> If we can avoid the deadlock by not having the (artificial) workqueue 
> dependency, it would allow everybody to just hold on to the mutex over the 
> whole sequence - and would obviate the need for that hacky 
> TTY_LDISC_CHANGING bit thing in tty_set_ldisc.
> 
> In other words, the whole problem really comes in from the fact that 
> do_tty_hangup() is called from "hangup_work", and the workqueues can get 
> hung to the point where you can't then do the (totally _unrelated_) queue 
> flushing.
> 
> Because flush_to_ldisc() itself - which is what we want to do - doesn't 
> need that mutex or the workqueue at all. It could run from any context, 
> afaik.
> 
> So if we were to turn it into just a timer (rather than a "delayed work"), 
> then we'd not need to do that "flush_scheduled_work()" thing at all, and 
> we wouldn't have that interaction with do_tty_hangup(). At which point we 
> could again hold on to locks, because we wouldn't need to worry about the 
> workqueues getting stuck on the mutex (that isn't even needed for the 
> actual flushing part that we want to do!).



Yeah, a simple timer would be better than a dedicated workqueue in that
we don't need a whole thread for such small job.


> 
> So don't get me wrong - there are _multiple_ ways to solve this. But they 
> are all pretty major surgery, changing "big" semantics. We could fix the 
> locking, we could change how we flush, we could do all of those things. 
> And I'd love to. But I think the almost-oneliner is the safest approach 
> right now. It's certainly not perfect, but it's fairly minimal impact.
> 
> 		Linus


Yep.
I hope the progressive work Jens Axboe is doing on workqueues will drop
their serialized nature which leads to such perpetual deadlocks.

