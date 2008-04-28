Return-Path: <linux-kernel-owner+w=401wt.eu-S966712AbYD1T1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966712AbYD1T1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965008AbYD1T1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:27:11 -0400
Received: from www.tglx.de ([62.245.132.106]:41381 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780AbYD1T1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:27:10 -0400
Date: Mon, 28 Apr 2008 21:26:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804282038160.3261@apollo.tec.linutronix.de>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org>
 <alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Linus Torvalds wrote:
> > > > How about making the optimization controlled by a config switch so
> > > > arch maintainers can decide whether they want to enable the constant
> > > > optimization or unconditionally call the lib function ?
> > > 
> > > No.
> > > 
> > > This is just making that damn header line look worse and worse.
> > > 
> > > Is there a _reason_ to optimize this stupid function this way?
> > 
> > On architectures which have a find bit instruction we can replace the
> > call to the library function by a single instruction when the size of
> > the bitmap is less/equal bits per long and when the bitnr is a
> > constant.
> 
> That's not what I asked.
> 
> I asked whether there is a *reason* to optimize this and cause all these 
> stupid problems.
> 
> Is there a real hot path anywhere that actually uses this and depends on 
> it?

Sorry, misunderstood your question. 

I checked the use cases and have not found a single one for
find_next_(zero_)bit() which makes use of this micro optimization. In
fact the .text section of vmlinux of the "optimized" and the straight
function call are identical. So the effect of those micro
optimizations is exactly zero.

find_first_(zero_)bit() has a couple of places where the optimization
hits, but the code size reduction is mere 21 bytes and the use cases
are not in real hot pathes AFAICT.

I doubt that that is worth the trouble and we should just remove those
inlines alltogether. This was discussed before, but Andi objected to
remove those micro optimizations and nobody had time to actually
verify the real benefits.

I'll whip up a patch.

Thanks,

	tglx
