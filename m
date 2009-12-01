Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZLAQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZLAQ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZLAQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:58:37 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:47621 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZLAQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:58:37 -0500
Message-ID: <4B154B29.1030807@cosmosbay.com>
Date: Tue, 01 Dec 2009 17:58:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com>
In-Reply-To: <4B15416A.2060202@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 01 Dec 2009 17:58:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> I'm hoping someone might be able to explain some odd behaviour that I'm
> seeing.
> 
> Some of our developers wanted to be able to see how much of their rx
> socket buffer space was in use, so I added the following to sock_ioctl()
> 
> 
> 		case SIOCGSKRMEMALLOC:
> 		{
> 			int tmp;
> 			err = -EINVAL;
> 			if(!sock->sk)
> 				break;
> 			tmp = atomic_read(&sock->sk->sk_rmem_alloc);
> 			err = copy_to_user(argp, &tmp, sizeof(tmp));
> 			break;
> 		}
> 
> To validate it, I wrote a testcase that opened a tcp socket, then looped
> sending 2k of data at a time to it and calling the above ioctl to check
> the sk_rmem_alloc value (without ever reading from the socket).
> 
> The results were odd--I've copied them below.  Can anyone explain how I
> can send 20K of data but sk_rmem_alloc still only shows 4.8K used, then
> it suddenly jumps by a lot on the next packet to something that more
> reflects reality, then repeats that pattern again?  Is there some
> additional buffering happening somewhere in the TCP stack?
> 

Me wondering why you think sk_rmem_alloc is about TX side.

Its used in RX path. rmem means ReadMemory.

You can send 1 Gbytes of data, and sk_rmem_alloc doesnt change, if your
TCP stream is unidirectionnal.

sk_rmem_alloc grows when skb are queued into receive queue
sk_rmem_alloc shrinks when application reads this receive queue.




