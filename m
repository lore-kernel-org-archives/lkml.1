Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYJCNIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYJCNIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbYJCNH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:07:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbYJCNH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:07:57 -0400
Date: Fri, 3 Oct 2008 06:07:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rob Mueller <robm@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org
Subject: Re: BUG: mmapfile/writev spurious zero bytes still in the wild
Message-Id: <20081003060723.7184a1ed.akpm@linux-foundation.org>
In-Reply-To: <20081003114414.GA14390@brong.net>
References: <1213682410.13174.1258837181@webmail.messagingengine.com>
	<1213682570.13708.1258839317@webmail.messagingengine.com>
	<alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
	<20081003114414.GA14390@brong.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 21:44:14 +1000 Bron Gondwana <brong@fastmail.fm> wrote:

> On Tue, Jun 17, 2008 at 02:20:49PM -0700, Linus Torvalds wrote:
> 
> [reminder from way back: this bug was caused by writev containing 
> mmaped pages that weren't paged in, it's 64 bit only.  It
> particularly affects Cyrus Imapd's database formats]
> 
> > On Tue, 17 Jun 2008, Linus Torvalds wrote:
> > > 
> > > Hmm. Something like this *may* salvage it.
> > > 
> > > Untested, so far (I'll reboot and test soon enough), but even if it fixes 
> > > things, it's not really very good. 
> > 
> > Ok, so I just rebooted with this, and it does indeed fix the bug.
> > 
> > I'd be happier with a more complete fix (ie being byte-accurate and 
> > actually doing the partial copy when it hits a fault in the middle), but 
> > this seems to be the minimal fix, and at least fixes the totally bogus 
> > return values from the x86-64 __copy_user*() functions.
> 
> Has this been revisited since?  I haven't noticed, but I really only
> skim LKML - have to save some time in the day for my real job[tm] of
> keeping an email service running!
> 
> > Not that I checked that I got _all_ cases correct (and maybe there are 
> > other versions of __copy_user that I missed entirely), but Bron's 
> > test-case at least seems to work properly for me now.
> > 
> > Bron? If you have a more complete test-suite (ie the real-world case that 
> > made you find this), it would be good to verify the whole thing. 
> 
> It's been fine for us since, but unfortunately most of the world is
> still running distribution "stable" kernels.  I've just been helping a
> user who's getting corrupted flat file databases on Ubuntu's stable 64
> bit xen kernels, and it looks like it's the same issue.
> 
> Is there a standard way to tell backporters "you really need to add this
> patch for your users' sanity"?

Yes, there is.  We backport the patch into earlier kernel releases and
that action _should_ wake the distros up to take a look at the fix.

This particular fix (42a886af728c089df8da1b0017b0e7e6c81b5335) was
included in 2.6.26 and also is present in 2.6.25.17, but not 2.6.25. 
So we did backport it into 2.6.25.x.  Maybe distros were slow or errant
in picking up the patch.

