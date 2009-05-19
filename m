Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZESVZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZESVZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZESVZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:25:04 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47106 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZESVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:25:02 -0400
X-Greylist: delayed 2973 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2009 17:25:01 EDT
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
Subject: nfsroot on multiple-NIC serial-over-LAN system -> deadlock?
From: Nix <nix@esperi.org.uk>
Emacs: because idle RAM is the Devil's playground.
Date: Tue, 19 May 2009 21:35:26 +0100
Message-ID: <87k54cu8z5.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-INFN-TO-Metrics: hades 1233; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.30rc (git head as of yesterday) and getting a bunch of
machines bootstrapped from the bare metal via PXE/pxelinux/nfsroot.
nfsroot plainly *works*, as I've got several machines booting happily.

But then I come to a machine with multiple NICs and IPMI, and things
fall over. I have to manually specify the NIC to use or it goes into a
DHCP-probing deadlock (cause undiagnosed but it looks identical to this
one so may be identical): but if I give the NIC info by hand, I *still*
see a deadlock:

[   89.613880] IP-Config: Complete:
[   89.616943]      device=eth0, addr=192.168.14.15, mask=255.255.255.0, gw=192.168.14.1,
[   89.624921]      host=spindle, domain=, nis-domain=(none),
[   89.630430]      bootserver=192.168.14.18, rootserver=192.168.14.18, rootpath=
[   90.333195] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   90.340668] 0000:03:00.0: eth0: 10/100 speed: disabling TSO
[  325.182384] INFO: task swapper:1 blocked for more than 120 seconds.
[  325.188653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  325.196473] swapper       D 00000014     0     1      0
[  325.201766]  f7061eec 00000046 dd66aa4a 00000014 00000000 00000000 00000000 c05d1480
[  325.209749]  c05d1480 00000000 00000000 f705ec40 f705eed4 c2805480 00000000 ded7f8e3
[  325.217743]  00000014 00000000 c0548160 00000000 00000000 00000000 00000000 f705eed4
[  325.225742] Call Trace:
[  325.228202]  [<c0408ebc>] schedule+0x8/0x17
[  325.232391]  [<c0408fa6>] schedule_timeout+0x17/0x164
[  325.237454]  [<c01346d1>] ? __wake_up+0x31/0x3b
[  325.241987]  [<c040844e>] wait_for_common+0xaa/0xfc
[  325.246872]  [<c013ae99>] ? default_wake_function+0x0/0xd
[  325.252271]  [<c0408512>] wait_for_completion+0x12/0x14
[  325.257498]  [<c014d003>] flush_cpu_workqueue+0x59/0x62
[  325.262720]  [<c014ced7>] ? wq_barrier_func+0x0/0xd
[  325.267605]  [<c014d177>] flush_workqueue+0x2b/0x49
[  325.272485]  [<c014d1a2>] flush_scheduled_work+0xd/0xf
[  325.277626]  [<c0585578>] kernel_init+0x10e/0x152
[  325.282340]  [<c058546a>] ? kernel_init+0x0/0x152
[  325.287045]  [<c011d8cf>] kernel_thread_helper+0x7/0x10

Its cause is unclear. I'd expect to see something like

 Looking up port of RPC 100003/2 on 192.168.14.18
 Looking up port of RPC 100005/1 on 192.168.14.18
 VFS: Mounted root (nfs filesystem) readonly on device 0:15.

at this point, but I don't. Just dead silence.

The boot parameters were:

 root=/dev/nfs ip=192.168.14.15:192.168.14.18:192.168.14.1:255.255.255.0:spindle:eth0:off nfsroot=/mnt/spindle-root console=ttyS0,115200

(IP addresses are definitely correct, and the interface name is
apparently correct because we can see it bring the link up in the kernel
messages: if I use the other interface name, there's no such chatter in
the log.)


(I'm using IPMI and a serial console, with the console redirected by
IPMI over the same NIC: but as this uses a distinct MAC --- hell, a
distinct processor --- it surely can't interfere. Can it?)


Any ideas? Am I missing something obvious? (Probably.)
