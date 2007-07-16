Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbXGPQFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbXGPQFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbXGPQFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:05:24 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54528 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757708AbXGPQFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:05:23 -0400
Date: Mon, 16 Jul 2007 18:05:17 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sunrpc-related Oops in latest git
Message-ID: <20070716180517.21caad75@dhcp-255-175.norway.atmel.com>
In-Reply-To: <1184597534.11083.1.camel@heimdal.trondhjem.org>
References: <20070715170523.2bed7110@dhcp-255-175.norway.atmel.com>
	<1184597534.11083.1.camel@heimdal.trondhjem.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 10:52:14 -0400
Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> So you are saying that if you revert this patch, and only this patch,
> then it fixes nfsroot? (sorry, I tend not to trust git-bisect)

Reverting only that patch gives me the following error:

/home/hskinnemoen/git/linux/net/sunrpc/sched.c: In function ‘rpciod_killall’:
/home/hskinnemoen/git/linux/net/sunrpc/sched.c:974: error: ‘rpc_sched_lock’ undeclared (first use in this function)
/home/hskinnemoen/git/linux/net/sunrpc/sched.c:974: error: (Each undeclared identifier is reported only once
/home/hskinnemoen/git/linux/net/sunrpc/sched.c:974: error: for each function it appears in.)
/home/hskinnemoen/git/linux/net/sunrpc/sched.c:975: error: ‘all_clients’ undeclared (first use in this function)
/home/hskinnemoen/git/linux/net/sunrpc/sched.c:983: error: ‘client_kill_wait’ undeclared (first use in this function)
/home/hskinnemoen/git/linux/net/sunrpc/sched.c: At top level:
/home/hskinnemoen/git/linux/net/sunrpc/sched.c:992: error: expected identifier or ‘(’ before ‘if’

So I tried reverting 188fef11db "SUNRPC: Move rpc_register_client and
friends into net/sunrpc/clnt.c" as well, which resulted in a clean
build, but the same Oops. So I guess you're right that git bisect
didn't work in this case...

Or hang on...it still oopses in queue_work(), but this time it's not
in interrupt context. I've included it below as another data point.

Perhaps the problem isn't as reproducible as I thought, and some of my
good bisection points weren't good after all...

Håvard

IP-Config: Complete:
      device=eth0, addr=10.191.255.173, mask=255.255.254.0, gw=10.191.254.1,
     host=stk1000, domain=, nis-domain=(none),
     bootserver=10.191.255.175, rootserver=10.191.255.175, rootpath=
Looking up port of RPC 100003/2 on 10.191.255.175
Unable to handle kernel NULL pointer dereference at virtual address 00000000
ptbr = 901669d4 pgd = 00000000
Oops: Kernel access of bad area, sig: 11 [#1]
FRAME_POINTER chip: 0x01f:0x1e82 rev 2
Modules linked in:
PC is at queue_work+0x2a/0x34
LR is at __init_begin+0x70000000/0x1c
pc : [<9002159a>]    lr : [<00000000>]    Not tainted
sp : 901a1c9c  r12: 00000000  r11: 901e9640
r10: 901e9640  r9 : 901e9644  r8 : 901e9644
r7 : 901a1c9c  r6 : 901e9400  r5 : 00000000  r4 : 00000000
r3 : 901b45a0  r2 : 901e958c  r1 : 000186a3  r0 : 901a1e24
Flags: qvnZc
Mode bits: hrje....g
CPU Mode: Supervisor
Process: swapper [1] (task: 9019e000 thread: 901a0000)
Stack: (0x901a1c9c to 0x901a2000)
1c80:                                                                900216d8
1ca0: 901a1cb0 901e9400 00000000 00000000 900fa92c 901a1cc4 901e9400 00000000
1cc0: 00000000 900f9eaa 901a1cd8 00000001 901e9400 00000000 900f8c90 901a1cfc
1ce0: 901e9400 901b45a0 00000000 901b45a0 901a1e4c 000186a3 901a1e24 900fc1c4
1d00: 901a1d10 901b4608 00000000 00000000 900fc362 901a1d34 901b45a0 901b45a0
1d20: 00000000 900f9030 901a1e4c 000186a3 901a1e24 900f838c 901a1d50 00000000
1d40: 901b45a0 00000000 00000000 00000000 900f83f4 901a1d74 901eb300 901eb300
1d60: 00000000 901a1e98 00000002 000186a3 901a1e24 901019e8 901a1e5c 901eb300
1d80: 901eb300 00000000 00000000 000186a3 00000002 00000011 00000000 00000000
1da0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1dc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1de0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e20: 00000000 31302e31 39312e32 35352e31 37350035 00000001 00000001 00000000
1e40: 90158f88 901a1e6c 9000c7f0 90165e40 901a1d88 901a1d98 00000000 90007c24
1e60: 901a1ea8 9000c7f0 00000011 00000000 00000002 000186a3 9000d8b8 00000000
1e80: 000186a3 00000002 0000000a 000000bf 000000ff 000000af 0002006f 0abfffaf
1ea0: 00000000 901a1ebc 90007d58 901a1f60 00000011 00000001 00000000 9000c7ec
1ec0: 900199d8 9000d8b8 00000000 90191100 00000000 9004a68a 9004c5e2 901a1f4c
1ee0: 00000000 fffffffe 00000000 901955d0 9018f000 9000d8b8 00000000 9019507c
1f00: 90191100 93825d88 0000000c 9018f001 00000010 00000000 00000000 9000bd0d
1f20: 00000000 000000ff 00000000 9000d8b8 00000000 9000eb04 901a1f74 9000bd08
1f40: 00000080 00000000 0abffe01 9004c62a 901a1f70 9000bd54 00000000 00000000
1f60: 90000a18 901a1f84 901663c8 00000000 00000000 00000000 900199d8 9000d8b8
1f80: 00000000 90000b32 901a1f98 9000bd54 00000000 00000000 90000512 901a1fdc
1fa0: 901663b8 00000000 00000000 00000000 00000000 00000000 00400000 90010d20
1fc0: 90010d20 901a2000 00000000 00000000 00000000 00000000 00000000 900199d8
1fe0: 00000000 00000000 00000000 00000000 00000000 900199d8 9000037c 00000000
Call trace:
 [<900216d8>] queue_delayed_work+0x10/0x1c
 [<900fa92c>] xs_connect+0x94/0xa8
 [<900f9eaa>] xprt_connect+0xb2/0xc8
 [<900f8c90>] call_connect+0x60/0x74
 [<900fc1c4>] __rpc_execute+0x5c/0x1d4
 [<900fc362>] rpc_execute+0x1a/0x1c
 [<900f838c>] rpc_do_run_task+0x6c/0x80
 [<900f83f4>] rpc_call_sync+0x14/0x28
 [<901019e8>] rpcb_getport_sync+0xc4/0xf4
 [<90007c24>] root_nfs_getport+0x48/0x58
 [<90007d58>] nfs_root_data+0x124/0x240
 [<90000a18>] mount_root+0x10/0xb0
 [<90000b32>] prepare_namespace+0x7a/0xbc
 [<90000512>] kernel_init+0x196/0x1c0
 [<900199d8>] do_exit+0x0/0x534

Kernel panic - not syncing: Attempted to kill init!
