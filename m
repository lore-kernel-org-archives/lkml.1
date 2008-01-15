Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYAOVNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYAOVNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYAOVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:13:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:30035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbYAOVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bLcxD/8h1B5uAb8ERVUGxhc/UFVC8yPuR0U6+a63Hza2PGYQ65i8VZahyS4AIe4FgQEg4xAHNZ102c+Xch7YqLkpGEH4NZ44eNCkgqcujbw4qeDZr4EmCeZvkGD0nxU1irOJCjgHz4XCInAmoEefbnqrzM0sLbrGCGO1du2Xpro=
Message-ID: <170fa0d20801151313s57dcc08cn550113036c3003be@mail.gmail.com>
Date: Tue, 15 Jan 2008 16:13:22 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Cc: "Peter Zijlstra" <peterz@infradead.org>, jplatte@naasa.net,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <400358577.30629@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801071151.11200.lists@naasa.net>
	 <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn>
	 <200801141230.13694.jplatte@naasa.net>
	 <1200310886.15103.1.camel@twins> <400358577.30629@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 7:50 AM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Mon, Jan 14, 2008 at 12:41:26PM +0100, Peter Zijlstra wrote:
> >
> > On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> > > Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> > >
> > > > Joerg, this patch fixed the bug for me :-)
> > >
> > > Fengguang, congratulations, I can confirm that your patch fixed the bug! With
> > > previous kernels the bug showed up after each reboot. Now, when booting the
> > > patched kernel everything is fine and there is no longer any suspicious
> > > iowait!
> > >
> > > Do you have an idea why this problem appeared in 2.6.24? Did somebody change
> > > the ext2 code or is it related to the changes in the scheduler?
> >
> > It was Fengguang who changed the inode writeback code, and I guess the
> > new and improved code was less able do deal with these funny corner
> > cases. But he has been very good in tracking them down and solving them,
> > kudos to him for that work!
>
> Thank you.
>
> In particular the bug is triggered by the patch named:
>         "writeback: introduce writeback_control.more_io to indicate more io"
> That patch means to speed up writeback, but unfortunately its
> aggressiveness has disclosed bugs in reiserfs, jfs and now ext2.
>
> Linus, given the number of bugs it triggered, I'd recommend revert
> this patch(git commit 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b). Let's
> push it back to -mm tree for more testings?

Fengguang,

I'd like to better understand where your writeback work stands
relative to 2.6.24-rcX and -mm.  To be clear, your changes in
2.6.24-rc7 have been benchmarked to provide a ~33% sequential write
performance improvement with ext3 (as compared to 2.6.22, CFS could be
helping, etc but...).  Very impressive!

Given this improvement it is unfortunate to see your request to revert
2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b but it is understandable if
you're not confident in it for 2.6.24.

That said, you recently posted an -mm patchset that first reverts
2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b and then goes on to address
the "slow writes for concurrent large and small file writes" bug:
http://lkml.org/lkml/2008/1/15/132

For those interested in using your writeback improvements in
production sooner rather than later (primarily with ext3); what
recommendations do you have?  Just heavily test our own 2.6.24 + your
evolving "close, but not ready for merge" -mm writeback patchset?

regards,
Mike
