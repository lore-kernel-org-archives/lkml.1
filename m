Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0BOTz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:55:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39845 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0BOTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:55:55 -0500
Date: Mon, 15 Feb 2010 19:55:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Add flags to __d_path for suppressing suffix and
 mapping /proc/self
Message-ID: <20100215195553.GW30031@ZenIV.linux.org.uk>
References: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:11:37PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I'd like to propose this patch.
> 
> TOMOYO and AppArmor are bothered by " (deleted)" suffix added by __d_path().
> 
> Also, converting /proc/PID to /proc/self makes it possible for TOMOYO to grant
> read access for only self process's information. It would be also useful for
> other users when auditing pathnames like /proc/self/mounts . In that case,
> flags (added by this patch) should be passed to d_path() as well.
> 
> I wrote reason why I can't do it outside __d_path(). If modifying __d_path() is
> not acceptable, I beg your permission for putting similar code to
> security/tomoyo/ directory.

This is crap.  Taking the handling of "(deleted)" into [some] callers is OK,
but we need to look at the callers and see which ones want it.  /proc/self
thing is just plain wrong.

> Also, procfs is usually mounted on /proc , but it can be mounted on /proc2 ,
> /mnt/proc3 or /p . Thus, the caller of __d_path() can't convert /proc/PID to
> /proc/self from string returned by __d_path() because the caller can't find
> the mount point of procfs from the returned string. If the caller traverses
> dentry/vfsmount tree in order to find the mount point of procfs, it results in
> duplicating __d_path() because the the caller does not use __d_path().

No.  If you don't care which instance it is, you can bloody well check that
superblock is that of a procfs and track the path to its root *in* *caller*.
Instead of calling d_path and looking at vfsmount tree at all.  And you'd
better do that without assumptions that no name in procfs could be a number
unrelated to PIDs (i.e. you'd need to check that parent of your candidate
is root).

BTW, *any* filesystem may be mounted at several places at once.  Moreover,
different subtrees of the same fs may be found at different mountpoints.  IIRC,
back when "pathname-based" checks had been discussed, their proponents said
that they don't care if rules for different instances were inconsistent and
that it's OK to have them covered sepately, as long as you default to giving
lower permissions to unrecognized ones.  Why is procfs an exception?
