Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbXLDVkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbXLDVkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXLDVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:39:59 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:46920 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbXLDVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:39:59 -0500
Date: Tue, 4 Dec 2007 16:39:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix for futex_wait signal stack corruption
Message-ID: <20071204213924.GA14915@goodmis.org>
References: <1196801858.1645.37.camel@localhost.localdomain> <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 01:09:36PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 4 Dec 2007, Steven Rostedt wrote:
> >
> > The solution I did to solve this is to allocate a temporary buffer when
> > setting up the block and free it in futex_wait_restart. This patch
> > allows David's test program to actually pass.
> 
> No. Unacceptable. This is a memory leak in case nobody retries it. It's 
> basically not how you can do this thing.

Fair enough.

I was misguided, that the return func had to be called.

> 
> The *only* thing you can pass for a system call restart is the argument 
> block register state. If that is not enough, then you cannot restart it. 
> It's that simple.
> 
> Andrew, please do *not* put this in any queues. It's fundamentally broken, 
> and cannot be fixed as is. 

Yep, trash it.

Seems that arg3 is not used here and since the timer is 64 bits, we can
store the bottom 32 bits in arg2 and the top in arg3 (this will work for
both 32 and 64 bit archs).

This will eliminate the need for kmalloc (I didn't like that solution
anyway).

New patch on its way (after I get some food to eat).

Thanks,

-- Steve

