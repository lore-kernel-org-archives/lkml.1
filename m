Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXCTGqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXCTGqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXCTGqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:46:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56046 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932224AbXCTGqt (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:46:49 -0400
Date: Tue, 20 Mar 2007 17:46:32 +1100
From: David Chinner <dgc@sgi.com>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Message-ID: <20070320064632.GO32602149@melbourne.sgi.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 11:32:27AM +0100, Marco Berizzi wrote:
> Marco Berizzi wrote:
> > David Chinner wrote:
> >
> >> Ok, so an ipsec change. And I see from the history below it
> >> really has nothing to do with this problem. it seems the problem
> >> has something to do with changes between 2.6.19.1 and 2.6.19.2.
> >
> > indeed. Yesterday at 13:00 I have switched from 2.6.19.1 to 2.6.19.2
> > (without the ipsec fix) and at about 17:30 linux has crashed again.
> > I have recompiled 2.6.19.2 with all kernel debugging options enabled
> > and rebooted. Now I'm waiting for the crash...
> 
> Linux has not been crashed. However here is dmesg output
> with all debugging option enabled: (search for 'INFO:
> possible recursive locking detected'). Is that normal?

.....
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.19.2 #1
> ---------------------------------------------
> rm/470 is trying to acquire lock:
>  (&(&ip->i_lock)->mr_lock){----}, at: [<c01cd64a>] xfs_ilock+0x5b/0xa1
> 
> but task is already holding lock:
>  (&(&ip->i_lock)->mr_lock){----}, at: [<c01cd64a>] xfs_ilock+0x5b/0xa1
> 
> other info that might help us debug this:
> 3 locks held by rm/470:
>  #0:  (&inode->i_mutex/1){--..}, at: [<c016e5a7>] do_unlinkat+0x70/0x115
>  #1:  (&inode->i_mutex){--..}, at: [<c030be35>] mutex_lock+0x1c/0x1f
>  #2:  (&(&ip->i_lock)->mr_lock){----}, at: [<c01cd64a>]
> xfs_ilock+0x5b/0xa1
> 
> stack backtrace:
>  [<c0103bc0>] dump_trace+0x215/0x21a
>  [<c0103c68>] show_trace_log_lvl+0x1a/0x30
>  [<c0103c90>] show_trace+0x12/0x14
>  [<c0103d8d>] dump_stack+0x19/0x1b
>  [<c01357e7>] print_deadlock_bug+0xc0/0xcf
>  [<c0135860>] check_deadlock+0x6a/0x79
>  [<c01372e1>] __lock_acquire+0x350/0x970
>  [<c0137fd1>] lock_acquire+0x75/0x97
>  [<c01331ab>] down_write+0x3a/0x54
>  [<c01cd64a>] xfs_ilock+0x5b/0xa1
>  [<c01eda0e>] xfs_lock_dir_and_entry+0x105/0x11b
>  [<c01edcc5>] xfs_remove+0x180/0x47f
>  [<c01f8a9e>] xfs_vn_unlink+0x22/0x4f
>  [<c016e533>] vfs_unlink+0x9e/0xa2
>  [<c016e5df>] do_unlinkat+0xa8/0x115
>  [<c016e68b>] sys_unlink+0x10/0x12
>  [<c0102cdb>] syscall_call+0x7/0xb
>  [<b7efaa7d>] 0xb7efaa7d
>  =======================

That's no problem - lockdep just doesn't know that we can nest i_lock
(we've got to get the annotations for this sorted out).

> Here is the relevant results:
> 
> Phase 2 - found root inode chunk
> Phase 3 - ...
>             agno = 0
>             ...
>             agno = 12
> LEAFN node level is 1 inode 1610612918 bno = 8388608

Hmmm - single bit error in the bno - that reminds of this:

http://oss.sgi.com/projects/xfs/faq.html#dir2

So I'd definitely make sure that is repaired....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
