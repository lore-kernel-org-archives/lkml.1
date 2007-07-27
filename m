Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbXG0UIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbXG0UIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763166AbXG0UH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:07:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763265AbXG0UHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:07:55 -0400
Date: Fri, 27 Jul 2007 13:07:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: robm@fastmail.fm
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       "Bron Gondwana" <brong@fastmail.fm>,
       "Oleg Drokin" <green@linuxhacker.ru>, "Chris Mason" <mason@suse.com>
Subject: Re: Memory leaking behaviour in 2.6.20.11, reiserfs related?
Message-Id: <20070727130739.9376a2b5.akpm@linux-foundation.org>
In-Reply-To: <1185436893.18946.1202118935@webmail.messagingengine.com>
References: <1185436893.18946.1202118935@webmail.messagingengine.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 18:01:33 +1000
"Robert Mueller" <robm@fastmail.fm> wrote:

> Hi
> 
> We've been seeing some kernel memory leak behaviour in 2.6.20.11. After 
> running for just over a week, one of our machines was showing almost all 
> it's memory being used, even though we'd exited all the main services on
> the machine. The machine is a newish IBM x3550 with a Xeon 5130 processor
> and 12G of RAM. We're using a x86 kernel with PAE rather than x86_64, but 
> haven't had a problem like this on other machines, though they are 8G and 
> Prescott based. It's being used for cyrus IMAP serving and has about 35 
> reiserfs volumes mounted on it. The result after a week is that memory looks 
> like this. 
>
> [root@imap10 ~]$ free
>              total       used       free     shared    buffers     cached
> Mem:      12466708   11690804     775904          0     560060     714292
> -/+ buffers/cache:   10416452    2050256
> Swap:      2048276      49952    1998324

yup, that's a leak.

> This is pretty much a vanilla kernel, with just one patch to work around
> a deadlock problem in the reiserfs_file_write code that I think isn't
> fixed.
> 
> http://lists.linuxcoding.com/kernel/2006-q1/msg32508.html
> 
> The patch basically bypasses all the code to use do_sync_write. We haven't
> noticed it as a performance issue. I haven't tested if the deadlock
> problem has been fixed since 2.6.16, but with this patch there definitely
> isn't a problem, so we haven't been particularly keen to find out.
> 
> --- linux-2.6.19.2/fs/reiserfs/file.c   2006-11-29 16:57:37.000000000 -0500
> +++ linux-2.6.19.2-syncwrite/fs/reiserfs/file.c 2007-02-02 01:01:36.000000000 -0500
> @@ -1358,6 +1358,8 @@
>         if (file->f_flags & O_DIRECT)
>                 return do_sync_write(file, buf, count, ppos);
> 
> +       return do_sync_write(file, buf, count, ppos);
> +
>         if (unlikely((ssize_t) count < 0))
>                 return -EINVAL;

So that sounds like a reiserfs bug.

> One other thing that is probably relevant, is that we saw some of these
> error messages in the dmesg log.
> 
> BUG: at fs/reiserfs/inode.c:2868 reiserfs_releasepage()
>  [<c0199ecb>] reiserfs_releasepage+0xa3/0xa8
>  [<c0199e28>] reiserfs_releasepage+0x0/0xa8
>  [<c013c8e9>] try_to_release_page+0x2c/0x40
>  [<c0141386>] pagevec_strip+0x52/0x54
>  [<c0141fa0>] shrink_active_list+0x2c0/0x3d1
>  [<c0142b33>] shrink_zone+0xd8/0xf5
>  [<c014307c>] kswapd+0x322/0x423
>  [<c012b4e4>] autoremove_wake_function+0x0/0x37
>  [<c0142d5a>] kswapd+0x0/0x423
>  [<c012b362>] kthread+0xae/0xd3
>  [<c012b2b4>] kthread+0x0/0xd3
>  [<c010383b>] kernel_thread_helper+0x7/0x1c
>  =======================

And so does that.

> [root@imap10 proc]$ dmesg | grep fs/reiserfs/inode.c | wc -l
> 38
> 
> All of them show basically the same trace as above.
> 
> There's a dump of the kernel config available here:
> http://robm.fastmail.fm/kernel/2007-07-26/config.txt
> 
> Here's a dump of just about everything from /proc that I thought might be useful
> 
> [root@imap10 ~]$ cat /proc/meminfo
> MemTotal:     12466708 kB
> MemFree:        739752 kB
> Buffers:        560436 kB
> Cached:         754096 kB
> SwapCached:       4540 kB
> Active:        9878988 kB
> Inactive:      1594924 kB
> HighTotal:    11663148 kB
> HighFree:       725192 kB
> LowTotal:       803560 kB
> LowFree:         14560 kB
> SwapTotal:     2048276 kB
> SwapFree:      1998324 kB
> Dirty:          130036 kB
> Writeback:           0 kB
> AnonPages:       12828 kB
> Mapped:           4396 kB
> Slab:           223012 kB
> SReclaimable:   192724 kB
> SUnreclaim:      30288 kB
> PageTables:        636 kB
> NFS_Unstable:        0 kB
> Bounce:              0 kB
> CommitLimit:   8281628 kB
> Committed_AS:    79208 kB
> VmallocTotal:   118776 kB
> VmallocUsed:     24536 kB
> VmallocChunk:    93532 kB

Large amounts of memory got lost on the LRU lists.

There are some debugging patches in -mm which will help us to identify the
leaker.  Unfortunately they don't apply well to mainline kernels so it's
probably easiest to run the whole -mm lineup.  2.6.22-rc6-mm1 was
reasonably stable.

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/page-owner-tracking-leak-detector.patch
contains instructions on how to use the page leak detector.

Unfortunately I suspect that this will just show that the pages were
allocated from the core pagecache allocation functions so the result won't
be interesting.

Quite a few people are using reiserfs and yours is the only report of this
which I can recall.  Can you think of any reason why your setup differs
from most other people's?

