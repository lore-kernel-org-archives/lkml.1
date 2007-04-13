Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXDMVIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXDMVIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXDMVIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:08:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030284AbXDMVIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:08:23 -0400
Date: Fri, 13 Apr 2007 14:08:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change kernel threads to ignore signals instead of
 blocking them
Message-Id: <20070413140802.3798a6bc.akpm@linux-foundation.org>
In-Reply-To: <m1bqhspdkj.fsf@ebiederm.dsl.xmission.com>
References: <20070413073116.GA1540@tv-sign.ru>
	<m1bqhspdkj.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 08:13:32 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > On top of Eric's
> >
> > 	kthread-dont-depend-on-work-queues-take-2.patch
> >
> > Currently kernel threads use sigprocmask(SIG_BLOCK) to protect against signals.
> > This doesn't prevent the signal delivery, this only blocks signal_wake_up().
> > Every "killall -33 kthreadd" means a "struct siginfo" leak.
> >
> > Change kthreadd_setup() to set all handlers to SIG_IGN instead of blocking them
> > (make a new helper ignore_signals() for that). If the kernel thread needs some
> > signal, it should use allow_signal() anyway, and in that case it should not use
> > CLONE_SIGHAND.
> >
> > Note that we can't change daemonize() (should die!) in the same way, because
> > it can be used along with CLONE_SIGHAND. This means that allow_signal() still
> > should unblock the signal to work correctly with daemonize()ed threads.
> >
> > However, disallow_signal() doesn't block the signal any longer but ignores it.
> >
> > NOTE: with or without this patch the kernel threads are not protected from
> > handle_stop_signal(), this seems harmless, but not good.
> 
> Hmm.  I like it all except for disallow_signal.
> 
> disallow_signal currently only has one user, jffs2.  While jffs2
> currently doesn't care, given the way jffs2 is using disallow_signal I
> would expect it would prefer to have the signal blocked.
> 
> Thinking about this some more if jffs2 or anyone else wants blocked
> signal behavior they can go ahead and block the signal.  Keeping
> disallow_signal in sync with allow_signal seems to make sense.

jffs2 actually wants its head examined.  W. T. F. does it think it's
doing in there?

Sigh.
