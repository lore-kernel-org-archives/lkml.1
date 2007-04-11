Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXDKI5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXDKI5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXDKI5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:57:48 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29928 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXDKI5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:57:46 -0400
Date: Wed, 11 Apr 2007 11:00:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 12/14 UPDATED] sysfs: implement sysfs_dirent active
 reference and immediate disconnect
Message-ID: <20070411110006.1007b209@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070411041515.GA10619@htj.dyndns.org>
References: <11760923261269-git-send-email-htejun@gmail.com>
	<11760923292724-git-send-email-htejun@gmail.com>
	<20070411041515.GA10619@htj.dyndns.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 13:15:15 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Cornelia, this should fix the problem you reported.  It's caused by
> doing up_write() on sysfs_dirent which is used for readdir cursor
> which is not deactivated before being released.
> release_sysfs_dirent() is udpated such that it does
> down_write_trylock() on s_active before doing up_write().  This also
> covers error paths where allocated sysfs_dirent is put due to errors
> during initialization.

I can confirm that this fixes the problem I saw earlier. However, I now
have a new one:

1. Define virtunal ctcs 7000 and 7001: This
creates /sys/bus/ccw/devices/{0.0.7000,0.0.7001}.

2. Do echo 0.0.7000,0.0.7001 > /sys/bus/ccwgroup/drivers/ctc/group.
This creates /sys/bus/ccwgroup/devices/0.0.7000, which has the two ccw
devices from above as slave devices.

3. Detach virtual ctcs 7000 and 7001. This causes the subchannel
beneath 0.0.7000 resp. 0.0.7001 to be unregistered (from a workqueue)
which will in turn trigger an unregistration of ccw device 0.0.7000,
ccw group device 0.0.7000 and ccw device 0.0.7001. Now lockdep is
unhappy:

crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=3, anc=1, erc=4, rsid=F
crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=3, anc=1, erc=4, rsid=10
DEV: Unregistering device. ID = '0.0.000f'
bus css: remove device 0.0.000f
DEV: Unregistering device. ID = '0.0.7000'
bus ccw: remove device 0.0.7000
DEV: Unregistering device. ID = '0.0.7000'
bus ccwgroup: remove device 0.0.7000

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21-rc6-ge666c753-dirty #54
-------------------------------------------------------
kslowcrw/64 is trying to acquire lock:
 (&sch->reg_mutex){--..}, at: [<00000000004233b2>] mutex_lock+0x3e/0x4c

but task is already holding lock:
 (&sd->s_active){----}, at: [<0000000000209578>] remove_dir+0xec/0x144

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&sd->s_active){----}:
       [<0000000000156998>] __lock_acquire+0x1008/0x1124
       [<0000000000156e9c>] lock_acquire+0x78/0xa8
       [<000000000014fc96>] down_write+0x5a/0xa0
       [<0000000000206f0a>] sysfs_hash_and_remove+0x112/0x15c
       [<00000000002071a6>] sysfs_remove_file+0x32/0x40
       [<00000000002a76bc>] device_remove_file+0x44/0x5c
       [<00000000002a813a>] device_del+0x1ae/0x26c
       [<00000000002a8236>] device_unregister+0x3e/0x58
       [<00000000002f0bc0>] css_sch_device_unregister+0x3c/0x54
       [<00000000002f174a>] css_evaluate_subchannel+0x266/0x3b8
       [<00000000002f1976>] css_trigger_slow_path+0xda/0x154
       [<0000000000144a6c>] run_workqueue+0x174/0x220
       [<0000000000144d26>] worker_thread+0x116/0x164
       [<000000000014ab9c>] kthread+0x158/0x160
       [<0000000000107c3a>] kernel_thread_starter+0x6/0xc
       [<0000000000107c34>] kernel_thread_starter+0x0/0xc

-> #0 (&sch->reg_mutex){--..}:
       [<000000000015671c>] __lock_acquire+0xd8c/0x1124
       [<0000000000156e9c>] lock_acquire+0x78/0xa8
       [<0000000000423070>] __mutex_lock_slowpath+0xbc/0x3c0
       [<00000000004233b2>] mutex_lock+0x3e/0x4c
       [<00000000002f0bb6>] css_sch_device_unregister+0x32/0x54
       [<00000000002f174a>] css_evaluate_subchannel+0x266/0x3b8
       [<00000000002f1976>] css_trigger_slow_path+0xda/0x154
       [<0000000000144a6c>] run_workqueue+0x174/0x220
       [<0000000000144d26>] worker_thread+0x116/0x164
       [<000000000014ab9c>] kthread+0x158/0x160
       [<0000000000107c3a>] kernel_thread_starter+0x6/0xc
       [<0000000000107c34>] kernel_thread_starter+0x0/0xc

other info that might help us debug this:

1 lock held by kslowcrw/64:
 #0:  (&sd->s_active){----}, at: [<0000000000209578>] remove_dir+0xec/0x144

stack backtrace:
0000000000000002 0000000000000002 0000000000000000 000000001fd1ba50 
       000000001fd1b9c8 00000000004bebf6 00000000004bebf6 0000000000103854 
       0000000000000000 0000000000000001 0000000000000000 0000000000602cb0 
       0000000000000000 000000001fd1ba10 000000001fd1b9b0 000000000000000e 
       000000000042a780 000000000010389e 000000001fd1b9b0 000000001fd1ba00 
Call Trace:
([<00000000001037f4>] show_trace+0xf8/0xfc)
 [<00000000001038ce>] show_stack+0xd6/0x100
 [<0000000000103926>] dump_stack+0x2e/0x3c
 [<0000000000154c6e>] print_circular_bug_tail+0x9e/0xb0
 [<000000000015671c>] __lock_acquire+0xd8c/0x1124
 [<0000000000156e9c>] lock_acquire+0x78/0xa8
 [<0000000000423070>] __mutex_lock_slowpath+0xbc/0x3c0
 [<00000000004233b2>] mutex_lock+0x3e/0x4c
 [<00000000002f0bb6>] css_sch_device_unregister+0x32/0x54
 [<00000000002f174a>] css_evaluate_subchannel+0x266/0x3b8
 [<00000000002f1976>] css_trigger_slow_path+0xda/0x154
 [<0000000000144a6c>] run_workqueue+0x174/0x220
 [<0000000000144d26>] worker_thread+0x116/0x164
 [<000000000014ab9c>] kthread+0x158/0x160
 [<0000000000107c3a>] kernel_thread_starter+0x6/0xc
 [<0000000000107c34>] kernel_thread_starter+0x0/0xc

INFO: lockdep is turned off.
DEV: Unregistering device. ID = '0.0.0010'
bus css: remove device 0.0.0010
DEV: Unregistering device. ID = '0.0.7001'
bus ccw: remove device 0.0.7001

(We use sch->reg_mutex to protect against concurrent
register/unregister of subchannels.)

I'll see whether I can figure out this one.
