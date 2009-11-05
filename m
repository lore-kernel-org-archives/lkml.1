Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZKENeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZKENeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZKENeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:34:23 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:49464 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZKENeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:34:22 -0500
Message-ID: <4AF2D460.5010608@gmail.com>
Date: Thu, 05 Nov 2009 14:34:24 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: paulmck@linux.vnet.ibm.com,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder	Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AF0B0D2.4030905@gmail.com> <20091104214844.GA6714@linux.vnet.ibm.com> <4AF2C266.1010603@gmail.com> <4AF2C8E4.9020202@gmail.com>
In-Reply-To: <4AF2C8E4.9020202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 05 Nov 2009 14:34:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> William Allen Simpson wrote:
>> Yes.  Just shuffling the pointers without ever freeing anything.  So,
>> there's nothing for call_rcu() to do, and nothing else to synchronize
>> (only the pointers).  This assumes that after _unlock_ any CPU cache
>> with an old pointer->expires will hit the _lock_ code, and that will
>> update *both* ->expires and the other array elements concurrently?
>>
> Reiterating, I've not found Documentation showing that this code works:
> 
> +    unsigned long jiffy = jiffies;
> +
> +    if (unlikely(time_after(jiffy, tcp_secret_generating->expires))) {
> +        spin_lock_bh(&tcp_secret_locker);
> +        if (!time_after(jiffy, tcp_secret_generating->expires)) {
> +            /* refreshed by another */
> +            spin_unlock_bh(&tcp_secret_locker);
> +            memcpy(&xvp->cookie_bakery[0],
> +                   &tcp_secret_generating->secrets[0],
> +                   sizeof(tcp_secret_generating->secrets));
> +        } else {
> 
> How is it ensured that an old tcp_secret_generating or an old ->expires,
> followed by a spin_lock, has updated both?
> 
> And even when both are updated, then every word of the ->secrets array has
> also been updated in the local cache?
> 
> Is this a property of spin_lock()?  Or spin_unlock()?

Yes,  

$ vi +1121 Documentation/memory-barriers.txt

 (1) LOCK operation implication:

     Memory operations issued after the LOCK will be completed after the LOCK
     operation has completed.

     Memory operations issued before the LOCK may be completed after the LOCK
     operation has completed.

 (2) UNLOCK operation implication:

     Memory operations issued before the UNLOCK will be completed before the
     UNLOCK operation has completed.

     Memory operations issued after the UNLOCK may be completed before the
     UNLOCK operation has completed.


