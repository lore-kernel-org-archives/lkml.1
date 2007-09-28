Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXI1JRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXI1JRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXI1JRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:17:14 -0400
Received: from smtp.nokia.com ([131.228.20.173]:29901 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbXI1JRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:17:13 -0400
Message-ID: <46FCC686.3050009@yandex.ru>
Date: Fri, 28 Sep 2007 12:16:54 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Write-back from inside FS - need suggestions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Sep 2007 09:16:55.0182 (UTC) FILETIME=[5038A2E0:01C801B0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we are writing anew flash FS (UBIFS) and need some advise/suggestion.
Brief FS info and the code are available at
http://www.linux-mtd.infradead.org/doc/ubifs.html.

At any point of time we may have a plenty of cached stuff which have to
be written back later to the flash media: dirty pages an dirty inodes.
This is what we call "liability" - current set of dirty pages and
inodes UBIFS must be able to write back on demand.

The problem is that we cannot do accurate flash space accounting due
to several reasons:
1. Wastage - some smal random amount of flash space at ends or
  eraseblocks cannot be used.
2. Compression - we do not know how well will the pages be compressed,
  so we do not know how much flash space will they consume.

So, if our current liability is X, we do not know exactly how much
flash space (Y) it will take. All we can do is to introduce some
pessimistic, worst-case function Y = F(X). This pessimistic function
assumes that pages won't be compressible, and it assumes worst-case
wastage. In real life it is hardly going to happen, but possible.
The functiion is really bad and may lead to huge over-estimations
like 40%.

So, if we are, say, in ->prepare_write(), we have to decide whether
there is enough flash space to write-back this page later. We do not
want to fail with -ENOSPC when,say, pdflush writes the page back. So
we use our pessimistic function F(X) to decide whether we have enough
space or not. If there is a plenty of flash space, the F(X) says "yes",
and just we proceed. The question is what do we do if F(X) says "no"?

If we just return -ENOSPC, the flash space utilization becomes too
poor, just because F() is really rough. We do have space in most
real-life cases. All we have to do in this case is to lessen our
liability. IOW, we have to flush few dirty inodes/pages, then we'd
be able to proceed.

So my question is: how can we flush _few_ oldest dirty pages/inodes
while we are inside UBIFS (e.g., in ->prepare_write(), ->mkdir(),
->link(), etc)?

I failed to find VFS calls which would do this. Stuff like
sync_sb_inodes() is not exactly what we need. Should we implement
a similar function? Since we have to call it from inside UBIFS, which
means we are holding i_mutex and the inode is locked, the function
has to be smart enough not to wait on this inode, but wait on other
inodes if needed.

A solution like kicking pdflush to do the job and wait on a waitqueue
would probably also work, but I'd prefer to do this from the context
of current task.

Should we have our own list of inodes and call write_inode_now() for
dirty ones? But I'd prefer to let VFS pick oldest victims.

So I'm asking for ideas which would work and be acceptable by the
community later.

Thanks! 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
