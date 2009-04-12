Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZDLUek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZDLUek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 16:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZDLUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 16:34:31 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35425 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZDLUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 16:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VEXTxkN5qDaq/9sNoBFH4Df+A+gqDogQPP6T3h2wwqqDn+QEvrPmLEeDxpndKLhPAc
         c4PsZql7ZEDFF+S85/Yw6BbqB6vVRAF4/AhjGW23ot/lmyf4Cf8sgk4OvJQIFJgkkIED
         hvJsEn8bpJedBinBdpykA5zIO/CrHYLaPXJbE=
MIME-Version: 1.0
In-Reply-To: <20090412135912.GA5246@elte.hu>
References: <1239381281-11282-1-git-send-email-abogani@texware.it>
	 <20090410182936.GA6018@nowhere>
	 <63a49ef40904101350y68e93b85tad7d355868de9a38@mail.gmail.com>
	 <20090412135912.GA5246@elte.hu>
Date: Sun, 12 Apr 2009 22:34:28 +0200
X-Google-Sender-Auth: 211a67a565add67f
Message-ID: <63a49ef40904121334p6cd3179ag2a173665f2986ccb@mail.gmail.com>
Subject: Re: [PATCH] remove the BKL: remove "BKL auto-drop" assumption from 
	nfs3_rpc_wrapper()
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir Molnar,

2009/4/12 Ingo Molnar <mingo@elte.hu>:
[...]
>> Unfortunately no. That lockdep message still happens when I
>> unmount rpc_pipefs. I'll investigate further.
>
> might make sense to post that message here out in the open - maybe
> someone with a strong NFSd-fu will comment on it.

This message appear when I unmount rpc_pipefs(/var/lib/nfs/rpc_pipefs)
or nfsd (/proc/fs/nfsd):

