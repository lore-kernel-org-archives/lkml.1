Return-Path: <linux-kernel-owner+w=401wt.eu-S1031112AbXD1F7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031112AbXD1F7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031111AbXD1F7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:59:09 -0400
Received: from smtp111.plus.mail.re2.yahoo.com ([206.190.53.36]:37800 "HELO
	smtp111.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031107AbXD1F7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:59:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=jb4opM7mNy2bpwP8Hd6/ElbIKsQxM51/Cp3Srh+st6tJRAVVF31ANKVq/g4o1Sk3OP42vHcQF4hArrpOxfPyTtJ3FzPINQYQGGpvr5Jh9zoVa5KvikgL7TIdwQ9aXrNRtRhctE0mYTpeQ6xun2QnuHzW7QOkqZ7aRhI/QnrQwOQ=  ;
X-YMail-OSG: dBvz4vsVM1k2TnTFjFzlt_vOkKpxdJimQ8Vp1OmQCxrg4DvMOJK8BXdz0_qs7WM.PuClFwFVDA--
Date: Sat, 28 Apr 2007 07:57:40 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized spinlock. was: Re: 2.6.21-rc7-mm2
Message-ID: <20070428055740.GA4957@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070427172230.94b82829.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 05:22:30PM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 20:25:19 +0200
> Borislav Petkov <bbpetkov@yahoo.de> wrote:
> 
> > 
> > Remove build warning mm/memory.c:1491: warning: 'ptl' may be used uninitialized in this function.
> > The spinlock pointer is assigned to null since it gets overwritten right away in
> > pte_alloc_map_lock().
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > ---
> > 
> > Index: linux-mm/mm/memory.c
> > ===================================================================
> > --- linux-mm.orig/mm/memory.c    2007-04-26 19:57:14.000000000 +0200
> > +++ linux-mm/mm/memory.c 2007-04-26 20:00:30.000000000 +0200
> > @@ -1488,7 +1488,7 @@
> >         pte_t *pte;
> >         int err;
> >         struct page *pmd_page;
> > -       spinlock_t *ptl;
> > +       spinlock_t *ptl = NULL;
> > 
> >         pte = (mm == &init_mm) ?
> >                 pte_alloc_kernel(pmd, addr) :
> > 
> 
> yes, I've been staring unhappily at this for some time.
> 
> Your change adds seven bytes of text to this function for no runtime
> benefit, just to fix a build-time warning.  It's a general problem.
> 
> 
> Often we just leave the warning in place and curse gcc each time it flies
> past.  Sometimes the code can be restructured in a sensible fashion to
> avoid the warning; often it cannot.
> 
> But I don't think I want to put up with a warning coming out of core MM all
> the time so let's go with the following silliness which adds no additional
> runtime cost.
> 
> --- a/mm/memory.c~add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix
> +++ a/mm/memory.c
> @@ -1455,7 +1455,7 @@ static int apply_to_pte_range(struct mm_
>  	pte_t *pte;
>  	int err;
>  	struct page *pmd_page;
> -	spinlock_t *ptl;
> +	spinlock_t *ptl = ptl;		/* Suppress gcc warning */
>  
>  	pte = (mm == &init_mm) ?
>  		pte_alloc_kernel(pmd, addr) :
> _

Yeah,
I saw in other places that usually a NULL/0 is assigned to such a type of pointer. 
However, writing code which looks pretty silly just to shut up gcc is pretty
senseless, IMHO. Isn't there such a tweak in gcc to say that this pointer is
going to be assigned to later on, so don't issue a warning. Something like 

__attribute__ __address_will_be_overwritten_so_don't_bother_warning_me__?

/me going to read gcc docs...

-- 
Regards/Gruﬂ,
    Boris.
