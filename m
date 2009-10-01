Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZJAL3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZJAL3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZJAL3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:29:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39191 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbZJAL3a (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 07:29:30 -0400
Message-ID: <4AC492E2.7060205@suse.de>
Date: Thu, 01 Oct 2009 17:00:42 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Rafael Wysocki <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon when
 s_bdev is NULL
References: <4AC1FC41.2060807@suse.de> <Pine.LNX.4.64.0910011052330.7682@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910011052330.7682@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 29 Sep 2009, Suresh Jayaraman wrote:
> 
>> While testing Swap over NFS patchset, I noticed an oops that was triggered
>> during swapon. Investigating further, the NULL pointer deference is due to the
>> SSD device check/optimization in the swapon code that assumes s_bdev could never
>> be NULL.
>>
>> inode->i_sb->s_bdev could be NULL in a few cases. For e.g. one such case is
>> loopback NFS mount, there could be others as well. Fix this by ensuring s_bdev
>> is not NULL before we try to deference s_bdev.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> 
> Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> Thanks a lot for that: sorry to say I was ignorant of the possibility.
> 
> This is only an issue with an out-of-tree patch, is that correct?

Yes, it was reproducible only with an out-of-tree patch.

> I'd like it to be fixed anyway, but if there's a way in which it can
> happen in unpatched 2.6.31, then we ought to send the fix to -stable.
> 
> I've added Rafael to the Cc, because CONFIG_HIBERNATION's swap_type_of()
> looks also dangerous in this respect - and especially where it does that
> "if (bdev == sis->bdev) {" match, I think it's assuming NULL bdev cannot
> match against anything.

Yeah, perhaps. I stumbled upon one more of such error - a NULL pointer
dereference in blkdev_issue_discard() called from get_swap_page() when I ran
memhog, a simple program to generate a memory hog with Swap over NFS patches.

The call sequence is add_to_swap() -> get_swap_page() ->  scan_swap_map()
-> discard_swap_cluster() -> blkdev_issue_discard().

Wrapping the code around a NULL check fixes the Oops for me.


Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 mm/swapfile.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4de7f02..51f39cf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -160,11 +160,13 @@ static int discard_swap(struct swap_info_struct *si)
 				continue;
 		}
 
-		err = blkdev_issue_discard(si->bdev, start_block,
-						nr_blocks, GFP_KERNEL,
-						DISCARD_FL_BARRIER);
-		if (err)
-			break;
+		if (si->bdev) {
+			err = blkdev_issue_discard(si->bdev, start_block,
+					nr_blocks, GFP_KERNEL,
+					DISCARD_FL_BARRIER);
+			if (err)
+				break;
+		}
 
 		cond_resched();
 	}
@@ -200,10 +202,12 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
-			if (blkdev_issue_discard(si->bdev, start_block,
+			if (si->bdev) {
+				if (blkdev_issue_discard(si->bdev, start_block,
 							nr_blocks, GFP_NOIO,
 							DISCARD_FL_BARRIER))
-				break;
+					break;
+			}
 		}
 
 		lh = se->list.next;
