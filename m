Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZEVBXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZEVBXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZEVBX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:23:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34736 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbZEVBX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:23:28 -0400
Date: Fri, 22 May 2009 11:23:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the vfs tree with the  tree
Message-Id: <20090522112326.9eafa340.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/reiserfs/super.c between commit
d38705358bf6f5ab82348d0c6ee8039cea20ce6b ("reiserfs: kill-the-BKL") from
the reiserfs-bkl tree and commit 8123178eb9ca12cde31a95170746e15a79528a62
("push BKL down into ->put_super") from the vfs tree.

OK, I am not sure what is needed here, so I combined both (see below).  I
can carry this fixup as necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/reiserfs/super.c
index b301f7d,90dcb7b..0000000
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@@ -468,13 -465,11 +465,18 @@@ static void reiserfs_put_super(struct s
  	struct reiserfs_transaction_handle th;
  	th.t_trans_id = 0;
  
+ 	lock_kernel();
+ 
 +	/*
 +	 * We didn't need to explicitly lock here before, because put_super
 +	 * is called with the bkl held.
 +	 * Now that we have our own lock, we must explicitly lock.
 +	 */
 +	reiserfs_write_lock(s);
 +
+ 	if (s->s_dirt)
+ 		reiserfs_write_super(s);
+ 
  	/* change file system state to current state if it was mounted with read-write permissions */
  	if (!(s->s_flags & MS_RDONLY)) {
  		if (!journal_begin(&th, s, 10)) {
