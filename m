Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXLRWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXLRWOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbXLRWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:14:10 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60869 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbXLRWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:14:09 -0500
Date: Tue, 18 Dec 2007 22:13:25 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] unionfs: 32-bit needs lock for i_size
In-Reply-To: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182212430.28390@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTP's iogen01 doio tests hang nicely on 32-bit SMP when /tmp is a unionfs
mount of a tmpfs.  See the comment on i_size_write in linux/fs.h: it needs
to be locked, otherwise i_size_read can spin forever waiting for a lost
seqcount update.

Most filesystems are already holding i_mutex for this, but unionfs calls
fsstack_copy_inode_size from many places, not necessarily holding i_mutex.
Use the low-level i_lock within fsstack_copy_inode_size when 32-bit SMP.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
This works for me, to help get through LTP, but is not enough: what about
those places which use i_size_write in common code called by unionfs?
They ought to participate in this i_locking too.  Needs an audit to
enumerate such places and decide what course to take.

Bigger question: is unionfs calling down to filesystems without holding
their i_mutex, where some may be relying on their i_mutex to be held?

 fs/stack.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- 2.6.24-rc5-mm1/fs/stack.c	2007-12-05 10:38:38.000000000 +0000
+++ unionfs2/fs/stack.c	2007-12-05 16:50:15.000000000 +0000
@@ -21,8 +21,14 @@
  */
 void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 {
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_lock(&dst->i_lock);
+#endif
 	i_size_write(dst, i_size_read((struct inode *)src));
 	dst->i_blocks = src->i_blocks;
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_unlock(&dst->i_lock);
+#endif
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
