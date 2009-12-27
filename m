Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZL0J51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZL0J51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 04:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZL0J50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 04:57:26 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39372 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZL0J5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 04:57:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G/KcS41pticgzPVl3LL1puO9v4IZRW4KT8Zcdpm33ALw4UMxFo0griWNiSlNeC87Mr
         7C5TPf2oBfGto6DHGzC07vGAxbGjbW/+ouB6nl7AXGhGJy6MLSTWOgeVal1k2kBDDHxH
         UFvjXaQRGtlzYJcuBBpDuFFnga2pvX6PKTI4M=
Date: Sun, 27 Dec 2009 01:57:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: nouveau@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Lockdep spew with nouveau on 2.6.33-rc2
Message-ID: <20091227095720.GA14655@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Every time I boot my laptop (Fedora 12) I get the following complint from
lockdep:

[  703.936365] =======================================================
[  703.936369] [ INFO: possible circular locking dependency detected ]
[  703.936372] 2.6.33-rc2 #154
[  703.936374] -------------------------------------------------------
[  703.936376] X/1365 is trying to acquire lock:
[  703.936379]  (&mm->mmap_sem){++++++}, at: [<ffffffff810f9672>] might_fault+0x72/0xd0
[  703.936388]
[  703.936389] but task is already holding lock:
[  703.936397]  (&dev->struct_mutex){+.+.+.}, at: [<ffffffffa003202d>] nouveau_gem_ioctl_pushbuf_call+0xfd/0x7d0 [nouveau]
[  703.936412]
[  703.936413] which lock already depends on the new lock.
[  703.936413]
[  703.936415]
[  703.936416] the existing dependency chain (in reverse order) is:
[  703.936418]
[  703.936418] -> #1 (&dev->struct_mutex){+.+.+.}:
[  703.936423]        [<ffffffff81081262>] check_prev_add+0x242/0x570
[  703.936428]        [<ffffffff81081be9>] validate_chain+0x659/0x750
[  703.936432]        [<ffffffff81081ff7>] __lock_acquire+0x317/0x4b0
[  703.936436]        [<ffffffff81082229>] lock_acquire+0x99/0x140
[  703.936440]        [<ffffffff8149c9c5>] __mutex_lock_common+0x65/0x4a0
[  703.936445]        [<ffffffff8149cede>] mutex_lock_nested+0x3e/0x50
[  703.936448]        [<ffffffff8130d67a>] drm_mmap+0x3a/0x70
[  703.936453]        [<ffffffffa0032d33>] nouveau_ttm_mmap+0x63/0xa0 [nouveau]
[  703.936461]        [<ffffffff81102954>] mmap_region+0x404/0x5a0
[  703.936466]        [<ffffffff81102e3c>] do_mmap_pgoff+0x34c/0x3a0
[  703.936470]        [<ffffffff810f496f>] sys_mmap_pgoff+0x1cf/0x2a0
[  703.936474]        [<ffffffff810079e9>] sys_mmap+0x29/0x30
[  703.936479]        [<ffffffff81002f6b>] system_call_fastpath+0x16/0x1b
[  703.936483]
[  703.936484] -> #0 (&mm->mmap_sem){++++++}:
[  703.936488]        [<ffffffff8108155e>] check_prev_add+0x53e/0x570
[  703.936492]        [<ffffffff81081be9>] validate_chain+0x659/0x750
[  703.936496]        [<ffffffff81081ff7>] __lock_acquire+0x317/0x4b0
[  703.936500]        [<ffffffff81082229>] lock_acquire+0x99/0x140
[  703.936503]        [<ffffffff810f969f>] might_fault+0x9f/0xd0
[  703.936507]        [<ffffffffa0030ebe>] validate_list+0x1be/0x290 [nouveau]
[  703.936515]        [<ffffffffa003171f>] nouveau_gem_pushbuf_validate+0xbf/0x150 [nouveau]
[  703.936524]        [<ffffffffa0032051>] nouveau_gem_ioctl_pushbuf_call+0x121/0x7d0 [nouveau]
[  703.936532]        [<ffffffffa0032726>] nouveau_gem_ioctl_pushbuf_call2+0x26/0x30 [nouveau]
[  703.936541]        [<ffffffff81306b25>] drm_ioctl+0x1c5/0x490
[  703.936549]        [<ffffffff811315c8>] vfs_ioctl+0x38/0xe0
[  703.936553]        [<ffffffff81131c65>] do_vfs_ioctl+0x75/0x370
[  703.936557]        [<ffffffff81131fe1>] sys_ioctl+0x81/0xa0
[  703.936560]        [<ffffffff81002f6b>] system_call_fastpath+0x16/0x1b
[  703.936564]
[  703.936565] other info that might help us debug this:
[  703.936565]
[  703.936568] 1 lock held by X/1365:
[  703.936569]  #0:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffffa003202d>] nouveau_gem_ioctl_pushbuf_call+0xfd/0x7d0 [nouveau]
[  703.936581]
[  703.936581] stack backtrace:
[  703.936584] Pid: 1365, comm: X Not tainted 2.6.33-rc2 #154
[  703.936587] Call Trace:
[  703.936591]  [<ffffffff8107f8c9>] print_circular_bug+0xe9/0xf0
[  703.936595]  [<ffffffff8108155e>] check_prev_add+0x53e/0x570
[  703.936599]  [<ffffffff81081be9>] validate_chain+0x659/0x750
[  703.936603]  [<ffffffff81081ff7>] __lock_acquire+0x317/0x4b0
[  703.936607]  [<ffffffff81082229>] lock_acquire+0x99/0x140
[  703.936610]  [<ffffffff810f9672>] ? might_fault+0x72/0xd0
[  703.936613]  [<ffffffff810f969f>] might_fault+0x9f/0xd0
[  703.936617]  [<ffffffff810f9672>] ? might_fault+0x72/0xd0
[  703.936624]  [<ffffffffa001253f>] ? ttm_bo_validate+0x6f/0xf0 [ttm]
[  703.936632]  [<ffffffffa0030ebe>] validate_list+0x1be/0x290 [nouveau]
[  703.936641]  [<ffffffffa003171f>] nouveau_gem_pushbuf_validate+0xbf/0x150 [nouveau]
[  703.936650]  [<ffffffffa0032051>] nouveau_gem_ioctl_pushbuf_call+0x121/0x7d0 [nouveau]
[  703.936653]  [<ffffffff810f9672>] ? might_fault+0x72/0xd0
[  703.936662]  [<ffffffffa0032726>] nouveau_gem_ioctl_pushbuf_call2+0x26/0x30 [nouveau]
[  703.936666]  [<ffffffff81306b25>] drm_ioctl+0x1c5/0x490
[  703.936670]  [<ffffffff81214dbd>] ? inode_has_perm+0x3d/0x70
[  703.936679]  [<ffffffffa0032700>] ? nouveau_gem_ioctl_pushbuf_call2+0x0/0x30 [nouveau]
[  703.936684]  [<ffffffff81214f41>] ? file_has_perm+0xb1/0xc0
[  703.936687]  [<ffffffff811315c8>] vfs_ioctl+0x38/0xe0
[  703.936690]  [<ffffffff81131c65>] do_vfs_ioctl+0x75/0x370
[  703.936693]  [<ffffffff81131fe1>] sys_ioctl+0x81/0xa0
[  703.936697]  [<ffffffff81002f6b>] system_call_fastpath+0x16/0x1b

Thanks.

-- 
Dmitry
