Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYBEIOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYBEIOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYBEIOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:14:11 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25590 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYBEIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:14:10 -0500
X-Greylist: delayed 1680 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 03:14:10 EST
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-kernel@vger.kernel.org
Subject: OOPS in sysctl.c
Date: Tue, 5 Feb 2008 08:45:58 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802050845.58691.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an embedded target (PXA255 based) where I have a nice
running kernel 2.6.15. Today I'm trying to get 2.6.24 running on
it. To get suspend/resume working, I had to add a patch from the
current development kernel, but after this things seemed to work
fine.

Unfortunately I can reproducibly trigger an OOPS. When I do
"ls /proc/sys" AFTER I suspended/resumed, I get this:

# ls /proc/sys
Unable to handle kernel NULL pointer dereference at virtual address 0000000c
pgd = c3e14000
[0000000c] *pgd=a3e22031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.24 #41)
PC is at sysctl_head_next+0x28/0x64
LR is at sysctl_head_next+0x20/0x64
pc : [<c0038be4>]    lr : [<c0038bdc>]    psr: 00000013
sp : c3e1bed0  ip : c3e1bed0  fp : c3e1bee0
r10: c3cfec00  r9 : 00000000  r8 : 00000000
r7 : c3e1bf14  r6 : c384ea2c  r5 : 00000000  r4 : 00000000
r3 : c01f6ffc  r2 : fffffffc  r1 : 00000000  r0 : 00000000
Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0000397f  Table: a3e14000  DAC: 00000015
Process ls (pid: 302, stack limit = 0xc3e1a258)
Stack: (0xc3e1bed0 to 0xc3e1c000)
bec0:                                     00000000 c3e1bf48 c3e1bee4 c00a4b80
bee0: c0038bc8 00000000 0000008f 00000000 00000004 c3cfec20 00000000 0000000d
bf00: c3c02540 c384ea2c c007cc08 c3e1bf74 c01f6ff8 00272c85 00000003 c01c9ef8
bf20: c3cfec00 c3845470 fffffffe c3e1bf74 c007cc08 c3e1a000 c38454d8 c3e1bf70
bf40: c3e1bf4c c007c860 c00a482c 00099128 00000000 00000400 fffffff7 c3cfec00
bf60: 40221000 c3e1bfa4 c3e1bf74 c007cdf0 c007c7fc 000991f8 000991e0 00000330
bf80: ffffffea 00000e58 00000000 00000e68 000000d9 c0024004 00000000 c3e1bfa8
bfa0: c0023e60 c007cd90 00000e58 00000000 00000003 00099128 00000400 00099128
bfc0: 00000e58 00000000 00000e68 00000000 00000400 00000000 40221000 bea9ed44
bfe0: 402232bc bea9ecf8 40196314 40196348 20000010 00000003 00000000 00000000
Backtrace:
[<c0038bbc>] (sysctl_head_next+0x0/0x64) from [<c00a4b80>] (proc_sys_readdir+0x360/0x394)
 r4:00000000
[<c00a4820>] (proc_sys_readdir+0x0/0x394) from [<c007c860>] (vfs_readdir+0x70/0x98)
[<c007c7f0>] (vfs_readdir+0x0/0x98) from [<c007cdf0>] (sys_getdents64+0x6c/0xc0)
[<c007cd84>] (sys_getdents64+0x0/0xc0) from [<c0023e60>] (ret_fast_syscall+0x0/0x2c)
 r8:c0024004 r7:000000d9 r6:00000e68 r5:00000000 r4:00000e58
Code: e2834004 ebffffe5 ea000008 e2442004 (e5923010)
---[ end trace e5f1dfd5727fedd3 ]---
Segmentation fault


Before suspend/resume the "ls /proc/sys" works as
expected. I tried to find the root cause, but could
so far only find a bandaid:

--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -1320,6 +1320,8 @@
                return head;
        next:
                tmp = tmp->next;
+               if (tmp == NULL)
+                       break;
                if (tmp == &root_table_header.ctl_entry)
                        break;
        }

Now the OOPS is gone. However, two problems remain:

* why the was the linked list thrashed in the first place?
* where are the missing file entries?

Because some entries are missing:

$ find /proc/sys >a
$ echo mem >/sys/power/state
$ find /proc/sys >b
$ diff a b
--- a   2008-02-04 15:36:36.000000000 +0100
+++ b   2008-02-04 15:36:36.000000000 +0100
@@ -26,20 +26,6 @@
 /proc/sys/kernel/randomize_va_space
 /proc/sys/kernel/maps_protect
 /proc/sys/kernel/poweroff_cmd
