Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZIBP7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZIBP7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 11:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZIBP7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 11:59:17 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61826 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZIBP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 11:59:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Ciprian Docan <docan@eden.rutgers.edu>
Subject: Re: NULL pointer dereference
Date: Wed, 2 Sep 2009 17:59:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>
References: <Pine.SOC.4.64.0909020944510.21222@er3.rutgers.edu>
In-reply-To: <Pine.SOC.4.64.0909020944510.21222@er3.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021759.10772.elendil@planet.nl>
X-OriginalArrivalTime: 02 Sep 2009 15:59:12.0073 (UTC) FILETIME=[5027AB90:01CA2BE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding CCs.

The commit that introduced ima_counts_put is:

commit 94e5d714f604d4cb4cb13163f01ede278e69258b
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Fri Jun 26 14:05:27 2009 -0400
    integrity: add ima_counts_put (updated)

    This patch fixes an imbalance message as reported by J.R. Okajima.
    The IMA file counters are incremented in ima_path_check. If the
    actual open fails, such as ETXTBSY, decrement the counters to
    prevent unnecessary imbalance messages.

Possibly this has already been fixed by the following commit? It seems
unlikely though as that was a very early commit after -rc7 and the problem
kernel was -rc7.git2 (if I read the version correctly).

commit 53a7197aff20e341487fca8575275056fe1c63e5
Author: Eric Paris <eparis@redhat.com>
Date:   Wed Aug 26 14:56:48 2009 -0400
    IMA: iint put in ima_counts_get and put

    ima_counts_get() calls ima_iint_find_insert_get() which takes a reference
    to the iint in question, but does not put that reference at the end of the
    function.  This can lead to a nasty memory leak.

Cheers,
FJP

Ciprian Docan wrote:
> Hi,
> 
> I got the following in dmesg:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000ae
> IP: [<ffffffff8124701a>] ima_counts_put+0x34/0xb1
> PGD a05e1067 PUD a05e2067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.3/class
> CPU 1
> Modules linked in: fuse sit tunnel4 nfs fscache nfsd lockd nfs_acl
> auth_rpcgss exportfs autofs4 sunrpc ip6t_REJECT nf_conntrack_ipv6
> ip6table_filter ip6_tables ipv6 dm_multipath uinput snd_hda_codec_analog
> snd_hda_intel snd_hda_codec ppdev snd_hwdep snd_pcm parport_pc serio_raw
> dcdbas snd_timer iTCO_wdt iTCO_vendor_support parport wmi snd soundcore
> snd_page_alloc i2c_i801 usb_storage e1000e pata_acpi ata_generic i915 drm
> i2c_algo_bit i2c_core video output [last unloaded: speedstep_lib]
> Pid: 3898, comm: devkit-disks-da Not tainted
> 2.6.31-0.174.rc7.git2.fc12.x86_64 #1 OptiPlex 760
> RIP: 0010:[<ffffffff8124701a>]  [<ffffffff8124701a>]
> ima_counts_put+0x34/0xb1
> RSP: 0000:ffff8800a05f5d78  EFLAGS: 00010202
> RAX: ffff8800b8f34148 RBX: 0000000000000004 RCX: 00000000b7698c0f
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
> RBP: ffff8800a05f5da8 R08: ffff8800a05f5ce8 R09: ffff8800a05f5d18
> R10: 00000000b7698c0f R11: 0000000000000000 R12: 0000000000000024
> R13: 0000000000000000 R14: ffff8800a05f5e28 R15: fffffffffffffffa
> FS:  00007ff4a8490790(0000) GS:ffff880007bde000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000000ae CR3: 00000000a05e0000 CR4: 00000000000406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process devkit-disks-da (pid: 3898, threadinfo ffff8800a05f4000, task
> ffff8800a05f8000)
> Stack:
>   ffff8800a05f5da8 00000000b7698c0f 0000000000000024 0000000000008001
> <0> 0000000000000024 0000000000000000 ffff8800a05f5ef8 ffffffff8114e4b8
> <0> ffff8800a05f5dc8 ffffffffffffff9c ffff8800a05f5dd8 00000000b7698c0f
> Call Trace:
>   [<ffffffff8114e4b8>] do_filp_open+0x534/0x9f3
>   [<ffffffff810956f1>] ? lock_release_holdtime+0x3f/0x146
>   [<ffffffff811146c4>] ? might_fault+0x71/0xd9
>   [<ffffffff8115a407>] ? alloc_fd+0x125/0x14b
>   [<ffffffff8113f3f1>] do_sys_open+0x71/0x131
>   [<ffffffff8113f51e>] sys_open+0x33/0x49
>   [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
> Code: 48 83 ec 18 0f 1f 44 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 d8 31
> c0 83 3d 36 22 28 01 00 48 8b 47 08 89 f3 48 8b 78 50 74 5e <0f> b7 87 ae
> 00 00 00 25 00 f0 00 00 3d 00 80 00 00 75 4b e8 da
> RIP  [<ffffffff8124701a>] ima_counts_put+0x34/0xb1
>   RSP <ffff8800a05f5d78>
> CR2: 00000000000000ae
> ---[ end trace 027f1f2d55021c25 ]---
> 
> Kernel version is: 2.6.31-0.174.rc7.git2.fc12.x86_64 #1 SMP Mon Aug 24
> 23:25:34 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux, from F12 rawhide
> repository.
> 
> I am not sure what caused this, as it happened over night, and the machine
> was idle. The machine is still up and running, so if you need more
> information about it please let me know and I will try to provide them.
> 
> Thank you,
> --
>  Ciprian Docan
