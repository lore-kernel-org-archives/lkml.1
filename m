Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZAEWZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZAEWZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZAEWY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:24:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZAEWY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:24:59 -0500
Date: Mon, 5 Jan 2009 14:24:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, dedekind@infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: mmotm 2009-01-05-12-50 uploaded (ubifs)
Message-Id: <20090105142437.9406c375.akpm@linux-foundation.org>
In-Reply-To: <49628515.7010609@oracle.com>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
	<49628515.7010609@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 14:09:25 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-01-05-12-50 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> mmotm-2009-0105-1250/fs/ubifs/super.c:435: error: 'WB_SYNC_HOLD' undeclared (first use in this function)
> 

It's amazing how much shiny new code turns up during the merge window
and screws things up.


commit 304d427cd99eb645b44b08d77e70ce308e6bcd8c
Author:     Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
AuthorDate: Sun Dec 28 08:04:17 2008 +0200
Commit:     Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CommitDate: Wed Dec 31 14:13:24 2008 +0200

    UBIFS: fix file-system synchronization
    
    Argh. The ->sync_fs call is called _before_ all inodes are flushed.
    This means we first sync write buffers and commit, then all
    inodes are synced, and we end up with unflushed write buffers!
    
    Fix this by forcing synching all indoes from 'ubifs_sync_fs()'.
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1309783..4713017 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -35,6 +35,7 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/math64.h>
+#include <linux/writeback.h>
 #include "ubifs.h"
 
 /*
@@ -431,6 +432,23 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
 	struct ubifs_info *c = sb->s_fs_info;
 	int i, ret = 0, err;
 	long long bud_bytes;
+	struct writeback_control wbc = {
+		.sync_mode   = wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
+		.range_start = 0,
+		.range_end   = LLONG_MAX,
+		.nr_to_write = LONG_MAX,
+	};
+
+	/*
+	 * VFS calls '->sync_fs()' before synchronizing all dirty inodes and
+	 * pages, so synchronize them first, then commit the journal. Strictly
+	 * speaking, it is not necessary to commit the journal here,
+	 * synchronizing write-buffers would be enough. But committing makes
+	 * UBIFS free space predictions much more accurate, so we want to let
+	 * the user be able to get more accurate results of 'statfs()' after
+	 * they synchronize the file system.
+	 */
+	generic_sync_sb_inodes(sb, &wbc);
 
 	if (c->jheads) {
 		for (i = 0; i < c->jhead_cnt; i++) {


WB_SYNC_HOLD got removed by
http://userweb.kernel.org/~akpm/mmotm/broken-out/fs-remove-wb_sync_hold.patch

I think I'll just switch that to WB_SYNC_NONE.  The `wait==0' mode is
just an advisory thing to help the fs shove lots of data into the
queues.  If some gets missed then it'll be picked up on the second
->sync_fs call, with wait==1.



