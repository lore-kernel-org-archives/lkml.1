Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbXFBFoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbXFBFoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 01:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXFBFnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 01:43:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376AbXFBFnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 01:43:52 -0400
Date: Fri, 1 Jun 2007 22:43:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-Id: <20070601224339.c803e04e.akpm@linux-foundation.org>
In-Reply-To: <4660FD7F.4090302@sandeen.net>
References: <20070524165935.GB19709@duck.suse.cz>
	<20070524170554.GC19709@duck.suse.cz>
	<20070524203653.GA7693@duck.suse.cz>
	<465DF0B4.2050203@sandeen.net>
	<20070601211036.GA23975@duck.suse.cz>
	<46609FBD.5040407@sandeen.net>
	<20070601154834.53558d1b.akpm@linux-foundation.org>
	<4660FD7F.4090302@sandeen.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Jun 2007 00:17:51 -0500 Eric Sandeen <sandeen@sandeen.net> wrote:

> Andrew Morton wrote:
> > On Fri, 01 Jun 2007 17:37:49 -0500
> > Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> >> going for the inode_lock twice?
> >>
> > 
> > lockdep should catch that.
> > 
> 
> hey that's a good idea...!  *sigh* sometimes I worry about myself... but 
> hey at least I got it right. :)
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.22-rc3 #8
> ---------------------------------------------
> lt-fsstress/3285 is trying to acquire lock:
>   (inode_lock){--..}, at: [<ffffffff802b0de9>] __mark_inode_dirty+0xe2/0x16c
> 
> but task is already holding lock:
>   (inode_lock){--..}, at: [<ffffffff80316cc9>] 
> _atomic_dec_and_lock+0x39/0x58
> 
> other info that might help us debug this:
> 3 locks held by lt-fsstress/3285:
>   #0:  (&inode->i_mutex/1){--..}, at: [<ffffffff8029f262>] 
> do_rmdir+0x7c/0xe3
>   #1:  (&inode->i_mutex){--..}, at: [<ffffffff80462809>] 
> mutex_lock+0x22/0x24
>   #2:  (inode_lock){--..}, at: [<ffffffff80316cc9>] 
> _atomic_dec_and_lock+0x39/0x58
> 
> stack backtrace:
> 
> Call Trace:
>   [<ffffffff8024e1fc>] __lock_acquire+0x155/0xbaa
>   [<ffffffff802b0de9>] __mark_inode_dirty+0xe2/0x16c
>   [<ffffffff8024eccc>] lock_acquire+0x7b/0x9f
>   [<ffffffff802b0de9>] __mark_inode_dirty+0xe2/0x16c
>   [<ffffffff80463bc9>] _spin_lock+0x1e/0x28
>   [<ffffffff802b0de9>] __mark_inode_dirty+0xe2/0x16c
>   [<ffffffff882dc7cc>] :udf:udf_write_aext+0x101/0x11b
>   [<ffffffff882e5992>] :udf:extent_trunc+0xd6/0x123
>   [<ffffffff882e5ab9>] :udf:udf_truncate_tail_extent+0xda/0x171
>   [<ffffffff882dfc5e>] :udf:udf_drop_inode+0x26/0x35
>   [<ffffffff802a726d>] iput+0x74/0x76
>   [<ffffffff802a4e9b>] dentry_iput+0xa0/0xb8
>   [<ffffffff802a612a>] prune_dcache+0xa2/0x174
>   [<ffffffff802a4f3c>] d_kill+0x21/0x43
>   [<ffffffff802a5eef>] prune_one_dentry+0x3a/0xef
>   [<ffffffff802a6175>] prune_dcache+0xed/0x174
>   [<ffffffff802a6253>] shrink_dcache_parent+0x21/0x10e
>   [<ffffffff8029becd>] dentry_unhash+0x26/0x84
>   [<ffffffff8029d23c>] vfs_rmdir+0x88/0x117
>   [<ffffffff8029f287>] do_rmdir+0xa1/0xe3
>   [<ffffffff8020cf4b>] syscall_trace_enter+0x8d/0x8f
>   [<ffffffff8029f300>] sys_rmdir+0x11/0x13
>   [<ffffffff80209da5>] tracesys+0xdc/0xe1
> 

Well.  Documentation/filesystems/Locking says

drop_inode:             no                              !!!inode_lock!!!

That patch is DOA, methinks.

