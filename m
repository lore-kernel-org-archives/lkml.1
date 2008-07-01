Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYGAJQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYGAJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYGAJQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:16:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:3565 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYGAJQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=CQCwSLO4mx9niTnl+xyzzJ4PhbzfqbIFS3xay7utLTP3CX8OCrBx/cF+F8rhqvb+Zf
         q5DAs/8QFIdKPwCVYZKytvAACWdv1jeJ83bq//BYQ07/HDNYCjakSWEVirASK8Xk8/b9
         dHzaE2nPhgMo/zYp9G9kWhgDYDYmG3FezBD2s=
Message-ID: <19f34abd0807010216k11a60382xf7a27b4b27f0819@mail.gmail.com>
Date: Tue, 1 Jul 2008 11:16:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: netdev@vger.kernel.org
Subject: kmemcheck detected possible information leak to userspace?
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running kmemcheck on -tip gives me the following warning:

kmemcheck: Caught 32-bit read from uninitialized memory (c72daa2e)
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiuuuuiiiiuuuuuuuuuu
                                              ^

Pid: 1345, comm: dhclient3 Tainted: G        W
(2.6.26-rc8-tip-00186-ga644034 #60)
EIP: 0060:[<c028dd63>] EFLAGS: 00000206 CPU: 0
EIP is at __copy_user_intel+0x43/0xb0
EAX: 00000000 EBX: 0000024e ECX: 000000ce EDX: 00000000
ESI: c72da992 EDI: bff8e2f8 EBP: c68abd90 ESP: c0823f88
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: c68a0328 CR3: 06899000 CR4: 00000690
DR0: c0b98b7c DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: 00004000 DR7: 00000000
 [<c028de27>] __copy_to_user_ll+0x57/0x60
 [<c028e3f8>] copy_to_user+0x48/0x60
 [<c04ade71>] memcpy_toiovec+0x41/0x60
 [<c04ae461>] skb_copy_datagram_iovec+0x131/0x1e0
 [<c05325c7>] packet_recvmsg+0xa7/0x1b0
 [<c04a5aa3>] sock_aio_read+0xf3/0x100
 [<c01a7c7d>] do_sync_read+0xcd/0x110
 [<c01a8556>] vfs_read+0x126/0x130
 [<c01a89ed>] sys_read+0x3d/0x70
 [<c0104017>] sysenter_past_esp+0x78/0xc5
 [<ffffffff>] 0xffffffff

..which is a bit worrying, because it means that we are copying
uninitialized data into userspace, i.e. this could be a data leak.
Most likely it's not very critical, but it would be nice to fix
anyway.

Relevant source lines are:

$ addr2line -e vmlinux -i c04ade71 # memcpy_toiovec
net/core/iovec.c:87

$ addr2line -e vmlinux -i c04ae461 # skb_copy_datagram_iovec
net/core/datagram.c:277

$ addr2line -e vmlinux -i c05325c7 # packet_recvmsg
net/packet/af_packet.c:1093


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
