Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYGJHct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYGJHct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYGJHch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:32:37 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:41867 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753535AbYGJHcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:32:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KR81ZkqVS3+TjtA9iW+U9Xhm9/6GYFurIQptH05zgPTHxAsPlQ8L+afO2lIyGaYDIkT97phTIuVlefHgxU6bCSd2TnpjblyOn0T8FodnaAhAVbYnyIN4FUilFS2QoIghmnCOUPbXyJuk5GubAwEKMG8xj5H9vbdkBHaIEtKobZg=  ;
X-YMail-OSG: iiPgDfEVM1nJFIWI1KVYgR9tcLjKNCHENU2GDaldHI_OQ0F1JLxgR1XJhLXKXPwq5sc4ce.BMliMl.ec4jDDsKZhOud76wuvVqwbyVp3KofLRI9kmhvEIjHfu3awOrdrzyM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Date: Thu, 10 Jul 2008 17:31:54 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       cl@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
References: <20080703213348.489120321@attica.americas.sgi.com> <200807081216.22029.nickpiggin@yahoo.com.au> <20080709191146.GA6251@sgi.com>
In-Reply-To: <20080709191146.GA6251@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101731.54910.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 05:11, Jack Steiner wrote:
> On Tue, Jul 08, 2008 at 12:16:21PM +1000, Nick Piggin wrote:
> > On Tuesday 08 July 2008 02:53, Jack Steiner wrote:
> > > On Mon, Jul 07, 2008 at 05:29:54PM +0100, Hugh Dickins wrote:
> > > > Maybe study the assumptions Nick is making in his arch/x86/mm/gup.c
> > > > in mm, and do something similar in your GRU driver (falling back to
> > > > the slow method when anything's not quite right).  It's not nice to
> > > > have such code out in a driver, but GRU is going to be exceptional,
> > > > and it may be better to have it out there than pretence of generality
> > > > in the core mm exporting it.
> > >
> > > Ok, I'll take this approach. Open code a pagetable walker into the GRU
> > > driver using the ideas of fast_gup(). This has the added benefit of
> > > being able to optimize for exactly what is needed for the GRU. For
> > > example, nr_pages is always 1 (at least in the current design).
> >
> > Well... err, it's pretty tied to the arch and mm design. I'd rather
> > if you could just make another entry point to gup.c (perhaps, one
> > which doesn't automatically fall back to the get_user_pages slowpath
> > for you) rather than code it again in your driver.
>
> Long term, that is probably a good idea. However, for the short term &
> while the GRU is stabilizing, I would prefer to keep the code in the driver
> itself. 

Well I disagree and I think it is a bad idea. gup.c is going into 2.6.27
anyway (and if it weren't going in, then it would be due to some discovered
issue in which case your driver should not use it either).


> I can address the issue of moving it to gup.c later. 

I guess you wouldn't be moving anything to gup, because it is already
implemented there... Literally all you have to do is extract a
function in gup.c which takes the fastpath body of get_user_pages_fast
and returns failure rather than branching to slowpath.

If ia64 uses the same sort of tlb invalidation and page table teardown
scheme as x86, then you should be able to copy the x86 gup.c straight
to ia64 (minus the PAE crud).

> I'll post the new GRU patch in a few minutes.

It looks broken to me. How does it determine whether it has a
normal page or not?
