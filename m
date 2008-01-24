Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYAXGKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYAXGKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYAXGJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:09:54 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40254 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbYAXGJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:09:53 -0500
Message-ID: <47982BB3.7090803@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2008 11:39:55 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel oops on CIFS while running fsstress
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The machine drops into xmon, while running the fsstress
on the cifs mounted partition.

1:mon> r
R00 = 0000000000000000   R16 = 0000000000000000
R01 = c00000017527f910   R17 = 0000000000000000
R02 = d000000000862258   R18 = 0000000000000000
R03 = 0000000000000001   R19 = 0000000000000000
R04 = 0000000000000001   R20 = c00000013999fcb0
R05 = 0000000000000000   R21 = c00000013c589978
R06 = 0000000000000000   R22 = c00000015a9e6e00
R07 = 0000000000000001   R23 = c0000001786dfdf0
R08 = 0000000000000000   R24 = c00000018b5a7f50
R09 = c00000019012ff08   R25 = c00000017527fc10
R10 = 0000000000000001   R26 = 000000000000477d
R11 = c0000000003d4f90   R27 = c00000013999fcb0
R12 = d0000000008323e8   R28 = c00000017527fc10
R13 = c000000000572380   R29 = c0000001504afdf0
R14 = 0000000000000000   R30 = d000000000860168
R15 = 0000000000000000   R31 = d00000000085a338
pc  = d000000000819e04 .find_writable_file+0x8c/0x1c0 [cifs]
lr  = d000000000819de0 .find_writable_file+0x68/0x1c0 [cifs]
msr = 8000000000009032   cr  = 24000888
ctr = c0000000003d4f90   xer = 0000000000000000   trap =  300
dar = c00000019012ff30   dsisr = 40010000
1:mon> t
[c00000017527f9b0] d00000000081f808 .cifs_setattr+0x178/0xb04 [cifs]
[c00000017527fae0] c0000000001202e4 .notify_change+0x1e0/0x414
[c00000017527fba0] c000000000101e2c .do_truncate+0x74/0xa8
[c00000017527fc80] c000000000102170 .sys_truncate+0x1c8/0x21c
[c00000017527fdb0] c000000000015f2c .compat_sys_truncate64+0x18/0x30
[c00000017527fe30] c000000000008734 syscall_exit+0x0/0x40
--- Exception: c00 (System Call) at 000000000ff2620c
SP (ff87f070) is in userspace
1:mon> e
cpu 0x1: Vector: 300 (Data Access) at [c00000017527f690]
    pc: d000000000819e04: .find_writable_file+0x8c/0x1c0 [cifs]
    lr: d000000000819de0: .find_writable_file+0x68/0x1c0 [cifs]
    sp: c00000017527f910
   msr: 8000000000009032
   dar: c00000019012ff30
 dsisr: 40010000
  current = 0xc00000018761f640
  paca    = 0xc000000000572380
    pid   = 12920, comm = fsstress


The gdb output 

(gdb) p find_writable_file
$1 = {struct cifsFileInfo *(struct cifsInodeInfo *)} 0x19d78 <find_writable_file>
(gdb) p/x 0x19d78+0x68
$3 = 0x19de0
(gdb) l *0x19de0
0x19de0 is in find_writable_file (fs/cifs/file.c:1079).
1074                    cERROR(1, ("Null inode passed to cifs_writeable_file"));
1075                    dump_stack();
1076                    return NULL;
1077            }
1078
1079            read_lock(&GlobalSMBSeslock);
1080    refind_writable:
1081            list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
1082                    if (open_file->closePend)
1083                            continue;
(gdb) 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
