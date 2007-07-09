Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbXGIUIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbXGIUIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXGIUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:08:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbXGIUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:08:46 -0400
Date: Mon, 9 Jul 2007 13:08:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <alpine.LFD.0.999.0707091250550.3412@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707091256510.3412@woody.linux-foundation.org>
References: <20070708043228.GB22397@wotan.suse.de>
 <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
 <alpine.LFD.0.999.0707091212410.3412@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707091241350.15898@alien.or.mcafeemobile.com>
 <alpine.LFD.0.999.0707091250550.3412@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jul 2007, Linus Torvalds wrote:
> 
> There are no issues with the 255-CPU cap on 32-bit x86. It's just not 
> relevant to anybody. So the _only_ thing that matters is speed and to a 
> secondary degree size.

..of course, from a pure speed standpoint, the "lock dec" one seems to 
be the fastest, with the difference bwteen the 16-bit/32-bit "lock xadd" 
being comparatively totally in the noise.

Which is what I'd expect.

The difference between a 16-bit and 32-bit xadd should basically not be 
likely to be really measurable (ie we're likely talking about a single CPU 
cycle - if that - for the decode of the operand size override, and since 
both variants need it for _one_ of the operations, it likely ends up being 
about instruction scheduling noise), while the difference between a "dec" 
and "xadd" could be the difference between a native uop and microcoded.

[ Not that "xadd" couldn't be as fast as a "dec" in theory, but it's much 
  less likely to be that. It obviously has to actually write to two 
  targets: the register -and- memory, and that tends to require at least 
  an extra uop.

  And together with being a r-op-w memory instruction to begin with (which 
  is generally the "most complex" normal instruction), and not a very 
  often used instruction, the end result is that it would often tend to be 
  handled specially somehow - either in a special decode unit, or as 
  actual microcode. ]

So from a pure performance standpoint, xadd will likely continue to lose 
against dec. So the reason to choose xadd in the first place isn't "best 
performance", but "best performance given fairness".

And any performance difference between xadd and dec is going to be much 
bigger than any difference between 16/32-bit versions of xadd.

So I wouldn't get too hung up on a potential single cycle, and it's 
arguably more important to make the (inlined) "unlock" thing be as simple 
and small as possible.

			Linus
