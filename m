Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYJOSMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYJOSMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYJOSMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:12:37 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:45472 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753048AbYJOSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:12:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=l5MQ++/GpomuFlbQlfV1g5r58wYzrUVv0956Vk2zAsRCTr3x7b4IO2V/uH7yUALaSZI/ZWvONcXHG3tbkqLpYDbUZqEUPEpk1oQcsCK1CB2SfvJ7KdYZSXa3eYYKbcBfK3gH0ueWG8aQKE1pocpWx1f4ZtGBPh6/6NdjXrbx8Aw=  ;
X-YMail-OSG: AU6Zln8VM1lZ0cveSlUi6cChSMifXQr0Baaxx08oROh0P34tBg3BpwTc047m_5pP6Fbj.Y7apNQtr9Yol.GK79wUZVzowrhA0lB3Xyssmd4ycAQZT32S0RNoHUwibc.1IwgbNEEH9E76l7vcd6yHwYLKikN61R1J3Jugxo3E
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 05:12:28 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160445.28781.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151058540.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810151058540.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160512.28443.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 05:03, Linus Torvalds wrote:
> On Thu, 16 Oct 2008, Nick Piggin wrote:
> > What do you mean by the allocation is stable?
>
> "all writes done to it before it's exposed".
>
> > 2. I think it could be easy to assume that the allocated object that was
> > initialised with a ctor for us already will have its initializing stores
> > ordered when we get it from slab.
>
> You make tons of assumptions.
>
> You assume that
>  (a) unlocked accesses are the normal case and should be something the
>      allocator should prioritize/care about.
>  (b) that if you have a ctor, it's the only thing the allocator will do.

Yes, as I said, I do not want to add a branch and/or barrier to the
allocator for this. I just want to flag the issue and discuss whether
there is anything that can be done about it.


> I don't think either of those assumptions are at all relevant or
> interesting. Quite the reverse - I'd expect them to be in a very small
> minority.

They will be in the minority or non-existant, but obviously there only
need be one "counterexample" bug to disprove a claim that it never
matters.


> Now, obviously, on pretty much all machines out there (ie x86[-64] and UP
> ARM), smp_wmb() is a no-op, so in that sense we could certainly say that
> "sure, this is a total special case, but we can add a smp_wmb() anyway
> since it won't cost us anything".
>
> On the other hand, on the machines where it doesn't cost us anything, it
> obviously doesn't _do_ anything either, so that argument is pretty
> dubious.
>
> And on machines where the memory ordering _can_ matter, it's going to add
> cost to the wrong point.

When I said "I'd really hate to add a branch to the slab fastpath", it
wasn't a tacit acknowlegement that the barrier is the only way to go,
if it sounded that way.

I meant: I'd *really* hate to add a branch to the slab fastpath :)
