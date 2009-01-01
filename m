Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZAAOZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZAAOZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 09:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZAAOY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 09:24:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbZAAOY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 09:24:57 -0500
Date: Thu, 1 Jan 2009 15:24:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
	modules (take 4)
Message-ID: <20090101142401.GA25690@elte.hu>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain> <ada63l0qmba.fsf@cisco.com> <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 31 Dec 2008, Andrew Morton wrote:
> > 
> > Adrian claimed that it was gcc-4.1.0 and 4.1.1 only.  He proposed
> > banning them: http://lkml.org/lkml/2008/8/5/444
> 
> If it really is just those releases, then yes, considering the number of 
> cases we apparently have, and considering how ugly it is in some cases 
> to move the weak function anywhere else, maybe banning those versions is 
> the proper thing to do.
> 
> It probably won't hurt very many people - yeah, some people will be 
> forced to upgrade, but I have this memory of early 4.1 having had other 
> bugs anyway, so it's probably a good idea.

That would be _really_ nice to do IMHO: in many cases putting the __weak 
definition into same-file scope with a call site is a natural approach. I 
think that's how we ended up having so many instances of that bug. When 
you use __weak as a 'default implementation' for some function, then it's 
very natural to put it into the same file that also uses it.

It goes into separate, inactive scope only in a few special cases: such as 
when it's some library function that can be overriden by the architecture. 
But if it's some non-libray kernel code then the usage site is close to 
the definition site.

If you look at most of the __weak fixes they IMO actually turned clean 
code into less clean code: they detached some natural clustering of 
definition and callsite.

And __weak is very elegant IMO, it can avoid a lot of #ifdefs and can be 
used to self-document architecture interfaces - so it would be nice to 
make it always work, regardless of the callsite's scope.

	Ingo
