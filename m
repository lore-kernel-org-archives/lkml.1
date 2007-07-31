Return-Path: <linux-kernel-owner+w=401wt.eu-S939842AbXGaALX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939842AbXGaALX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXGaALO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:11:14 -0400
Received: from mail.screens.ru ([213.234.233.54]:46501 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbXGaALN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:11:13 -0400
Date: Tue, 31 Jul 2007 04:11:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-ID: <20070731001117.GA583@tv-sign.ru>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730163538.67b256da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Andrew Morton wrote:
>
> On Sun, 29 Jul 2007 19:05:05 +0200
> Manfred Spraul <manfred@colorfullife.com> wrote:
> 
> > Hi Andrew,
> > 
> > poll() returns -EINTR if a signal is pending.
> > EINTR is a bad choice: it means that poll returns to user space if the
> > task is stopped by SIGSTOP/SIGCONT or by the freezer.
> > select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
> > user space for signals that are handled by the kernel.
> > 
> > The patch switches poll() to ERESTARTNOHAND.
> > Tested with FC6. Patch against 2.6.23-rc1-mm1.
> 
> hm.  Is this a fix against
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/broken-out/do_poll-return-eintr-when-signalled.patch
> only, or does mainline also need fixing?

That patch doesn't (at least shouldn't) change the behaviour.

> I guess the consequences of the thing-which-this-fixes aren't huge, s I ca
> queue this up for 2.6.24, after Oleg's
> do_poll-return-eintr-when-signalled.patch?
> 
> > Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> > 
> > --- 2.6/fs/select.c	2007-07-28 20:31:51.000000000 +0200
> > +++ build-2.6/fs/select.c	2007-07-28 21:21:52.000000000 +0200
> > @@ -621,7 +621,7 @@ static int do_poll(unsigned int nfds,  s
> >  		if (!count) {
> >  			count = wait->error;
> >  			if (signal_pending(current))
> > -				count = -EINTR;
> > +				count = -ERESTARTNOHAND;

I am not sure. This means we restart sys_poll() with the same timeout
if there is no pending signal. I think we need ERESTART_RESTARTBLOCK
logic.

Oleg.

