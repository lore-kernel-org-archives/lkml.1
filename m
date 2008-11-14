Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKNHfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKNHfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYKNHf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:35:27 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:38858 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750727AbYKNHf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:35:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uiZVvcnbAY0d3JT7/IGjXRaMSfafbix7K/ifYsBOoLhutP3y5B430O5pFtAcqhASHaMcNtPdm6etf4S8mw1RfHWtiFEdHq7J4sitGaGORVShVAFQWd4HkryzReYQDtQwMM38rWQskkqi/4/4uj/1htehTYpn79Hp38E0aYg9Rek=  ;
X-YMail-OSG: kHdp6mUVM1m9M2o_XQUEIXRVa1.fZumk.VhndULdxMZjFy01P9nziznPdvsdrJ0xTUA1.NzMWd9FLJGooGpsc3aT_WxMs8AY9LCSyD0zeGAglJD2q1Fm42pFRzt1vsD.DNStA78vcrXchUWeebhvvOGHJE7jpo9nrkNxcP7tP8e8VjStUK_Z6H7Qk0ji
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
Date: Fri, 14 Nov 2008 18:35:16 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <491C61B1.10005@goop.org> <200811141417.35724.nickpiggin@yahoo.com.au> <491D0B2F.7050900@goop.org>
In-Reply-To: <491D0B2F.7050900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811141835.17073.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 16:22, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > On Friday 14 November 2008 13:56, Jeremy Fitzhardinge wrote:
> >> Nick Piggin wrote:
> >>> This isn't performance critical to anyone?
> >>
> >> The only difference should be between having the specialized code and an
> >> indirect function call, no?
> >
> > Indirect function call per pte. It's going to be slower surely.
>
> Yes, though changing the calling convention to handle (up to) a whole
> page worth of ptes in one call would be fairly simple I think.

Yep. And leaving it alone is even simpler and still faster :)


> > It is accepted practice to (carefully) duplicate the page table walking
> > functions in memory management code. I don't think that's a problem,
> > there is already so many instances of them (just be sure to stick to
> > exactly the same form and variable names, and any update or bugfix to
> > any of them is trivially applicable to all).
>
> I think that's pretty awful practice, frankly, and I'd much prefer there
> to be a single iterator function which everyone uses.

I think its pretty nice. It means you can make the loops fairly
optimal even if they might have slightly different requirements
(different arguments, latency breaks, copy_page_range etc).


> The open-coded 
> iterators everywhere just makes it completely impractical to even think
> about other kinds of pagetable structures.  (Of course we have at least
> two "general purpose" pagetable walkers now...)

I think that's being way over dramatic. When switching to a
different page table structure, I assure you that copying and
pasting your new walking algorithm a few times will be the least
of your worries :)

It's not meant to be pluggable. Actually this came up last I think
when the UNSW wanted to add page table accessors to abstract this.
They came up with a good set of things, but in the end you can't
justify slowing things down in these paths unless you actually have
a replacement page table structure that gets you a *net win*. So
far, I haven't heard from them again.

No, adding a cycle here or an indirect function call there IMO is
not acceptable in core mm/ code without a good reason.
