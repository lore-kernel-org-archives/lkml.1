Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYKWEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYKWEqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 23:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYKWEqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 23:46:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbYKWEqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 23:46:07 -0500
Message-ID: <4928E010.4090801@kernel.org>
Date: Sun, 23 Nov 2008 13:46:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com, Jens Axboe <jens.axboe@oracle.com>
Subject: about TRIM/DISCARD support and barriers
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Nov 2008 04:45:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

Dongjun Shin who works for Samsung SSD dep asked me about libata TRIM
support and pointed me to the new DISCARD support David Woodhouse got
merged for 2.6.28.  I took a look at the code and blk-layer
interface-wise we seemed to be ready both for filesystems and userland
(so that fsck or something which runs background can mark unused
blocks) but there doesn't seem to be any low level driver which
actually implements ->prepare_discard_fn or fs which sets the DISCARD
flag.

Adding ->prepare_discard_fn wouldn't be difficult at all but I became
curious about a few things after looking at the DISCARD interface.
First of all - how to avoid racing aginst reusing and how to schedule
DISCARDs.

* There are two variants of DISCARD - DISCARD w/o barrier and DISCARD
  w/ barrier, if a fs uses the former, it would need to make sure that
  it the DISCARD finishes before re-using the block.  Block layer will
  make sure order will be kept for the latter but depending on how
  often those DICARDs are issued it can disrupt IO scheduling.

* It looks like non-barrier DISCARD will be put into the IO sched and
  scheduled the same way as regular IOs.  I don't relly think this is
  necessary or a good idea.  DISCARDs probably don't need any kind of
  sorting anyway and it's likely to disrupt IO sched heuristics.
  Also, DISCARDs can be postponed w/o affecting correct operation.
  However, DISCARDs are not likely to take a long time and we might
  not have to worry about it too much unless it starves regular IOs.

With the above three points, I think it might be better to make block
layer manage and order DISCARD requests than putting it onto the
filesystem or barrier mechanism.  If block layer manages map of
pending DISCARDs and FSes just tell block layer newly freed blocks,
block layer can schedule DISCARDs as it sees fit and cancels pending
ones if IO access to it occurs before the DISCARD is issued to the
drive.  This way, adding DISCARD support to FSes become much easier -
it can just put blk_discard(lba, range) where it's discarding blocks
and don't have to worry about ordering or error handling.

What do you think?

Also, I have a question regarding the current barrier implementation.
When I asked it to Chris Mason some time ago, I was told that btrfs
doesn't really make use of barrier in that btrfs itself waits for the
barrier to complete before proceeding.  I've been thinking about
colored barrier implementation because I heard that the current
barrier ordering is too crude or heavy handed.  But, then again, if
the filesystem waits for requests to complete itself and those
dependent requests are marked SYNC as necessary so that they don't get
postponed too much, all that's needed is flush cache.  Doing it that
way will add a bit of latency but as long as things can progress in
parallel, it will probably perform better than the current barrier.

After all, it's not like we have selective FLUSH on actual devices
anyway.  Where the selective barriering can make difference is how
it's handled in the IO scheduler and FS waiting for requests to finish
and then issuing barrier achieves that quite alright and communicating
the partitial ordering of requests to block layer wouldn't be much
simpler than doing it in FS proper and there's also the problem of how
to communicate or handle when one of the request in the partial
ordering fails.  So, would selective / more intelligent barrier be
beneficial to filesystems or is the way things are just fine?

Thanks.

-- 
tejun
