Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbXKSNSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbXKSNSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXKSNSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:18:33 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62750 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbXKSNSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:18:32 -0500
To: hch@infradead.org, trond.myklebust@fys.uio.no
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFS helper functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<20071116173524.195366292@I-love.SAKURA.ne.jp>
	<1195235255.7653.69.camel@heimdal.trondhjem.org>
	<20071119125334.GC15942@infradead.org>
In-Reply-To: <20071119125334.GC15942@infradead.org>
Message-Id: <200711192218.GGB69793.VOQtMLFFOSHOJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 19 Nov 2007 22:18:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christoph Hellwig wrote:
> > NACK to this. Passing function parameters through the task_struct is
> > definitely not an acceptable hack
> Exactly.  Having a vfsmount other than the current processes root or
> current working directory in task_struct doesn't make any sense.
The process's root and cwd vfsmounts are used permanently, but
this last_vfsmount passed via task_struct behaves like temporary variable
pushed on stack memory.
In other words, last_vfsmount becomes NULL when it becomes invalid.

| static inline int vfs_create2(struct inode *dir, struct dentry *dentry,
| 			      int mode, struct nameidata *nd)
| {
| 	int ret;
| 	struct vfsmount *mnt = nd ? nd->path.mnt : NULL;
| 	struct task_struct *task = current;
| 	struct vfsmount *prev_mnt = task->last_vfsmount;
| 	task->last_vfsmount = mntget(mnt);
| 	ret = vfs_create(dir, dentry, mode, nd);
| 	task->last_vfsmount = prev_mnt;
| 	mntput(mnt);
| 	return ret;
| }

I agree that keeping last_vfsmount after it lost it's reference count is bad, but
I don't understand why keeping last_vfsmount while it has it's reference count is bad too.

Regards.

