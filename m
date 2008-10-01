Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbYJAJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbYJAJ3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJAJ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:29:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYJAJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:29:30 -0400
Date: Wed, 1 Oct 2008 11:29:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct - v3
Message-ID: <20081001092906.GA14912@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <48D966AE.1040008@linux-foundation.org> <20080924155332.GA29041@linux-os.sc.intel.com> <200809301728.02269.nickpiggin@yahoo.com.au> <20080930112128.GB21367@elte.hu> <20080930211418.GK15609@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930211418.GK15609@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Tue, Sep 30, 2008 at 04:21:28AM -0700, Ingo Molnar wrote:
> > 
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > 
> > > On Thursday 25 September 2008 01:53, Venki Pallipadi wrote:
> > >
> > > >  /*
> > > > + * RED-PEN:  TODO: Add PageReserved() check as well here,
> > > > + * once we add SetPageReserved() to all the drivers using
> > > > + * set_memory_* or set_pages_*.
> > > > + *
> > > > + * This will help prevent accidentally freeing pages
> > > > + * before setting the attribute back to WB.
> > > > + */
> > >
> > > I'd rather we didn't add any more uses of PageReserved without a
> > > really good reason.
> > >
> > > At this point in time (or at least last time I looked, a year or
> > > two ago), it isn't a whole lot of work to remove PG_reserved
> > > completely. If the waters get muddied up again, it could require
> > > another significant rework to remove it in future...
> > 
> > agreed.
> 
> If a driver by mistake free's a RAM page before changing its memory 
> attribute back to WB, we want the generic -mm to catch it.
>
> Today, free_pages_check() prevents freeing the page with PageReserved 
> set. We want to use this and make sure that either set_page_uc/wc() or 
> the driver calling these API's set the PageReserved bit. There are 
> already some drivers which do SetPageReserved() before changing the 
> attribute.

no, the generic -mm does not 'catch' PageReserved, it simply _ignores_ 
it. So i agree about having a debug check there, it's just that what you 
propose does not achieve that.

PageReserved is a legacy thing that should not be used in new code.  
Using it will only hide bugs and adds quirkiness to the PAT code.

> I don't know the history behind PageReserved. But is there a 
> recommended way to achieve what we want? Either we need to use 
> PageReserved bit or add some arch specific checks (in the x86 case, 
> check arch_1) in free_pages_check(). Right?

the best way i think would be to add arch_1 to PAGE_FLAGS_CHECK_AT_FREE. 
That way the mm becomes very noisy if this is ever freed.

Nick, Andrew, any preferences?

	Ingo
