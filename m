Return-Path: <linux-kernel-owner+w=401wt.eu-S966194AbXIKG7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966194AbXIKG7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbXIKG71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:59:27 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:27276 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760258AbXIKG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:59:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zjk0YVwuY9zjBkviCXdknAybaGCOGAb+CWz2vJjmp24KJ/v6sXs/osWOltru8I1R9FPg6rxWtSrdg7DcQURomnJKkkVqPavsRYsWA4pKRiYxRSnyFmgsKwgbS4V8JFFxZO8tXiT01oelbQHTAJrupDcrts1jKEDr9RSTujriUMY=  ;
X-YMail-OSG: ldmVnxoVM1kOAlDSHfQ.lbxkGdZKsdKmJtf0i7Ruh2pJvIVCzSY3x7.rEB.nrYkcKSI8zbiXkg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Date: Tue, 11 Sep 2007 01:17:57 +1000
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709110117.57387.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 05:07, Christoph Lameter wrote:
> On Mon, 10 Sep 2007, Nick Piggin wrote:
> > OK, so after isolating the scheduler, then SLUB should be as fast as SLAB
> > at the same allocation size. That's basically what we need to do before
> > we can replace SLAB with it, I think?
>
> The regression is due to the limited number of objects in the per cpu
> "queue" in SLUB for 4k objects. With the .23 code this is one or two
> (order 1 slab). So we have to call into the page allocator frequently and
> do it for order 1 pages which requires the zone locks. Urgh.

The impression I got at vm meeting was that SLUB was good to go :(


> I think the regression is best addressed by the page allocator pass
> through patch in mm which makes the page allocator handle these objects.
> They are single pages so the pcp lists are in use which provide much
> larger queues than SLUB/SLAB.
>
> IMHO >=4k objects should be handled by the page allocator. From the
> numbers I have seen there is then still a 1% regression left. If
> that is still the case after we have fixed the scheduler then maybe
> we need to slim down the page allocator fast path.

It is trivial to test SLUB vs SLAB independently of the scheduler change.
And actually, a scheduler regression here might just never be fixed,
because it is likely to be a higher level thing where the scheduling just
happens not to interact with tbench so well (and either it would be
impossible to find out why, or no point tuning the scheduler for such a
case).

But slab allocations don't really control the macro behaviour of a
benchmark like that so much. So don't wait until something happens
with the scheduler, fix it now.

Yay, looks like we'll get yet more logic in the VM to polish the proverbial
turd that is higher order allocations :P
