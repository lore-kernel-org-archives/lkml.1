Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZKCXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZKCXDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZKCXDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:03:19 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:56981 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZKCXDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:03:18 -0500
Message-ID: <4AF0B6B9.2030707@gmail.com>
Date: Wed, 04 Nov 2009 00:03:21 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AF0B0D2.4030905@gmail.com>
In-Reply-To: <4AF0B0D2.4030905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 04 Nov 2009 00:03:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> Eric Dumazet wrote:
>> This patch looks fine, but I dont see how this new function is used.
>>
>> Some points :
>>
>> 1) We are working hard to remove rwlocks from network stack, so please
>> dont
>> add a new one. You probably can use a seqlock or RCU, or a server
>> handling 10.000 connections request per second on many NIC will hit
>> this rwlock.
>>
> This is my attempt at using RCU, as seqlock didn't seem to apply (and is
> missing any Documentation.)
> 

That seems very good, thanks, we can sort out details later, when full picture
is available.

> After the discussion about context, one question that I have is the need
> for the _bh suffix?
> 
> +        rcu_read_lock_bh();
> +        memcpy(&xvp->cookie_bakery[0],
> +               &rcu_dereference(tcp_secret_generating)->secrets[0],
> +               sizeof(tcp_secret_generating->secrets));
> +        rcu_read_unlock_bh();
> 

Well, you dont need to disable BH in this code running in softirq context only.

Just use rcu_read_lock() (like you use spin_lock() in same function/context)


> 
> Documentation/RCU/checklist.txt #7 says:
> 
>   One exception to this rule: rcu_read_lock() and rcu_read_unlock()
>   may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
>   in cases where local bottom halves are already known to be
>   disabled, for example, in irq or softirq context.  Commenting
>   such cases is a must, of course!  And the jury is still out on
>   whether the increased speed is worth it.
> 

