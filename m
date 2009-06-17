Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbZFQKvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbZFQKvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFQKv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:51:28 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:42058 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZFQKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:51:27 -0400
Message-ID: <4A38CAAC.4090606@in.ibm.com>
Date: Wed, 17 Jun 2009 16:21:24 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       menage@google.com
Subject: [BUG] lib/kernel_lock.c:126 with cgroups regression ltp tests
Content-Type: multipart/mixed;
 boundary="------------080808090809040803080509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080808090809040803080509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While executing cgroups regression tests from LTP May 2009
release on a Power6 box came across the following bug.
This is with 2.6.30-git10 (300df7dc89cc276377fc020704e34875d5c473b6)

------------[ cut here ]------------
kernel BUG at lib/kernel_lock.c:126!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: ipv6 fuse loop dm_mod sr_mod ehea cdrom sg ibmveth sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c0000000005c6dac LR: c0000000001965ac CTR: 0000000000000006
REGS: c00000002a5d3910 TRAP: 0700   Not tainted  (2.6.30-git10)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 82042442  XER: 00000000
TASK = c0000000407cbc20[9581] 'mount' THREAD: c00000002a5d0000 CPU: 3
<6>GPR00: 0000000000000001 c00000002a5d3b90 c000000000ef31f0 fffffffffffffff0 
<6>GPR04: c0000000000f0098 c000000000799813 0000000000000000 0000000000000001 
<6>GPR08: c000000000e36aa0 c0000000407cbc20 0000000000000002 c0000000407cbc20 
<6>GPR12: 0000000024042424 c000000000ff2a00 00000fffed50f6fd 00000fffed506e08 
<6>GPR16: 00000fffed506db8 000000001002b638 0000000000000000 0000000000000000 
<6>GPR20: 00000000100329a0 00000fffed506e0c c00000003e14b870 0000000000000000 
<6>GPR24: 0000000000000000 c00000002a030000 0000000000000000 0000000000000000 
<6>GPR28: c00000003e14b800 fffffffffffffff0 c000000000e7aa40 c00000002a5d3b90 
NIP [c0000000005c6dac] .unlock_kernel+0x20/0x78
LR [c0000000001965ac] .do_remount_sb+0x190/0x204
Call Trace:
[c00000002a5d3bd0] [c00000000019659c] .do_remount_sb+0x180/0x204
[c00000002a5d3c70] [c0000000001b8210] .do_mount+0x38c/0x9fc
[c00000002a5d3d60] [c0000000001b8940] .SyS_mount+0xc0/0x12c
[c00000002a5d3e30] [c000000000008534] syscall_exit+0x0/0x40
Instruction dump:
383f0040 ebc1fff0 ebe1fff8 4e800020 fbc1fff0 fbe1fff8 f821ffc1 7c3f0b78 
ebc2c0b8 e92d01b0 e809001e 78000fe0 <0b000000> e96d01b0 812b001c 3929ffff 
---[ end trace 3bf0012ad33d52b2 ]---

Corresponding c code is :

void __lockfunc unlock_kernel(void)
{
        BUG_ON(current->lock_depth < 0);  <<======
        if (likely(--current->lock_depth < 0))
                __unlock_kernel();

Have attached the cgroups regression test run log.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------080808090809040803080509
Content-Type: text/x-log;
 name="controller-run.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="controller-run.log"

cgroup_regression_test    1  PASS  :  no kernel bug was found
/ltp-full-20090531/testcases/bin/cgroup_regression_test.sh: line 102:  7036 Terminated              ./fork_processes
cgroup_regression_test    2  PASS  :  notify_on_release is inherited
cgroup_regression_test    3  PASS  :  no kernel bug was found
cgroup_regression_test    4  CONF  :  CONFIG_LOCKDEP is not enabled
cgroup_regression_test    5  PASS  :  no kernel bug was found
/ltp-full-20090531/testcases/bin/cgroup_regression_test.sh: line 253:  8781 Terminated              sleep 100
/ltp-full-20090531/testcases/bin/cgroup_regression_test.sh: line 325:  8800 Terminated              ./test_6_2
cgroup_regression_test    6  PASS  :  no kernel bug was found
------------[ cut here ]------------
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: ipv6 fuse loop dm_mod sr_mod ehea cdrom sg ibmveth sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c0000000005c6dac LR: c0000000001965ac CTR: 0000000000000006
REGS: c00000002a5d3910 TRAP: 0700   Not tainted  (2.6.30-git10)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 82042442  XER: 00000000
TASK = c0000000407cbc20[9581] 'mount' THREAD: c00000002a5d0000 CPU: 3
<6>GPR00: 0000000000000001 c00000002a5d3b90 c000000000ef31f0 fffffffffffffff0 
<6>GPR04: c0000000000f0098 c000000000799813 0000000000000000 0000000000000001 
<6>GPR08: c000000000e36aa0 c0000000407cbc20 0000000000000002 c0000000407cbc20 
<6>GPR12: 0000000024042424 c000000000ff2a00 00000fffed50f6fd 00000fffed506e08 
<6>GPR16: 00000fffed506db8 000000001002b638 0000000000000000 0000000000000000 
<6>GPR20: 00000000100329a0 00000fffed506e0c c00000003e14b870 0000000000000000 
<6>GPR24: 0000000000000000 c00000002a030000 0000000000000000 0000000000000000 
<6>GPR28: c00000003e14b800 fffffffffffffff0 c000000000e7aa40 c00000002a5d3b90 
NIP [c0000000005c6dac] .unlock_kernel+0x20/0x78
LR [c0000000001965ac] .do_remount_sb+0x190/0x204
Call Trace:
[c00000002a5d3bd0] [c00000000019659c] .do_remount_sb+0x180/0x204
[c00000002a5d3c70] [c0000000001b8210] .do_mount+0x38c/0x9fc
[c00000002a5d3d60] [c0000000001b8940] .SyS_mount+0xc0/0x12c
[c00000002a5d3e30] [c000000000008534] syscall_exit+0x0/0x40
Instruction dump:
383f0040 ebc1fff0 ebe1fff8 4e800020 fbc1fff0 fbe1fff8 f821ffc1 7c3f0b78 
ebc2c0b8 e92d01b0 e809001e 78000fe0 <0b000000> e96d01b0 812b001c 3929ffff 
---[ end trace 3bf0012ad33d52b2 ]---
/ltp-full-20090531/testcases/bin/cgroup_regression_test.sh: line 347:  9581 Trace/breakpoint trap   mount -t cgroup -o remount xxx cgroup/ 2> /dev/null
/ltp-full-20090531/testcases/bin/cgroup_regression_test.sh: line 363:  9579 Terminated              sleep 100 < cgroup/0
Cannot create link /etc/mtab~
Perhaps there is a stale lock file?

Cannot create link /etc/mtab~
Perhaps there is a stale lock file?


--------------080808090809040803080509--
