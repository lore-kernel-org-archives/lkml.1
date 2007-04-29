Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXD2GvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXD2GvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXD2GvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:51:05 -0400
Received: from smtp112.plus.mail.re2.yahoo.com ([206.190.53.37]:47629 "HELO
	smtp112.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756243AbXD2GvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:51:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=P1YZxh4ptxReAa2WtayP9MOceEyn+VEOW26Fv1zm15VY4TOcBoGASj3lsQYlM4toT5Os0c03ZDFixKD2JyCb55oD0zlMMDyRdMvyzjtyrvdrLE6ZtP2L2xTrx2Cyk+BLGqQtDgTW9awDMLFGySDyFRAt08Q/9tFxsaWQsmy3jDE=  ;
X-YMail-OSG: .DRufO4VM1lcjTxY32REg4WWCQ5023cq6.Vzslhh5dcGZs0lOBv7qde3.uEN3MlcH14X39UvMpaq1oUYutL70XD5Oxa.tUUhsUI3nfM0Z2Gpi8ti68fxyXafQ5j4JolSQQTP5Cn3ZxbyPuU-
Date: Sun, 29 Apr 2007 08:50:49 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized spinlock. was: Re: 2.6.21-rc7-mm2
Message-ID: <20070429065049.GB4446@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org> <4633DD55.1020006@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4633DD55.1020006@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:48:37AM +0100, Andy Whitcroft wrote:
> Andrew Morton wrote:
> > On Thu, 26 Apr 2007 20:25:19 +0200
> > Borislav Petkov <bbpetkov@yahoo.de> wrote:
> > 
> >> Remove build warning mm/memory.c:1491: warning: 'ptl' may be used uninitialized in this function.
> >> The spinlock pointer is assigned to null since it gets overwritten right away in
> >> pte_alloc_map_lock().
> >>
> >> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> >> ---
> >>
> >> Index: linux-mm/mm/memory.c
> >> ===================================================================
> >> --- linux-mm.orig/mm/memory.c    2007-04-26 19:57:14.000000000 +0200
> >> +++ linux-mm/mm/memory.c 2007-04-26 20:00:30.000000000 +0200
> >> @@ -1488,7 +1488,7 @@
> >>         pte_t *pte;
> >>         int err;
> >>         struct page *pmd_page;
> >> -       spinlock_t *ptl;
> >> +       spinlock_t *ptl = NULL;
> >>
> >>         pte = (mm == &init_mm) ?
> >>                 pte_alloc_kernel(pmd, addr) :
> >>
> > 
> > yes, I've been staring unhappily at this for some time.
> > 
> > Your change adds seven bytes of text to this function for no runtime
> > benefit, just to fix a build-time warning.  It's a general problem.
> > 
> > 
> > Often we just leave the warning in place and curse gcc each time it flies
> > past.  Sometimes the code can be restructured in a sensible fashion to
> > avoid the warning; often it cannot.
> > 
> > But I don't think I want to put up with a warning coming out of core MM all
> > the time so let's go with the following silliness which adds no additional
> > runtime cost.
> > 
> > --- a/mm/memory.c~add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix
> > +++ a/mm/memory.c
> > @@ -1455,7 +1455,7 @@ static int apply_to_pte_range(struct mm_
> >  	pte_t *pte;
> >  	int err;
> >  	struct page *pmd_page;
> > -	spinlock_t *ptl;
> > +	spinlock_t *ptl = ptl;		/* Suppress gcc warning */
> >  
> >  	pte = (mm == &init_mm) ?
> >  		pte_alloc_kernel(pmd, addr) :
> > _
> > 
> 
> Perhaps we should have some kind definition helper.
> 
> #define suppress_unused(x) x = x
> 
> 	spinlock_t *suppress_unused(ptl);

I like that idea, let's do that. However, Andrew's concern remains still valid
about suppressing the suppression and thereby hiding real bugs. But hey, the use
of such a macro is pretty straightforward and if we choose a suitable name for
it stating the unitialized state of the variable, messing up stuff then and
producing a faulty code out of it is pretty careless to begin with, IMVHO.
Here's a patch:

-----
From: Borislav Petkov <bbpetkov@yahoo.de>

Introduce a macro for suppressing gcc from generating a warning about a probable
unitialized state of a variable.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

---

Index: linux-mm/include/linux/compiler.h
===================================================================
--- linux-mm.orig/include/linux/compiler.h
+++ linux-mm/include/linux/compiler.h
@@ -109,6 +109,10 @@ extern int do_check_likely(struct likeli
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#ifndef unitialized_var
+# define unitialized_var(x) x = x
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
Index: linux-mm/mm/memory.c
===================================================================
--- linux-mm.orig/mm/memory.c
+++ linux-mm/mm/memory.c
@@ -1488,7 +1488,7 @@ static int apply_to_pte_range(struct mm_
 	pte_t *pte;
 	int err;
 	struct page *pmd_page;
-	spinlock_t *ptl;
+	spinlock_t *unitialized_var(ptl);

 	pte = (mm == &init_mm) ?
 		pte_alloc_kernel(pmd, addr) :
-- 
Regards/Gruﬂ,
Boris.