[  130.094907] =======================================================
[  130.096071] [ INFO: possible circular locking dependency detected ]
[  130.096071] 2.6.30-rc1-nobkl #39
[  130.096071] -------------------------------------------------------
[  130.096071] umount/2883 is trying to acquire lock:
[  130.096071]  (kernel_mutex){+.+.+.}, at: [<ffffffff80748074>]
lock_kernel+0x34/0x43
[  130.096071]
[  130.096071] but task is already holding lock:
[  130.096071]  (&type->s_lock_key#8){+.+...}, at:
[<ffffffff803196ce>] lock_super+0x2e/0x30
[  130.096071]
[  130.096071] which lock already depends on the new lock.
[  130.096071]
[  130.096071]
[  130.096071] the existing dependency chain (in reverse order) is:
[  130.096071]
[  130.096071] -> #2 (&type->s_lock_key#8){+.+...}:
[  130.096071]        [<ffffffff802891cc>] __lock_acquire+0xf9c/0x13e0
[  130.096071]        [<ffffffff8028972f>] lock_acquire+0x11f/0x170
[  130.096071]        [<ffffffff8074534e>] __mutex_lock_common+0x5e/0x510
[  130.096071]        [<ffffffff807458df>] mutex_lock_nested+0x3f/0x50
[  130.096071]        [<ffffffff803196ce>] lock_super+0x2e/0x30
[  130.096071]        [<ffffffff80319b8d>] __fsync_super+0x2d/0x90
[  130.096071]        [<ffffffff80319c06>] fsync_super+0x16/0x30
[  130.096071]        [<ffffffff80319c61>] do_remount_sb+0x41/0x280
[  130.096071]        [<ffffffff8031ad1b>] get_sb_single+0x6b/0xe0
[  130.096071]        [<ffffffffa00c3bdb>] nfsd_get_sb+0x1b/0x20 [nfsd]
[  130.096071]        [<ffffffff8031a521>] vfs_kern_mount+0x81/0x180
[  130.096071]        [<ffffffff8031a693>] do_kern_mount+0x53/0x110
[  130.096071]        [<ffffffff8033504a>] do_mount+0x6ba/0x910
[  130.096071]        [<ffffffff80335360>] sys_mount+0xc0/0xf0
[  130.096071]        [<ffffffff80213232>] system_call_fastpath+0x16/0x1b
[  130.096071]        [<ffffffffffffffff>] 0xffffffffffffffff
[  130.096071]
[  130.096071] -> #1 (&type->s_umount_key#34/1){+.+.+.}:
[  130.096071]        [<ffffffff802891cc>] __lock_acquire+0xf9c/0x13e0
[  130.096071]        [<ffffffff8028972f>] lock_acquire+0x11f/0x170
[  130.096071]        [<ffffffff80277702>] down_write_nested+0x52/0x90
[  130.096071]        [<ffffffff8031a99b>] sget+0x24b/0x560
[  130.096071]        [<ffffffff8031acf3>] get_sb_single+0x43/0xe0
[  130.096071]        [<ffffffffa00c3bdb>] nfsd_get_sb+0x1b/0x20 [nfsd]
[  130.096071]        [<ffffffff8031a521>] vfs_kern_mount+0x81/0x180
[  130.096071]        [<ffffffff8031a693>] do_kern_mount+0x53/0x110
[  130.096071]        [<ffffffff8033504a>] do_mount+0x6ba/0x910
[  130.096071]        [<ffffffff80335360>] sys_mount+0xc0/0xf0
[  130.096071]        [<ffffffff80213232>] system_call_fastpath+0x16/0x1b
[  130.096071]        [<ffffffffffffffff>] 0xffffffffffffffff
[  130.096071]
[  130.096071] -> #0 (kernel_mutex){+.+.+.}:
[  130.096071]        [<ffffffff802892ad>] __lock_acquire+0x107d/0x13e0
[  130.096071]        [<ffffffff8028972f>] lock_acquire+0x11f/0x170
[  130.096071]        [<ffffffff8074534e>] __mutex_lock_common+0x5e/0x510
[  130.096071]        [<ffffffff807458df>] mutex_lock_nested+0x3f/0x50
[  130.096071]        [<ffffffff80748074>] lock_kernel+0x34/0x43
[  130.096071]        [<ffffffff80319ef4>] generic_shutdown_super+0x54/0x140
[  130.096071]        [<ffffffff8031a046>] kill_anon_super+0x16/0x50
[  130.096071]        [<ffffffff8031a0a7>] kill_litter_super+0x27/0x30
[  130.096071]        [<ffffffff8031a485>] deactivate_super+0x85/0xa0
[  130.096071]        [<ffffffff8033301a>] mntput_no_expire+0x11a/0x160
[  130.096071]        [<ffffffff803333d4>] sys_umount+0x64/0x3c0
[  130.096071]        [<ffffffff80213232>] system_call_fastpath+0x16/0x1b
[  130.096071]        [<ffffffffffffffff>] 0xffffffffffffffff
[  130.096071]
[  130.096071] other info that might help us debug this:
[  130.096071]
[  130.096071] 2 locks held by umount/2883:
[  130.096071]  #0:  (&type->s_umount_key#35){+.+...}, at:
[<ffffffff8031a47d>] deactivate_super+0x7d/0xa0
[  130.096071]  #1:  (&type->s_lock_key#8){+.+...}, at:
[<ffffffff803196ce>] lock_super+0x2e/0x30
[  130.096071]
[  130.096071] stack backtrace:
[  130.096071] Pid: 2883, comm: umount Not tainted 2.6.30-rc1-nobkl #39
[  130.096071] Call Trace:
[  130.096071]  [<ffffffff80286c96>] print_circular_bug_tail+0xa6/0x100
[  130.096071]  [<ffffffff802892ad>] __lock_acquire+0x107d/0x13e0
[  130.096071]  [<ffffffff8028972f>] lock_acquire+0x11f/0x170
[  130.096071]  [<ffffffff80748074>] ? lock_kernel+0x34/0x43
[  130.096071]  [<ffffffff8074534e>] __mutex_lock_common+0x5e/0x510
[  130.096071]  [<ffffffff80748074>] ? lock_kernel+0x34/0x43
[  130.096071]  [<ffffffff80287685>] ? trace_hardirqs_on_caller+0x165/0x1c0
[  130.096071]  [<ffffffff80748074>] ? lock_kernel+0x34/0x43
[  130.096071]  [<ffffffff807458df>] mutex_lock_nested+0x3f/0x50
[  130.096071]  [<ffffffff80748074>] lock_kernel+0x34/0x43
[  130.096071]  [<ffffffff80319ef4>] generic_shutdown_super+0x54/0x140
[  130.096071]  [<ffffffff8031a046>] kill_anon_super+0x16/0x50
[  130.096071]  [<ffffffff8031a0a7>] kill_litter_super+0x27/0x30
[  130.096071]  [<ffffffff8031a485>] deactivate_super+0x85/0xa0
[  130.096071]  [<ffffffff8033301a>] mntput_no_expire+0x11a/0x160
[  130.096071]  [<ffffffff803333d4>] sys_umount+0x64/0x3c0
[  130.096071]  [<ffffffff80213232>] system_call_fastpath+0x16/0x1b

Please notice that removing lock_kernel()/unlock_kernel() from
generic_shutdown_super() make this warning disappear but I'm not sure
that is it the _real_ fix.

Ciao,
Alessio
