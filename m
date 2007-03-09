Return-Path: <linux-kernel-owner+w=401wt.eu-S2993155AbXCIWKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993155AbXCIWKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993157AbXCIWKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:10:22 -0500
Received: from smtp008.mail.ukl.yahoo.com ([217.12.11.62]:20339 "HELO
	smtp008.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993155AbXCIWKT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:10:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3ILcgyW3n+ZjWPRX4Pa29FqvgSB/1Qhj8AksQSIB9TEUClVH3mA14p/BVf8y0ug+3DyvF2OCk289GL1rGDLUW6B3y/mp5XImgQV+sckPM7mOoljAPWeKdEt4piYfcek4q8VAiJlj+Qm38M+hZntACwR+WtmWpIihNV8UnHcyT4Y=  ;
X-YMail-OSG: HUwkEQcVM1mf0zYZtbSuX6mGpJD50nuAFE5G2DY4IdL6aMIQPUJhmoWHaKz2LKekCIKEpm9liJcdeR7fZE7l_dhTL6yo2JagG6sB6aq5HVzLPLPRQgRdd8WIRllazETE9VVYkHGs0AH2
From: Blaisorblade <blaisorblade@yahoo.it>
To: "LKML" <linux-kernel@vger.kernel.org>, petero2@telia.com
Subject: Lockdep report against pktcdvd
Date: Fri, 9 Mar 2007 23:10:13 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703092310.13540.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When booting my laptop with a 2.6.20.1 laptop with lockdep enabled to test my 
code, I got a lockdep warning on pktcdvd on setup. It seems that do_open on a 
pktcdvd device causes another do_open on the underlying device, and that 
mutex_lock_nested is called with the same subclass (the for_part argument to 
do_open). So this may be a false positive, after all, but I'll let you 
decide.

I've installed and configured Ubuntu udftools so that pktcdvd0 is linked 
to /dev/cdrw, i.e. /dev/sr0, on my system.

This is an extract from my /proc/config.gz - it shows that both LOCKDEP and 
FRAME_POINTER are enabled, so the stack trace below out to be correct.

#
# Kernel hacking
#
CONFIG_DEBUG_KERNEL=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_STACKOVERFLOW=y
~

[   56.517353] pktcdvd: writer pktcdvd0 mapped to sr0
[   56.525469] 
[   56.525471] =============================================
[   56.525476] [ INFO: possible recursive locking detected ]
[   56.525479] 2.6.20.1-rfp+skas-v9-pre9+skas-dbg #3
[   56.525498] ---------------------------------------------
[   56.525501] vol_id/4536 is trying to acquire lock:
[   56.525503]  (&bdev->bd_mutex){--..}, at: [<ffffffff810a2869>] 
do_open+0x7b/0x2c4
[   56.525515] 
[   56.525521] but task is already holding lock:
[   56.525536]  (&bdev->bd_mutex){--..}, at: [<ffffffff810a2869>] 
do_open+0x7b/0x2c4
[   56.525560] 
[   56.525561] other info that might help us debug this:
[   56.525579] 2 locks held by vol_id/4536:
[   56.525593]  #0:  (&bdev->bd_mutex){--..}, at: [<ffffffff810a2869>] 
do_open+0x7b/0x2c4
[   56.525610]  #1:  (&ctl_mutex#2){--..}, at: [<ffffffff8120d470>] 
mutex_lock+0x22/0x26
[   56.525634] 
[   56.525634] stack backtrace:
[   56.525646] 
[   56.525652] Call Trace:
[   56.525666]  [<ffffffff8104aa1e>] __lock_acquire+0x137/0xa62
[   56.525687]  [<ffffffff8120ce13>] __mutex_unlock_slowpath+0x129/0x14f
[   56.525712]  [<ffffffff8104b61c>] lock_acquire+0x4d/0x69
[   56.525732]  [<ffffffff810a2869>] do_open+0x7b/0x2c4
[   56.525750]  [<ffffffff8120d57a>] mutex_lock_nested+0x106/0x2cd
[   56.525774]  [<ffffffff810a2869>] do_open+0x7b/0x2c4
[   56.525795]  [<ffffffff810a2b98>] __blkdev_get+0x7b/0x8d
[   56.525830]  [<ffffffff810a2bb5>] blkdev_get+0xb/0xd
[   56.525853]  [<ffffffff8823bbf5>] :pktcdvd:pkt_open+0xb5/0xd52
[   56.525876]  [<ffffffff8108f854>] __d_lookup+0x116/0x142
[   56.525897]  [<ffffffff8104a8d8>] debug_check_no_locks_freed+0x12b/0x13a
[   56.525922]  [<ffffffff8104a789>] trace_hardirqs_on+0x11a/0x13e
[   56.525944]  [<ffffffff81049eef>] lockdep_init_map+0xa6/0x326
[   56.525968]  [<ffffffff8120d41b>] __mutex_lock_slowpath+0x281/0x2b4
[   56.525990]  [<ffffffff8104a5b7>] mark_held_locks+0x53/0x71
[   56.526010]  [<ffffffff8120d41b>] __mutex_lock_slowpath+0x281/0x2b4
[   56.526034]  [<ffffffff8120ce13>] __mutex_unlock_slowpath+0x129/0x14f
[   56.526054]  [<ffffffff8120d70c>] mutex_lock_nested+0x298/0x2cd
[   56.526075]  [<ffffffff8104a5b7>] mark_held_locks+0x53/0x71
[   56.526095]  [<ffffffff8120d70c>] mutex_lock_nested+0x298/0x2cd
[   56.526117]  [<ffffffff8104830f>] debug_mutex_free_waiter+0x58/0x5c
[   56.526141]  [<ffffffff8120d732>] mutex_lock_nested+0x2be/0x2cd
[   56.526165]  [<ffffffff810a289c>] do_open+0xae/0x2c4
[   56.526184]  [<ffffffff8120eec6>] _spin_unlock+0x2d/0x4b
[   56.526205]  [<ffffffff810a2ab2>] blkdev_open+0x0/0x6b
[   56.526225]  [<ffffffff810a2ae6>] blkdev_open+0x34/0x6b
[   56.526247]  [<ffffffff8107d664>] __dentry_open+0x128/0x201
[   56.526270]  [<ffffffff8107d7ce>] nameidata_to_filp+0x2a/0x3c
[   56.526291]  [<ffffffff8107d81d>] do_filp_open+0x3d/0x4f
[   56.526315]  [<ffffffff8120eec6>] _spin_unlock+0x2d/0x4b
[   56.526335]  [<ffffffff8107d1cf>] get_unused_fd+0xfa/0x10b
[   56.526356]  [<ffffffff8107d87c>] do_sys_open+0x4d/0xd5
[   56.526377]  [<ffffffff8107d92d>] sys_open+0x1b/0x1d
[   56.526396]  [<ffffffff81009f6e>] system_call+0x7e/0x83
[   56.526417] 
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
