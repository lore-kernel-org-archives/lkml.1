Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYDIH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYDIH1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYDIH1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:27:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:43995 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYDIH1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=EmWjyIaZIjpXF0VXvak6eXwIWYVaMDnDMauJoxcuaH/MFJWug6rYY4U1tvK5Zs30aI5CjaTqqXcV9/ittNbxYbN8R8U/ittzxFzxA11sdtWYiLAUX9q642FHjFxfTPYi9MLWYqqFnY+Ta/XG6uIbZEuvjcOj6QH9nH0bdqnhhX0=
Date: Wed, 9 Apr 2008 15:32:24 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] snd_hda_intel : mutex_unlock balance fix
Message-ID: <20080409073224.GA3572@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mutex lock/unlock balance problem detected by lockdep, see below info.

This patch moves the mutex_unlock into "if {}"

[  893.231878] =====================================
[  893.231878] [ BUG: bad unlock balance detected! ]
[  893.231878] -------------------------------------
[  893.231878] firefox-bin/2796 is trying to release lock (&codec->spdif_mutex) at:
[  893.231878] [<c03d7608>] mutex_unlock+0x8/0x10
[  893.231878] but there are no more locks to release!
[  893.231878] 
[  893.231878] other info that might help us debug this:
[  893.231878] 2 locks held by firefox-bin/2796:
[  893.231878]  #0:  (&pcm->open_mutex){--..}, at: [<f892d093>] snd_pcm_open+0xc3/0x190 [snd_pcm]
[  893.231878]  #1:  (&chip->open_mutex){--..}, at: [<f893bc57>] azx_pcm_open+0x37/0x1b0 [snd_hda_intel]
[  893.231878] 
[  893.231878] stack backtrace:
[  893.231878] Pid: 2796, comm: firefox-bin Not tainted 2.6.25-rc8-mm1 #9
[  893.231878]  [<c0128148>] ? printk+0x18/0x20
[  893.231878]  [<c014bd49>] print_unlock_inbalance_bug+0xd9/0xf0
[  893.231878]  [<c03d7608>] ? mutex_unlock+0x8/0x10
[  893.231878]  [<c014be4a>] lock_release_non_nested+0x7a/0x170
[  893.231878]  [<c014a7b9>] ? mark_lock_irq+0x209/0x3b0
[  893.231878]  [<c014bf7c>] lock_release_nested+0x3c/0xf0
[  893.231878]  [<c03d7608>] ? mutex_unlock+0x8/0x10
[  893.231878]  [<c014c09b>] __lock_release+0x6b/0x70
[  893.231878]  [<c03d7608>] ? mutex_unlock+0x8/0x10
[  893.231878]  [<c014c2f6>] lock_release+0x56/0x80
[  893.231878]  [<c03d7f2e>] __mutex_unlock_slowpath+0x5e/0x140
[  893.231878]  [<c03d7608>] mutex_unlock+0x8/0x10
[  893.231878]  [<f893f157>] snd_hda_multi_out_analog_open+0xd7/0x150 [snd_hda_intel]
[  893.231878]  [<f894d749>] stac92xx_playback_pcm_open+0x19/0x20 [snd_hda_intel]
[  893.231878]  [<f893bd6f>] azx_pcm_open+0x14f/0x1b0 [snd_hda_intel]
[  893.231878]  [<f892ce94>] snd_pcm_open_substream+0x44/0x80 [snd_pcm]
[  893.231878]  [<f892cefd>] snd_pcm_open_file+0x2d/0xa0 [snd_pcm]
[  893.231878]  [<c013be0b>] ? add_wait_queue+0x3b/0x50
[  893.231878]  [<f892d0b3>] snd_pcm_open+0xe3/0x190 [snd_pcm]
[  893.231878]  [<c0121900>] ? default_wake_function+0x0/0x10
[  893.231878]  [<c03d7608>] ? mutex_unlock+0x8/0x10
[  893.231878]  [<f892cf93>] snd_pcm_playback_open+0x23/0x30 [snd_pcm]
[  893.231878]  [<f88e3217>] snd_open+0x147/0x1f0 [snd]
[  893.231878]  [<c018baf9>] chrdev_open+0xf9/0x1d0
[  893.231878]  [<c0187c0c>] __dentry_open+0x18c/0x310
[  893.231878]  [<c0187e2d>] nameidata_to_filp+0x2d/0x60
[  893.231878]  [<c018ba00>] ? chrdev_open+0x0/0x1d0
[  893.231878]  [<c0192850>] do_filp_open+0x190/0x620
[  893.231878]  [<c0148720>] ? lock_release_holdtime+0x60/0x80
[  893.231878]  [<c014c077>] ? __lock_release+0x47/0x70
[  893.231878]  [<c0187fb8>] ? get_unused_fd_flags+0xb8/0xf0
[  893.231878]  [<c03d94f7>] ? _spin_unlock+0x27/0x40
[  893.231878]  [<c0187fb8>] ? get_unused_fd_flags+0xb8/0xf0
[  893.231878]  [<c0188114>] do_sys_open+0x54/0xe0
[  893.231878]  [<c0103edb>] ? restore_nocheck+0x12/0x15
[  893.231878]  [<c01881bc>] sys_open+0x1c/0x20
[  893.231878]  [<c0103e7a>] syscall_call+0x7/0xb
[  893.231878]  =======================

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
sound/pci/hda/hda_codec.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux/sound/pci/hda/hda_codec.c linux.new/sound/pci/hda/hda_codec.c
--- linux/sound/pci/hda/hda_codec.c	2008-04-09 15:08:21.000000000 +0800
+++ linux.new/sound/pci/hda/hda_codec.c	2008-04-09 15:09:20.000000000 +0800
@@ -2665,8 +2665,8 @@ int snd_hda_multi_out_analog_open(struct
 			if (mout->spdif_maxbps < hinfo->maxbps)
 				hinfo->maxbps = mout->spdif_maxbps;
 		}
+		mutex_unlock(&codec->spdif_mutex);
 	}
-	mutex_unlock(&codec->spdif_mutex);
 	return snd_pcm_hw_constraint_step(substream->runtime, 0,
 					  SNDRV_PCM_HW_PARAM_CHANNELS, 2);
 }
