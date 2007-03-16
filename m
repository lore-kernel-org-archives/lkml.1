Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXCPUIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXCPUIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXCPUIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:08:13 -0400
Received: from 1wt.eu ([62.212.114.60]:1206 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbXCPUIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:08:12 -0400
Date: Fri, 16 Mar 2007 21:08:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: Grzegorz Ja?kiewicz <gryzman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pcap app causes kernel panic on 2.4.33.3 right after "NETDEV WATCHDOG: eth1: transmit timed out"
Message-ID: <20070316200807.GA14656@1wt.eu>
References: <2f4958ff0703120410j321c88a0pad91f78778520fc8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f4958ff0703120410j321c88a0pad91f78778520fc8@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grzegorz,

you were right to resend, I did not catch your first email.
Sorry about that.

On Mon, Mar 12, 2007 at 12:10:19PM +0100, Grzegorz Ja?kiewicz wrote:
> Hi folks.
> 
> I have a simple program, that analyzes ethernet packets. Counting
> traffic on from/to basis, and dumping that informatio nevery minute.
> Everything is cleared - in terms of memory, valgrind doesn't complain
> a bit.
> 
> But once every 2-3 days the router on which the software is running,
> freezes. It is clear kernel panic.

Well, you speak about a freeze then a kernel panic. How can you ensure
it's a kernel panic if you only see a freeze ? I mean, there can be a
deadlock somewhere causing a freeze without necessarily a panic,
eventhough you have a oops.

> Before that panic occurs, I have "NETDEV WATCHDOG: eth1: transmit
> timed out" . always right before crash.

This is not good. Generally it implies stuck transceiver or interrupt.
What driver is this ?

> I am sure, the software doesn't have memleaks. Everything in pcap was
> programmed according with examples, and double checked - but I can
> give source away on request.

I don't think it is a memleak either. You would have seen messages like
"Out Of Memory - killing process".

> I think the problem must lay somewhere between pcap and kernel (the
> "transmit timed out" message sounds too dodgee, and it is always there
> right before crash - only).

I even would not accuse pcap because a deadlock, oops or panic always
find its roots in the kernel or lower (hardware).

So please send your config, explain a bit what your router and/or
program is doing before the crash. For instance, I see traces of
udp_sendmsg() in your oops, from a process named "postmaster".
Is it your network analyzer's name ? it sounds like a postfix process,
which is not clear to me as to what it does on a network analyzer. If
it is postfix, it is possible then that the UDP packet trying to go
out is DNS resolving ?

If this is the case, does your router still crash when you disable pcap ?
Is it possible to use another interface / another driver for outgoing
traffic ?

I'm sorry, but a single oops out of any context is a bit hard to
investigate. So please return lsmod, dmesg, config, processes and
any information which can help.

Regards,
Willy

> Oops:
> 
> Unable to handle kernel paging request at virtual address 909fe955
> c013b582
> *pde = 00000000
> Oops: 0000
> CPU:   0
> eax: 909fe93d  ebx: 00000001 ecx: 909fe93d  edx: 00000000
> esi: cf4e6d90  edi: 00000000 ebp: 00000000  esp: c3701c58
> ds: 0018   es: 0018  ss: 0018
> Process postmaster (pid:3838, stackpage=c3701000)
> Stack: c031a7ec 00000000 cf4e6d80 cf4e6d80 c031a847 cf4e6d80 c3701c94 
> cf4e6d80
>        c7ad6810 c031a9ae cf4e6d80 00000000 cf4e6d80 c0339a6d cf4e6d80 
>        c031f187
>        00000000 c0468a5c 00000046 c0468a6c 00000246 cf4e6d80 cfd03740 
>        00000000
> Call Trace:    [<c031a7ec>] [<c031a847>] [<c031a9ae>] [<c0339a6d>] 
> [<c031f187>]
>   [<c031f70e>] [<c031f810>] [<c031f97f>] [<c0122586>] [<c033cad0>] 
>   [<c0329c28>]
>   [<c033cad0>] [<c033e58f>] [<c033cad0>] [<c035dfe2>] [<c035dc50>] 
>   [<c01868dd>]
>   [<c017e6fb>] [<c03169e4>] [<c03167bc>] [<c0317be4>] [<c018bbb8>] 
>   [<c0186d68>]
>   [<c0186e9c>] [<c0317c53>] [<c0318637>] [<c0108eff>]
> Code: 8b 40 18 f6 c4 40 75 0b f0 ff 49 14 0f 94 c0 84 c0 75 01 c3
> Using defaults from ksymoops -t elf32-i386 -a i386
> 
> 
> >>esi; cf4e6d90 <_end+f026bf8/10603ec8>
> >>esp; c3701c58 <_end+3241ac0/10603ec8>
> 
> Trace; c031a7ec <skb_release_data+4c/90>
> Trace; c031a847 <kfree_skbmem+17/80>
> Trace; c031a9ae <__kfree_skb+fe/160>
> Trace; c0339a6d <ip_rcv+ad/4e0>
> Trace; c031f187 <netif_rx+97/1f0>
> Trace; c031f70e <netif_receive_skb+20e/270>
> Trace; c031f810 <process_backlog+a0/140>
> Trace; c031f97f <net_rx_action+cf/180>
> Trace; c0122586 <do_softirq+76/e0>
> Trace; c033cad0 <output_maybe_reroute+0/10>
> Trace; c0329c28 <.text.lock.netfilter+b6/ce>
> Trace; c033cad0 <output_maybe_reroute+0/10>
> Trace; c033e58f <ip_build_xmit+3af/440>
> Trace; c033cad0 <output_maybe_reroute+0/10>
> Trace; c035dfe2 <udp_sendmsg+232/4a0>
> Trace; c035dc50 <udp_getfrag+0/100>
> Trace; c01868dd <journal_dirty_metadata+15d/220>
> Trace; c017e6fb <ext3_do_update_inode+19b/450>
> Trace; c03169e4 <sock_sendmsg+74/d0>
> Trace; c03167bc <sockfd_lookup+1c/90>
> Trace; c0317be4 <sys_sendto+f4/130>
> Trace; c018bbb8 <log_wait_commit+68/b0>
> Trace; c0186d68 <journal_stop+168/230>
> Trace; c0186e9c <journal_force_commit+6c/90>
> Trace; c0317c53 <sys_send+33/40>
> Trace; c0318637 <sys_socketcall+167/280>
> Trace; c0108eff <system_call+33/38>
> 
> Code;  00000000 Before first symbol
> 00000000 <_EIP>:
> Code;  00000000 Before first symbol
>   0:   8b 40 18                  mov    0x18(%eax),%eax
> Code;  00000003 Before first symbol
>   3:   f6 c4 40                  test   $0x40,%ah
> Code;  00000006 Before first symbol
>   6:   75 0b                     jne    13 <_EIP+0x13>
> Code;  00000008 Before first symbol
>   8:   f0 ff 49 14               lock decl 0x14(%ecx)
> Code;  0000000c Before first symbol
>   c:   0f 94 c0                  sete   %al
> Code;  0000000f Before first symbol
>   f:   84 c0                     test   %al,%al
> Code;  00000011 Before first symbol
>  11:   75 01                     jne    14 <_EIP+0x14>
> Code;  00000013 Before first symbol
>  13:   c3                        ret
> 
> <0>Kernel panic: Aiee, killing interrupt handler!
> 
> 
> -- 
> GJ
> 
> MOTD: gocr sux so much, words can't describe
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
