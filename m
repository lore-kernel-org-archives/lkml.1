Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZGBOhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZGBOhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZGBOhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:37:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53248 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753127AbZGBOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:37:12 -0400
Date: Thu, 2 Jul 2009 10:37:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Deleting timers
In-Reply-To: <20090701222234.ee049bc0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0907021029420.3291-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Andrew Morton wrote:

> On Fri, 26 Jun 2009 15:50:54 -0400 (EDT) Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Thomas:
> 
> I'm not Thomas, but I play one on TV.
> 
> > The major difference -- in fact, almost the only difference -- between
> > del_timer() and try_to_del_timer_sync() is that try_to_del_timer_sync
> > returns a special code (-1) if the timer couldn't be deleted because it
> > is currently running, whereas del_timer doesn't check this.
> 
> And del_timer() is heaps faster against a not-pending timer.  I have a
> vague memory that there are some callsites which do this quite a lot.
> 
> And try_to_del_timer_sync() forgot to do timer_stats_timer_clear_start_info().
> 
> > Furthermore, the "_sync" in the name suggests that 
> > try_to_del_timer_sync will wait until a running timer has finished, 
> > which it clearly does not do.
> 
> yup.
> 
> > Despite these facts, the kerneldoc for try_to_del_timer_sync states 
> > that it must not be called in interrupt context.  Why not?  Isn't that
> > advice simply wrong?
> 
> : commit fd450b7318b75343fd76b3d95416853e34e72c95
> : Author:     Oleg Nesterov <oleg@tv-sign.ru>
> : AuthorDate: Thu Jun 23 00:08:59 2005 -0700
> : Commit:     Linus Torvalds <torvalds@ppc970.osdl.org>
> : CommitDate: Thu Jun 23 09:45:16 2005 -0700
> : 
> :     [PATCH] timers: introduce try_to_del_timer_sync()
> :     
> :     This patch splits del_timer_sync() into 2 functions.  The new one,
> :     try_to_del_timer_sync(), returns -1 when it hits executing timer.
> :     
> :     It can be used in interrupt context, or when the caller hold locks which
> :     can prevent completion of the timer's handler.
> :     
> :     NOTE.  Currently it can't be used in interrupt context in UP case, because
> :     ->running_timer is used only with CONFIG_SMP.
> :     
> :     Should the need arise, it is possible to kill #ifdef CONFIG_SMP in
> :     set_running_timer(), it is cheap.
> : 
> 
> The changelog is somewhat vodka-fogged, but there is a bit of a problem
> there.

Okay, thanks.  That makes sense.

> > With this in mind, would there be any objection if I renamed it to 
> > try_to_del_timer(), removed the comment forbidding it to be used in 
> > interrupt context, and made it available even on non-SMP builds?
> 
> Sounds sane to me, if the set_running_timer() change is also made.

It turns out I probably don't need the enhanced functionality after 
all.  So never mind for now...

Alan Stern

