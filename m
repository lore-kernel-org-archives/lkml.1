Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631Ab0AUPxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0AUPxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323Ab0AUPxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:53:37 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:41251 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0AUPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:53:36 -0500
Date: Thu, 21 Jan 2010 16:53:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug
Message-ID: <20100121155335.GB4471@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

rumours are that you could be responsible for the following lockdep message:

Happens on cpu hotplug on s390:

=============================================
[ INFO: possible recursive locking detected ]
2.6.33-rc4-00399-g24bc734 #1
---------------------------------------------
bash/2576 is trying to acquire lock:
 (s_active){++++.+}, at: [<000000000016c506>] sysfs_addrm_finish+0x5a/0xa8

but task is already holding lock:
 (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88

other info that might help us debug this:
5 locks held by bash/2576:
 #0:  (&buffer->mutex){+.+.+.}, at: [<000000000016a912>] sysfs_write_file+0x4a/0x1a8
 #1:  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
 #2:  (s_active){++++.+}, at: [<000000000016c8e6>] sysfs_get_active_two+0x3e/0x88
 #3:  (cpu_add_remove_lock){+.+.+.}, at: [<00000000003dd318>] cpu_down+0x44/0x88
 #4:  (cpu_hotplug.lock){+.+.+.}, at: [<0000000000056eee>] cpu_hotplug_begin+0x3e/0x74

stack backtrace:
CPU: 1 Not tainted 2.6.33-rc4-00399-g24bc734 #1
Process bash (pid: 2576, task: 000000003f0e25d0, ksp: 000000003d9339d8)
000000003d9338b0 000000003d933830 0000000000000002 0000000000000000 
       000000003d9338d0 000000003d933848 000000003d933848 00000000003e4996 
       0000000000000000 0000000000000000 000000003f0e2cb8 0000000000835208 
       000000000000000d 000000000000000c 000000003d933898 0000000000000000 
       0000000000000000 00000000000172aa 000000003d933830 000000003d933870 
Call Trace:
([<00000000000171b2>] show_trace+0xee/0x144)
 [<000000000008a1a0>] validate_chain+0xa2c/0x1100
 [<000000000008ad84>] __lock_acquire+0x510/0xbfc
 [<000000000008b51c>] lock_acquire+0xac/0xd4
 [<000000000016bba8>] sysfs_deactivate+0x94/0x108
 [<000000000016c506>] sysfs_addrm_finish+0x5a/0xa8
 [<0000000000169f38>] sysfs_hash_and_remove+0x64/0x9c
 [<000000000016dbae>] sysfs_remove_group+0x76/0x12c
 [<00000000003dfaae>] smp_cpu_notify+0xae/0xc8
 [<00000000003eb652>] notifier_call_chain+0x56/0x98
 [<000000000007a1b2>] raw_notifier_call_chain+0x2a/0x3c
 [<00000000003dd132>] _cpu_down+0x1aa/0x34c
 [<00000000003dd356>] cpu_down+0x82/0x88
 [<00000000003ddac0>] store_online+0x5c/0xc8
 [<000000000016a9be>] sysfs_write_file+0xf6/0x1a8
 [<00000000000ffd5c>] vfs_write+0xac/0x178
 [<00000000000fff24>] SyS_write+0x58/0xa8
 [<00000000000295b6>] sysc_noemu+0x10/0x16
