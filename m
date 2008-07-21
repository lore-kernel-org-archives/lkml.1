Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbYGUFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbYGUFtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYGUFtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:49:09 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:31304 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752286AbYGUFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:49:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N9B9nlwDTCRswNRBuqjMGHZGpdogmF/i1UlaY4p3fKs+Yna031kWA2SFdC+YREzGuRtvaaOInwZerX/TYISjIFlAE5enMI4KZ4EMeLfdT/9BhLV744R/umYCY226a4/V9eYBecBZpz4JCdidUq8dBjie7eS1dK7GY6H9lTMEO3s=  ;
X-YMail-OSG: TX3L_k0VM1mWKon1Y31sIVzhkQT7A1lPATx09hji75coNki8dY8TKqp5atX6h3ZGe6GyGa4MNQkQb1NR2D7MrjaAv95wlhdqzFAEXL4PuS1jX5EdRM4RX6jj1qwanirccQZE3Z60W.mHTE4d8b5SzwQRgpfFoxhXjxo4hFiq_F.2ykWokd4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Date: Mon, 21 Jul 2008 15:49:00 +1000
User-Agent: KMail/1.9.5
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Rik van Riel" <riel@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <87y73x4w6y.fsf@saeurebad.de> <2f11576a0807201709q45aeec3cvb99b0049421245ae@mail.gmail.com> <20080720184843.9f7b48e9.akpm@linux-foundation.org>
In-Reply-To: <20080720184843.9f7b48e9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211549.00770.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008 11:48, Andrew Morton wrote:
> On Mon, 21 Jul 2008 09:09:26 +0900 "KOSAKI Motohiro" 
<kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi Johannes,
> >
> > > File pages accessed only once through sequential-read mappings between
> > > fault and scan time are perfect candidates for reclaim.
> > >
> > > This patch makes page_referenced() ignore these singular references and
> > > the pages stay on the inactive list where they likely fall victim to
> > > the next reclaim phase.
> > >
> > > Already activated pages are still treated normally.  If they were
> > > accessed multiple times and therefor promoted to the active list, we
> > > probably want to keep them.
> > >
> > > Benchmarks show that big (relative to the system's memory)
> > > MADV_SEQUENTIAL mappings read sequentially cause much less kernel
> > > activity.  Especially less LRU moving-around because we never activate
> > > read-once pages in the first place just to demote them again.
> > >
> > > And leaving these perfect reclaim candidates on the inactive list makes
> > > it more likely for the real working set to survive the next reclaim
> > > scan.
> >
> > looks good to me.
> > Actually, I made similar patch half year ago.
> >
> > in my experience,
> >   - page_referenced_one is performance critical point.
> >     you should test some benchmark.
> >   - its patch improved mmaped-copy performance about 5%.
> >     (Of cource, you should test in current -mm. MM code was changed
> > widely)
> >
> > So, I'm looking for your test result :)
>
> The change seems logical and I queued it for 2.6.28.
>
> But yes, testing for what-does-this-improve is good and useful, but so
> is testing for what-does-this-worsen.  How do we do that in this case?

It's OK, but as always I worry about adding "cool new bells and
whistles" to make already-bad code work a bit faster. It slows
things down. A mispredicted branch btw is about as costly as an
atomic operation.

It is already bad because: if you are doing a big streaming copy
which you know is going to blow the cache and not be used again,
then you should be unmapping behind you as you go. If you do not
do this, then page reclaim has to do the rmap walk, page table
walk, and then the (unbatched, likely IPI delivered) TLB shootdown
for every page. Not to mention churning through the LRU and
chucking other things out just to find these pages.

So what you actually should do is use direct IO, or do page
unmappings and fadvise thingies to throw out the cache.

Adding code and branches to speed up by 5% an already terribly
suboptimal microbenchmark is not very good.

