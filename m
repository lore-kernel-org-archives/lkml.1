Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZHZHNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZHZHNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbZHZHNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:13:33 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61238 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbZHZHNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UdPsZwAqlJnaBAB/J0U9AphKytw7p7/vDGh2PbZa+JExTkl5ABU/9wGgaVDIe13NnU
         sE1zXoM87Daqe8LdjhvwQ85FpxJiVDtU6pmXVkkFXSrS9ZEWsGmNb7lCEtVTh2mTo6Q4
         T2DUYPl21ph3WiulpPg1Ev/tAcqDG2mA0ZfDA=
MIME-Version: 1.0
In-Reply-To: <20090826055659.GA6066@elte.hu>
References: <20090826055659.GA6066@elte.hu>
Date: Wed, 26 Aug 2009 09:13:31 +0200
Message-ID: <19f34abd0908260013n4e701796j90fb2b1ab74495de@mail.gmail.com>
Subject: Re: [kmemcheck] WARNING: kmemcheck: Caught 32-bit read from 
	uninitialized memory, in sock_init_data()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/26 Ingo Molnar <mingo@elte.hu>:
>
> -tip testing found another kmemcheck warning:
>
> calling  netlink_proto_init+0x0/0x1b0 @ 1
> NET: Registered protocol family 16
> initcall netlink_proto_init+0x0/0x1b0 returned 0 after 39062 usecs
> calling  olpc_init+0x0/0x110 @ 1
> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f5c38304)
> 0100000002000000000000000000000000000000ad4eaddeffffffffffffffff
>  i i i i i i u u i i i i i i i i i i i i i i i i i i i i i i i i
>         ^
>
> Pid: 1, comm: swapper Not tainted (2.6.31-rc7-tip-01170-gaaea9cf-dirty #24) P4DC6
> EIP: 0060:[<c15c8ab1>] EFLAGS: 00010286 CPU: 0
> EIP is at sock_init_data+0xe1/0x220
> EAX: 0001b000 EBX: f606196c ECX: 00000000 EDX: c1a148d2
> ESI: f6061800 EDI: f5c38300 EBP: f606ef0c ESP: c1ceb9ac
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: f60a8108 CR3: 01a61000 CR4: 000006f0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
>  [<c15fac15>] __netlink_create+0x35/0xa0
>  [<c15fd01a>] netlink_kernel_create+0x5a/0x180
>  [<c15df55e>] rtnetlink_net_init+0x1e/0x50
>  [<c15d130a>] register_pernet_operations+0x6a/0xf0
>  [<c15d14fe>] register_pernet_subsys+0x1e/0x30
>  [<c1b3d84c>] rtnetlink_init+0x4c/0x100
>  [<c1b3e105>] netlink_proto_init+0x105/0x1b0
>  [<c1001037>] do_one_initcall+0x27/0x170
>  [<c1afea97>] kernel_init+0x157/0x210
>  [<c10039a7>] kernel_thread_helper+0x7/0x10
>  [<ffffffff>] 0xffffffff
> initcall olpc_init+0x0/0x110 returned 0 after 0 usecs
> calling  bdi_class_init+0x0/0x40 @ 1
>
> config attached.

Thanks. AFAICT, it's this one:

1816 void sock_init_data(struct socket *sock, struct sock *sk)
1817 {
...
1835         sock_set_flag(sk, SOCK_ZAPPED);

Which sort of makes sense, given all the trouble we've had with bitfields/flags.

Is it possible that struct sock's sk_flags is (partially)
uninitialized at this point?

I'll investigate more later, lecture of statistics is about to begin.


Vegard
