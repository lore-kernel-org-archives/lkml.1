Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZETW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZETW17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZETW1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:27:54 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:41690 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZETW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:27:52 -0400
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: nfsroot on multiple-e1000e serial-over-LAN system -> deadlock?
References: <87k54cu8z5.fsf@hades.wkstn.nix>
From: Nix <nix@esperi.org.uk>
Emacs: a real time environment for simulating molasses-based life forms.
Date: Wed, 20 May 2009 23:27:43 +0100
In-Reply-To: <87k54cu8z5.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "19 May 2009 22:25:17 +0100")
Message-ID: <874ovfv28w.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(e1000-devel, this is with an 82574L in 100Mb/s mode and upstream git
up-to-date as of a couple of days ago. Your driver works, modulo a small
patch and some unpleasant screaming in the log on boot: the in-tree one
doesn't work.)

On 19 May 2009, nix@esperi.org.uk uttered the following:
> But then I come to a machine with multiple NICs and IPMI, and things
> fall over. I have to manually specify the NIC to use or it goes into a
> DHCP-probing deadlock (cause undiagnosed but it looks identical to this
> one so may be identical): but if I give the NIC info by hand, I *still*
> see a deadlock:
>
> [   89.613880] IP-Config: Complete:
> [   89.616943]      device=eth0, addr=192.168.14.15, mask=255.255.255.0, gw=192.168.14.1,
> [   89.624921]      host=spindle, domain=, nis-domain=(none),
> [   89.630430]      bootserver=192.168.14.18, rootserver=192.168.14.18, rootpath=
> [   90.333195] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> [   90.340668] 0000:03:00.0: eth0: 10/100 speed: disabling TSO
> [  325.182384] INFO: task swapper:1 blocked for more than 120 seconds.
> [  325.188653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  325.196473] swapper       D 00000014     0     1      0
> [  325.201766]  f7061eec 00000046 dd66aa4a 00000014 00000000 00000000 00000000 c05d1480
> [  325.209749]  c05d1480 00000000 00000000 f705ec40 f705eed4 c2805480 00000000 ded7f8e3
> [  325.217743]  00000014 00000000 c0548160 00000000 00000000 00000000 00000000 f705eed4
> [  325.225742] Call Trace:
> [  325.228202]  [<c0408ebc>] schedule+0x8/0x17
> [  325.232391]  [<c0408fa6>] schedule_timeout+0x17/0x164
> [  325.237454]  [<c01346d1>] ? __wake_up+0x31/0x3b
> [  325.241987]  [<c040844e>] wait_for_common+0xaa/0xfc
> [  325.246872]  [<c013ae99>] ? default_wake_function+0x0/0xd
> [  325.252271]  [<c0408512>] wait_for_completion+0x12/0x14
> [  325.257498]  [<c014d003>] flush_cpu_workqueue+0x59/0x62
> [  325.262720]  [<c014ced7>] ? wq_barrier_func+0x0/0xd
> [  325.267605]  [<c014d177>] flush_workqueue+0x2b/0x49
> [  325.272485]  [<c014d1a2>] flush_scheduled_work+0xd/0xf
> [  325.277626]  [<c0585578>] kernel_init+0x10e/0x152
> [  325.282340]  [<c058546a>] ? kernel_init+0x0/0x152
> [  325.287045]  [<c011d8cf>] kernel_thread_helper+0x7/0x10
>
> Its cause is unclear.

sysrq-t suggests a cause:

[  257.002484] ksoftirqd/3   R running      0    13      2
[  257.007778]  00000000 00000000 00000040 f70aff8c f683205c f62d04c4 f62d03c0 00000040
[  257.015744]  00000000 f70aff68 c0317c79 00000246 f62d04c4 f62d03c0 00000040 f62d04c4
[  257.023704]  00000040 00000000 f70aff8c c03aae90 c28330f8 c283310c ffffcf91 000000ac
[  257.031659] Call Trace:
[  257.034113]  [<c0317c79>] ? e1000_clean+0x5f/0x1f5
[  257.038909]  [<c03aae90>] ? net_rx_action+0x57/0x100
[  257.043876]  [<c0144567>] ? __do_softirq+0x121/0x129
[  257.048836]  [<c0144595>] ? do_softirq+0x26/0x2b
[  257.053451]  [<c01445e7>] ? ksoftirqd+0x4d/0xb7
[  257.057988]  [<c014459a>] ? ksoftirqd+0x0/0xb7
[  257.062435]  [<c014fece>] ? kthread+0x45/0x6b
[  257.066796]  [<c014fe89>] ? kthread+0x0/0x6b
[  257.071068]  [<c011d8cf>] ? kernel_thread_helper+0x7/0x10

Isn't e1000_clean supposed to be really fast? Hanging for many seconds
seems wrong.


... but whatever the bug was, it's fixed in the out-of-tree e1000e
0.5.18.3, which works. Being a daredevil sort and also doing an nfsroot
boot without initramfs I built it statically: this worked fine.

Why is the e1000e in the kernel tree based on such an old driver, anyway
(version 0.3.3.4 according to DRV_VERSION in netdev.c)?

All is not well with the out-of-tree driver, though: 0.5.18.3 doesn't
even build without the patch below, and screams loudly in the log at
startup, e.g.:

[   93.041327] irq event 57: bogus return value f70b5eb4
[   93.046871] Pid: 0, comm: swapper Not tainted 2.6.30-rc6-00114-g583172f-dirty #9
[   93.054952] Call Trace:
[   93.057649]  [<c01662fa>] __report_bad_irq+0x2e/0x6f
[   93.063098]  [<c0166395>] note_interrupt+0x5a/0x149
[   93.068428]  [<c01668ab>] handle_edge_irq+0xdd/0x106
[   93.073879]  [<c011e7ae>] handle_irq+0x1a/0x20
[   93.078731]  [<c011e210>] do_IRQ+0x40/0x83
[   93.083230]  [<c011d4e9>] common_interrupt+0x29/0x30
[   93.088673]  [<c01400d8>] ? copy_process+0xe91/0xea8
[   93.094125]  [<c02b7e12>] ? acpi_idle_enter_c1+0xc8/0xd1
[   93.099940]  [<c02b7ede>] acpi_idle_enter_bm+0xc3/0x296
[   93.105661]  [<c0368dd3>] ? menu_select+0x39/0x9a
[   93.110816]  [<c0368386>] cpuidle_idle_call+0x60/0x92
[   93.116197]  [<c011c192>] cpu_idle+0x44/0x5e
[   93.120874]  [<c05ae8f2>] start_secondary+0x1b6/0x1be

(that's the *last* such message: the first scrolled out of the kernel
log, even with LOG_BUF_SHIFT of 16. Not ideal.)

The message is mystifying, as every single IRQ handler in e1000e
0.5.18.3 returns REQUEST_IRQ or IRQ_NONE, so the message looks spurious
to me. (But then so does the 'incompatible pointer type' compilation
warning kicked up for argument 2 of every call to request_irq() in the
driver, so I'm obviously missing something because I doubt GCC is lying
here. But the prototypes look compatible to me...)


Vile patch to build with 2.6.30rc: obviously not suitable, but what's
mystifying is that the change that added the network namespace parameter
to __dev_get_by_name() is *old*, introduced in
881d966b48b035ab3f3aeaae0f3d3f9b584f45b2 in 2007! How has the e1000e
driver been building since then? Plainly it *has* for other people, but
I don't see how...

(This patch probably would not be necessary if only I could find the
e1000e development tree to match the development kernel, but after much
searching of the mailing list archives via MARC's vile interface I have
found no clue as to where e1000e development actually happens. Some git
tree somewhere, presumably, but the only one I found a reference to was
one of Auke Kok's from 2006, which is gone. I hate out-of-tree drivers
sometimes.)

--- e1000e-0.5.18.3-orig/src/kcompat_ethtool.c       2009-03-05 18:43:14.000000000 +0000
+++ e1000e-0.5.18.3/src//kcompat_ethtool.c        2009-05-20 21:28:02.000000000 +0100
@@ -54,6 +54,7 @@
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <asm/uaccess.h>
+#include <net/net_namespace.h>

 #include "kcompat.h"

@@ -782,7 +783,7 @@
 #define ETHTOOL_OPS_COMPAT
 int ethtool_ioctl(struct ifreq *ifr)
 {
-       struct net_device *dev = __dev_get_by_name(ifr->ifr_name);
+       struct net_device *dev = __dev_get_by_name(&init_net, ifr->ifr_name);
        void *useraddr = (void *) ifr->ifr_data;
        u32 ethcmd;
