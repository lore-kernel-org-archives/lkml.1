Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYDQUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYDQUkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYDQUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:39:58 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:58488 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbYDQUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:39:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h+IMtPCCbe1nWK0ziwxg7PuC0ck8LyIWPejzpEOH3+SxjjVS0iKF1/2M9GpnI0qMZAi/c3TrGDsH/hHPC3o/KKoORqo9z4fnN6/kSHaqpD3F+Xezl7mAxlJSGHYylEwMAUwbswwadqzFQLDWZdnEPazEzmPwt8wp3WvFiFEFwZ0=
Message-ID: <19f34abd0804171339l7aab0895wb7e82534c4ab8b9a@mail.gmail.com>
Date: Thu, 17 Apr 2008 22:39:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20080417124353.30fe1d06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu>
	 <20080417002552.5742ad65.akpm@linux-foundation.org>
	 <20080417083000.GA4935@elte.hu>
	 <20080417014054.ea788f1f.akpm@linux-foundation.org>
	 <20080417090626.GA14383@elte.hu>
	 <20080417021813.04df7912.akpm@linux-foundation.org>
	 <20080417093025.GA17389@elte.hu>
	 <20080417023603.672d1032.akpm@linux-foundation.org>
	 <19f34abd0804171147l4403d49aoeab005105a90392b@mail.gmail.com>
	 <20080417124353.30fe1d06.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you very much for the review of this patch. Those are hard to
come by, and I've posted kmemcheck to LKML already 3 or 4 times, with
relatively sparse response. I mean, the fact that they were ALL
whitespace damaged, but discovered by nobody, quite plainly tells me
that nobody actually tried to apply it (except perhaps Daniel Walker,
but we never realized it was whitespace damage causing the problems).
The patches that Ingo took into x86 were probably sent as an
attachment...

On Thu, Apr 17, 2008 at 9:43 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 17 Apr 2008 20:47:06 +0200
>
> "Vegard Nossum" <vegard.nossum@gmail.com> wrote:
>  > Actually it doesn't. I attach a patch which gets rid of the page flag,
>  > and we rely instead on the PTE flag for page-trackedness.
>  >
>  > The reason we didn't do this at once is that the making of kmemcheck
>  > has been pretty much my first introduction to SLUB, x86, page flags,
>  > etc., and the actual semantics of the various introduced flags have
>  > varied since the first version of kmemcheck. At this point, the struct
>  > page flags weren't actually needed anymore, but they were convenient.
>  >
>  > My apologies for not inlining the patch -- I don't have a mail client
>  > that won't mess up whitespace. It can also be downloaded at:
>  > http://folk.uio.no/vegardno/linux/0001-kmemcheck-remove-use-of-tracked-page-flag.patch
>  >
>  > The patch has received minimal amount of testing, but I've
>  > double-checked the logic. It boots fine on my laptop, boot log at:
>  > http://folk.uio.no/vegardno/linux/kmemcheck-20080417.txt
>  >
>  > Ingo, will you take this for some additional testing?
>  >
>
>  If you're OK with doing it this way then it would be preferable.
>
>  > diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
>  > index 16dce10..d82f35d 100644
>  > --- a/arch/x86/kernel/kmemcheck.c
>  > +++ b/arch/x86/kernel/kmemcheck.c
>  > @@ -233,12 +233,27 @@ param_kmemcheck(char *str)
>  >       if (!str)
>  >               return -EINVAL;
>  >
>  > -     sscanf("%d", str, &kmemcheck_enabled);
>  > +     sscanf(str, "%d", &kmemcheck_enabled);
>  >       return 0;
>  >  }
>
>  whoops.  Note to Ingo: unrelated bugfix in there.

Yes, sorry. I had actually already e-mailed this as a separate patch
to Ingo before sending this to the list, so he should know. But it
should not have been part of this patch, I agree.

>  >  early_param("kmemcheck", param_kmemcheck);
>
>  kmemcheck= is documented in at least three places, which is nice, but it
>  isn't mentioned in the place where we document kernel-parameters:
>  Documentation/kernel-parameters.txt.  A brief section there which directs
>  the user to the extended docs would be fine.
>
>  early_param() is unusual - we normally use __setup().  I assume there's a
>  reason for using early_param(), but that reason cannot be discerned from
>  reading the code.  A /*comment*/ is the way to fix that.

The reason is that we need to set this before kmalloc() is ever
called. A comment will come.

But it seems that __setup() is what is really missing a comment. I
don't know what it is or how it works, and the comments around the
definition are not very helpful. Maybe somebody could enlighten me?

>  > +static pte_t *
>  > +address_get_pte(unsigned int address)
>
>  This is not the preferred way of laying out function declarations but I've
>  basically given up on this one.
>
>         (void *)address
>
>  is more common, but I'm close to giving up on that too.
>
>  >  static int
>  > -show_addr(uint32_t addr)
>  > +show_addr(uint32_t address)
>
>  u32 is preferred, but ditto.

This will be turned into unsigned long with 64-bit support. (Hopefully
we can get that working too.)

Changing these to match the rest of the kernel is no problem for me.
It is not the way I would write it, but Pekka and Ingo has already
forced me to write if () instead of if(), so there should be no reason
to stop here! :-)

>  Perhaps we should get all this code onto the list(s) for re-review.  It's
>  been a while..

I'm not sure it would make much of a difference, except perhaps for
you, if you want to review it all. (My latest post to LKML had 0
replies in total. Well, except private e-mail exchange with Ingo and
Pekka; they should know the code already. Once again, thanks to them
for helping me.) Do you still want me to post it again?

Thank  you.


Vegard

PS: And it's not that I do that much testing/reviewing myself. But I
do think I have the excuse of being a newbie at this :-)

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
