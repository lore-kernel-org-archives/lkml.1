Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAKBBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAKBBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYAKBBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:01:34 -0500
Received: from mail.tmr.com ([64.65.253.246]:42443 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYAKBBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:01:33 -0500
Message-ID: <4786C578.3090302@tmr.com>
Date: Thu, 10 Jan 2008 20:25:12 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
References: <20080109085231.GE6650@kernel.dk>
In-Reply-To: <20080109085231.GE6650@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> loop.c currently uses the page cache interface to do IO to file backed
> devices. This works reasonably well for simple things, like mapping an
> iso9660 file for direct mount and other read-only workloads. Writing is
> somewhat problematic, as anyone who has really used this feature can
> attest to - it tends to confuse the vm (hello kswapd) since it break
> dirty accounting and behaves very erratically on writeout. Did I mention
> that it's pretty slow as well, for both reads and writes?
> 
Since you are looking for comments, I'll mention a loop-related behavior 
I've been seeing and see if it gets comments or is useful, since it can 
be used to tickle bad behavior on demand.

I have an 6GB sparse file, which I mount with cryptoloop and populate as 
an ext3 filesystem (more later on why). I then copy ~5.8GB of data to 
the filesystem, which is unmounted to be burnt to a DVD. Before it's 
burned the "dvdisaster" application is used to add some ECC information 
to the end, and make an image which fits on a DVD-DL. Media will be 
burned and distributed to multiple locations.

The problem:

When copying with rsync, the copy runs at ~25MB/s for a while, then 
falls into a pattern of bursts of 25MB/s followed by 10-15 sec of iowait 
with no disk activity. So I tried doing the copy by cpio
   find . -depth | cpio -pdm /mnt/loop
which shows exactly the same behavior. Then, for no good reason I tried
   find . -depth | cpio -pBdm /mnt/loop
and the copy ran at 25MB/s for the whole data set.

I was able to see similar results with a pure loop mount, I only mention 
the crypto for accuracy. Because many of these have been shipped over 
the last two years and new loop code would only be useful in this case 
if it were compatible so old data sets could be read.

> It also behaves differently than a real drive. For writes, completions
> are done once they hit page cache. Since loop queues bio's async and
> hands them off to a thread, you can have a huge backlog of stuff to do.
> It's hard to attempt to guarentee data safety for file systems on top of
> loop without making it even slower than it currently is.
> 
> Back when loop was only used for iso9660 mounting and other simple
> things, this didn't matter. Now it's often used in xen (and others)
> setups where we do care about performance AND writing. So the below is a
> attempt at speeding up loop and making it behave like a real device.
> It's a somewhat quick hack and is still missing one piece to be
> complete, but I'll throw it out there for people to play with and
> comment on.
> 
> So how does it work? Instead of punting IO to a thread and passing it
> through the page cache, we instead attempt to send the IO directly to the
> filesystem block that it maps to. loop maintains a prio tree of known
> extents in the file (populated lazily on demand, as needed). Advantages
> of this approach:
> 
> - It's fast, loop will basically work at device speed.
> - It's fast, loop it doesn't put a huge amount of system load on the
>   system when busy. When I did comparison tests on my notebook with an
>   external drive, running a simple tiobench on the current in-kernel
>   loop with a sparse file backing rendered the notebook basically
>   unusable while the test was ongoing. The remapper version had no more
>   impact than it did when used directly on the external drive.
> - It behaves like a real block device.
> - It's easy to support IO barriers, which is needed to ensure safety
>   especially in virtualized setups.
> 
> Disadvantages:
> 
> - The file block mappings must not change while loop is using the file.
>   This means that we have to ensure exclusive access to the file and
>   this is the bit that is currently missing in the implementation. It
>   would be nice if we could just do this via open(), ideas welcome...
> - It'll tie down a bit of memory for the prio tree. This is GREATLY
>   offset by the reduced page cache foot print though.
> - It cannot be used with the loop encryption stuff. dm-crypt should be
>   used instead, on top of loop (which, I think, is even the recommended
>   way to do this today, so not a big deal).
> 

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
