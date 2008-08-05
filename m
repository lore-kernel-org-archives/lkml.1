Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYHEEKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYHEEKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYHEEJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:09:54 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:43251 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751210AbYHEEJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:09:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wvXXbnPDClwGW2GYwSp8kOXvAlnNoghJeexJde7sO+tfOD5Ln1gt11jPJyIhyZ9BzSI/9I6SIOM7RuRFAX5c75Y/f4Ykb92FS9jG4SoK1UMrZcx/4oRBwfu3NA/5xgBUG4KXZsb/yPHu664fFSMk3IgXBuIQ8lNzKi+AHpITh6s=  ;
X-YMail-OSG: fU.ldUEVM1lqQ_PAToEsk1N5ggA3dE4qb.7wHhOVSS2WuGcJvqJxcg8fSVjAw3Gb1JsP7gsxJnMBA_Vc5yJN0QLu540HCOgp_FZnLOLb3DIzFucO9LAkka8iSUhMsji3NvQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 14:09:45 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051341.53282.nickpiggin@yahoo.com.au> <20080804205754.b05c8aa9.akpm@linux-foundation.org>
In-Reply-To: <20080804205754.b05c8aa9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051409.46083.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 13:57, Andrew Morton wrote:
> On Tue, 5 Aug 2008 13:41:53 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Tuesday 05 August 2008 13:28, Linus Torvalds wrote:
> > > On Tue, 5 Aug 2008, Nick Piggin wrote:
> > > > On Thursday 31 July 2008 17:26, Nick Piggin wrote:
> > > > > Hi,
> > > > >
> > > > > I'm wondering if I could get a patch merged which changes all
> > > > > TestSetPageLocked and replaces them with trylock_page?
> > > >
> > > > Yes? No?
> > > >
> > > > The alternative is try to merge it via -mm or -next, but that just
> > > > wastes everybodies time with conflicts of having these differences
> > > > between -mm and mainline.
> > >
> > > Heh. I had just been _assuming_ this would go through -mm, since it's
> > > exactly the kind of thing that usually does go through there.
> > >
> > > So I hadn't even really considered it.
> >
> > OK... it just causes Andrew headaches I suspect. But if he prefers
> > to hold onto it for an entire release cycle... Andrew?
>
> Yup.  A mechanical rename-foo-to-bar can be prepared and merged late -
> there's little payback for the pain of maintaining it for a couple of
> months.
>
> Would prefer either that we hold off until after 2.6.27 is released or
> just do it now.
>
> > > I don't mind the patch per se, but can you give some background on what
> > > the pending optimization is that makes such a big difference?
> >
> > Using the lock semantics bitops is the first one. While it is true
> > that we could just hack them into TestSetPageLocked, I really prefer
> > callers to require at least a cursory glance to convert them, and
> > understand that this is a lock lock, and not a test_and_set bitop
> > with full barrier semantics.
>
> This patch wouldn't do anything to ensure that callers get the review
> which you describe, would it?
>
> (and we don't need to patch the code to just read it!)

OK, not it doesn't really ensure that I guess. But it at least helps me
attempt to review callsites and maintainers of external patches hopefully
will get at least some heads up.

Basically it is the best we can do I think. I haven't seen any problems
in this area and I don't really expect to (only in some areas does the
lock implementation itself assume knowledge of barriers beyond regular
lock semantics).

In case something assumes a store won't be passed by TestSetPageLocked,
for example, it should be commented. Code that makes subtle use of
memory ordering and is not commented I think we can say from experience
is almost broken by definition :)

... no, that's not my excuse for introducing breakage.. I have *attempted*
to review callers, but it's not easy to detect uncommented use of barrier.
