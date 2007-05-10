Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXEJI1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXEJI1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbXEJI0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:26:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:38335 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbXEJI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eiQ2JrZ20lgN0QD+KQz45ko1KElEAXqe+1McVzXwBztVJIKbivIBQYX8FDE8gYnJ69/orvBS5Yr9TRf8LpV25f64G7z8/Nf1sdgWMffKxzAiEarx/YmGCbezFRZCvACDA2FKrFbLbzODw3Og9gp4sF9zJzLFVlrVbxUizgYSAc0=
Message-ID: <a781481a0705100126x6a649c16ic26409b4ffe80ed3@mail.gmail.com>
Date: Thu, 10 May 2007 13:56:27 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Cc: "Jarek Poplawski" <jarkao2@o2.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705091129t6a348fb7ya2a225123fca3f6@mail.gmail.com>
	 <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> >  static inline unsigned int
> >tbase_get_deferrable(tvec_base_t *base)
> >> >> >  {
> >> >> > -  return ((unsigned int)(unsigned long)base &
> >> >TBASE_DEFERRABLE_FLAG);
> >> >> > +  return (unsigned int)((unsigned long)base &
> >> >TBASE_DEFERRABLE_FLAG);
> >> >> >  }
> >> >...
> >> >> The change makes sense, but does it actually "fix" anything?
> >> >>
> >> >
> >> >Yes - this first place fixes logical error, so it's a sin
> >> >- even if not punishable in practice. (It's also unnecessary
> >> >test for long to int conversion.)
> >> >
> >>
> >> I am sorry, I don't understand. What is the logical error in
> >the first
> >> one?
> >>
> >> Actually, your change makes it different from what was originally
> >> indended.
> >> Original intention was to type convert base to a 32 bit value and
> >> bitwise& with FLAG.
> >
> >But that is not what the original code is doing. If you wanted to
> >typecast "base" to "a 32 bit value" then you should've used u32
> >instead.
> >
> >Anyway, if you originally intended to actually typecast "base" to
> >unsigned int, then you could do that directly without typecasting it
> >first to unsigned long (unnecessarily) and then to unsigned int. Of
> >course, if your system implements a pointer as something bigger than
> >unsigned int (which is what you eventually convert "base" to), then
> >you're screwed anyway and the intermediate typecast to unsigned long
> >doesn't buy you anything at all.
>
> On a 64 bit system, converting pointer to int causes unnecessary
> compiler
> warning, and intermediate long conversion was to avoid that. I will have

Whoa! Hello, hold on, just wait a second there. Do you _really_ want
an unsigned int return out of tbase_get_deferrable() or will an
unsigned long do? If the rest of your code is fine with unsigned long,
then I'd suggest something like:

static inline unsigned long tbase_get_deferrable(tvec_base_t *base)
{
	return ((unsigned long)base & TBASE_DEFERRABLE_FLAG);
}

I don't really know your code (so I could be horribly incorrect here),
but personally I would prefer *heeding* to that warning than _hiding_
it -- it's not unnecessary, it's telling you that you're *losing* data
by converting a pointer (which is always unsigned long) to unsigned
int for 64-bit platforms where sizeof(void *) == sizeof(unsigned long)
== 8 bytes, but sizeof(unsigned int) == 4.
