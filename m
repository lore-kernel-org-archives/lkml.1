Return-Path: <linux-kernel-owner+w=401wt.eu-S937524AbXGaASo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937524AbXGaASo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763298AbXGaASU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:18:20 -0400
Received: from mail.screens.ru ([213.234.233.54]:50767 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbXGaAST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:18:19 -0400
Date: Tue, 31 Jul 2007 04:18:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-ID: <20070731001847.GA623@tv-sign.ru>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <20070731001117.GA583@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731001117.GA583@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Oleg Nesterov wrote:
>
> > Manfred Spraul <manfred@colorfullife.com> wrote:
> > 
> > > poll() returns -EINTR if a signal is pending.
> > > EINTR is a bad choice: it means that poll returns to user space if the
> > > task is stopped by SIGSTOP/SIGCONT or by the freezer.
> > > select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
> > > user space for signals that are handled by the kernel.
> > > 
> > > The patch switches poll() to ERESTARTNOHAND.
> > > Tested with FC6. Patch against 2.6.23-rc1-mm1.
> > 
> > > --- 2.6/fs/select.c	2007-07-28 20:31:51.000000000 +0200
> > > +++ build-2.6/fs/select.c	2007-07-28 21:21:52.000000000 +0200
> > > @@ -621,7 +621,7 @@ static int do_poll(unsigned int nfds,  s
> > >  		if (!count) {
> > >  			count = wait->error;
> > >  			if (signal_pending(current))
> > > -				count = -EINTR;
> > > +				count = -ERESTARTNOHAND;
> 
> I am not sure. This means we restart sys_poll() with the same timeout
> if there is no pending signal. I think we need ERESTART_RESTARTBLOCK
> logic.

Forgot to mention, sys_select() can use ERESTARTNOHAND because it
modifies "struct timeval __user *tvp" before return, but sys_poll()
gets timeout_msecs by value.

Oleg.

