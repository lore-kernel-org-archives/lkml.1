Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZEQWZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZEQWZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZEQWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:24:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36032
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZEQWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:24:56 -0400
Date: Sun, 17 May 2009 15:24:54 -0700 (PDT)
Message-Id: <20090517.152454.91703958.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: hugh@veritas.com, ak@linux.intel.com, ian.campbell@citrix.com,
       jakub@redhat.com, linux-kernel@vger.kernel.org, jesper.nilsson@axis.com,
       hannes@cmpxchg.org, arjan@linux.intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.01.0905171502160.3301@localhost.localdomain>
References: <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
	<Pine.LNX.4.64.0905171536470.23834@blonde.anvils>
	<alpine.LFD.2.01.0905171502160.3301@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 May 2009 15:18:19 -0700 (PDT)

> The thing is, on at least x86-64, any function using va_start() will 
> allocate something like 64 bytes of stack space for the reg-save area. I'm 
> not quite sure _why_ it does that, but it's very irritating, and it showed 
> up quite clearly in some of the stackspace usage things.
> 
> I even sent the gcc people a patch to fix the worst of it (gcc used to 
> allocate about twice as much space because it also had a XMM save area 
> even if you compiled without XMM support or something like that), but my 
> point is, I'm afraid there is still a noticeable gap on the stack due to 
> this, at least for the _fmt() case.

I ran into this issue on sparc64 while helping someone investigate
stack usage there.

There is some strageness wrt. varargs in that it seems that the opaque
object used to reference varargs is effectively an array which
includes first the arguments passed in registers and then the
non-register stack args.

I never got down to the details yet, but on sparc64 currently we
always eat that extra space (in addition to the normal register window
stack space costs) and I had intended to look into eliminating the
varargs incoming argument save slots for cases where we are not doing
any varargs stuff at all.
