Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYDKPOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYDKPOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYDKPOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:14:03 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:9852 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbYDKPOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oR2JZ3e6wu3SqWr84pwogyAyZbgmAHgW1GXPee9NR00KkAVkzrJjx5jaeKY5bodEYRkBKRP/xOg2qMAR5iTu+MXe/ZHy0MlvZi5PhUyRPYpLanJlM7zsKXMYfBTdgyiwCWosn/mTxUHdX6a7aSD5gq4t6VLOZ9I4Kxwsrh2eGeY=
Message-ID: <e4957ae10804110813y159019c1p84296058bcc769cf@mail.gmail.com>
Date: Fri, 11 Apr 2008 18:13:59 +0300
From: "Uladzislau Rezki" <urezki@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel Oops within Linux Fedore Core 5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

I am running linux Fedore Core 5 with 2.6.15 linux kernel.

So , the problem is that, while loading my own kernel module, kernel gets Oops.

---> usbfs
---> tmpfs
---> binfmt_misc
---> rpc_pipefs
---> autofs
Unable to handle kernel paging request at virtual address dead4ead
printing eip:
c7034018
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /class/net/sit0/address
Modules linked in: sb_show(U) ipv6 autofs4 hidp rfcomm l2cap bluetooth
sunrpc dm_mirror dm_mod video button battery ac lp parport_pc parport
floppy nvram sg i2c_piix4 pcnet32 mii i2c_core ext3 jbd mptspi
mptscsih sd_mod scsi_mod mptbase
CPU: 0
EIP: 0060:[<c7034018>] Not tainted VLI
EFLAGS: 00010282 (2.6.15-1.2054_FC5.root #1)
EIP is at sb_show_init+0x18/0x41 [sb_show]
eax: dead4ead ebx: c0344740 ecx: c5877d90 edx: c7006096
esi: c1304e00 edi: c57d2b68 ebp: c70065c8 esp: c3962e6c
ds: 007b es: 007b ss: 0068
Process insmod (pid: 1675, threadinfo=c3962000 task=c621d000)
Stack: <0>c57d2b58 c7006580 c0130506 0001027a 00000550 00000320
c7006580 00000000
00000000 00000000 00000000 00000000 00000000 00000000 c72205fc 00000000
c59e78c0 c721b8ec c721b5cc c721b914 c720b000 00000004 0000000a 00000000
Call Trace:
[<c0130506>] sys_init_module+0x1382/0x1514 [<c015240f>] do_sync_read+0xb8/0xf3
[<c01511f1>] nameidata_to_filp+0x19/0x28 [<c012a17b>]
autoremove_wake_function+0x0/0x2d
[<c014620e>] vma_link+0x4a/0xc2 [<c01c066e>] _atomic_dec_and_lock+0x22/0x2c
[<c0169c2e>] mntput_no_expire+0x11/0x6d [<c0102bc1>] syscall_call+0x7/0xb
Code: Bad EIP value.
Continuing in 1 seconds.

here is source:

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/mount.h>

static int __init
sb_show_init (void)
{
    struct super_block *init_sb = NULL;
    struct task_struct *init = NULL;
    struct list_head *list_sb = NULL;
    struct vfsmount *root_mnt;

    /*
     * The init_task struct describes
     * init process.
    */
    init = &init_task;
    root_mnt = init->fs->rootmnt;
    init_sb = root_mnt->mnt_sb;

    list_for_each(list_sb, &init_sb->s_list) {
        struct super_block *sb = sb_entry(list_sb);

        mutex_lock(&s->s_lock);
        printk(KERN_ERR "---> %s\n", sb->s_id);
        mutex_unlock(&s->s_lock);
    }

    return 0;
}

static void __exit
sb_show_exit (void)
{
    printk(KERN_ERR "By-by.\n");
}

I try just go through the list of super blocks and printing "s_id" as
a result get Oops. it works fine with 2.6.18/22/24 kernels. Maybe this
problem concerns just Fedore Core kernel? Or maybe my code is wrong?

thanks.
