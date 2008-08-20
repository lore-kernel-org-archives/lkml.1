Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYHTQH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYHTQH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYHTQHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:07:48 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:56731 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYHTQHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:07:47 -0400
Message-Id: <200808201613.AA00212@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 21 Aug 2008 01:13:45 +0900
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <20080820004326.519405a2.akpm@linux-foundation.org>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Wed, 20 Aug 2008 11:45:05 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
>
>> This is a kernel patch of NILFS2 file system which was previously
>> announced in [1].  Since the original code did not comply with the
>> Linux Coding Style, I've rewritten it a lot.
>
>I expected this email two years ago :)

I'm sorry for that. Thank you to remember this file system :)

>What approach does it take to garbage collection?

Lifetime information is maintained for each (virtualized) address of disk 
block to judge whether a given disk block is eliminable or not.

The garbage collector (GC) of NILFS2 works as follows:

1. GC does not remove snapshots, which are the checkpoints marked as snapshot.
   Plain checkpoints are not protected from GC except for the recent ones.

2. Disk blocks that do not belong to any snapshots nor the recent checkpoints,
   are eliminable.    For a given disk block, GC confirms state of every
   checkpoints whose serial number is included in the lifetime.  It judges 
   the block is not eliminable if at least one snapshot or a recent checkpoint
   is included.

3. GC reclaims disk space in units of segment. (where a segment is equally 
   divided disk region.)

   For a selected segment, removable blocks are just ignored, and 
   unremovable blocks (live blocks) are copied to a new log appended in the
   current segment for writing.

   When all the live blocks are copied into the new log, the segment becomes
   free and reusable.

4. To make disk blocks relocatable, NILFS2 maintains a table file (called DAT)
   which maps virtual disk blocks addresses to usual block addresses.
   The lifetime information is recorded in the DAT per virtual block address.

The current NILFS2 GC simply reclaims from the oldest segment, so the disk
partition acts like a ring buffer. (this behaviour can be changed by 
replacing userland daemon).

>> Some impressive benchmark results on SSD are shown in [3],
>
>heh.  It wipes the floor with everything, including btrfs.
>
>But a log-based fs will do that, initially.  What will the performace
>look like after a month or two's usage?

I'm using NILFS2 for my home directory for serveral months, but so far
I don't feel notable performance degradation.  Later, I'd like to try
a benchmark for a server.
Anyhow, I have many things to do for performance.

>> however the
>> current NILFS2 performance is sensitive to machine environment due to
>> its immature implementation.
>> .. 
>> It is not yet divided into pieces (sorry).  Unlike original code
>> available at [4], many code lines to support past kernel versions and
>> peculiar debug code are removed in this patch.
>
>Yes, please do that splitup and let's get down to reviewing it.

Sure, I will.

With regards,
Ryusuke Konishi
