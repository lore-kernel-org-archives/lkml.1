Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYIJSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYIJSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYIJSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:10:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbYIJSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:10:38 -0400
Date: Wed, 10 Sep 2008 11:10:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: paccept() oddity
Message-Id: <20080910111016.b289b3eb.akpm@linux-foundation.org>
In-Reply-To: <48AC4B6E.4040409@gmail.com>
References: <48AC4B6E.4040409@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 18:50:54 +0200 Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> Ulrich,
> 
> [
> 2.6.27-rc has paccept():
> 
> int paccept(int fd, struct sockaddr *sockaddr, socklen_t *addrlen,
>          const sigset_t *sigmask, int setsize, int flags)
> ]
> 
> While considering the sigset argument for paccept() (see my previous
> message), and testing that system call, I realized that there is a certain
> oddness in the implementation of paccept().
> 
> Like accept(), paccept() automatically restarts if interrupted by a signal
> handler that was established with the SA_RESTART flag.
> 
> On the other hand, pselect(), ppoll(), and epoll_pwait() are never restarted
> if interrupted by a handler, even if the handler was established with
> SA_RESTART.  (This is the same as with select(), poll(), and epoll_wait().)
> 
> It seems to me that it makes little sense to restart paccept(), especially in
> the case where it is interrupted by a handler for one of the signals that is
> in sigmask, since the whole point of calling paccept() is to block until a
> connection is received, or until one of the signals in sigmask is caught().
> 
> How about changing paccept() so that it is never automatically restarted if
> interrupted by a signal handler, regardless of the SA_RESTART flag.  (In
> other words, paccept() should be consistent with pselect(), ppoll(), and
> epoll_pwait(), rather than being consistent with accept().)  What are your
> thoughts?
> 

Oleg, Roland: would you have the time to ponder the above, please?

If we can't get this nailed down very soon I'd suggest that we disable
sys_paccept() for 2.6.27.  We don't want to be releasing a new system
call into 2.6.27 if there are doubts surrounding its userspace-visible
behaviour.

Thanks.
