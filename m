Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab0BDTtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:49:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:56890 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758406Ab0BDTts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:49:48 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19QiclVLVtQpf3gt2H81t1jXbtiG1p1b96suGZUZE
	RS9tKmcz+Roowy
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: hadi@cyberus.ca
Subject: Re: patch net-restore-ip-source-validation.patch added to 2.6.32-stable tree
Date: Thu, 4 Feb 2010 20:49:29 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-sidux-686; KDE/4.3.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
References: <1265060041850@kroah.org> <201002041931.40493.s.L-H@gmx.de> <1265308725.4651.14.camel@bigi>
In-Reply-To: <1265308725.4651.14.camel@bigi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002042049.31582.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 04 February 2010, jamal wrote:
> On Thu, 2010-02-04 at 19:31 +0100, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Thursday 04 February 2010, jamal wrote:
> 
> > > ----
> > >         NET_IPV4_CONF_ARP_ACCEPT=21,
> > >         NET_IPV4_CONF_ARP_NOTIFY=22,
> > >         NET_IPV4_CONF_ACCEPT_LOCAL=23,
> > >         NET_IPV4_CONF_SRC_VMARK=24,
> > >         __NET_IPV4_CONF_MAX
> > > ---
> > > 
> > > I have a feeling you are missing NET_IPV4_CONF_ACCEPT_LOCAL
> > 
> > Yes, you're 100% right - such a hunk is missing from queue-2.6.32 [1]
> > 
> 
> Do you mind changing to NET_IPV4_CONF_SRC_VMARK=23 in that patch?
> As i mentioned in my other email it is a wild guess - so it likely will
> have no effect but worth a try if you have time.

just enumerating NET_IPV4_CONF_ACCEPT_LOCAL, without the actual 
implementation behind it, which only came with 

    commit 8ec1e0ebe26087bfc5c0394ada5feb5758014fc8
    Author: Patrick McHardy <kaber@trash.net>
    Date:   Thu Dec 3 12:16:35 2009 +0100

        ipv4: add sysctl to accept packets with local source addresses

        Change fib_validate_source() to accept packets with a local source address when
        the "accept_local" sysctl is set for the incoming inet device. Combined with the
        previous patches, this allows to communicate between multiple local interfaces
        over the wire.

        Signed-off-by: Patrick McHardy <kaber@trash.net>

    Signed-off-by: David S. Miller <davem@davemloft.net>

post 2.6.32 and hasn't made it into the stable tree either

--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -490,6 +490,7 @@ enum
 	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
 	NET_IPV4_CONF_ARP_ACCEPT=21,
 	NET_IPV4_CONF_ARP_NOTIFY=22,
+	NET_IPV4_CONF_ACCEPT_LOCAL=23,
 	NET_IPV4_CONF_SRC_VMARK=24,
 	__NET_IPV4_CONF_MAX
 };

isn't sufficient, 2.6.32.8-rc1 plus the suggested patch above fails to boot
as well (this time on amd64):

sysctl table check failed: /net/ipv4/conf/all/src_valid_mark .3.5.16.-2.24 Unknown sysctl binary path
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8132c54e>] inetdev_init+0x7e/0x230
PGD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.32-7.slh.6-sidux-amd64 #1 MS-7185
RIP: 0010:[<ffffffff8132c54e>]  [<ffffffff8132c54e>] inetdev_init+0x7e/0x230
RSP: 0018:ffff88007fb7bdb0  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88007f091200 RCX: 0000000000000000
RDX: ffff88007f0912c0 RSI: ffffffff814fd0c0 RDI: ffff88007f136800
RBP: ffff88007f136800 R08: 0000000000000000 R09: ffff88007f091200
R10: 0000000000000014 R11: 0000000000000000 R12: ffff88007f091200
R13: 0000000000000000 R14: 000000000008c000 R15: ffffffff81674340
FS:  0000000000000000(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88007fb7a000, task ffff88007fb80000)
Stack:
 ffffffff8142498a ffff88007f136800 0000000000000000 0000000000000005
<0> 0000000000000000 ffffffff8132cad8 0000000000000000 0000000000000000
<0> ffffffff8151c1c4 ffffffff814fdba0 ffffffff81674340 ffffffff814fdc20
Call Trace:
 [<ffffffff8132cad8>] ? inetdev_event+0x3d8/0x490
 [<ffffffff812d1714>] ? register_netdevice_notifier+0x94/0x1b0
 [<ffffffff81568c9c>] ? inet_init+0x0/0x1ff
 [<ffffffff81568c53>] ? devinet_init+0x2d/0x76
 [<ffffffff81568404>] ? ip_rt_init+0x1a2/0x287
 [<ffffffff81568c9c>] ? inet_init+0x0/0x1ff
 [<ffffffff81568620>] ? ip_init+0x9/0x14
 [<ffffffff81568dd5>] ? inet_init+0x139/0x1ff
 [<ffffffff8100a044>] ? do_one_initcall+0x34/0x1a0
 [<ffffffff81534701>] ? kernel_init+0x157/0x1ad
 [<ffffffff810130da>] ? child_rip+0xa/0x20
 [<ffffffff815345aa>] ? kernel_init+0x0/0x1ad
 [<ffffffff810130d0>] ? child_rip+0x0/0x20
Code: 48 85 db 49 89 dc 0f 84 e7 00 00 00 48 8b 85 c8 03 00 00 48 8d 93 c0 00 00 00 48 c7 c6 c0 d0 4f 81 48 89 ef 48 8b 80 e0 01 00 00 <48> 8b 08 48 89 8b c0 00 00 00 48 8b 48 08 48 89 4a 08 48 8b 48
RIP  [<ffffffff8132c54e>] inetdev_init+0x7e/0x230
 RSP <ffff88007fb7bdb0>
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.32-7.slh.6-sidux-amd64 #1
Call Trace:
 [<ffffffff81374cc6>] ? panic+0x8a/0x146
 [<ffffffff8105e106>] ? do_exit+0x6e6/0x800
 [<ffffffff81016a53>] ? oops_end+0xa3/0xf0
 [<ffffffff8103b05a>] ? no_context+0xfa/0x260
 [<ffffffff81063f32>] ? __register_sysctl_paths+0x352/0x360
 [<ffffffff81378395>] ? page_fault+0x25/0x30
 [<ffffffff8132c54e>] ? inetdev_init+0x7e/0x230
 [<ffffffff8132cad8>] ? inetdev_event+0x3d8/0x490
 [<ffffffff812d1714>] ? register_netdevice_notifier+0x94/0x1b0
 [<ffffffff81568c9c>] ? inet_init+0x0/0x1ff
 [<ffffffff81568c53>] ? devinet_init+0x2d/0x76
 [<ffffffff81568404>] ? ip_rt_init+0x1a2/0x287
 [<ffffffff81568c9c>] ? inet_init+0x0/0x1ff
 [<ffffffff81568620>] ? ip_init+0x9/0x14
 [<ffffffff81568dd5>] ? inet_init+0x139/0x1ff
 [<ffffffff8100a044>] ? do_one_initcall+0x34/0x1a0
 [<ffffffff81534701>] ? kernel_init+0x157/0x1ad
 [<ffffffff810130da>] ? child_rip+0xa/0x20
 [<ffffffff815345aa>] ? kernel_init+0x0/0x1ad
 [<ffffffff810130d0>] ? child_rip+0x0/0x20

Regards
	Stefan Lippers-Hollmann
