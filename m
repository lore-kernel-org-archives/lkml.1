Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZKBK4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZKBK4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZKBK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:56:04 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:41276 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbZKBK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:56:03 -0500
Message-ID: <4AEEBAC6.7020308@gmail.com>
Date: Mon, 02 Nov 2009 11:56:06 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AEEB6D2.7090505@gmail.com>
In-Reply-To: <4AEEB6D2.7090505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 02 Nov 2009 11:56:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
>
> The (buggy?) syncookie code that I'm avoiding/replacing is:
> 
> static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
>               ipv4_cookie_scratch);
> 
> static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16
> dport,
>                u32 count, int c)
> {
>     __u32 *tmp = __get_cpu_var(ipv4_cookie_scratch);
> 
>     memcpy(tmp + 4, syncookie_secret[c], sizeof(syncookie_secret[c]));
>     tmp[0] = (__force u32)saddr;
>     tmp[1] = (__force u32)daddr;
>     tmp[2] = ((__force u32)sport << 16) + (__force u32)dport;
>     tmp[3] = count;
>     sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
> 
>     return tmp[17];
> }
> 
> It appears to me that the operations could be interrupted at any time, and
> the fairly expensive sha transform (or probably any of the assignments)
> could be corrupted?
> 
> That is, cpu0 grabs a scratch area, copies some data into it, interrupts,
> cpu0 comes along again with another packet, points into the same workspace,
> mashes the data, while cpu1 completes the previous operation with the
> old tmp pointer on the stack.
> 
> Worse, this is called twice, each time getting tmp, and mashing the data,
> and at the same time others are calling it twice more for verification.
> 
> Since syncookies only occur under stress, the code isn't well tested, and
> the only symptom would be the returned packet would be dropped after
> failing to verify.  Since this only happens when lots of packets are
> arriving, dropped packets probably aren't noticed.
> 
> However, that would be unacceptable for my code.
>


cookie_hash() runs in a non preemptable context. CPU cannot change under us.

(or else, we would not use __get_cpu_var(ipv4_cookie_scratch); )

And of course, each cpu gets its own scratch area, thanks to __get_cpu_var()

