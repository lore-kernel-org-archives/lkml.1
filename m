Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbXLRWLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbXLRWLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbXLRWL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:11:28 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54971 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbXLRWL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:11:27 -0500
Date: Tue, 18 Dec 2007 22:10:34 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] unionfs: work better with tmpfs
Message-ID: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a few patches to unionfs, which together with the tmpfs
patches I just posted, get that combination working better.

 fs/stack.c         |    6 +++
 fs/unionfs/inode.c |   83 +++++++++++++++++++++----------------------
 fs/unionfs/mmap.c  |    3 -
 3 files changed, 47 insertions(+), 45 deletions(-)

But on the way I've noticed a number of issues with unionfs not dealt
with in these patches.

1. Please try unionfs with lockdep configured on (perhaps while running LTP
to get coverage of a variety of cases): I soon gave up, not knowing which
way round the locks should really be taken e.g. unionfs_read_lock versus
unionfs_lock_dentry.

2. I'm worried about the locking generally (no doubt it's difficult!).
My 2/4 patch half-fixes one issue, but raises others: if some function
in a filesystem is usually called with i_mutex held, are you safe to be
calling it (not knowing that lower filesystem) without its i_mutex held?

3. LTP's rename14 tends to fill the filesystem with inodes, which prevent
further tests from running (but not on all machines: a timing issue perhaps).
I have to run LTP with rename14 moved aside.

4. Though you made improvements, some blocks still remain mysteriously
allocated even after the unionfs should be empty e.g. after an LTP run.

Hugh
