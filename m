Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0BPMLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:11:49 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63701 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab0BPMLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:11:47 -0500
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Add flags to __d_path for suppressing suffix andmapping /proc/self
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
	<20100215195553.GW30031@ZenIV.linux.org.uk>
In-Reply-To: <20100215195553.GW30031@ZenIV.linux.org.uk>
Message-Id: <201002162111.AIH87095.OQOMVFtFOHSLJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 16 Feb 2010 21:11:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> > Also, procfs is usually mounted on /proc , but it can be mounted on /proc2 ,
> > /mnt/proc3 or /p . Thus, the caller of __d_path() can't convert /proc/PID to
> > /proc/self from string returned by __d_path() because the caller can't find
> > the mount point of procfs from the returned string. If the caller traverses
> > dentry/vfsmount tree in order to find the mount point of procfs, it results in
> > duplicating __d_path() because the the caller does not use __d_path().
>
> No.  If you don't care which instance it is, you can bloody well check that
> superblock is that of a procfs and track the path to its root *in* *caller*.

I couldn't catch. Are you suggesting that TOMOYO should not call __d_path() for
dentry if dentry->d_sb->s_magic == PROC_SUPER_MAGIC ?

> Instead of calling d_path and looking at vfsmount tree at all.  And you'd
> better do that without assumptions that no name in procfs could be a number
> unrelated to PIDs (i.e. you'd need to check that parent of your candidate
> is root).

I'm doing IS_ROOT(parent) to check that parent of dentry is root.

> BTW, *any* filesystem may be mounted at several places at once.  Moreover,
> different subtrees of the same fs may be found at different mountpoints.

Yes. I know.

> IIRC,
> back when "pathname-based" checks had been discussed, their proponents said
> that they don't care if rules for different instances were inconsistent and
> that it's OK to have them covered sepately, as long as you default to giving
> lower permissions to unrecognized ones.  Why is procfs an exception?

Because procfs redirects /proc/self to /proc/PID using symlink when the
userspace accesses information of current process. This redirection makes it
impossible for name based checks to grant only accessing information of
current process.

What I want to do is to undo this redirection done by procfs. Undoing this
redirection makes it possible for name based checks to grant only accessing
information of current process.

Granting /proc/self/ is more secure than granting /proc/*/ if userspace needs
to access only information of current process.
