Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZFOJzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZFOJzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZFOJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:55:28 -0400
Received: from sith.mimuw.edu.pl ([193.0.96.4]:29328 "EHLO sith.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZFOJzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:55:25 -0400
Date: Mon, 15 Jun 2009 11:55:28 +0200
From: Jan Rekorajski <baggins@sith.mimuw.edu.pl>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090615095528.GG4379@sith.mimuw.edu.pl>
Mail-Followup-To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
	Valerie Aurora <vaurora@redhat.com>, Jan Blunck <jblunck@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
	mszeredi@suse.cz
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <20090521125419.GM30663@sith.mimuw.edu.pl> <20090608195752.GD4363@fsbox> <20090608224406.GA6801@sith.mimuw.edu.pl> <20090608224831.GF24586@fsbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608224831.GF24586@fsbox>
X-Operating-System: Linux 2.6.29.4 x86_64
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jun 2009, Valerie Aurora wrote:

> On Tue, Jun 09, 2009 at 12:44:06AM +0200, Jan Rekorajski wrote:
> > On Mon, 08 Jun 2009, Valerie Aurora wrote:
> > 
> > > You'll get -EBUSY on the second mount of any NFS file system over
> > > another - try it again with the --union flag.  Support for NFS on NFS
> > > union mount would have to change this.
> > 
> > I did just that, --union didn't change standard NFS behaviour.
> 
> Er, excuse me - I mean to type "try it again WITHOUT the --union
> flag."  My apologies!

I did, see below.

> > 
> > mount -t nfs server:/export/system /mnt
> > mount --union -t nfs server:/export/profile /mnt
> > mount.nfs: /mnt is busy or already mounted
> > 
> > I did an experiment by using different IP of the server (same machine)
> > when mounting the second fs, mount worked then, but 'ls -1 /mnt' oopsed.
> > I can reproduce this and send you the oops next week.
> 
> Interesting!  Does this happen without the --union flag?

Filesystems are exported ro, all mounts nfs3,ro,tcp.

Without --union:

mount -t nfs 10.1.0.4:/nfs/system /mnt -oro,nolock,vers=3,tcp
OK

mount -t nfs 10.1.0.4:/nfs/profile /mnt -oro,nolock,vers=3,tcp
-EBUSY (as expected)

mount -t nfs 10.1.0.3:/nfs/profile /mnt -oro,nolock,vers=3,tcp
 (notice different IP - but it's the same machine)
Works, just overmounts /mnt, ls shown contents of /nfs/profile

Now, --union:

mount -t nfs 10.1.0.4:/nfs/system /mnt -oro,nolock,vers=3,tcp
OK

mount --union -t nfs 10.1.0.4:/nfs/profile /mnt -oro,nolock,vers=3,tcp
-EBUSY (/mnt busy or already mounted)

mount --union -t nfs 10.1.0.3:/nfs/profile /mnt -oro,nolock,vers=3,tcp
 (notice different IP - but it's the same machine)
mount command works, ls Oopses:

[   61.766392] creating fallthru for opt
[   61.766417] BUG: unable to handle kernel NULL pointer dereference at (null)
[   61.766433] IP: [<(null)>] (null)
[   61.766482] *pdpt = 000000001e0e9001 *pde = 0000000000000000 
[   61.767324] Oops: 0010 [#1] PREEMPT SMP 
[   61.767324] last sysfs file: /sys/kernel/uevent_seqnum
[   61.767324] Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc sch_sfq thermal processor thermal_sys rtc_cmos rtc_core i2c_piix4 e1000 ac psmouse rtc_lib hwmon pcspkr button i2c_core sg sr_mod serio_raw evdev cdrom
[   61.767324] 
[   61.767324] Pid: 2460, comm: ls Not tainted (2.6.29.3 #1) VirtualBox
[   61.767324] EIP: 0060:[<00000000>] EFLAGS: 00010286 CPU: 0
[   61.767324] EIP is at 0x0
[   61.767324] EAX: df6d23c0 EBX: df69d1b0 ECX: e105d3e0 EDX: df69d630
[   61.767324] ESI: df69d630 EDI: de16d300 EBP: de1b1d18 ESP: de1b1d04
[   61.767324]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
[   61.767324] Process ls (pid: 2460, ti=de1b0000 task=de0ee3f0 task.ti=de1b0000)
[   61.767324] Stack:
[   61.767324]  c02d03d9 c054f57d df69d698 00000002 00000000 de1b1d7c e10357f0 00000002
[   61.767324]  00000000 0180677d 00000000 0000000a c02d0340 df69d1b0 00000000 00000002
[   61.767324]  0180677d 00000000 df6d2128 de16d300 de1b1f08 de1b1f08 df69d5a0 de1b1ed4
[   61.767324] Call Trace:
[   61.767324]  [<c02d03d9>] union_copyup_dir_one+0x99/0xc0
[   61.767324]  [<e10357f0>] nfs_do_filldir+0x210/0x570 [nfs]
[   61.767324]  [<c02d0340>] union_copyup_dir_one+0x0/0xc0
[   61.767324]  [<e1036072>] nfs_readdir+0x522/0xa10 [nfs]
[   61.767324]  [<c02d0340>] union_copyup_dir_one+0x0/0xc0
[   61.767324]  [<c0293502>] __mem_cgroup_commit_charge+0x42/0x100
[   61.767324]  [<c0293c07>] mem_cgroup_charge_common+0x57/0x70
[   61.767324]  [<e1039f18>] __put_nfs_open_context+0x28/0xb0 [nfs]
[   61.767324]  [<e0a6fbe2>] rpcauth_lookup_credcache+0x152/0x1f0 [sunrpc]
[   61.767324]  [<e0a6f92d>] rpcauth_lookupcred+0x5d/0xb0 [sunrpc]
[   61.767324]  [<e1049c10>] nfs3_decode_dirent+0x0/0x220 [nfs]
[   61.767324]  [<c02d0ad1>] union_copyup_dir+0x111/0x160
[   61.767324]  [<c02a6190>] filldir64+0x0/0x110
[   61.767324]  [<c02a6575>] vfs_readdir+0xd5/0xf0
[   61.767324]  [<c02a65fd>] sys_getdents64+0x6d/0xc0
[   61.767324]  [<c02033da>] syscall_call+0x7/0xb
[   61.767324] Code:  Bad EIP value.
[   61.767324] EIP: [<00000000>] 0x0 SS:ESP 0068:de1b1d04
[   61.816597] ---[ end trace 60fb13bae2f23426 ]---

-- 
Jan Rekorajski            |  ALL SUSPECTS ARE GUILTY. PERIOD!
baggins<at>mimuw.edu.pl   |  OTHERWISE THEY WOULDN'T BE SUSPECTS, WOULD THEY?
BOFH, MANIAC              |                   -- TROOPS by Kevin Rubio
