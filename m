Return-Path: <linux-kernel-owner+w=401wt.eu-S1762431AbZENBll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431AbZENBll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZENBld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:41:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9435 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZENBlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Ft/VVZLkSSjp7gGLHSicAx0kAzdmJMDQ31ikV4ZfD1QDCGn3kc4o20joWfaF7rm+El
         mKGliK6JxNh8Ixu7zLsGThUBsil9a+Hyi6H2ABQmHxXs26P/5+H5k+R0MyK3wj9DasY1
         36NXJy9YmXg3Ji8WaceY1wFrNEtO2NYOz6YiU=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 18:33:10 -0700
Message-ID: <43e72e890905131833k291c8720r4045e9e497430b40@mail.gmail.com>
Subject: pm-susend on 2.6.30-rc5
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying suspend on 2.6.30-rc5 I get the following WARN and also
cannot use my write to my file system. I cannot even reboot:

mcgrof@pogo ~ $ sudo reboot
sudo: unable to execute /sbin/reboot: Success
mcgrof@pogo ~ $ echo $?
127

Granted, I've never tried to suspend on this box, its a development
desktop, but still think you'd like to know about it. The actual WARN
in question is:

        /* Warning on suspend means the RTC alarm period needs to be
         * larger -- the system was sooo slooowwww to suspend that the
         * alarm (should have) fired before the system went to sleep!
         *
         * Warning on either suspend or resume also means the system
         * has some performance issues.  The stack dump of a WARN_ON
         * is more likely to get the right attention than a printk...
         */
        WARN(msec > (TEST_SUSPEND_SECONDS * 1000), "Component: %s\n", label);

But what is surprising is this is a decent desktop: AMD Phenom(tm)
9750 Quad-Core Processor with 8 GB RAM. not sure what to make out of
this WARN then or what to do.

The hard drive (sdb) / ext3 issues seem separate. Below I paste the
WARN and some sda/ext3 errors.

For complete logs:

http://bombadil.infradead.org/~mcgrof/logs/2.6.30-rc5/bootup.log
http://bombadil.infradead.org/~mcgrof/logs/2.6.30-rc5/suspend.log
http://bombadil.infradead.org/~mcgrof/logs/2.6.30-rc5/resume.log
http://bombadil.infradead.org/~mcgrof/logs/2.6.30-rc5/system-info.log

I've booted with nmi_watchdog=1 (which doesn't work see bug #12774)
and apic=debug.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=12774

In suspend.log you'll find a cfg80211 related lockdep warning -- I am
testing WoW code but I do not believe the lockdep issue is related to
that code so that should be reproducible without ithe WoW stuff I
have. Anyway if anyone has an idea how to fix this issue that the WARN
complains about please let me know. The sdb/ext3 issues are a little
more concerning. Not like I care but others using similar systems and
for whatever reason they suspend (I guess to save power at home on a
power hog machine) may.

[  202.381160] ------------[ cut here ]------------
[  202.381162] WARNING: at kernel/power/main.c:176
suspend_test_finish+0x7c/0x80()
[  202.381164] Hardware name: System Product Name
[  202.381165] Component: resume devices
[  202.381166] Modules linked in: ipv6 cpufreq_ondemand powernow_k8
freq_table binfmt_misc loop dm_multipath scsi
_dh arc4 ecb ath9k mac80211 af_packet rfkill led_class ath sr_mod
cdrom cfg80211 shpchp evdev evbug usbhid psmous
e e1000 i2c_nforce2 pci_hotplug hid pata_amd i2c_core processor pcspkr
serio_raw sg floppy wmi button thermal dm_
snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ahci
ata_generic pata_acpi libata sd_mod scsi_mod crc_t10
dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: scsi_wait_scan]
[  202.381205] Pid: 3879, comm: pm-suspend Not tainted 2.6.30-rc5-wl #28
[  202.381207] Call Trace:
[  202.381214]  [<ffffffff8023f520>] warn_slowpath_fmt+0xd0/0x120
[  202.381219]  [<ffffffff80560380>] ? _spin_unlock+0x30/0x60
[  202.381222]  [<ffffffff802402c1>] ? vprintk+0x2f1/0x490
[  202.381226]  [<ffffffff8048c522>] ? device_resume+0x312/0x450
[  202.381230]  [<ffffffff8055c370>] ? printk+0x67/0x6f
[  202.381234]  [<ffffffff8026b37d>] ? trace_hardirqs_on+0xd/0x10
[  202.381237]  [<ffffffff8055dbb9>] ? mutex_unlock+0x9/0x10
[  202.381239]  [<ffffffff8048c59e>] ? device_resume+0x38e/0x450
[  202.381242]  [<ffffffff8027864c>] suspend_test_finish+0x7c/0x80
[  202.381245]  [<ffffffff8027871f>] suspend_devices_and_enter+0xaf/0x240
[  202.381247]  [<ffffffff80278a46>] enter_state+0x166/0x1e0
[  202.381250]  [<ffffffff80278b7a>] state_store+0xba/0x100
[  202.381254]  [<ffffffff803f5537>] kobj_attr_store+0x17/0x20
[  202.381258]  [<ffffffff8033f96a>] sysfs_write_file+0xca/0x140
[  202.381262]  [<ffffffff802ebbdb>] vfs_write+0xcb/0x190
[  202.381264]  [<ffffffff802ebd90>] sys_write+0x50/0x90
[  202.381268]  [<ffffffff8020bf6b>] system_call_fastpath+0x16/0x1b
[  202.381270] ---[ end trace 3b85c8c444ddfc72 ]---
[  202.401320] PM: Finishing wakeup.
[  202.401367] Restarting tasks ... done.
[  202.484982] sd 2:0:0:0: [sdb] Unhandled error code
[  202.485043] sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  202.485141] end_request: I/O error, dev sdb, sector 16180793
[  202.485227] sd 2:0:0:0: [sdb] Unhandled error code
[  202.485277] sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  202.485372] end_request: I/O error, dev sdb, sector 16180793
[  202.969259] sd 2:0:0:0: [sdb] Unhandled error code
[  202.969317] sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  202.969419] end_request: I/O error, dev sdb, sector 144323017
[  202.969497] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=4505287, block
=17990126
[  202.969717] sd 2:0:0:0: [sdb] Unhandled error code
[  202.969769] sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  202.969867] end_request: I/O error, dev sdb, sector 402009
[  202.969924] Buffer I/O error on device dm-0, logical block 0
[  202.969978] lost page write due to I/O error on dm-0
[  207.400942] sd 2:0:0:0: [sdb] Unhandled error code
[  207.401003] sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  207.401104] end_request: I/O error, dev sdb, sector 235923705
[  207.401165] Buffer I/O error on device dm-0, logical block 29440212
[  207.401220] lost page write due to I/O error on dm-0
[  207.401298] sd 2:0:0:0: [sdb] Unhandled error code
[  207.401350] sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  207.401454] end_request: I/O error, dev sdb, sector 235976561
[  207.401518] Buffer I/O error on device dm-0, logical block 29446819
