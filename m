Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915Ab0AaDro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0AaDro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 22:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236Ab0AaDro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 22:47:44 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:56036 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0AaDrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 22:47:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T3bRCSpSoaSp3VrI8jHKHY0h46PjuC4tKaHV608t0DK5YPfkI/iB+cOznIjcioRo1x
         bV1O735bfi3HZTo0+ptFXzVqgLK+PumKkec5grDtrYitkOcMI+z7ANl6JUvsiX11eE5D
         TRTOqy6kYNaFh6bViMERccLstxHkFiLJp5Y8w=
Date: Sat, 30 Jan 2010 21:47:18 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100131034718.GE27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net> <20100130161114.07278221@infradead.org> <20100131003549.GC27390@mediacenter.gateway.2wire.net> <20100130164716.230dfe31@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100130164716.230dfe31@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 04:47:16PM -0800, Arjan van de Ven wrote:
> On Sat, 30 Jan 2010 18:35:49 -0600
> Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> \
> > 
> > I agree that we are currently depending on a bug in epoll.  The epoll
> > implementation currently rounds up to the next jiffie, so specifying a
> > timeout of 1 ms really just wakes the process up at the next timer
> > tick. I have a patch to fix epoll by converting it to use
> > schedule_hrtimeout_range() that I'll gladly send, but I still need a
> > way to achieve the same thing.
> 
> it's not going to help you; your expectation is incorrect.
> you CANNOT get 1000 iterations per second if you do
> 
> <wait 1 msec>
> <do a bunch of work>
> <wait 1 msec>
> etc in a loop
> 
> the more accurate (read: not rounding down) the implementation, the
> more not-1000 you will get, because to hit 1000 the two actions

Of course that patch makes my situation worse, which was my point.  We
are depending on the _current_ epoll_wait() implementation which calls
schedule_timeout(1).  You do agree that the current epoll_wait()
implementation sleeps less than 1 msec with HZ == 1000 correct?  So as
long as:

work + scheduling_overhead < 1 msec

We _should_ be able to achieve 1000 iterations per second.  I also
realize that with multiple worker processes I need:

(total_work + scheduling_overhead)/number_cpus < 1 msec

With the old kernel I can run 500 of these processes, and I'm hoping
that I'm simply missing the knob I need to tweak to achieve similar
performance on a recent kernel.

Thanks,
Shawn
