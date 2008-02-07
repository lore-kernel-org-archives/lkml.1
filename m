Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYBGK2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYBGK2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYBGK2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:28:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39507 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYBGK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:28:34 -0500
Date: Thu, 7 Feb 2008 11:28:15 +0100
From: Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
Message-ID: <20080207102815.GB26403@atrey.karlin.mff.cuni.cz>
References: <47A9F495.8060400@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A9F495.8060400@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For a long time I'm bitten by a bad interaction
> of mount -o remount,ro and quota operations.
> 
> The sequence is as follows:
> 
>  mount /fs
>  quotaon -ug /fs
>  mount -o remount,ro /fs
>  umount /fs
> 
> At this point, umount never returns.  /proc/$pid/wchan
> shows vfs_quota_off:
> 
> Feb  6 20:53:25 linux kernel: umount        D e5183eb8     0  8646      1
> Feb  6 20:53:25 linux kernel:        e5183ecc 00000086 00000002 e5183eb8 e5183eb0 00000000 c1db2540 c1db2684
> Feb  6 20:53:25 linux kernel:        c1db2684 c1c0dd00 00000000 cfd9f1c0 c0367080 c0367080 f5849000 f7f06880
> Feb  6 20:53:25 linux kernel:        f7e89d80 00000000 c0367080 b7c9795c 005f3997 00000000 000000ff 00000000
> Feb  6 20:53:25 linux kernel: Call Trace:
> Feb  6 20:53:25 linux kernel:  [<c01a2a65>] vfs_quota_off+0x345/0x490
> Feb  6 20:53:25 linux kernel:  [<c013a3a0>] autoremove_wake_function+0x0/0x50
> Feb  6 20:53:25 linux kernel:  [<c0174bf6>] deactivate_super+0x46/0x80
> Feb  6 20:53:25 linux kernel:  [<c0188bba>] sys_umount+0x4a/0x240
> Feb  6 20:53:25 linux kernel:  [<c017637f>] sys_stat64+0xf/0x30
> Feb  6 20:53:25 linux kernel:  [<c0162069>] remove_vma+0x39/0x50
> Feb  6 20:53:25 linux kernel:  [<c0162b67>] do_munmap+0x197/0x1f0
> Feb  6 20:53:25 linux kernel:  [<c0188dc5>] sys_oldumount+0x15/0x20
> Feb  6 20:53:25 linux kernel:  [<c010417e>] sysenter_past_esp+0x5f/0x85
> 
> The filesystem is ext3.  The issue is here for a long time,
> at least since before 2.6.20, and is still present in 2.6.23
> (I'll try 2.6.24 later today).
> 
> Can it be fixed please? :)
  Of course, thanks for report :). The problem is we allow remounting
read only which we should refuse when quota is enabled. I'll fix that in
a minute.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
