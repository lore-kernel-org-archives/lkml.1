Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZFVChj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZFVChj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 22:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZFVChc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 22:37:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZFVChb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 22:37:31 -0400
Date: Sun, 21 Jun 2009 19:37:09 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-cachefs@redhat.com
Subject: CacheFiles: Readpage failed on backing file
Message-ID: <alpine.DEB.2.01.0906211926080.6439@bogon>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+ydK5BdD699jjbt+TMptqFCMwYcZXmKMf2Eqg
 XkrlvKQ0M/owJRPiv7W1jKf6f68DBGzrXhldzuV/sphgezVqTm
 /s2+4ownVGt5cXRJot28Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

excited that the cachefiles made it into mainline, I've mounted an NFS 
share with "-o fsc". After a clean reboot, I only need to read some files 
off the NFS mount to get the following trace:

[  399.332262] Pid: 709, comm: kslowd Tainted: G        W  2.6.30 #1
[  399.332275] Call Trace:
[  399.332288]  [<ffffffff811e2e5b>] ? __wait_on_bit+0x6b/0x80
[  399.332301]  [<ffffffffa00c67b6>] ? cachefiles_read_waiter+0x96/0xe0 [cachefiles]
[  399.332314]  [<ffffffff8100dc70>] ? check_events+0x12/0x22
[  399.332322]  [<ffffffff81028100>] ? __wake_up_common+0x50/0x80
[  399.332330]  [<ffffffff8102814c>] ? __wake_up+0x1c/0x30
[  399.332338]  [<ffffffff81040a33>] ? __wake_up_bit+0x23/0x30
[  399.332346]  [<ffffffff810da03a>] ? ext3_truncate+0x26a/0x9e0
[  399.332354]  [<ffffffff8100dc0c>] ? xen_irq_enable_direct+0xc/0x13
[  399.332362]  [<ffffffff810e943a>] ? journal_stop+0x17a/0x240
[  399.332370]  [<ffffffff8100d5d9>] ? xen_force_evtchn_callback+0x9/0x10
[  399.332377]  [<ffffffff8100dc70>] ? check_events+0x12/0x22
[  399.332385]  [<ffffffff8106cbf5>] ? vmtruncate+0xa5/0x110
[  399.332393]  [<ffffffff81098b0e>] ? inode_setattr+0x2e/0x170
[  399.332400]  [<ffffffff810d735f>] ? ext3_setattr+0xff/0x230
[  399.332407]  [<ffffffff81098d5e>] ? notify_change+0x10e/0x350
[  399.332414]  [<ffffffff8100dc5d>] ? xen_restore_fl_direct_end+0x0/0x1
[  399.332424]  [<ffffffffa00c35ec>] ? cachefiles_attr_changed+0xec/0x190 [cachefiles]
[  399.332434]  [<ffffffffa00c3caf>] ? cachefiles_lookup_object+0x5f/0x110 [cachefiles]
[  399.332450]  [<ffffffffa005a1c0>] ? fscache_lookup_object+0x80/0x150 [fscache]
[  399.332461]  [<ffffffffa005aabe>] ? fscache_object_slow_work_execute+0x58e/0x670 [fscache]
[  399.332472]  [<ffffffff81057b2d>] ? slow_work_thread+0x2ed/0x430
[  399.332480]  [<ffffffff81040a80>] ? autoremove_wake_function+0x0/0x30
[  399.332488]  [<ffffffff81057840>] ? slow_work_thread+0x0/0x430
[  399.332495]  [<ffffffff810405f6>] ? kthread+0x96/0xa0
[  399.332502]  [<ffffffff8102afcd>] ? T.831+0x2d/0x80
[  399.332510]  [<ffffffff81010a8a>] ? child_rip+0xa/0x20
[  399.332517]  [<ffffffff810105db>] ? retint_restore_args+0x5/0x6
[  399.332525]  [<ffffffff811846a0>] ? datagram_poll+0x0/0xe0
[  399.332533]  [<ffffffff811846a0>] ? datagram_poll+0x0/0xe0
[  399.332539]  [<ffffffff81010a80>] ? child_rip+0x0/0x20
[  399.332608] CacheFiles: I/O Error: Readpage failed on backing file 4000000000000810
[  399.332617] FS-Cache: Cache cachefiles stopped due to I/O error


This is reproducible with a current (-git) vanilla kernel, 
cachefilesd-0.9-2 (Debian/unstable) in a 64 bit Xen DomU.

I've seen a simlar thing reported on the linux-cachefs list in May:
http://www.redhat.com/archives/linux-cachefs/2009-May/msg00018.html

...where the backtrace looks similar, but mine has some Xen stuff in 
between. Full dmesg & .config and /proc bits are here:
    http://nerdbynature.de/bits/2.6.30/

Thanks,
Christian.
-- 
BOFH excuse #55:

Plumber mistook routing panel for decorative wall fixture
