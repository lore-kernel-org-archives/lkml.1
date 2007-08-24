Return-Path: <linux-kernel-owner+w=401wt.eu-S1765468AbXHXO0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765468AbXHXO0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbXHXO0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:26:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59691 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXHXOZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uCkLa5mOaULcI0evkOonf2m65PCTy7vLoKAk72MkSBF7kjViGtH56GEgiW+Z+CsBO42FtWVb5jl1cgNTdzi5g17HNfQLub0jYhSuDIv/mw1TwC0vgxb6qBS+wnOVrbY+z2gmoglaRZ6zFeb1dwuZIFHRRY+tiIezcwczQL+4IUA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Kenn Humborg" <kenn@bluetree.ie>
Subject: Re: [PATCH] i386: Fix a couple busy loops in mach_wakecpu.h:wait_for_init_deassert()
Date: Fri, 24 Aug 2007 15:25:50 +0100
User-Agent: KMail/1.9.1
Cc: "Satyam Sharma" <satyam@infradead.org>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Chris Snook" <csnook@redhat.com>, clameter@sgi.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       netdev@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       ak@suse.de, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
References: <NBBBIGEGHIGMPCNKHCECAEPEELAA.kenn@bluetree.ie>
In-Reply-To: <NBBBIGEGHIGMPCNKHCECAEPEELAA.kenn@bluetree.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241525.51049.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 13:12, Kenn Humborg wrote:
> > On Thursday 16 August 2007 01:39, Satyam Sharma wrote:
> > >  static inline void wait_for_init_deassert(atomic_t *deassert)
> > >  {
> > > -	while (!atomic_read(deassert));
> > > +	while (!atomic_read(deassert))
> > > +		cpu_relax();
> > >  	return;
> > >  }
> >
> > For less-than-briliant people like me, it's totally non-obvious that
> > cpu_relax() is needed for correctness here, not just to make P4 happy.
> >
> > IOW: "atomic_read" name quite unambiguously means "I will read
> > this variable from main memory". Which is not true and creates
> > potential for confusion and bugs.
>
> To me, "atomic_read" means a read which is synchronized with other
> changes to the variable (using the atomic_XXX functions) in such
> a way that I will always only see the "before" or "after"
> state of the variable - never an intermediate state while a
> modification is happening.  It doesn't imply that I have to
> see the "after" state immediately after another thread modifies
> it.

So you are ok with compiler propagating n1 to n2 here:

n1 += atomic_read(x);
other_variable++;
n2 += atomic_read(x);

without accessing x second time. What's the point? Any sane coder
will say that explicitly anyway:

tmp = atomic_read(x);
n1 += tmp;
other_variable++;
n2 += tmp;

if only for the sake of code readability. Because first code
is definitely hinting that it reads RAM twice, and it's actively *bad*
for code readability when in fact it's not the case!

Locking, compiler and CPU barriers are complicated enough already,
please don't make them even harder to understand.
--
vda
