Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZKQAVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZKQAVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZKQAVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:21:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51357 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882AbZKQAVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:21:15 -0500
Message-Id: <1258417281.1921.1345554581@webmail.messagingengine.com>
X-Sasl-Enc: bvpGpm/8DHUaNNsGDMFTIrRViW7GfSnYa0KaYHMPfaxv 1258417281
From: myuboot@fastmail.fm
To: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <4AFA6B7F.10404@walsimou.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
 <1257898975.30125.1344591929@webmail.messagingengine.com>
 <4AFA6B7F.10404@walsimou.com>
Subject: problem bring up initramfs and busybox
Date: Mon, 16 Nov 2009 18:21:21 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been struggling to bring up a MIPS 32 board with busybox with or
without initramfs.
The kernel stucks there without the shell coming up.

[    1.153000] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
[    1.161000] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.167000] TCP cubic registered
[    1.170000] NET: Registered protocol family 17
[   25.971000] Freeing unused kernel memory: 1032k freed
[   39.969000] Algorithmics/MIPS FPU Emulator v1.5


What I tried here is to use initramfs with statically linked busybox.
The initramfs seems to be up, and runs the commands in the /init one by
one, and then it goes to a inifite loop in r4k_wait at
arch/mips/kernel/genex.S.

The following is the execution sequense when it runs /init. Can anyone
give me some idea what is wrong?

Thanks, Andrew


Breakpoint 2, do_execve (filename=0x9780a000 "/bin/sh", argv=0x4f73a4,
envp=0x4f73ac, regs=0x97997f30) at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.

Breakpoint 2, do_execve (filename=0x9780a000 "/sbin/switch_root",
argv=0x4f7450, envp=0x4f7464, regs=0x97819f30) at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.

Breakpoint 2, do_execve (filename=0x9780a000 "/usr/sbin/switch_root",
argv=0x4f7450, envp=0x4f7464, regs=0x97819f30) at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.

Breakpoint 2, do_execve (filename=0x9780a000 "/bin/switch_root",
argv=0x4f7450, envp=0x4f7464, regs=0x97819f30) at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.

Breakpoint 2, do_execve (filename=0x9780a000 "/usr/bin/switch_root",
argv=0x4f7450, envp=0x4f7464, regs=0x97819f30) at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.
^C
Program received signal SIGSTOP, Stopped (signal).
r4k_wait () at arch/mips/kernel/genex.S:147
147             jr      ra

-- And here is the content of /init script - 
#!/bin/busybox sh

# Mount the /proc and /sys filesystems.
mount -t proc none /proc
mount -t sysfs none /sys

mdev -s
/bin/sh

# Do your stuff here.
echo "This script mounts rootfs and boots it up, nothing more!"

# Mount the root filesystem.
mount -o ro /dev/mtdblock4 /mnt/root

# Clean up.
umount /proc
umount /sys

# Boot the real thing.
exec switch_root /mnt/root /sbin/init
