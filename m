Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZEMBUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZEMBUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 21:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZEMBUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 21:20:17 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:55179 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZEMBUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 21:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i2w1RrrIZswMYgUEji6ZEaoJ6XoYAjR2NVrPCR9qXBlQm+VRqrDrEfGKrRR+z+qVor
         7iXAWv6itGFV2aY+HZ29nGbOLn5RZSGU9fvvhGFrMnzY8lSLd37u8kRMj/xPuZI7onC1
         b8DKQMV4CqWv/m5uvVsaUb9XN8o8Z5zG+mV/I=
Date: Wed, 13 May 2009 03:20:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090513012011.GA32518@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com> <20090512154456.GC6255@nowhere> <20090512160434.GD6255@nowhere> <20090512183105.09e628f0@gondolin> <20090512165227.GE6255@nowhere> <20090512191848.25764af6@gondolin> <d82e647a0905121728m278b604bn9a0f5122b964978a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0905121728m278b604bn9a0f5122b964978a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 08:28:15AM +0800, Ming Lei wrote:
> 2009/5/13 Cornelia Huck <cornelia.huck@de.ibm.com>:
> > On Tue, 12 May 2009 18:52:29 +0200,
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> This division would make more sense indeed.
> >>
> >> - async_schedule_inatomic() would be nosync() and would use
> >>   GFP_ATOMIC. I guess the case where we want to run
> >>   a job synchronously from atomic in case of async failure is too rare
> >>   (non-existent?).
> >
> > It would add complexity for those callers providing a function that is
> > safe to be called in both contexts.
> >
> >> - async_schedule_nosync() would be only nosync() and would use
> >>   GFP_KERNEL
> >>
> >> I'm not sure the second case will ever be used though.
> >
> > It might make sense for the "just fail if we cannot get memory" case.
> >
> >>
> >> Another alternative would be to define a single async_schedule_nosync()
> >> which also takes a gfp flag.
> >
> > Wouldn't async_schedule() then need a gfp flag as well?
> >
> 
> IMHO, we should call async_schedule*() from non-atomic contexts and
> async_schedule_inatomic*() from atomic contexts explicitly, so
> async_schedule*()
> use GFP_KERNEL and async_schedule_inatomic*() use GFP_ATOMIC
> always. This can simplify the problem much more.



I think Cornelia is right about the complex case of a job
launched from atomic context that could either be run
synchronously. I have troubles to imagine such case though
but I guess it's possible.

 
> Also we still allow async_schedule*()  to run a job synchronously if
> out of memory
> or other failure. This can keep consistency with before.


Yes, but also most of the current users of async_schedule() could call
it with GFP_KERNEL. For now it's not an issue because it is not widely
used, but who knows how that will evolve...


> Any sugesstions or objections?


I have shared feelings. I don't know if the dual sense of
this new helper deserves enough disambiguation and granularity
to be split up in two parts:

- adding an async_schedule_nosync() helper
- add a new gfpflag_t parameter


Or should we just do:

- adding async_schedule_inatomic() which is a merge of nosync + GFP_ATOMIC
- use GFP_KERNEL in async_schedule()


It depends on the future users. Will someone ever accept to schedule a job
that could end up running synchronously in the worst case?

Frederic.

