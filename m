Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZCVNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZCVNzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 09:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZCVNzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 09:55:22 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37957 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZCVNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 09:55:21 -0400
Date: Sun, 22 Mar 2009 13:55:06 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-kernel@vger.kernel.org, Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: 2.6.28.2 kernel bug
In-Reply-To: <49C5D217.2010201@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0903221325470.20915@blonde.anvils>
References: <49C52958.7030700@xs4all.nl> <Pine.LNX.4.64.0903212014380.15606@blonde.anvils>
 <49C5D217.2010201@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009, Udo van den Heuvel wrote:
> Hugh Dickins wrote:
> > This would become more interesting if you are able to reproduce it,
> 
> Just restarted the find command again, crashed after about 7 hours,

Thank you.

> this time
> with just one line in messages, about the bad page state for `find` again.

Just one line?  Hmm.  Well, please do send that "Bad page state"
message and whatever comes just before and just after it.

This does tend to confirm that the problem is a double-free somewhere,
and the rmap negative mapcount Eeeks no more than a consequence of the
page getting reused in userspace that time, but not this time.

> 
> > or something like it - is that massive removal of files something
> > you often do without a problem, or was this new?  What does your
> > find/rm command line look like?  I'm wondering if we have a bug
> > with exceptionally long arg lists.
> 
> I ran a find to get rid of ~2.5M files in
> ~/.beagle/Indexes/Thunderbird/ToIndex which shouldn't have been there:
> find ToIndex -type f -exec rm -f {} \;

Right, so no long arg lists at all: just one find and many execs.
And the filesystem is ext3, to judge by some of the stacktraces.

> This find runs pretty slowish.

(Yes, there will be much faster ways to delete all those unwanted files,
running exec one by one is very inefficient: "man 1 xargs" (and skip to
the EXAMPLES so as not to be put off by all its options!), that may be
what you want in future (or just "rm -rf ToIndex"?).  But irrelevant to
this kernel crash - the way you're doing it should never cause Bad page
states or rmap Eeeks.)

> 
> The 2nd time I ran a sync severy 123 seconds to avoid big troubles in case of
> a crash.
> 
> Now I just made a list of all files and have a small shell script delete the
> files one by one.
> 
> I seldomly have these amounts of files to delete.

Ah, and now you've deleted them, so wouldn't be able to reproduce this
for a few months?  I'm assuming you won't feel much like creating 2.5M
files just to experiment for us!

Are you expecting to upgrade to 2.6.29 when it comes out (maybe in a week
or so), or one of its early -stables?  That has a good chance of giving
you less trouble when such an error occurs, but I don't know of anything
fixed that would fully resolve your issue.

> I never have this specific problem logged. (as far as I recall for this box)
> It is typical that `find` triggers it and not cc1, Xorg etc.

I'm still unclear how often this happens: your "seldomly" suggested
once in a few months, but your "typical" suggests that it's happened
many times with 2.6.28.N.

You're right that cc1 is famous for being able to trigger RAM problems
that memtest misses (though it's definitely still worth trying memtest).

This _feels_ a little more likely to be a page double-free somewhere
in ext3 or jbd - but I really shouldn't make such an accusation,
I've not heard any other evidence for it - and I'm not at all
likely to locate it either.

Hugh
