Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0CLH4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:56:09 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:57679 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab0CLH4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:56:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u4Lp8HNldiWBLmzTBNATXb/FO5BiK11e3jTmHw6GRBsnfCUZpwPJro7p82l9gfE8sU
         2CZW1o1l8LxOQIpRwRYURcKNvzKwF6+u2rPf2uccVDa1uLvqhC3J5uCon4g3lbiQ/NA3
         aXnkyONED1GrQTO7uVKkBfzjhfj7LfbBB1SmM=
MIME-Version: 1.0
In-Reply-To: <20100311161751.GA3804@hack>
References: <2375c9f91003110205v1d7f00bfk89472cb11bd985d3@mail.gmail.com>
	 <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100311161751.GA3804@hack>
Date: Fri, 12 Mar 2010 15:56:03 +0800
Message-ID: <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing netdev)

On Fri, Mar 12, 2010 at 12:17 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Mar 11, 2010 at 05:45:56AM -0800, Paul E. McKenney wrote:
>>On Thu, Mar 11, 2010 at 06:05:38PM +0800, Américo Wang wrote:
>>> Hello, Paul and Peter,
>>>
>>> Attached is the lockdep warning that I triggered today.
>>>
>>> I am not sure if this is a bug of rcu lockdep, because I am
>>> testing my patch when this occurred. However, in the backtrace,
>>> there is none of the functions that I touched, weird.
>>>
>>> So, please help to check if this is a bug of rcu lockdep.
>>
>>This sort of thing is caused by acquiring the same lock with softirq
>>(AKA BH) blocked and not, which can result in self-deadlock.
>>
>>There was such a bug in the RCU lockdep stuff in -tip, but it has long
>>since been fixed.  If you were seeing that bug, rcu_do_batch() would
>>be on the stack, which it does not appear to be.
>>
>>So does your patch involve the usbfs_mutex?  Or attempt to manipulate
>>vfs/fs state from withing networking softirq/BH context?
>>
>
> Nope, it is a patch for netpoll, nothing related with usb, nor vfs.
>

Ok, after decoding the lockdep output, it looks like that
netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
But I don't know if all callers of netif_receive_skb() are in softirq context.

Paul, what do you think?

Thank you.
