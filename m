Return-Path: <linux-kernel-owner+w=401wt.eu-S1422869AbXBHNHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422869AbXBHNHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422890AbXBHNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:07:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422869AbXBHNHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:07:19 -0500
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <akpm@linux-foundation.org>
Message-Id: <20070208105437.26443.35653.sendpatchset@linux.site>
Subject: [rfc][patch 0/3] a faster buffered write deadlock fix?
Date: Thu,  8 Feb 2007 14:07:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In my last set of numbers for my buffered-write deadlock fix using 2 copies
per page, I realised there is no real performance hit for !uptodate pages
as opposed to uptodate ones. This is unexpected because the uptodate pages
only require a single copy...

The problem turns out to be operator error. I forgot tmpfs won't use this
prepare_write path, so sorry about that.

On ext2, copy 64MB of data from /dev/zero (IO isn't involved), using
4K and 64K block sizes, and conv=notrunc for testing overwriting of
uptodate pages. Numbers is elapsed time in seconds, lower is better.

		2.6.20		bufferd write fix
4K		0.0742		0.1208 (1.63x)
4K-uptodate	0.0493		0.0479 (0.97x)
64K		0.0671		0.1068 (1.59x)
64K-uptodate	0.0357		0.0362 (1.01x)

So we get about a 60% performance hit, which is more expected. I guess if
0.5% doesn't fly, then 60% is right out ;)

If there were any misconceptions, the problem is not that the code is
incredibly tricky or impossible to fix with good performance. The problem
is that the existing aops interface is crap. "correct, fast, compatible
-- choose any 2"

So I have finally finished a first slightly-working draft of my new aops
op (perform_write) proposal. I would be interested to hear comments about
it.  Most of my issues and concerns are in the patch headers themselves,
so reply to them.

The patches are against my latest buffered-write-fix patchset. This
means filesystems not implementing the new aop, will remain safe, if slow.
Here's some numbers after converting ext2 to the new aop:

		2.6.20		perform_write aop
4K		0.0742		0.0769 (1.04x)
4K-uptodate	0.0493		0.0475 (0.96x)
64K		0.0671		0.0613 (0.91x)
64K-uptodate	0.0357		0.0343 (0.96x)

Thanks,
Nick

--
SuSE Labs

