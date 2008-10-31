Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYJaNlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYJaNlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYJaNlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:41:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50340 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYJaNlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:41:36 -0400
Date: Fri, 31 Oct 2008 14:41:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Helge Deller <deller@gmx.de>, Jeroen Roovers <jer@gentoo.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 2.6.28-rc2: USB/INPUT: slab error in cache_alloc_debugcheck_after():
 double free?
In-Reply-To: <20081031044553.50882e86@epia.jer-c2.orkz.net>
Message-ID: <alpine.LRH.1.10.0810311437270.7585@twin.jikos.cz>
References: <200810310011.08618.deller@gmx.de> <20081031044553.50882e86@epia.jer-c2.orkz.net>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Helge Deller wrote:

> I noticed various slab errors with complete kernel crashes with my USB 
> keyboard/mouse on a 32bit parisc machine with both 2.6.28-rc1 and -rc2. 
> Kernel 2.6.27 was still OK.
[ ... ]

On Fri, 31 Oct 2008, Jeroen Roovers wrote:

> I am seeing the same USB problem but without the SLAB errors - [1] is
> the Gentoo bug report. The kernel boots fine with both USB keyboard and
> mouse detached.
[ ... ]
> [17179609.972000] IASQ: 00000000 00000000 IAOQ: 102f6a50 102f6a54
> [17179609.972000]  IIR: 0f40101c    ISR: 00000000  IOR: 00000000
> [17179609.972000]  CPU:        0   CR30: 8f86c000 CR31: 11111111
> [17179609.972000]  ORIG_R28: 0000000f
> [17179609.972000]  IAOQ[0]: strcmp+0x0/0x34
> [17179609.972000]  IAOQ[1]: strcmp+0x4/0x34
> [17179609.972000]  RP(r2): sysfs_find_dirent+0x34/0x50
> [17179609.972000] Backtrace:
> [17179609.972000]  [<101daa9c>] sysfs_find_dirent+0x34/0x50
> [17179609.972000]  [<101daad8>] __sysfs_add_one+0x20/0xc0
> [17179609.972000]  [<101dab8c>] sysfs_add_one+0x14/0x50
> [17179609.972000]  [<101db250>] create_dir+0x64/0xcc
> [17179609.972000]  [<101db2e4>] sysfs_create_dir+0x2c/0x5c
> [17179609.972000]  [<102f2cd0>] kobject_add_internal+0xb8/0x1b0
> [17179609.972000]  [<102f326c>] kobject_add+0x38/0x68
> [17179609.972000]  [<1035b2b0>] device_add+0xdc/0x55c
> [17179609.972000]  [<103d6930>] mousedev_create+0x17c/0x1f8
> [17179609.972000]  [<103d7284>] mousedev_connect+0x48/0x138
> [17179609.972000]  [<103d2b50>] input_attach_handler+0x6c/0xac
> [17179609.972000]  [<103d5014>] input_register_device+0x1a4/0x250
> [17179609.972000]  [<103dfe08>] hidinput_connect+0x308/0x3b40
> [17179609.972000]  [<103de5d4>] hid_connect+0x22c/0x2c0
> [17179609.972000]  [<103de740>] hid_device_probe+0xd8/0xfc
> [17179609.972000]  [<1035db94>] driver_probe_device+0xa4/0x198

What architecture is this, please?

If I understand the dump correctly, it bugs because strcmp() in 
sysfs_find_dirent() got somehow NULL pointer.

I am not able to reproduce this locally and I can't see what is going 
wrong here. Could you please try the patch below and send the dmesg 
output? (beware, it will produce quite some output volume). This might 
help us understand a little bit better what string goes NULL where, or 
what exactly is happening.
Thanks.

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..e14fb5f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -418,6 +418,9 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  */
 int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	printk(KERN_DEBUG "__sysfs_add_one\n");
+	printk(KERN_DEBUG "%s\n", acxt->parent_sd->s_name);
+	printk(KERN_DEBUG "%s\n", sd->s_name);
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
 		return -EEXIST;
 

-- 
Jiri Kosina
