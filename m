Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbZJGPnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbZJGPnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759436AbZJGPnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:43:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52037 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327AbZJGPnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:43:22 -0400
Message-ID: <4ACCB6BE.5040602@gmail.com>
Date: Wed, 07 Oct 2009 17:41:50 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Takahiro Yasui <tyasui@redhat.com>,
       Hideo Aoki <haoki@redhat.com>
Subject: Re: [Bug #14301] WARNING: at net/ipv4/af_inet.c:154
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.mdH.sMTxKB@chimera> <4AC70D20.4060009@gmail.com> <4AC710DF.5070705@gmail.com> <4AC78F7C.40908@gmail.com>
In-Reply-To: <4AC78F7C.40908@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 07 Oct 2009 17:41:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Eric Dumazet a écrit :
>>> Rafael J. Wysocki a écrit :
>>>> This message has been generated automatically as a part of a report
>>>> of regressions introduced between 2.6.30 and 2.6.31.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>>>> be listed and let me know (either way).
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14301
>>>> Subject		: WARNING: at net/ipv4/af_inet.c:154
>>>> Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
>>>> Date		: 2009-09-30 12:24 (2 days old)
>>>> References	: http://marc.info/?l=linux-kernel&m=125431350218137&w=4
>>>>
> 
> Investigation still needed...
> 

OK, my last (buggy ???) feeling is about commit 95766fff6b9a78d1

[UDP]: Add memory accounting.

(Its a two years old patch, oh well...)

Problem is the udp_poll() :

We check the first frame to be dequeued from sk_receive_queue has a good checksum.

If it doesnt, we drop the frame ( calling kfree_skb(skb); )

Problem is now we perform memory accounting on UDP, this kfree_skb()
should be done with socket locked, but we are allowed to
call lock_sock() from this udp_poll() context

unsigned int udp_poll(struct file *file, struct socket *sock, poll_table *wait)
{
        unsigned int mask = datagram_poll(file, sock, wait);
        struct sock *sk = sock->sk;
        int     is_lite = IS_UDPLITE(sk);

        /* Check for false positives due to checksum errors */
        if ((mask & POLLRDNORM) &&
            !(file->f_flags & O_NONBLOCK) &&
            !(sk->sk_shutdown & RCV_SHUTDOWN)) {
                struct sk_buff_head *rcvq = &sk->sk_receive_queue;
                struct sk_buff *skb;

                spin_lock_bh(&rcvq->lock);
                while ((skb = skb_peek(rcvq)) != NULL &&
                       udp_lib_checksum_complete(skb)) {
                        UDP_INC_STATS_BH(sock_net(sk),
                                        UDP_MIB_INERRORS, is_lite);
                        __skb_unlink(skb, rcvq);
<<HERE>>                kfree_skb(skb);
                }
                spin_unlock_bh(&rcvq->lock);



David, Herbert, any idea how to solve this problem ?

1) Allow false positives

Or

2) Maybe we should finally convert sk_forward_alloc to an atomic_t after all...
   This would make things easier, and speedup UDP (no more need to lock_sock())

Or 

3) ???