-/proc/sys/kernel/ostype
-/proc/sys/kernel/osrelease
-/proc/sys/kernel/version
-/proc/sys/kernel/hostname
-/proc/sys/kernel/domainname
-/proc/sys/kernel/shmmax
-/proc/sys/kernel/shmall
-/proc/sys/kernel/shmmni
-/proc/sys/kernel/msgmax
-/proc/sys/kernel/msgmni
-/proc/sys/kernel/msgmnb
-/proc/sys/kernel/sem
-/proc/sys/kernel/pty/max
-/proc/sys/kernel/pty/nr
 /proc/sys/vm/overcommit_memory
 /proc/sys/vm/panic_on_oom
 /proc/sys/vm/oom_kill_allocating_task
@@ -190,20 +176,6 @@
 /proc/sys/net/ipv4/neigh/lo/locktime
 /proc/sys/net/ipv4/neigh/lo/retrans_time_ms
 /proc/sys/net/ipv4/neigh/lo/base_reachable_time_ms
-/proc/sys/net/ipv4/neigh/eth0/mcast_solicit
-/proc/sys/net/ipv4/neigh/eth0/ucast_solicit
-/proc/sys/net/ipv4/neigh/eth0/app_solicit
-/proc/sys/net/ipv4/neigh/eth0/retrans_time
-/proc/sys/net/ipv4/neigh/eth0/base_reachable_time
-/proc/sys/net/ipv4/neigh/eth0/delay_first_probe_time
-/proc/sys/net/ipv4/neigh/eth0/gc_stale_time
-/proc/sys/net/ipv4/neigh/eth0/unres_qlen
-/proc/sys/net/ipv4/neigh/eth0/proxy_qlen
-/proc/sys/net/ipv4/neigh/eth0/anycast_delay
-/proc/sys/net/ipv4/neigh/eth0/proxy_delay
-/proc/sys/net/ipv4/neigh/eth0/locktime
-/proc/sys/net/ipv4/neigh/eth0/retrans_time_ms
-/proc/sys/net/ipv4/neigh/eth0/base_reachable_time_ms
 /proc/sys/net/ipv4/conf/lo/forwarding
 /proc/sys/net/ipv4/conf/lo/mc_forwarding
 /proc/sys/net/ipv4/conf/lo/accept_redirects
@@ -267,28 +239,6 @@
 /proc/sys/net/ipv4/conf/default/disable_policy
 /proc/sys/net/ipv4/conf/default/force_igmp_version
 /proc/sys/net/ipv4/conf/default/promote_secondaries
-/proc/sys/net/ipv4/conf/eth0/forwarding
-/proc/sys/net/ipv4/conf/eth0/mc_forwarding
-/proc/sys/net/ipv4/conf/eth0/accept_redirects
-/proc/sys/net/ipv4/conf/eth0/secure_redirects
-/proc/sys/net/ipv4/conf/eth0/shared_media
-/proc/sys/net/ipv4/conf/eth0/rp_filter
-/proc/sys/net/ipv4/conf/eth0/send_redirects
-/proc/sys/net/ipv4/conf/eth0/accept_source_route
-/proc/sys/net/ipv4/conf/eth0/proxy_arp
-/proc/sys/net/ipv4/conf/eth0/medium_id
-/proc/sys/net/ipv4/conf/eth0/bootp_relay
-/proc/sys/net/ipv4/conf/eth0/log_martians
-/proc/sys/net/ipv4/conf/eth0/tag
-/proc/sys/net/ipv4/conf/eth0/arp_filter
-/proc/sys/net/ipv4/conf/eth0/arp_announce
-/proc/sys/net/ipv4/conf/eth0/arp_ignore
-/proc/sys/net/ipv4/conf/eth0/arp_accept
-/proc/sys/net/ipv4/conf/eth0/disable_xfrm
-/proc/sys/net/ipv4/conf/eth0/disable_policy
-/proc/sys/net/ipv4/conf/eth0/force_igmp_version
-/proc/sys/net/ipv4/conf/eth0/promote_secondaries
-/proc/sys/net/unix/max_dgram_qlen
 /proc/sys/fs/inode-nr
 /proc/sys/fs/inode-state
 /proc/sys/fs/file-nr

Additional suspend/resume cycles don't eat more
file entries.
