Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYI3Km7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYI3Km7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYI3Kmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:42:51 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:30933 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752088AbYI3Kmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:42:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CWPOOPCfZx+zKfjQ/FEIWHCVHn4Z36wztNLdQ3Gr532gAOS7Qvk/iQCtmioelGhtFmnYfjpxvzFfI9dOWl7KZOpKjynmxZ0rqd0zN2eWaUbzPMPkMJLQHYTp/UTGVM6vsch99igGk1vkhHzKHskTw/LnHJ0yAM9+ukTBeSA4bUY=  ;
X-YMail-OSG: l7dhUwcVM1nUWLy6MAucewPOXy98AbAKPTvmj32KVpSzq7cn6Xf4DGh3DrROlbEOAkAajoJBmnpT4KcVU.KK317iGvcAqi3DD3KJAgdJ8OoNeBmvWAsMHIX5ighZK_KP3ySPyUrFmea4DLwBtwymyWav4VCHrw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] futex: get_user_pages_fast() for shared futexes
Date: Tue, 30 Sep 2008 20:42:25 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080926173219.885155151@twins.programming.kicks-ass.net> <200809301721.52148.nickpiggin@yahoo.com.au> <1222764669.12646.26.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1222764669.12646.26.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809302042.26224.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008 18:51, Peter Zijlstra wrote:
> On Tue, 2008-09-30 at 17:21 +1000, Nick Piggin wrote:

> > But these patches look good to me (last time we discussed them I thought
> > there was a race with page truncate, but it looks like you've closed that
> > by holding page lock over the whole operation...)
>
> Just to be sure, I only hold the page lock over the get_futex_key() op,
> and drop it after getting a ref on the futex key.
>
> I then drop the futex key ref after the futex op is complete.

I think that's fine.


> This assumes the futex key ref is suffucient to guarantee whatever is
> needed - which is the point I'm still not quite sure about myself.

It is enough to guarantee enough to function normally I guess. Actually
futex syscalls are interesting in that they logically perform 2 totally
different operations and actually want 2 keys but it manages to mash
them into one (the user address).

They need a futex identifier, on which to wait/wake/etc. For anonymous
futexes, this is basically an arbitrary number which is taken from the
user address (but note that if that address is subsequently mremap()ed
for example, then the futex identifier does not follow the address). For
shared futexes, the pagecache address is used for the futex, which is
derived from the address.

Then they also need a memory address which is the target of the
particular operation requested. This doesn't actually logically have to
be directly related to the futex identifier...

I guess for all practical purposes, this is fine. "if you mremap a live
mutex, you lose" and similar probably doesn't constrain too many people
(although I don't think any of that is actually documented). But anyway,
just to point out that we do already have constraints on how existing
futexes are going to work.


> The futex key ref was used between futex ops, with I assume the intent
> to ensure the futex backing stays valid. However, the key ref only takes
> a ref on either the inode or the mm, neither which avoid the specific
> address of the futex to get unmapped between ops.
>
> So in that respect we're not worse off than before, and any application
> doing: futex_wait(), munmap(), futex_wake() is going to suffer. And as
> far as I understand it get the waiting task stuck in D state for
> ever-more or somesuch.

Yeah, I think you're fine there (the sleep is interruptible, so it should
not be a DoS or anything). Just so long as you always pin things like the
inode correctly while taking a ref on it...

