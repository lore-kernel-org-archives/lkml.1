Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYIWTZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYIWTZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYIWTZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:25:44 -0400
Received: from main.gmane.org ([80.91.229.2]:45921 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYIWTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:25:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [lockdep] possible circular locking dependency, between &pcm->open_mutex
 and &mm->mmap_sem
Date: Tue, 23 Sep 2008 20:25:36 +0100
Message-ID: <48D942B0.7030906@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: perex@perex.cz, Ingo Molnar <mingo@elte.hu>
X-Gmane-NNTP-Posting-Host: 87.112.14.28.plusnet.ptn-ag1.dyn.plus.net
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on linux-tip today. I'm not quite sure what to do with it (what's 
the correct procedure for lockdep messages? I didn't turn up much in a 
Google search for pcm->open_mutex lockdep ...) and it seems to be ALSA 
related...

[   51.391587] =======================================================
[   51.391596] [ INFO: possible circular locking dependency detected ]
[   51.391603] 2.6.27-rc7-tipskw-00756-g6522eab #6
[   51.391607] -------------------------------------------------------
[   51.391613] pulseaudio/3736 is trying to acquire lock:
[   51.391618]  (&pcm->open_mutex){--..}, at: [<c032bce8>] 
snd_pcm_release+0x58/0xd0
[   51.391637]
[   51.391639] but task is already holding lock:
[   51.391644]  (&mm->mmap_sem){----}, at: [<c016fd27>] sys_munmap+0x27/0x50
[   51.391658]
[   51.391659] which lock already depends on the new lock.
[   51.391662]
[   51.391666]
[   51.391667] the existing dependency chain (in reverse order) is:
[   51.391672]
[   51.391674] -> #2 (&mm->mmap_sem){----}:
[   51.391683]        [<c0148c48>] validate_chain+0xad8/0x1000
[   51.391693]        [<c014a050>] __lock_acquire+0x220/0x5d0
[   51.391701]        [<c014a45c>] lock_acquire+0x5c/0x80
[   51.391709]        [<c016b13b>] might_fault+0x6b/0x90
[   51.391718]        [<c020e7d6>] copy_from_user+0x36/0x70
[   51.391728]        [<c0320f32>] snd_ctl_elem_user_tlv+0x62/0x130
[   51.391737]        [<c03219a0>] snd_ctl_tlv_ioctl+0x120/0x150
[   51.391745]        [<c03223c9>] snd_ctl_ioctl+0x1d9/0xe50
[   51.391752]        [<c0186fad>] vfs_ioctl+0x2d/0x90
[   51.391760]        [<c018706c>] do_vfs_ioctl+0x5c/0x2f0
[   51.391768]        [<c018733e>] sys_ioctl+0x3e/0x60
[   51.391775]        [<c010330d>] sysenter_do_call+0x12/0x35
[   51.391784]        [<ffffffff>] 0xffffffff
[   51.391791]
[   51.391792] -> #1 (&card->controls_rwsem){----}:
[   51.391802]        [<c0148c48>] validate_chain+0xad8/0x1000
[   51.391810]        [<c014a050>] __lock_acquire+0x220/0x5d0
[   51.391818]        [<c014a45c>] lock_acquire+0x5c/0x80
[   51.391825]        [<c03caf97>] down_read+0x37/0x50
[   51.391834]        [<c032849c>] snd_pcm_attach_substream+0x7c/0x3c0
[   51.391843]        [<c032bd7b>] snd_pcm_open_substream+0x1b/0xa0
[   51.391852]        [<c032bece>] snd_pcm_open+0xce/0x180
[   51.391861]        [<c032bfd8>] snd_pcm_playback_open+0x28/0x30
[   51.391869]        [<c031e4cb>] snd_open+0x6b/0x80
[   51.391879]        [<c017e040>] chrdev_open+0x70/0x160
[   51.391888]        [<c0179cb4>] __dentry_open+0xf4/0x1f0
[   51.391896]        [<c0179df5>] nameidata_to_filp+0x45/0x60
[   51.391905]        [<c0185a9c>] do_filp_open+0x17c/0x680
[   51.391915]        [<c0179a80>] do_sys_open+0x50/0xe0
[   51.391923]        [<c0179b7e>] sys_open+0x2e/0x40
[   51.391931]        [<c010330d>] sysenter_do_call+0x12/0x35
[   51.391939]        [<ffffffff>] 0xffffffff
[   51.391951]
[   51.391952] -> #0 (&pcm->open_mutex){--..}:
[   51.391961]        [<c0148723>] validate_chain+0x5b3/0x1000
[   51.391969]        [<c014a050>] __lock_acquire+0x220/0x5d0
[   51.391977]        [<c014a45c>] lock_acquire+0x5c/0x80
[   51.391985]        [<c03ca9a7>] __mutex_lock_common+0x87/0x360
[   51.391993]        [<c03cacdd>] mutex_lock_nested+0x1d/0x20
[   51.392001]        [<c032bce8>] snd_pcm_release+0x58/0xd0
[   51.392009]        [<c017c8b4>] __fput+0xa4/0x190
[   51.392012]        [<c017c9bd>] fput+0x1d/0x30
[   51.392012]        [<c016e42d>] remove_vma+0x2d/0x50
[   51.392012]        [<c016fa98>] do_munmap+0x198/0x1f0
[   51.392012]        [<c016fd34>] sys_munmap+0x34/0x50
[   51.392012]        [<c010330d>] sysenter_do_call+0x12/0x35
[   51.392012]        [<ffffffff>] 0xffffffff
[   51.392012]
[   51.392012] other info that might help us debug this:
[   51.392012]
[   51.392012] 1 lock held by pulseaudio/3736:
[   51.392012]  #0:  (&mm->mmap_sem){----}, at: [<c016fd27>] 
sys_munmap+0x27/0x50
[   51.392012]
[   51.392012] stack backtrace:
[   51.392012] Pid: 3736, comm: pulseaudio Not tainted 
2.6.27-rc7-tipskw-00756-g6522eab #6
[   51.392012]  [<c014779b>] print_circular_bug_tail+0x7b/0xd0
[   51.392012]  [<c0146163>] ? print_circular_bug_entry+0x43/0x50
[   51.392012]  [<c0148723>] validate_chain+0x5b3/0x1000
[   51.392012]  [<c014a050>] __lock_acquire+0x220/0x5d0
[   51.392012]  [<c014a45c>] lock_acquire+0x5c/0x80
[   51.392012]  [<c032bce8>] ? snd_pcm_release+0x58/0xd0
[   51.392012]  [<c03ca9a7>] __mutex_lock_common+0x87/0x360
[   51.392012]  [<c032bce8>] ? snd_pcm_release+0x58/0xd0
[   51.392012]  [<c03cacdd>] mutex_lock_nested+0x1d/0x20
[   51.392012]  [<c032bce8>] ? snd_pcm_release+0x58/0xd0
[   51.392012]  [<c032bce8>] snd_pcm_release+0x58/0xd0
[   51.392012]  [<c017c8b4>] __fput+0xa4/0x190
[   51.392012]  [<c017c9bd>] fput+0x1d/0x30
[   51.392012]  [<c016e42d>] remove_vma+0x2d/0x50
[   51.392012]  [<c016fa98>] do_munmap+0x198/0x1f0
[   51.392012]  [<c016fd34>] sys_munmap+0x34/0x50
[   51.392012]  [<c010330d>] sysenter_do_call+0x12/0x35
[   51.392012]  =======================


-- 
Sitsofe | http://sucs.org/~sits/

