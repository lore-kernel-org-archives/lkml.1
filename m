Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZFDDVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZFDDVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZFDDVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:21:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42458 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZFDDVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:21:23 -0400
Date: Thu, 4 Jun 2009 05:15:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090604031544.GA23930@redhat.com>
References: <20090601161234.GA10486@redhat.com> <20090601174159.48acf3f5@lxorguk.ukuu.org.uk> <20090601171119.GA13970@redhat.com> <20090601184608.6379440c@lxorguk.ukuu.org.uk> <20090601182305.GA16372@redhat.com> <20090601203845.B010DFC3C7@magilla.sf.frob.com> <20090601223241.GA26788@redhat.com> <20090601230210.C0B15FC3C7@magilla.sf.frob.com> <20090602000850.GA31064@redhat.com> <20090603070939.4E31CFC333@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603070939.4E31CFC333@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Roland McGrath wrote:
>
> > But since the coredumping task is not freezable anyway, perhaps we should
> > change fake_signal_wake_up() to ignore SIGNAL_GROUP_DUMPING task.
>
> That could be a long delay and a lot of i/o before suspending.
>
> > Or we should make the coredumping freezable. This means dump_write/seek
> > and exit_mm() should do try_to_freeze().
>
> Yes, I think this is the thing to do for that issue.

Fortunately, this doesn't look hard. Whatever we do, we should modify
dump_write/seek to check fatal_signal_pending() anyway. Because we can't
know if f_ops->write() pays attention to signals. This means we can just
add try_to_freeze().

As for exit_mm(), we can use freezer_do_not_count() + freezer_count()
around the "for (;;)" loop.

> > In any case, the coredumping is special. If ->write() returns -ERESTART/EINTR
> > it assumes the return to ths user-space, this is not true for the coredump.
> > This means that handling the spurious signals in coredump_file_write() is
> > not so bad if we can't avoid this.
>
> I am not so confident.  It seems far too easy to wind up with some other
> way that TIF_SIGPENDING gets continually set and this loops, for example.
> (This could be some day in the future when fs, driver or pipe-io code
> changes somehow completely obscure.)  It's far better to have confidence
> just in the signals code itself: the only things that set TIF_SIGPENDING
> interlock with the logic of the only things that are expected to clear it.

Looks like, if we introduce a difference between "really killed" tasks and
exiting/execing/coredumping tasks (as discussed in another thread), we get
this all for free.

Oleg.

