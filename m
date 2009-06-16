Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbZFPUrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbZFPUrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762869AbZFPUrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:47:04 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:55570 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764652AbZFPUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:47:03 -0400
X-Trace: 215965825/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.95.160/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.95.160
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGAN+hN0pQKV+g/2dsb2JhbACBT9N/hAsF
X-IronPort-AV: E=Sophos;i="4.42,231,1243810800"; 
   d="scan'208";a="215965825"
Date: Tue, 16 Jun 2009 21:45:01 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
In-Reply-To: <4A37F098.2060208@redhat.com>
Message-ID: <Pine.LNX.4.64.0906162108550.6321@sister.anvils>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random>
 <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <4A37F098.2060208@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Izik Eidus wrote:
> Hugh Dickins wrote:
> >
> > Looks like Izik and I hit the same problem (otherwise running well):

Ran well enough overnight (with mm/mmap.c vm_flags hack to be merging
everything it could) that, to judge by your remarks below, I ought to
switch away from investigating and fixing and reviewing, to sending
you patches to bring us back in synch.

I don't think I have any problems with the madvise route, which weren't
already problems with the /dev/ksm route: there are oddities I'm eager
to look into (fork still raising questions for me), but nothing serious
enough to get in the way of resynching.

Andrea will be relieved to learn that I like mm_slot->touched very much:
I don't know (and now don't need to know) what was serving that purpose
in the /dev/ksm version.

> Good, This solve another issue that you probably dont hit beacuse you work
> with the madvise version:
> the .release call back of the file_operations strcture will call to:
> ksm_sma_release() that will call to remove_slot_from_hash_and_tree() that will
> do the silly break_cow() call (even that the prcoesses just die!!!)

Yes, I'd noticed before that break_cow() can be silly more work than
necessary, may need care in ordering things.  But, if it's still any
issue, it's something that can be optimized later: you have a technique
that goes about it safely, that's good.

> Now beacuse that exit_mm() will set tsk->mm = NULL before the .release will
> get called, we will trigger this path even without the kernel thread context.
> (I prepred patch that just avoid the break_cow() from the .release context,
> but it isnt needed with this patch)
> 
> (You shouldnt have that specific problem in the madvise() version beacuse we
> dont have this .release callback anymore, but we still do there useless
> break_cow() calls, considering the fact that the process just die, this
> break_cow() calls should be made only when the user ask specifically to stop
> merging pages i guess...,

Yes, and I'm thinking that although it's fine for madvise(,,MADV_MERGEABLE)
to be slow to get around to merging, probably madvise(,,MADV_UNMERGEABLE)
needs to have broken COW on any KSM pages before the call returns.  I've
a suspicion that nobody will ever use MADV_UNMERGEABLE, outside of our
testing; and yet it's against my principles not to provide it, and if it
is used, then I think it needs to give that guarantee before returning.
But again, something we can fill in once we're in synch.

> I will send patch that will make it work more logical on top of your patches
> as soon as you send something)

Right, what would you like me to base against?  What if you were to
send me a rollup patch against 2.6.30 of what your tree has now?  Or
would you prefer to base against an mmotm?  With or without your RFC
patches, or something close to them?

Once I have your base, whichever way you prefer it, then I can put
together a series of patches to adjust that to what I'm now working
with (mainly: the ksm.c end of it would be much as in your RFC though
with tidyups, and minus 4/4; whereas the madvise.c end of it I reworked).

The patches we send to Andrew for mmotm, later on, would be something
different, I believe (and something different from your git history):
there I think we'd be asking him to remove the KSM patches he already
has, and providing fresh equivalents based around the madvise interface
(so, for example, I think there would be no patch at all to mm/rmap.c,
all the changes made there earlier being later reverted).

Hugh
