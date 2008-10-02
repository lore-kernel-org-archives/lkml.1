Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbYJBC1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbYJBC1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 22:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYJBC1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 22:27:37 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:20361 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751764AbYJBC1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 22:27:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=54SdtULDWZYPUXSrULG7e/Si4FDhK2wP+QY6i/cVhoxhBRhgiHAG7dadBG3fr8Q6TW3n84m9alw+NnmKQAz9yyV3MHqAgVNK13dHJKK9aYKG7dcSx1yiht69YWa7+ZMqxRHLDsyLfVhs62sDNHexEv1GPLgP7qamw/o1Swyk5fw=  ;
X-YMail-OSG: jfnoUUoVM1lK7BmoaJWnLTrdTcZzKAS1QlBhbtDr5OZlJEbQOXi2smMGlDQEXL9AZ573gKVsgYEiu_nthEa5zb.pS.0Azi6oITOpx1jdJl78EdXGhhW9BHOaNEmlSY1o5JvMappe.yXCWkXOOyn2XE1g.VhEcMRFKQND.cjMNfugkeUp.ME-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct - v3
Date: Thu, 2 Oct 2008 12:27:28 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080930112128.GB21367@elte.hu> <20080930211418.GK15609@linux-os.sc.intel.com>
In-Reply-To: <20080930211418.GK15609@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021227.28815.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 07:14, Suresh Siddha wrote:
> On Tue, Sep 30, 2008 at 04:21:28AM -0700, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Thursday 25 September 2008 01:53, Venki Pallipadi wrote:
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
> Today, free_pages_check() prevents freeing the page with PageReserved set.

That's gone away in -mm.


> We want to use this and make sure that either set_page_uc/wc() or the
> driver calling these API's set the PageReserved bit. There are already some
> drivers which do SetPageReserved() before changing the attribute.
>
> I don't know the history behind PageReserved. But is there a recommended
> way to achieve what we want? Either we need to use PageReserved bit or  add
> some arch specific checks (in the x86 case, check arch_1) in
> free_pages_check(). Right?

It would be better if another flag is used, yes.

Setting PageReserved used to prevent put_page from decrementing the page's
refcount. Most drivers still do it just because we kept that code in there
to catch any bugs caused by the removal of PageReserved check from the
refcounting.
