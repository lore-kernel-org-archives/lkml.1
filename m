Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXFMXTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXFMXTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXFMXTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:19:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:60379 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbXFMXTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:19:13 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20070613230153.7B3034D059F@magilla.localdomain>
References: <20070613230153.7B3034D059F@magilla.localdomain>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 09:18:49 +1000
Message-Id: <1181776729.14818.350.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 16:01 -0700, Roland McGrath wrote:
> 
> > What about something like:
> > 
> >                       do {
> >                               rm_from_queue_full(&mask, &t->pending);
> > -                             recalc_sigpending_and_wake(t);
> >                               t = next_thread(t);
> >                       } while (t != current);
> > +                     recalc_sigpending();
> 
> There is no need for the +, just the -.  The calling thread is the one
> where know there is certainly no perturbation of behavior due to leaving
> TIF_SIGPENDING set rather than clearing it.  It's just going to exit the
> syscall and deal with signal state properly on the way out either way.
> Doing recalc_sigpending is an unnecessary optimization of the corner case.

Fair enough. I'll cook a patch for that one when I'm at work.

> > So at the end of the day, easier to test it inside dequeue_signal().
> 
> Before completely revamping the whole set of entrypoints to be saner all
> around, yes.

btw, another interesting grep is to see how tweak TIF_SIGPENDING by
hand ... there's some scary bits in the tty code too...

Ben.


