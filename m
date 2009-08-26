Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZHZIIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZHZIIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZHZIIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:08:37 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43797 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZHZIIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:08:35 -0400
Message-ID: <4A94ED74.6000200@gmail.com>
Date: Wed, 26 Aug 2009 10:08:20 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [kmemcheck] WARNING: kmemcheck: Caught 32-bit read from 	uninitialized
 memory, in sock_init_data()
References: <20090826055659.GA6066@elte.hu> <19f34abd0908260013n4e701796j90fb2b1ab74495de@mail.gmail.com>
In-Reply-To: <19f34abd0908260013n4e701796j90fb2b1ab74495de@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 26 Aug 2009 10:08:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum a écrit :
> 2009/8/26 Ingo Molnar <mingo@elte.hu>:
>> -tip testing found another kmemcheck warning:
>>
>> calling  netlink_proto_init+0x0/0x1b0 @ 1
>> NET: Registered protocol family 16
>> initcall netlink_proto_init+0x0/0x1b0 returned 0 after 39062 usecs
>> calling  olpc_init+0x0/0x110 @ 1
>> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f5c38304)
>> 0100000002000000000000000000000000000000ad4eaddeffffffffffffffff
>>  i i i i i i u u i i i i i i i i i i i i i i i i i i i i i i i i
>>         ^
>>
>> Pid: 1, comm: swapper Not tainted (2.6.31-rc7-tip-01170-gaaea9cf-dirty #24) P4DC6
>> EIP: 0060:[<c15c8ab1>] EFLAGS: 00010286 CPU: 0
>> EIP is at sock_init_data+0xe1/0x220
>> EAX: 0001b000 EBX: f606196c ECX: 00000000 EDX: c1a148d2
>> ESI: f6061800 EDI: f5c38300 EBP: f606ef0c ESP: c1ceb9ac
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> CR0: 8005003b CR2: f60a8108 CR3: 01a61000 CR4: 000006f0
>> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> DR6: ffff4ff0 DR7: 00000400
>>  [<c15fac15>] __netlink_create+0x35/0xa0
>>  [<c15fd01a>] netlink_kernel_create+0x5a/0x180
>>  [<c15df55e>] rtnetlink_net_init+0x1e/0x50
>>  [<c15d130a>] register_pernet_operations+0x6a/0xf0
>>  [<c15d14fe>] register_pernet_subsys+0x1e/0x30
>>  [<c1b3d84c>] rtnetlink_init+0x4c/0x100
>>  [<c1b3e105>] netlink_proto_init+0x105/0x1b0
>>  [<c1001037>] do_one_initcall+0x27/0x170
>>  [<c1afea97>] kernel_init+0x157/0x210
>>  [<c10039a7>] kernel_thread_helper+0x7/0x10
>>  [<ffffffff>] 0xffffffff
>> initcall olpc_init+0x0/0x110 returned 0 after 0 usecs
>> calling  bdi_class_init+0x0/0x40 @ 1
>>
>> config attached.
> 
> Thanks. AFAICT, it's this one:
> 
> 1816 void sock_init_data(struct socket *sock, struct sock *sk)
> 1817 {
> ...
> 1835         sock_set_flag(sk, SOCK_ZAPPED);

Are you sure it is not the 16 bit padding in 'struct sock', after 'type' field ?

struct socket {
	socket_state        state;
	short           type;
// here, a 16 bits hole
	unsigned long       flags;

the warning is strange since I suspect it happens here :

    if (sock) {
<<>>	sk->sk_type =   sock->type; // here, kmemcheck warning while reading sock->type
	sk->sk_sleep    =   &sock->wait;
	sock->sk    =   sk;

and sock->type is a 16 bit field, correctly initialized (with value = 2)
(Yes the hole, right after, is not initialized)

WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f5c38304)
0100000002000000000000000000000000000000ad4eaddeffffffffffffffff
 i i i i i i u u i i i i i i i i i i i i i i i i i i i i i i i i





> 
> Which sort of makes sense, given all the trouble we've had with bitfields/flags.
> 
> Is it possible that struct sock's sk_flags is (partially)
> uninitialized at this point?
> 
> I'll investigate more later, lecture of statistics is about to begin.
> 
> 
> Vegard
>
