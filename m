Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYI3VOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYI3VOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYI3VOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:14:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:44864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYI3VOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:14:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,340,1220252400"; 
   d="scan'208";a="445453044"
Date: Tue, 30 Sep 2008 14:14:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct - v3
Message-ID: <20080930211418.GK15609@linux-os.sc.intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com> <48D966AE.1040008@linux-foundation.org> <20080924155332.GA29041@linux-os.sc.intel.com> <200809301728.02269.nickpiggin@yahoo.com.au> <20080930112128.GB21367@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930112128.GB21367@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 04:21:28AM -0700, Ingo Molnar wrote:
> 
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > On Thursday 25 September 2008 01:53, Venki Pallipadi wrote:
> >
> > >  /*
> > > + * RED-PEN:  TODO: Add PageReserved() check as well here,
> > > + * once we add SetPageReserved() to all the drivers using
> > > + * set_memory_* or set_pages_*.
> > > + *
> > > + * This will help prevent accidentally freeing pages
> > > + * before setting the attribute back to WB.
> > > + */
> >
> > I'd rather we didn't add any more uses of PageReserved without a
> > really good reason.
> >
> > At this point in time (or at least last time I looked, a year or
> > two ago), it isn't a whole lot of work to remove PG_reserved
> > completely. If the waters get muddied up again, it could require
> > another significant rework to remove it in future...
> 
> agreed.

If a driver by mistake free's a RAM page before changing its memory attribute
back to WB, we want the generic -mm to catch it.

Today, free_pages_check() prevents freeing the page with PageReserved set. We
want to use this and make sure that either set_page_uc/wc() or the driver
calling these API's set the PageReserved bit. There are already some drivers
which do SetPageReserved() before changing the attribute.

I don't know the history behind PageReserved. But is there a recommended
way to achieve what we want? Either we need to use PageReserved bit or  add
some arch specific checks (in the x86 case, check arch_1) in free_pages_check().
Right?

thanks,
suresh
