Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYIKAjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYIKAjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYIKAjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:39:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYIKAjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:39:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: paccept() oddity
In-Reply-To: Andrew Morton's message of  Wednesday, 10 September 2008 11:10:16 -0700 <20080910111016.b289b3eb.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <48AC4B6E.4040409@gmail.com>
	<20080910111016.b289b3eb.akpm@linux-foundation.org>
Emacs: if SIGINT doesn't work, try a tranquilizer.
Message-Id: <20080911003833.265E7154210@magilla.localdomain>
Date: Wed, 10 Sep 2008 17:38:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any rationale for changing paccept to be an oddball special
case in its EINTR behavior.

select/poll are special cases historically, and that's why the principle of
least astonishment makes it best for pselect/ppoll to match their behavior.

The same principle makes it highly dubious to have paccept differ from
accept in such a subtlety.  I don't see any reason to want it, anyway.
An application that wants to see EINTR can just use sigaction to clear
SA_RESTART.

Frankly, I don't see the rationale for rolling the implicit sigprocmask
into paccept at all.  accept is analogous to read or other i/o calls,
not to select/poll.  It's not any normal plan to fiddle blocked signals
around a blocking i/o call.  Instead, programs use (p)select/poll (and
sometimes also O_NONBLOCK) to manage the blocking and waking up.  Then
when the program finally calls accept, it knows it won't block.  The
atomic signal machinery makes sense for pselect/ppoll to help manage the
corner cases of blocking/wakeup in event loops.  It makes no more sense
to roll blocked signal set changes into accept than it would to have
read, write, etc. all take a sigset_t and do that.


Thanks,
Roland
