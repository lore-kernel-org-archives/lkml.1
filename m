Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYLZThc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYLZThc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYLZThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:37:23 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37896 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYLZThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:37:22 -0500
Date: Fri, 26 Dec 2008 14:33:07 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andreas Sundstrom <sunkan@zappa.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Message-ID: <20081226193307.GA2138@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Sundstrom <sunkan@zappa.cx>, linux-kernel@vger.kernel.org
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495526F6.9040704@zappa.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 07:48:22PM +0100, Andreas Sundstrom wrote:
> Yes, I mounted it with ext3 and barrier=1 and could reproduce the problem.
> ext3 did not remount the fs ro though, it seems to only disable barriers:
> 
> [    7.681759] blkfront: xvda1: write barrier op failed
> [    7.681776] blkfront: xvda1: barriers disabled
> [    7.681785] end_request: I/O error, dev xvda1, sector 4584
> [    7.681800] end_request: I/O error, dev xvda1, sector 4584
> [    7.681886] JBD: barrier-based sync failed on xvda1 - disabling barriers
> 
> And then I tested with ext4 and barrier=0 and that also works.

Ext4 has patches which will checks the error returns on writes to the
journal, and will abort the journal in case of I/O failures.  Ext3
should have the same patches, but it's apparently missing one of the
patches, or it's otherwise not noticing the problem.  (You were
testing ext3 on a 2.6.28 kernel, right?)

> But I'm here if you want something tested or a patch verified or anything,
> but I guess this might be a Xen issue rather than vanilla kernel stuff.

Yes, this looks very much like a Xen issue.  What is going on is that
we submit the write with barriers enabled, and if it fails, we try
again without barriers.  I'm guessing that Xen emulation code didn't
notice that we were trying again without barriers, or the Xen
emulation isn't clearing the error flag, but for whatever reason,
we're getting a write failure somewhere else later on, and that's
causing the failures.

What would be really useful to nail down exactly what is going on
would be to patch fs/jbd/journal.c and fs/jbd2/journal.c so that the
line:

u8 journal_enable_debug __read_mostly;

is changed to read:

u8 journal_enable_debug=3 __read_mostly;


and similarly in fs/jbd2/journal.c, change:

u8 jbd2_journal_enable_debug __read_mostly;

to read

u8 jbd2_journal_enable_debug=3 __read_mostly;

That will generate a lot more debugging information, and hopefully we
can see exactly what was going on right before the journal abort, and
why ext4 apparently didn't get the corret error return after the
barrier operation failed.

But yes, this ultimately seems very likely to be a Xen emulation bug.

    	      		       	    	      - Ted







> 
> Thanks for helping out with the narrowing down of the issue
> 
> /Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
