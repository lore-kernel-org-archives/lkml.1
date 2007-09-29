Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXI2J5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXI2J5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXI2J5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:57:33 -0400
Received: from smtp.nokia.com ([131.228.20.173]:34152 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXI2J5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:57:32 -0400
Message-ID: <46FE2167.8000800@yandex.ru>
Date: Sat, 29 Sep 2007 12:56:55 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
Subject: Re: Write-back from inside FS - need suggestions
References: <46FCC686.3050009@yandex.ru>
In-Reply-To: <46FCC686.3050009@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Sep 2007 09:56:55.0812 (UTC) FILETIME=[11857440:01C8027F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This is precisely the problem which needs to be solved for delayed
> allocation on ext2/3/4.  This is because it is infeasible to work out how
> much disk space an ext2 pagecache page will take to write out (it will
> require zero to three indirect blocks as well).
>
> When I did delalloc-for-ext2, umm, six years ago I did
> maximally-pessimistic in-memory space accounting and I think I just ran a
> superblock-wide sync operation when ENOSPC was about to happen.  That
> caused all the pessimistic reservations to be collapsed into real ones,
> releasing space.  So as the disk neared a real ENOSPC, the syncs becaome
> more frequent.  But the overhead was small.
>
> I expect that a similar thing was done in the ext4 delayed allocation
> patches - you should take a look at that and see what can be
> shared/generalised/etc.
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
>
> Although, judging by the comment in here:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ext4-delayed-allocation.patch
>
> + * TODO:
> + *   MUST:
> + *     - flush dirty pages in -ENOSPC case in order to free reserved blocks
>
> things need a bit more work.  Hopefully that's a dead comment.
>
> <looks>
>
> omigod, that thing has gone and done a clone-and-own on half the VFS.
> Anyway, I doubt if you'll be able to find a design description anyway
> but you should spend some time picking it apart.  It is the same problem..

(For some reasons I haven't got your answer in my mailbox, found it in
archives)

Thank you for these pointers. I was looking at ext4 code and found haven't
found what they do in these cases. I think I need some hints to realize
what's going on there. Our FS is so different from traditional ones
- e.g., we do not use buffer heads, we do not have block device
underneath, etc, so I even doubt I can borrow anything from ext4.

I have impression that I just have to implement my own list of
inodes and my own victim-picking policies. Although I still think it
should better be done on VFS level, because it has all these LRU lists,
and I'd duplicate things.

Nevertheless, I add Teo on CC in a hope he'll give me some pointers.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
