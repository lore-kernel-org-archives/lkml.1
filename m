Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZJKJmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZJKJmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZJKJmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:42:52 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:50272 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZJKJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:42:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DsEyQNkH4MsDdlu848qukq8HdMx9CsZ9DvNf7Oaay5l0+6FlzE8Y5u32Q4RzX3NGMd
         0X4+Qxhm5/0MYpfGxqyRrBR1gVb7FNzvgYiy+gybc4hnKdZjE1oyXYUpGxESSNFFQJSn
         SzpSQ8+saH/R5bpQKcg/ZZspV79jdq79SKcA0=
Date: Sun, 11 Oct 2009 17:41:40 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [mmotm 2009-10-09-01-07] b43/wireless possible circular locking
Message-ID: <20091011094139.GA2778@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got lockdep warnings about possible circular lock with
b43 interface startup. It looks like a real problem.

[   71.974542] wlan0: deauthenticating from 00:19:e0:db:24:de by local choice (reason=3)
[   72.004352] b43-phy0 debug: Removing Interface type 2
[   72.005431] 
[   72.005435] =======================================================
[   72.006168] [ INFO: possible circular locking dependency detected ]
[   72.006759] 2.6.32-rc3-mm1 #4
[   72.007047] -------------------------------------------------------
[   72.007617] ifconfig/2175 is trying to acquire lock:
[   72.007617]  (&(&rfkill->poll_work)->work){+.+...}, at: [<c0239375>] __cancel_work_timer+0x8c/0x18e
[   72.007617] 
[   72.007617] but task is already holding lock:
[   72.007617]  (&wl->mutex){+.+.+.}, at: [<f8fa5359>] b43_op_stop+0x28/0x6a [b43]
[   72.007617] 
[   72.007617] which lock already depends on the new lock.
[   72.007617] 
[   72.007617] 
[   72.007617] the existing dependency chain (in reverse order) is:
[   72.007617] 
[   72.007617] -> #1 (&wl->mutex){+.+.+.}:
[   72.007617]        [<c024b251>] __lock_acquire+0x9e2/0xb73
[   72.007617]        [<c024b449>] lock_acquire+0x67/0x84
[   72.007617]        [<c055854d>] __mutex_lock_common+0x35/0x2ca
[   72.007617]        [<c0558880>] mutex_lock_nested+0x30/0x38
[   72.007617]        [<f8fb9bcd>] b43_rfkill_poll+0x26/0xc9 [b43]
[   72.007617]        [<f8f8330e>] ieee80211_rfkill_poll+0x1f/0x21 [mac80211]
[   72.007617]        [<f8396011>] cfg80211_rfkill_poll+0x11/0x13 [cfg80211]
[   72.007617]        [<f826b740>] rfkill_poll+0x14/0x2a [rfkill]
[   72.007617]        [<c0239927>] worker_thread+0x13b/0x1ff
[   72.007617]        [<c023be0c>] kthread+0x58/0x5d
[   72.007617]        [<c0203d07>] kernel_thread_helper+0x7/0x10
[   72.007617] 
[   72.007617] -> #0 (&(&rfkill->poll_work)->work){+.+...}:
[   72.007617]        [<c024b15c>] __lock_acquire+0x8ed/0xb73
[   72.007617]        [<c024b449>] lock_acquire+0x67/0x84
[   72.007617]        [<c02393a2>] __cancel_work_timer+0xb9/0x18e
[   72.007617]        [<c0239482>] cancel_delayed_work_sync+0xb/0xd
[   72.007617]        [<f826b71b>] rfkill_pause_polling+0x20/0x22 [rfkill]
[   72.007617]        [<f8396328>] wiphy_rfkill_stop_polling+0x10/0x12 [cfg80211]
[   72.007617]        [<f8fa5361>] b43_op_stop+0x30/0x6a [b43]
[   72.007617]        [<f8f895af>] ieee80211_stop_device+0x20/0x53 [mac80211]
[   72.007617]        [<f8f8141d>] ieee80211_stop+0x3d3/0x452 [mac80211]
[   72.007617]        [<c04e0c47>] dev_close+0x74/0x90
[   72.007617]        [<c04e082c>] dev_change_flags+0x96/0x144
[   72.007617]        [<c05262fd>] devinet_ioctl+0x212/0x468
[   72.007617]        [<c052814d>] inet_ioctl+0x8e/0xa7
[   72.007617]        [<c04d3e16>] sock_ioctl+0x1d3/0x1f7
[   72.007617]        [<c02a6b49>] vfs_ioctl+0x22/0x67
[   72.007617]        [<c02a707d>] do_vfs_ioctl+0x45f/0x493
[   72.007617]        [<c02a70f1>] sys_ioctl+0x40/0x5a
[   72.007617]        [<c020325d>] syscall_call+0x7/0xb
[   72.007617] 
[   72.007617] other info that might help us debug this:
[   72.007617] 
[   72.007617] 2 locks held by ifconfig/2175:
[   72.007617]  #0:  (rtnl_mutex){+.+.+.}, at: [<c04e8b90>] rtnl_lock+0xf/0x11
[   72.007617]  #1:  (&wl->mutex){+.+.+.}, at: [<f8fa5359>] b43_op_stop+0x28/0x6a [b43]
[   72.007617] 
[   72.007617] stack backtrace:
[   72.007617] Pid: 2175, comm: ifconfig Not tainted 2.6.32-rc3-mm1 #4
[   72.007617] Call Trace:
[   72.007617]  [<c024a863>] print_circular_bug+0x8a/0x96
[   72.007617]  [<c024b15c>] __lock_acquire+0x8ed/0xb73
[   72.007617]  [<c024b449>] lock_acquire+0x67/0x84
[   72.007617]  [<c0239375>] ? __cancel_work_timer+0x8c/0x18e
[   72.007617]  [<c02393a2>] __cancel_work_timer+0xb9/0x18e
[   72.007617]  [<c0239375>] ? __cancel_work_timer+0x8c/0x18e
[   72.007617]  [<c05587c8>] ? __mutex_lock_common+0x2b0/0x2ca
[   72.007617]  [<c0248233>] ? debug_mutex_free_waiter+0x45/0x48
[   72.007617]  [<c05587d8>] ? __mutex_lock_common+0x2c0/0x2ca
[   72.007617]  [<c0239482>] cancel_delayed_work_sync+0xb/0xd
[   72.007617]  [<f826b71b>] rfkill_pause_polling+0x20/0x22 [rfkill]
[   72.007617]  [<f8396328>] wiphy_rfkill_stop_polling+0x10/0x12 [cfg80211]
[   72.007617]  [<f8fa5361>] b43_op_stop+0x30/0x6a [b43]
[   72.007617]  [<f8f895af>] ieee80211_stop_device+0x20/0x53 [mac80211]
[   72.007617]  [<f8f8141d>] ieee80211_stop+0x3d3/0x452 [mac80211]
[   72.007617]  [<c0249d42>] ? trace_hardirqs_on+0xb/0xd
[   72.007617]  [<c022fd77>] ? _local_bh_enable_ip+0x9d/0xa6
[   72.007617]  [<c022fd88>] ? local_bh_enable_ip+0x8/0xa
[   72.007617]  [<c05592a8>] ? _spin_unlock_bh+0x25/0x28
[   72.007617]  [<c04e0c47>] dev_close+0x74/0x90
[   72.007617]  [<c04e082c>] dev_change_flags+0x96/0x144
[   72.007617]  [<c05262fd>] devinet_ioctl+0x212/0x468
[   72.007617]  [<c052814d>] inet_ioctl+0x8e/0xa7
[   72.007617]  [<c04d3e16>] sock_ioctl+0x1d3/0x1f7
[   72.007617]  [<c04d3c43>] ? sock_ioctl+0x0/0x1f7
[   72.007617]  [<c02a6b49>] vfs_ioctl+0x22/0x67
[   72.007617]  [<c02a707d>] do_vfs_ioctl+0x45f/0x493
[   72.007617]  [<c0221652>] ? need_resched+0x14/0x1e
[   72.007617]  [<c0557e29>] ? schedule+0x6ed/0x6fd
[   72.007617]  [<c055b24e>] ? do_page_fault+0x29d/0x2a5
[   72.007617]  [<c02a70f1>] sys_ioctl+0x40/0x5a
[   72.007617]  [<c020325d>] syscall_call+0x7/0xb
[   73.122930] b43-phy0 debug: Wireless interface stopped
[   73.131557] ifconfig used greatest stack depth: 5660 bytes left
[   73.310494] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[   73.329042] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[   77.923855] b43-phy0 debug: Chip initialized
[   77.924695] b43-phy0 debug: PIO initialized
[   77.925410] b43-phy0 debug: QoS enabled
[   77.941415] b43-phy0 debug: Wireless interface started
[   77.942164] b43-phy0 debug: Adding Interface type 2
[   77.961969] wlan0: direct probe to AP 00:19:e0:db:24:de (try 1)
[   78.160198] wlan0: direct probe to AP 00:19:e0:db:24:de (try 2)
[   78.164241] wlan0: direct probe responded
[   78.164649] wlan0: authenticate with AP 00:19:e0:db:24:de (try 1)
[   78.167341] wlan0: authenticated
[   78.167791] wlan0: associate with AP 00:19:e0:db:24:de (try 1)
[   78.170935] wlan0: RX ReassocResp from 00:19:e0:db:24:de (capab=0x421 status=0 aid=4)
[   78.171690] wlan0: associated

--
Regards
dave
