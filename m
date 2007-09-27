Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbXI0P6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbXI0P6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXI0P6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:58:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56654 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXI0P63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:58:29 -0400
Subject: Re: lockdep wierdness...
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
In-Reply-To: <20070927140007.GA17543@infradead.org>
References: <1190671658.6700.31.camel@heimdal.trondhjem.org>
	 <20070925021359.GB11809@goodmis.org> <1190901067.31636.6.camel@twins>
	 <20070927140007.GA17543@infradead.org>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 17:58:20 +0200
Message-Id: <1190908700.31636.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 15:00 +0100, Christoph Hellwig wrote:
> On Thu, Sep 27, 2007 at 03:51:07PM +0200, Peter Zijlstra wrote:
> > Christoph,
> > 
> > does Steve's story make sense? 
> 
> Yes.
> 
> > All that would need to be done is add an extra lock_class_key to
> > file_system_type for i_mutex_dir_key, and extend alloc_inode to say
> > something like:
> > 
> >   if (dir)
> >     lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_dir_key);
> >   else
> >     lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
> 
> Unfortunately we don't know what type of inode we have when calling
> alloc_inode.  We only know it after reading in the inode from disk,
> aka in unlock_new_inode.  Then again there is no reason to use
> i_mutex before unlock_new_inode returns, so maybe we could defer
> initializing it until unlock_new_inode.  I'm pretty sure we'll have
> to fix a few filesystems that take i_mutex before that despite not
> needing it, e.g. through i_size_write, though.

How about this:

---
Make a distinction between file and dir usage of i_mutex.

The inode should be complete and unused at unlock_new_inode(), re-init
i_mutex depending on its type.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/inode.c         |   12 ++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 13 insertions(+)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -576,6 +576,18 @@ EXPORT_SYMBOL(new_inode);
 
 void unlock_new_inode(struct inode *inode)
 {
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct file_system_type *type = inode->i_sb->s_type;
+	/*
+	 * ensure nobody is actually holding i_mutex
+	 */
+	mutex_destroy(&inode->i_mutex);
+	mutex_init(&inode->i_mutex);
+	if (inode->i_mode & S_IFDIR)
+		lockdep_set_class(&inode->i_mutex, &type->i_mutex_dir_key);
+	else
+		lockdep_set_class(&inode->i_mutex, &type->i_mutex_key);
+#endif
 	/*
 	 * This is special!  We do not need the spinlock
 	 * when clearing I_LOCK, because we're guaranteed
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1426,6 +1426,7 @@ struct file_system_type {
 
 	struct lock_class_key i_lock_key;
 	struct lock_class_key i_mutex_key;
+	struct lock_class_key i_mutex_dir_key;
 	struct lock_class_key i_alloc_sem_key;
 };
 


