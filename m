Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYFRECM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYFRECM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYFREB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:01:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40346
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYFREB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:01:59 -0400
Date: Tue, 17 Jun 2008 21:01:59 -0700 (PDT)
Message-Id: <20080617.210159.141238856.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 17 Jun 2008 20:47:57 -0400 (EDT)

> Wait queue waking looks like being written by a high-level maniac --- it 
> contains 8 levels of calls (none of them inlined). 7 of these calls (until 
> try_to_wake_up) do nothing but pass arguments to lower level call. And 
> each of these calls allocate at least 192 bytes of stack space. All these 
> 7 useless calls consume 1360 bytes of stack (and cause windows traps that 
> needlessly damage performance). Would you agree to inline most of the 
> calls to save stack? Or do you see another solution?

Some of them could be inlined but there are a few limiting
factors here.

Even spin lock acquisitions are function calls, limiting how
much leaf function and tail call optimizations can be done.

Also, wake_up_bit has this aggregate local variable "key" whose
address is passed down to subsequent functions, which limits
optimizations even further.

It could still be improved a lot, however.

> Long-term consideration: Is it possible to implement interrupt stacks on 
> sparc64? Functions on sparc eat stack much more aggressively than on other 
> architectures (minimum stack size for a function is 192 bytes).

I had a patch but at the time I wrote it (several years ago) I
couldn't make it stable enough to put mainline, I may resurrect it.

I just did a quick scan and I can't find the last copy I had, and
things have changed enough that I'd probably work from scratch
anyways.

But the level of recursion possible by the current device layer is
excessive and needs to be curtained irrespective of these generic
wakeup and sparc64 interrupt stack issues.
