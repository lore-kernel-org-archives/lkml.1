Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZLMUtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZLMUtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZLMUtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46781 "HELO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753686AbZLMUtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:49:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
X-Fcc: ~/Mail/utrace
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
In-Reply-To: Peter Zijlstra's message of  Tuesday, 8 December 2009 19:19:38 +0100 <1260296378.17334.21.camel@laptop>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
	<20091201220847.GA25400@redhat.com>
	<1260210877.3935.594.camel@laptop>
	<20091208150417.GA11883@redhat.com>
	<1260286163.3935.1497.camel@laptop>
	<20091208163131.GA14815@redhat.com>
	<1260296378.17334.21.camel@laptop>
Emacs: anything free is worth what you paid for it.
Message-Id: <20091213204848.02B2B1DE@magilla.sf.frob.com>
Date: Sun, 13 Dec 2009 12:48:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All that seems to do is call ->release() and kmem_cache_free()s the
> utrace_engine thing, why can't that be done with utrace->lock held?

Calling ->release with a lock held is clearly insane, sorry.  It is true
that any engine-writer who does anything like utrace_* calls inside their
release callback is doing things the wrong way.  But guaranteeing that
simple mistakes result in spin-lock deadlocks just seems clearly wrong to
me.  A main point of the utrace API is to make it easier to work in this
space and help you avoid writing the pathological bugs.  Adding picayune
gotchas like this just does not help anyone.  No other API callback is made
holding some internal implementation lock, and making this one the sole
exception seems just obviously ill-advised on its face.  I can't really
imagine what a justification for such an obfuscation would be.

> But yeah, passing that list along does seem like a better solution.

So you find it cleaner to have each caller of utrace_reset take another
output parameter and be followed with the same exact source code duplicated
in each call site, than to have utrace_reset() do the unlock and then the
common code itself.  I guess there is no accounting for taste.  

We try not to get excited about trivia, so on matters like this one we will
do whatever the consensus of gate-keeping reviewers wants.  My patch to
implement your suggestion adds 13 lines of source and 134 bytes of compiled
text (x86-64).  Is that what you prefer?

I'll note that the code as it stands uses the __releases annotation for
sparse, as well as thoroughly documenting the locking details in comments.
I gather that clear explanation of the code is in your eyes no excuse for
ever writing code that requires one to actually read the comments.  I'm not
sure that attitude can ever be satisfied by any code that is nontrivial or
makes any attempts at optimization.


Thanks,
Roland
