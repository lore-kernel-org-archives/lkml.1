Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYE1JnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYE1JnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYE1Jmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:42:52 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:50839 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYE1Jmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:42:50 -0400
Message-ID: <483D28C5.4060406@linux.vnet.ibm.com>
Date: Wed, 28 May 2008 15:11:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: MPTSAS problems in 2.6.26-rc2-mm1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have 2.6.26-rc2-mm1 with Rik's splitvm patches. While booting the kernel, I
ran into the following. I searched my email quickly to see that no one else has
reported this problem. Lockdep seems to be complaining about the same lock being
held at the same location (the message is a bit confusing to me).


=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc2-mm1 #2
---------------------------------------------
insmod/1072 is trying to acquire lock:
 (&cls->mutex){--..}, at: [<ffffffff803eb2cc>] device_add+0x46e/0x5d7

but task is already holding lock:
 (&cls->mutex){--..}, at: [<ffffffff803eb2cc>] device_add+0x46e/0x5d7

other info that might help us debug this:
3 locks held by insmod/1072:
 #0:  (&ioc->sas_discovery_mutex){--..}, at: [<ffffffffa003e7e9>]
mptsas_probe+0x3a1/0x442 [mptsas]
 #1:  (&shost->scan_mutex){--..}, at: [<ffffffff80466cbd>]
scsi_scan_target+0x71/0xb0
 #2:  (&cls->mutex){--..}, at: [<ffffffff803eb2cc>] device_add+0x46e/0x5d7

stack backtrace:
Pid: 1072, comm: insmod Not tainted 2.6.26-rc2-mm1 #2

Call Trace:
 [<ffffffff80254545>] __lock_acquire+0x911/0xc4c
 [<ffffffff80254835>] ? __lock_acquire+0xc01/0xc4c
 [<ffffffff803eb2cc>] ? device_add+0x46e/0x5d7
 [<ffffffff8025490e>] lock_acquire+0x8e/0xb2
 [<ffffffff803eb2cc>] ? device_add+0x46e/0x5d7
 [<ffffffff8059e067>] mutex_lock_nested+0xf2/0x27f
 [<ffffffff803eb2cc>] ? device_add+0x46e/0x5d7
 [<ffffffff8059f80b>] ? _spin_unlock+0x26/0x2a
 [<ffffffff803eb2cc>] device_add+0x46e/0x5d7
 [<ffffffff803eb44e>] device_register+0x19/0x1d
 [<ffffffff803eb531>] device_create+0xdf/0x110
 [<ffffffff80253794>] ? trace_hardirqs_on_caller+0xf9/0x124
 [<ffffffff802537cc>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8059df73>] ? mutex_unlock+0x9/0xb
 [<ffffffff803eed13>] ? kobj_map+0x119/0x12e
 [<ffffffff802a4488>] ? exact_lock+0x0/0x14
 [<ffffffff802a4364>] ? exact_match+0x0/0x9
 [<ffffffff80488bb4>] sg_add+0x262/0x394
 [<ffffffff8059f80b>] ? _spin_unlock+0x26/0x2a
 [<ffffffff803eb31b>] device_add+0x4bd/0x5d7
 [<ffffffff80467d9b>] scsi_sysfs_add_sdev+0xde/0x200
 [<ffffffff80465feb>] scsi_probe_and_add_lun+0x847/0x977
 [<ffffffff8046639d>] __scsi_scan_target+0xbf/0x522
 [<ffffffff80253794>] ? trace_hardirqs_on_caller+0xf9/0x124
 [<ffffffff80250b9d>] ? debug_mutex_free_waiter+0x46/0x4a
 [<ffffffff8059e1e5>] ? mutex_lock_nested+0x270/0x27f
 [<ffffffff80466cbd>] ? scsi_scan_target+0x71/0xb0
 [<ffffffff80466ce8>] scsi_scan_target+0x9c/0xb0
 [<ffffffffa001ad60>] :scsi_transport_sas:sas_rphy_add+0x14c/0x15b
 [<ffffffffa003cc17>] :mptsas:mptsas_probe_one_phy+0x364/0x3a9
 [<ffffffffa003d651>] :mptsas:mptsas_probe_hba_phys+0x5bb/0x614
 [<ffffffffa0028aeb>] ? :mptbase:mpt_timer_expired+0x0/0x2e
 [<ffffffffa0028aeb>] ? :mptbase:mpt_timer_expired+0x0/0x2e
 [<ffffffffa0028aeb>] ? :mptbase:mpt_timer_expired+0x0/0x2e
 [<ffffffffa003e7f1>] :mptsas:mptsas_probe+0x3a9/0x442
 [<ffffffff8039126a>] pci_device_probe+0xbd/0x116
 [<ffffffff803ed1f0>] driver_probe_device+0xdb/0x162
 [<ffffffff803ed2c6>] __driver_attach+0x4f/0x79
 [<ffffffff803ed277>] ? __driver_attach+0x0/0x79
 [<ffffffff803ec832>] bus_for_each_dev+0x4d/0x7e
 [<ffffffff803ed01c>] driver_attach+0x1c/0x1e
 [<ffffffff803eccc0>] bus_add_driver+0xba/0x212
 [<ffffffff803ed4a6>] driver_register+0x93/0x10a
 [<ffffffff80391526>] __pci_register_driver+0x73/0xad
 [<ffffffffa00450e2>] :mptsas:mptsas_init+0xe2/0xfa
 [<ffffffff8025c25e>] sys_init_module+0x9e/0x1b2
 [<ffffffff8020b20b>] system_call_after_swapgs+0x7b/0x80



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
