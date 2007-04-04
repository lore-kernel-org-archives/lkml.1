Return-Path: <linux-kernel-owner+w=401wt.eu-S2992813AbXDDKBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992813AbXDDKBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992809AbXDDKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:01:36 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:7494 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992813AbXDDKBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:01:35 -0400
X-AuditID: d80ac287-96cc9bb000000c42-9c-4613777f2c98 
Date: Wed, 4 Apr 2007 10:45:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Andrea Arcangeli <andrea@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: <20070404033726.GE18507@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com>
References: <20070329075805.GA6852@wotan.suse.de>
 <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
 <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 10:01:34.0657 (UTC) FILETIME=[3A325310:01C776A0]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Nick Piggin wrote:
> On Fri, Mar 30, 2007 at 04:40:48AM +0200, Nick Piggin wrote:
> > 
> > Well it would make life easier if we got rid of ZERO_PAGE completely,
> > which I definitely wouldn't complain about ;)

Yes, I love this approach too.

> 
> So, what bad things (apart from my bugs in untested code) happen
> if we do this? We can actually go further, and probably remove the
> ZERO_PAGE completely (just need an extra get_user_pages flag or
> something for the core dumping issue).

Some things will go faster (no longer needing a separate COW fault
on the read-protected ZERO_PAGE), some things will go slower and use
more memory.  The open question is whether anyone will notice those
regressions: I'm hoping they won't, I'm afraid they will.  And though
we'll see each as a program doing "something stupid", as in the Altix
case Robin showed to drive us here, we cannot just ignore it.

> 
> Shall I do a more complete patchset and ask Andrew to give it a
> run in -mm?

I'd like you to: I didn't study the fragment below, it's really all
uses of the ZERO_PAGE that I'd like to see go, then we see who shouts.

It's quite likely that the patch would have to be reverted: don't
bother to remove the allocations of ZERO_PAGE in each architecture
at this stage, too much nuisance going back and forth on those.

Leave ZERO_PAGE as configurable, default off for testing, buried
somewhere like under EMBEDDED?  It's much more attractive just to
remove the old code, and reintroduce it if there's a demand; but
leaving it under config would make it easy to restore, and if
there's trouble with removing ZERO_PAGE, we might later choose
to disable it at the high end but enable it at the low.  What
would you prefer?

Hugh
