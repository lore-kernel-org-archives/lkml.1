Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZKBRmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZKBRmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:42:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZKBRmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:42:01 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:58333 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbZKBRmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:42:00 -0500
Message-ID: <4AEF19EA.6020003@gmail.com>
Date: Mon, 02 Nov 2009 18:42:02 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AEEB6D2.7090505@gmail.com> <4AEEBAC6.7020308@gmail.com> <4AEED23A.7070009@gmail.com> <4AEEDBBC.40800@gmail.com> <4AEF1534.4090506@gmail.com>
In-Reply-To: <4AEF1534.4090506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 02 Nov 2009 18:42:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> Eric Dumazet wrote:
>> Large part of network code is run by softirq handler, and a softirq
>> handler
>> is not preemptable with another softirq (including itself).
>>
> Thank you.  That's helpful to know, as some existing locks have a "bh".
> I've never figured out the ip_local_deliver_finish() context.
> 
> Knowing that there can only be one instance of the tcp stack running at
> any one time, and the cpu never changes even after being interrupted, will
> make it much easier to code.

Correction :

There is one instance of sofirq handler running per cpu.

So TCP (or UDP) stack can run simultaneously on several (and eventually all online) cpus.

This is why we still need some locks in various places.


>>
> (No, I've not yet added locks; obviously, I'm still asking about them.)
> 
> Unlikely, as it was easy to reproduce by changing one line, without
> *any* of
> my code present.  Usually works, but doesn't work with tcpdump running on
> the interface:

Yes, tcpdump has the nasty habit to consume a lot of ram, queuing a copy of
all network traffic on an af_packet socket. (or using a mmap buffer, it depends
on libpcap version you use)

> 
>  struct sock *tcp_create_openreq_child(struct sock *sk, struct
> request_sock *req, struct sk_buff *skb)
>  {
> -    struct sock *newsk = inet_csk_clone(sk, req, GFP_ATOMIC);
> +    struct sock *newsk = inet_csk_clone(sk, req, GFP_KERNEL);

Here you want a GFP_KERNEL allocation, that is allowed to sleep if there is not
enough available memory. (It's allowed to sleep to let some processes to free
bit of ram, eventually)

But as the caller of tcp_create_openreq_child() runs from {soft}irq context,
its not allowed to sleep at all, even 10 usecs.

Therefore, linux kernel kindly warns you that's its illegal and deadlockable.

Dont change GFP_ATOMIC here, its really there for a valid reason.
And be prepared to get a NULL result from allocation.

If your machine has problems when running tcpdump, maybe it lacks some ram, maybe you could
tune tcpdump socket to not exhaust all LOWMEM.
I see your kernel is 32bits, so you have only 860 MB of kernel memory, called LOWMEM.
I believe last kernels might have some problems in OOM situations... 

