Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZBSU1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZBSU1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZBSU04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:26:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZBSU04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:26:56 -0500
Date: Thu, 19 Feb 2009 21:26:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Petr Tesarik <ptesarik@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Definition of BUG on x86
Message-ID: <20090219202647.GB784@elte.hu>
References: <1235047082.15053.49.camel@nathan.suse.cz> <20090219124702.GC22044@elte.hu> <1235048535.15053.52.camel@nathan.suse.cz> <20090219144902.GA8650@elte.hu> <499D7B9D.7060001@goop.org> <20090219153544.GA31637@elte.hu> <1235059883.15053.68.camel@nathan.suse.cz> <20090219161649.GC9556@elte.hu> <499D8A0C.5030908@goop.org> <499DBBEF.2090508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DBBEF.2090508@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Jeremy Fitzhardinge wrote:
>> Ingo Molnar wrote:
>>> Well, the important question is thatGCC will optimize out whatever  
>>> comes after the __builtin_trap(), right? To guarantee an assert we 
>>> can do something like:
>>>
>>>      __builtin_trap();
>>>     panic("should never get here");
>>>
>>> to guarantee a message. (But realistically GCC will at most generate 
>>> a build error.)
>>>   
>>
>> Ah, right, I remember the problem.  There's no guaranteed way of 
>> getting the address of the ud2a instruction __builtin_trap generates to 
>> put it into the bug table.
>>
>
> Did we actually run into any instance where that failed?
>
> It's true that it's not guaranteed, but it seems highly 
> unlikely that it would happen in real life.  We *could* do a 
> forward search at that point, that should catch the vast 
> majority of the failing cases, again, but once again there are 
> no guarantees.
>
> I guess I should ask the gcc people...

The whole thing is borderline anyway (the win is small), and the 
combination of relying on __builtin_trap() [which is documented 
as a non-stable interface], and the reliance on basic block 
non-ordering.

Another complication is that this is _debug_ code - i.e. if 
there's a rare bug here we'll only see it if a bug triggers 
there - which is very rare in itself.

So i'm rather uneasy to rely on GCC to this level. They should 
allow to pass __noreturn to asm()s - that's a far cleaner 
approach.

	Ingo
