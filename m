Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXIYCP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXIYCP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 22:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbXIYCPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 22:15:50 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:48422 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbXIYCPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 22:15:49 -0400
Date: Mon, 24 Sep 2007 22:13:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: lockdep wierdness...
Message-ID: <20070925021359.GB11809@goodmis.org>
References: <1190671658.6700.31.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190671658.6700.31.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 06:07:38PM -0400, Trond Myklebust wrote:
> I'm seeing lockdep warning about a potential lock inversion between
> &mm->mmap_sem and &inode->i_mutex in NFS (see attachment).
> 
> Unfortunately the basis for the warning appears to be the behaviour in
> ext3(???). AFAICS there is no way for NFS to share an inode->i_mutex
> with ext3. What to do?

Actually this can probably happen just on NFS alone.

> 
> Trond

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.23-rc7-g8809e921 #1
> -------------------------------------------------------
> beagle-build-in/24375 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<c05a2887>] do_page_fault+0x17d/0x591
> 
> but task is already holding lock:
>  (&inode->i_mutex){--..}, at: [<c059f9e3>] mutex_lock+0x1c/0x1f
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&inode->i_mutex){--..}:
>        [<c043d4da>] __lock_acquire+0x9f3/0xba6
>        [<c043da62>] lock_acquire+0x5f/0x78
>        [<c059f832>] __mutex_lock_slowpath+0xe5/0x27a
>        [<c059f9e3>] mutex_lock+0x1c/0x1f
>        [<f8c92495>] nfs_revalidate_mapping+0x64/0x9c [nfs]
>        [<f8c8ff2a>] nfs_file_mmap+0x46/0x75 [nfs]
>        [<c046097c>] mmap_region+0x1ea/0x3b8
>        [<c0460e9b>] do_mmap_pgoff+0x27b/0x2da
>        [<c0407d77>] sys_mmap2+0x9b/0xb5
>        [<c040405e>] sysenter_past_esp+0x5f/0x99
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&mm->mmap_sem){----}:
>        [<c043d3c6>] __lock_acquire+0x8df/0xba6
>        [<c043da62>] lock_acquire+0x5f/0x78
>        [<c04360db>] down_read+0x3a/0x4c
>        [<c05a2887>] do_page_fault+0x17d/0x591
>        [<c05a1382>] error_code+0x72/0x78
>        [<f88acaac>] call_filldir+0xac/0xc3 [ext3]
>        [<f88acdb2>] ext3_readdir+0x217/0x5e5 [ext3]
>        [<c04798a1>] vfs_readdir+0x67/0x93
>        [<c0479af6>] sys_getdents+0x5f/0x9d
>        [<c040405e>] sysenter_past_esp+0x5f/0x99
>        [<ffffffff>] 0xffffffff

The circular lock seems to be this:

#1:

  sys_mmap2:              down_write(&mm->mmap_sem);
  nfs_revalidate_mapping: mutex_lock(&inode->i_mutex);


#0:

  vfs_readdir:     mutex_lock(&inode->i_mutex);
   - during the readdir (filldir64), we take a user fault (missing page?)
    and call do_page_fault -
  do_page_fault:   down_read(&mm->mmap_sem);


So it does indeed look like a circular locking. Now the question is, "is
this a bug?".  Looking like the inode of #1 must be a file or something
else that you can mmap and the inode of #0 seems it must be a directory.
I would say "no".

Now if you can readdir on a file or mmap a directory, then this could be
an issue.

Otherwise, I'd love to see someone teach lockdep about this issue! ;-)

-- Steve


