Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZKASDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZKASDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 13:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZKASDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 13:03:43 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:48786 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbZKASDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 13:03:42 -0500
Message-ID: <4AEDCD7C.2010403@gmail.com>
Date: Sun, 01 Nov 2009 19:03:40 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com>
In-Reply-To: <4AED86AD.6010906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 01 Nov 2009 19:03:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> Since October 4th, I've repeatedly asked publicly for assistance with these
> Linux-specific memory locking constructs and cryptography.  I've also sent
> private messages.  No help has been forthcoming.  None.  Nada.
> 
> At this point, I've spent weeks re-spinning code that I'd understood was
> approved a year ago.  The whole project should have been finished by now!

Your messages on netdev are two weeks old, not one year, and came during
LKS. Many developpers were busy in Japan.

> 
> So, I'll try a larger audience.  Could somebody take a look at my usage of
> read and write locking?
> 
> NB, I'm trying to port some 15-year-old fairly simple and straightforward
> (single cpu) code from the KA9Q cooperative multitasking platform.
> 
> I've examined existing code used for syncookies and TCP MD5 authenticators.
> Neither meets my needs, as this secret is updated every few minutes.  Both
> have very different approaches.  They are rarely used.  My code will be
> used on the order of tens of thousands of connections per second.
> 
> Moreover, it seems to my naive eye that the syncookie per cpu code simply
> doesn't work properly.  The workspace is allocated per cpu, but the cpu
> could change during the extensive SHA1 computations.  Bug?
> 
> Therefore, I'm approaching this as simply as possible.  I'm particularly
> concerned about the initialization and cache state of memory pointers.
> 
> Does the locking handle this?  Or is there more to be done?
> 

This patch looks fine, but I dont see how this new function is used.

Some points :

1) We are working hard to remove rwlocks from network stack, so please dont
add a new one. You probably can use a seqlock or RCU, or a server handling 
10.000 connections request per second on many NIC will hit this rwlock.

2) 

	} else if (unlikely(time_after(jiffy, tcp_secret_primary->expires))) {
		get_random_bytes(secrets, sizeof(secrets));

		write_lock(&tcp_secret_locker);

It would be better to first get the lock, then get random_bytes, in order
not wasting entropy.


3) If you change secret ever 600 seconds, it might be better to use a timer
so that you dont have to check expiration and this logic at each SYN packet.
(Disociate the lookup (read-only, done many time per second) from the updates
(trigerred by a timer every 600 secs))

(Not counting you'll probably need to use a similar lookup algo for the ACK
packet coming from client)




