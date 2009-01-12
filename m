Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZALVM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZALVM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZALVMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:12:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZALVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:12:49 -0500
Date: Mon, 12 Jan 2009 22:12:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112211230.GA7320@elte.hu>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain> <20090112205259.GA5303@elte.hu> <1231794230.5405.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231794230.5405.1.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0255]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Mon, 2009-01-12 at 21:52 +0100, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > +static inline int is_new_memtype_allowed(unsigned long flags,
> > +                                               unsigned long new_flags)
> > +{
> > +       /*
> > +        * Certain new memtypes are not allowed with certain
> > +        * requested memtype:
> > +        * - request is uncached, return cannot be write-back
> > +        * - request is write-combine, return cannot be write-back
> > +        */
> > +       if ((flags == _PAGE_CACHE_UC_MINUS &&
> > +            new_flags == _PAGE_CACHE_WB) ||
> > +           (flags == _PAGE_CACHE_WC &&
> > +            new_flags == _PAGE_CACHE_WB)) {
> > +               return 0;
> > +       }
> 
> 	if ((flags == _PAGE_CACHE_UC_MINUS || flags == _PAGE_CACHE_WC) &&
> 	    (new_flags == _PAGE_CACHE_WB))
> 
> might be a bit neater perhaps.

indeed. The most readable one is probably:

static inline int
is_new_memtype_allowed(unsigned long flags, unsigned long new_flags)
{
	/*
	 * Certain new memtypes are not allowed with certain
	 * requested memtype:
	 * - request is uncached, return cannot be write-back
	 * - request is write-combine, return cannot be write-back
	 */

	if (new_flags != _PAGE_CACHE_WB)
		return 1;

	if (flags == _PAGE_CACHE_UC_MINUS)
		return 0;
	if (flags == _PAGE_CACHE_WC)
		return 0;

	return 1;
}

	Ingo
