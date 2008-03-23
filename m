Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYCWJVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYCWJVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYCWJVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:21:32 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:49549 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYCWJVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:21:30 -0400
Date: Sun, 23 Mar 2008 10:21:26 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: IPv6 slab leak (was: Re: dst cache overflow)
Message-ID: <20080323092125.GB2950@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org> <20071216073533.GA2706@gondor.apana.org.au> <20071216083828.GA512@yamamaya.is-a-geek.org> <20080317012513.GA3139@yamamaya.is-a-geek.org> <20080318185914.GA9275@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080318185914.GA9275@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> 
> > just a reminder, the server is now running 2.6.24 and the leak is
> > still there.  I noticed there is a slab leak debug option and turned
> > it on, results should be visible in a few days I guess.
> 
> Current (20080318 19:42) biggest net-related numbers:
> 
> skbuff_head_cache: 1614 __alloc_skb+0x29/0x108
> ip_dst_cache: 1579 dst_alloc+0x25/0x5f
> skbuff_fclone_cache: 965 __alloc_skb+0x29/0x108
> size-512: 895 sock_wmalloc+0x2b/0x4d
> TCPv6: 856 sk_clone+0x14/0x16a
> size-2048: 733 tcp_sendmsg+0x174/0x9fc
> size-512: 279 sock_alloc_send_skb+0x7c/0x193
> size-512: 238 tcp_send_ack+0x2a/0xec
> size-512: 223 tcp_send_fin+0x60/0x12e
> sock_inode_cache: 172 sock_alloc_inode+0x10/0x4e
> size-1024: 147 sock_alloc_send_skb+0x7c/0x193

20080323 10:03
ip_dst_cache: 5556 dst_alloc+0x25/0x5f
skbuff_fclone_cache: 4668 __alloc_skb+0x29/0x108
TCPv6: 4113 sk_clone+0x14/0x16a
skbuff_head_cache: 3919 __alloc_skb+0x29/0x108
size-2048: 3662 tcp_sendmsg+0x174/0x9fc
size-512: 1126 sock_alloc_send_skb+0x7c/0x193
size-512: 990 tcp_send_ack+0x2a/0xec
size-512: 973 tcp_send_fin+0x60/0x12e
size-1024: 349 sock_alloc_send_skb+0x7c/0x193

http://tdiedrich.de/~ranma/slab_allocators.20080318
http://tdiedrich.de/~ranma/slab_allocators.20080319
http://tdiedrich.de/~ranma/slab_allocators.20080321
http://tdiedrich.de/~ranma/slab_allocators.20080323

http://tdiedrich.de/~ranma/slab-month-oni-20080323.png
http://tdiedrich.de/~ranma/route-month-oni-20080323.png

oni:~# ip route ls
217.172.187.0/24 dev eth0  proto kernel  scope link  src
217.172.187.75 
default via 217.172.187.1 dev eth0 
oni:~# ip -6 route ls
2001:6f8:900:aee::/64 via :: dev sixxs  metric 256  expires -152518sec mtu 1480 advmss 1420 hoplimit 4294967295
2001:6f8:1002::/64 via :: dev sixxs  metric 256  expires -152518sec mtu 1480 advmss 1420 hoplimit 4294967295
fe80::/64 dev eth0  metric 256  expires -552013sec mtu 1500 advmss 1440 hoplimit 4294967295
fe80::/64 via :: dev sixxs  metric 256  expires -152517sec mtu 1480 advmss 1420 hoplimit 4294967295
ff00::/8 dev eth0  metric 256  expires -552013sec mtu 1500 advmss 1440 hoplimit 4294967295
ff00::/8 dev sixxs  metric 256  expires -152517sec mtu 1480 advmss 1420 hoplimit 4294967295
default via 2001:6f8:900:aee::1 dev sixxs  metric 1  expires -152517sec mtu 1480 advmss 1420 hoplimit 4294967295
oni:~# uptime
 10:09:07 up 6 days,  9:20,  1 user,  load average: 0.14, 0.10, 0.08
oni:~# ip route ls cache | fgrep cache | wc -l
81
oni:~# cat /proc/net/stat/rt_cache 
entries  in_hit in_slow_tot in_slow_mc in_no_route in_brd
in_martian_dst in_martian_src  out_hit out_slow_tot out_slow_mc
gc_total gc_ignored gc_goal_miss gc_dst_overflow in_hlist_search
out_hlist_search
000015b5  0049feed 0035b5a2 00000000 00000000 00000006 00000000
00000001  00104e45 00017421 00000000 0001d440 0001090e 000007be
00000000 00124053 00018998 
oni:~# grep . /proc/sys/net/ipv4/route/*
/proc/sys/net/ipv4/route/error_burst:500
/proc/sys/net/ipv4/route/error_cost:100
grep: /proc/sys/net/ipv4/route/flush: Permission denied
/proc/sys/net/ipv4/route/gc_elasticity:8
/proc/sys/net/ipv4/route/gc_interval:60
/proc/sys/net/ipv4/route/gc_min_interval:0
/proc/sys/net/ipv4/route/gc_min_interval_ms:500
/proc/sys/net/ipv4/route/gc_thresh:2048
/proc/sys/net/ipv4/route/gc_timeout:300
/proc/sys/net/ipv4/route/max_delay:10
/proc/sys/net/ipv4/route/max_size:32768
/proc/sys/net/ipv4/route/min_adv_mss:256
/proc/sys/net/ipv4/route/min_delay:2
/proc/sys/net/ipv4/route/min_pmtu:552
/proc/sys/net/ipv4/route/mtu_expires:600
/proc/sys/net/ipv4/route/redirect_load:2
/proc/sys/net/ipv4/route/redirect_number:9
/proc/sys/net/ipv4/route/redirect_silence:2048
/proc/sys/net/ipv4/route/secret_interval:600
grep: /proc/sys/net/ipv6/route/flush: Permission denied
/proc/sys/net/ipv6/route/gc_elasticity:0
/proc/sys/net/ipv6/route/gc_interval:30
/proc/sys/net/ipv6/route/gc_min_interval:0
/proc/sys/net/ipv6/route/gc_min_interval_ms:500
/proc/sys/net/ipv6/route/gc_thresh:1024
/proc/sys/net/ipv6/route/gc_timeout:60
/proc/sys/net/ipv6/route/max_size:4096
/proc/sys/net/ipv6/route/min_adv_mss:12
/proc/sys/net/ipv6/route/mtu_expires:600
oni:~# netstat -an | wc -l
200
oni:~# cat /proc/net/sockstat
sockets: used 191
TCP: inuse 13 orphan 0 tw 14 alloc 27 mem 1
UDP: inuse 11
UDPLITE: inuse 0
RAW: inuse 0
FRAG: inuse 0 memory 0

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
