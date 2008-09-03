Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYICMMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYICMMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYICMMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:12:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYICMMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:12:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] utrace: ptrace cooperation
In-Reply-To: Christoph Hellwig's message of  Saturday, 30 August 2008 09:38:34 -0400 <20080830133834.GA17566@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain>
	<20080826220237.66B3D154233@magilla.localdomain>
	<20080830133834.GA17566@infradead.org>
Emacs: because you deserve a brk today.
Message-Id: <20080903121011.42AC9154228@magilla.localdomain>
Date: Wed,  3 Sep 2008 05:10:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't like this patch in it's current form.  Having two different ways
> to do ptrace is a rather awkward thing and not very good for testing
> coverage.  This should not be an option but required.  

The main idea behind having CONFIG_UTRACE_PTRACE be an option separate
from CONFIG_UTRACE is just for debugging during this development and
transition period.  With CONFIG_UTRACE=y, CONFIG_UTRACE_PTRACE=n, then
ptrace works as it ever did.  You'll only have trouble if you use utrace
on the same tasks.  So if you hit bad problems working on something
using utrace, you can always switch to CONFIG_UTRACE_PTRACE=n to use gdb
and strace et al reliably on your userland code, which might be damn
helpful in figuring out how you're triggering the utrace bugs.  By the
time it's no longer EXPERIMENTAL, the separate option could be gone.

> I'm not even sure
> keeping a non-utrace version at all is a good idea. I'd rather set a
> deadline for arch maintainers to convert everything to the generic
> ptrace bits + regsets + tracehook and if they don't manage to do it by
> then ptrace will be disabled for those who can't keep up.  Of course
> this will need an announcement on linux-arch first, but it's much better
> than a never ending phase of APIs in migration.

We agree on how it should end up.  I have concentrated on how not to
break any arch that doesn't care about my work, or put another way, how
not to let progress be held hostage to delay as long as some arch's
don't care.  An arch deadline is fine with me (I'm not the one who has
to meet it).  I've always assumed there would be one eventually.  But
any reasonable deadline would be some time hence, I don't know how long
(time scales in feature-removal-schedule.txt seem to be pretty long).  I
wouldn't like to make merging any of utrace be contingent on waiting for
that deadline, just to avoid having a phase of APIs in migration--one
that can certainly end.

There is another point, not about the arch issue.  In the first utrace
prototype, I wound up spending basically all my time on ptrace.  An
internal reorganization that implements ptrace is not very interesting.
I think that working on different users of utrace will be far more
effective at honing the utrace layer.  My hope is that utrace can be
merged and EXPERIMENTAL for some time while users develop, beat on, and
get it solid.  Meanwhile, people not working on that need reliable old
ptrace code when they don't select the newfangled options.

As the patch posting said, this is a minimal kludge to get by for now.
After some of those other users you've demanded have banged it all out,
then I'll get back to worrying about ptrace later.  (In the meantime, if
it goes too wrong, switch back to the old code while we keep hashing out
utrace bugs by other means.)

Some more ptrace cleanups can be done orthogonal to utrace,
e.g. reorganizing the data structures as you mentioned in another
message.  This can be done in parallel to getting utrace in shape.
Doing it that way makes it easy to test and prove those cleanups on
their own and thus isolate any ptrace regressions either to those
changes or to utrace problems.


Thanks,
Roland
