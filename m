Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbXEIS3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbXEIS3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXEIS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:29:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:13598 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbXEIS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e6YOh7nBb3w9zyM6JJD3JgkDOyWyRWqBHzzEWqWtIsKPTNkyifqIM9daG4N4ysC2eHNRgtZo+hkxnemJYPBDjGJy++NJE/p9OHx4B6mQKqzBQIhFnGf8OzU3fa4wiWkpcg1xR0iWjXvtxXd8GvkjKJy2f0j3CJ3Gll9Z4u/5BDc=
Message-ID: <a781481a0705091129t6a348fb7ya2a225123fca3f6@mail.gmail.com>
Date: Wed, 9 May 2007 23:59:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Cc: "Jarek Poplawski" <jarkao2@o2.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F55DF9FD@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070509053144.GA995@ff.dom.local>
	 <653FFBB4508B9042B5D43DC9E18836F55DF9FD@scsmsx415.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
>
> >-----Original Message-----
> >From: Jarek Poplawski [mailto:jarkao2@o2.pl]
> >Sent: Tuesday, May 08, 2007 10:32 PM
> >To: Andrew Morton
> >Cc: Pallipadi, Venkatesh; linux-kernel@vger.kernel.org; Oleg Nesterov
> >Subject: Re: [PATCH -mm] timer: parenthesis fix in
> >tbase_get_deferrable() etc.
> >
> >On Tue, May 08, 2007 at 04:33:58PM -0700, Andrew Morton wrote:
> >> On Tue, 8 May 2007 12:33:48 +0200
> >> Jarek Poplawski <jarkao2@o2.pl> wrote:
> >>
> >> >
> >> > Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> >> >
> >> > ---
> >> >
> >> > diff -Nurp 2.6.21-mm1-/kernel/timer.c 2.6.21-mm1/kernel/timer.c
> >> > --- 2.6.21-mm1-/kernel/timer.c     2007-05-08
> >11:54:48.000000000 +0200
> >> > +++ 2.6.21-mm1/kernel/timer.c      2007-05-08
> >12:05:11.000000000 +0200
> >> > @@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
> >> >  /* Functions below help us manage 'deferrable' flag */
> >> >  static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
> >> >  {
> >> > -  return ((unsigned int)(unsigned long)base &
> >TBASE_DEFERRABLE_FLAG);
> >> > +  return (unsigned int)((unsigned long)base &
> >TBASE_DEFERRABLE_FLAG);
> >> >  }
> >...
> >> The change makes sense, but does it actually "fix" anything?
> >>
> >
> >Yes - this first place fixes logical error, so it's a sin
> >- even if not punishable in practice. (It's also unnecessary
> >test for long to int conversion.)
> >
>
> I am sorry, I don't understand. What is the logical error in the first
> one?
>
> Actually, your change makes it different from what was originally
> indended.
> Original intention was to type convert base to a 32 bit value and
> bitwise& with FLAG.

But that is not what the original code is doing. If you wanted to
typecast "base" to "a 32 bit value" then you should've used u32
instead.

Anyway, if you originally intended to actually typecast "base" to
unsigned int, then you could do that directly without typecasting it
first to unsigned long (unnecessarily) and then to unsigned int. Of
course, if your system implements a pointer as something bigger than
unsigned int (which is what you eventually convert "base" to), then
you're screwed anyway and the intermediate typecast to unsigned long
doesn't buy you anything at all.

The other 3 changes in this patch were clearly meaningless, though.
