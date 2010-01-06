Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691Ab0AFJbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0AFJbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626Ab0AFJbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:31:46 -0500
Received: from daytona.panasas.com ([67.152.220.89]:41408 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755493Ab0AFJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:31:44 -0500
Message-ID: <4B44587D.30503@panasas.com>
Date: Wed, 06 Jan 2010 11:31:41 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Subject: [GIT PULL] exofs fixes for 2.6.33-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2010 09:31:43.0061 (UTC) FILETIME=[0EB67850:01CA8EB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull:
	git://git.open-osd.org/linux-open-osd.git for-linus

To receive the following two fixes for the 2.6.33 Kernel.

 . The first problem was found when integrating pnfs-tree with 2.6.33-rc1
 . The second problem was found by running a git-clone of a very large Linux tree
   on a memory tight system, with these new very large pack files of recent. Actually
   I think only git clone is able to produce a workload to exercise this bug.
   (up until now git has found 85% of my bugs it's my number one test. Other 15% is
    compilation of a kernel, all the synthetic tests are good for nothing)

commit 89be503021f550575fc896671b569941140b2c2e
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Mon Dec 21 16:36:23 2009 +0200

    exofs: fix pnfs_osd re-definitions in pre-pnfs trees
    
    Some on disk exofs constants and types are defined in the pnfs_osd_xdr.h
    file. Since we needed these types before the pnfs-objects code was
    accepted to mainline we duplicated the minimal needed definitions into
    an exofs local header. The definitions where conditionally included
    depending on !CONFIG_PNFS defined. So if PNFS was present in the tree
    definitions are taken from there and if not they are defined locally.
    
    That was all good but, the CONFIG_PNFS is planed to be included upstream
    before the pnfs-objects is also included. (The first pnfs batch might be
    pnfs-files only)
    
    So condition exofs local definitions on the absence of pnfs_osd_xdr.h
    inclusion (__PNFS_OSD_XDR_H__ not defined). User code must make sure
    that in future pnfs_osd_xdr.h will be included before fs/exofs/pnfs.h,
    which happens to be so in current code.
    
    Once pnfs-objects hits mainline, exofs's local header will be removed.
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

 fs/exofs/pnfs.h |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

commit efd124b999fb4d426b30675f1684521af0872789
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Sun Dec 27 17:01:42 2009 +0200

    exofs: simple_write_end does not mark_inode_dirty
    
    exofs uses simple_write_end() for it's .write_end handler. But
    it is not enough because simple_write_end() does not call
    mark_inode_dirty() when it extends i_size. So even if we do
    call mark_inode_dirty at beginning of write out, with a very
    long IO and a saturated system we might get the .write_inode()
    called while still extend-writing to file and miss out on the last
    i_size updates.
    
    So override .write_end, call simple_write_end(), and afterwords if
    i_size was changed call mark_inode_dirty().
    
    It stands to logic that since simple_write_end() was the one extending
    i_size it should also call mark_inode_dirty(). But it looks like all
    users of simple_write_end() are memory-bound pseudo filesystems, who
    could careless about mark_inode_dirty(). I might submit a
    warning-comment patch to simple_write_end() in future.
    
    CC: Stable <stable@kernel.org>
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

 fs/exofs/inode.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

Thanks in advance
Boaz
