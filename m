Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZLILoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZLILoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZLILoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:44:05 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:14850 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbZLILoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:44:04 -0500
X-Trace: 300616225/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicBABMcH0tQKW/F/2dsb2JhbAAI1iOELAQ
X-IronPort-AV: E=Sophos;i="4.47,368,1257120000"; 
   d="scan'208";a="300616225"
Date: Wed, 9 Dec 2009 11:43:57 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Miller <davem@davemloft.net>, Ollie Wild <aaw@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
       viro@ftp.linux.org.uk, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <20091208220638.GN14381@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0912091041250.23659@sister.anvils>
References: <20091208060701.GM14381@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0912081142280.31223@sister.anvils> <Pine.LNX.4.64.0912081254500.3365@sister.anvils>
 <20091208.130802.25121122.davem@davemloft.net> <20091208220638.GN14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Peter, Ollie:
  What started out with some nasty problems in mremap(), not checking
  as mmap() does that it was expanding or moving into forbidden areas
  of the address space, has now mostly morphed into a discussion of how
  to enforce such checks when get_user_pages() has mm != current->mm: and
  in particular, how to eliminate get_user_pages() on bprm->mm in exec().
  Hence I've added you, with Rik, to the Cc list.]

On Tue, 8 Dec 2009, Al Viro wrote:
> On Tue, Dec 08, 2009 at 01:08:02PM -0800, David Miller wrote:
> > From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Date: Tue, 8 Dec 2009 13:03:30 +0000 (GMT)
> > 
> > > That would impose some (unacceptable?) limits, and require some funny
> > > code to migrate the pages over to the new mm later (instead of
> > > relocating within the new mm as we do now).
> > 
> > I think this approach would create new failure cases that don't exist
> > now.  Whether that's acceptable or not is another issue.

David: Yes, that's one of my fears too - I don't think
rlimits would pose any new problem, but building up the argv+env below
sp on the execer's userstack would be in danger of colliding with the
vma below if the space allowed to that userstack is too small.  We can
say "sorry, you left too little space for your userstack", but it's
still a regression.  My other big fear is this: that it's such a simple
and obvious way to do it, that it has probably been ruled out for very
good reasons in the past.

> > 
> > The forced page table move, and TLB+cache flush that goes along with
> > that, for every single compat task we get now on the other hand is not
> > acceptable :-)

David: This seems a valid concern, but this is the first
time I've heard such a complaint.  Perhaps I've just not noticed them;
but I do wonder if it's been noticed as a regression in practice, or
just causing alarm now that Al has drawn attention to how it works.

> > 
> > I also think this page table move overhead is worse than the
> > non-swapability added by Al's approach.

David: I see your point, though it may be an issue on which the "main"
architectures win the day.  My execer's userstack approach would have
the same overhead as at present, I think; no, worse, it would involve
that overhead in all cases.  Hmm.

> 
> We should be able to make them swappable - embed an inode into bprm, use
> a _very_ trimmed-down analog of shmem.c to handle it, then, after switch
> to new VM, swap what's needed in, steal it from that inode and shove resulting
> anon pages into freshly created stack vma.  At least assuming that I haven't
> completely misunderstood Rik's answers to my questions, which is admittedly
> quite possible ;-)
> 
> I'll try to do it that way and see what falls out...

... my hair ;-)
I have to say, Dr Frankenstein, that this idea fills me with dread.

I'm not saying it's impossible, but the resulting creature sounds like
it's going to be special in several easily-buggy hard-to-maintain ways.

I think you already realize that shmem file pages (shared) live by
different rules from anonymous pages (COWed): they're both swappable,
but switching a group of pages from one to the other is going to be
weird new territory.  (In fairness, my suggestion involves some
weird new territory too, but considerably less scary to me.)

I think you'd do better to drop the idea of swappability for the moment.
I don't like to do so at all, but I'd rather you came up with a clean
design without it first, and swappability be added a release later
if it can be got to work.

However, if you do drop swappability for the moment, what are you left
with?  A reversion of commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
"mm: variable length argument support", but putting the pages into a
linked list instead of a MAX_ARG_PAGES array.  Well, that should be
very easy, but would it be adequate?

Hugh
