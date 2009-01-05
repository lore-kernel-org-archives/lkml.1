Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZAEQZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZAEQZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZAEQZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:25:33 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28751 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751231AbZAEQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:25:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mN0LsyJ1QqmvNcoxM0mXRWkziXLoPqsiHxpyctQQC+eMaeAuJ/Z/RXobFRwUZxAB3HYd9KisHXheieUUUh0WMsxA2dwcOJpUR2SdUMpO05Q3oo9xahhoh4Aw5pfkf/WcXoZWoc08xDVS2D8y/m2a7Q08ya7i43NHbJAmi4skPQ0=  ;
X-YMail-OSG: JLDyZLwVM1nnQ_hSXl84e01hY3tWqzWgKPY8W44.DyhSJdqjQ8kDvrauTxZIBVbdMY9Vu9CeJQzsWJD5aTOFirlNGclTnOfD.bevQOHvza986evmre1Z0I_ZQn3t8XOj.MbLsGEG1bmaWxal4qineilV7NlsXPqLZ3rthpE97RudQH0kZCgmt3lA3znc665x.ZZ79QOYkZOGI7pIGteHDDQUqqoN
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: atomics: document that linux expects certain atomic behaviour from unsigned long
Date: Tue, 6 Jan 2009 03:25:12 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       segher@kernel.crashing.org, rth@gcc.gnu.org
References: <20090103124400.GA1572@ucw.cz> <200901052300.24951.nickpiggin@yahoo.com.au> <20090105160501.GB6959@linux.vnet.ibm.com>
In-Reply-To: <20090105160501.GB6959@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901060325.13362.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 03:05:01 Paul E. McKenney wrote:
> On Mon, Jan 05, 2009 at 11:00:24PM +1100, Nick Piggin wrote:
> > On Monday 05 January 2009 22:23:50 Alan Cox wrote:
> > > > Pretty much everywhere that uses RCU for example does so using atomic
> > > > pointer loads and stores. The nastiest issue IMO actually is
> > > > reloading the value through the pointer even if it isn't explicitly
> > > > dereferenced. RCU gets this right with ACCESS_ONCE. Probably a lot of
> > > > code using basic types does not. x86 atomic_read maybe should be
> > > > using ACCESS_ONCE too...
> > >
> > > I'm pretty sure it should. gcc makes no guarantees about not being
> > > clever with accesses.
> >
> > Arguably it should. I don't know what the concurrent C standard looks
> > like, but prohibiting reloads of potentially concurrently modified memory
> > when there is no explicit pointer dereference is the natural complement
> > to prohibiting stores to potentially concurrently read memory when there
> > is no explicit store (which I think is begrudgingly agreed to be a
> > problem).
> >
> > http://lkml.org/lkml/2007/10/24/673
> >
> > I think I would like to see multiple reloads to local variables
> > prohibited, to avoid potential really subtle problems... But if
> > ACCESS_ONCE is here to stay, then I do think that atomic_read etc should
> > use it.
>
> The concurrency stuff in c++0x still permits the compiler to have its
> way with loads and stores to normal variables, but provides an "atomic"
> type that must be loaded and stored as specified in the program.

So:
if (trylock())
  locked = 1;
...
if (locked)
  *var = blah;
...
if (locked)
  unlock();

So the second part can still be transformed into a predicated calculation
of blah, then an unconditional store to *var?


> The issue with ACCESS_ONCE() is that gcc doesn't do any optimizations on
> volatile accesses, even the obvious ones.  Speaking of which, the gcc
> guys kicked out my bug 33102, which was complaining about this
> situation.  :-/

Hmm. It's still quite annoying even to have to switch everything to the
atomic type. I guarantee there will be bugs in Linux caused by the
compiler reloading pointers/longs/ints to access local variables...


