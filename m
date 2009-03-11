Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZCKN5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZCKN5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZCKN5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:57:21 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:58437 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752427AbZCKN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:57:20 -0400
Subject: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
From: Laurent GUERBY <laurent@guerby.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 14:57:12 +0100
Message-Id: <1236779832.11347.2082.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14067837861572582936
X-Ovh-Remote: 79.90.156.46 (46.156.90-79.rev.gaoland.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.29-rc5 (on an ARM platform but I don't think it's significant)
when I try to enable swap on a file which is on an USB mounted vfat
partition the swapon syscall gets stuck:

swapon        D c03780d4     0 22361      1
[<c0377db0>] (schedule+0x0/0x3ac) from [<c0378e50>] (__mutex_lock_slowpath+0x94/0xf4)
[<c0378dbc>] (__mutex_lock_slowpath+0x0/0xf4) from [<c0378c40>] (mutex_lock+0x20/0x24)
 r6:df49e808 r5:00000000 r4:00000000
[<c0378c20>] (mutex_lock+0x0/0x24) from [<c013bb2c>] (_fat_bmap+0x28/0x68)
[<c013bb04>] (_fat_bmap+0x0/0x68) from [<c00af910>] (bmap+0x2c/0x40)
 r6:0005ffff r5:00000000 r4:00000000
[<c00af8e4>] (bmap+0x0/0x40) from [<c0094b84>] (sys_swapon+0x630/0xcbc)
 r5:c0541510 r4:00300000
[<c0094554>] (sys_swapon+0x0/0xcbc) from [<c0029960>] (ret_fast_syscall+0x0/0x2c)

Looking around in the kernel sources it looks like the inode mutex is
taken both by mm/swapfile.c and by fs/fat/inode.c, the latter one since
this patch from november 2008:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa93ca18a8b0da4e26bd9491ad144cd14d22f8ec

When I use a loopback device on the very same file the swapon call works
so there's an easy workaround for this issue.

Sincerely,

Laurent
http://guerby.org/blog

