Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZK1Su7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZK1Su7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 13:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZK1Su7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 13:50:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbZK1Su6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 13:50:58 -0500
Date: Sat, 28 Nov 2009 19:50:52 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mark Veltzer <mark.veltzer@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: get_user_pages question
Message-ID: <20091128185052.GB30235@random.random>
References: <200911090850.26724.mark.veltzer@gmail.com>
 <87skco59jl.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0911091031460.15199@sister.anvils>
 <200911100013.31768.mark.veltzer@gmail.com>
 <Pine.LNX.4.64.0911101613080.22198@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911101613080.22198@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh and everyone,

On Tue, Nov 10, 2009 at 04:33:30PM +0000, Hugh Dickins wrote:
> In fairness I've added Andrea and KOSAKI-san to the Cc, since I know
> they are two people keen to fix this issue once and for all.  Whereas

Right, I'm sure Nick also wants to fix this once and for all (adding
him too to Cc ;).

I thought and I still think it's bad to leave races like this open for
people to find out the hard way. It just takes somebody to use
pthread_create, open a file with O_DIRECT with 512byte (not page
alignment) and call fork to trigger this, and they may find out only
later after going productive on thousand of servers... If this was a
too hard problem to fix I would understand, but I've all patches ready
to fix this completely! And they're quite localized they only touch
fork and gup and they don't alter the fast path (except for 1
conditional jump in fork that surely is lost in the noise, plus fork
is all but a fast path).

I tried to fix this in RHEL but eventually the user affected added
larger alignment to the userland app to prevent this, so it isn't as
urgent anymore and so I'd rather prefer to fix this in mainline
first. This isn't the first and surely won't be the last user that is
bitten by this, unless we take action.

> I am with Linus in the opposite camp: solutions have looked nasty,
> and short of bright new ideas, I feel we've gone as far as we ought.

There are two gup races that materializes when we wrprotect and share
an anonymous page.

bug 1) If a parent thread writes to the first half of the page while
the gup user writes to the second half of the page and then fork is
run, the O_DIRECT read from disk in the second half of the page gets
lost. In addition the child will still receive the O_DIRECT writes to
memory when it should not.

bug 2) The backward race happens after fork, when the parent starts an
O_DIRECT write to disk from the first half of the page, and then
writes to memory in the second half of the page, after that the child
writes to the page will be read by the parent direct-io.

fix for bug 1) is what Nick and me implemented, that consists in
copying (instead of sharing) anon pages during fork, if they could be
under gup. The two implementations are vastly different but they look
to do the same thing (he used bitflags in the vma and in the page, I
only used a bitflag in the page, worst thing of my patch was having to
set that bitflag in gup_fast too, I don't like having to add a bit to
the vma when a bit in the page is enough).

fix A for bug 2) is what KOSAKI tried to implement in message-id
20090414151554.C64A.A69D9226. The trick is in having do_wp_page not
taking over a page under GUP (that means reuse_swap_cache has to take
the page_count into account too, not just the mapcount). However
taking page_count into account in reuse_swap_cache, means that it
won't be capable of taking over a page under gup that got temporarily
converted to swapcache and unmapped, so leading to losing O_DIRECT
reads from disk during paging. So another change is required to rmap
code to prevent ever unmapping any pinned anon page that could be
under GUP to avoid losing I/O during paging.

fix B for bug 2) is what Nick and me implemented, that consists in
always de-cowing anon shared pages during gup even in case of
gup(write=0). That's much simpler than fix A for bug 2 and the fix
doesn't affect rmap swap semantics, but it loses some sharing
capability in gup(write=0) cases, not a practical matter though.

All other patches floating around spread an mm-wide semaphore over
fork fast path, and across O_DIRECT, nfs, and aio, and they most
certainly didn't fix the two races for all gup users, and they weren't
stable because of having to identify the closure of the I/O across all
possible put_page. That approach kind of opens a can of worms and it
looks the wrong way to go to me, and I think they scale worse too for
the fast path (no O_DIRECT or no fork). Identifying the gup closure
points and replacing the raw put_page with gup_put_page would not be
an useless effort though and I felt if the gup API was just a little
bit more sophisticated I could simplify a bit the put_compound_page to
serialize the race against split_huge_page_refcount, but this is an
orthogonal issue with the mm-wide semaphore release addition which I
personally dislike.
