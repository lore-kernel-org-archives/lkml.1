Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbYBRONm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbYBRONm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYBRONe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:13:34 -0500
Received: from www.balabit.hu ([212.92.18.33]:34647 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYBRONd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:13:33 -0500
Message-ID: <47B9928A.60202@balabit.hu>
Date: Mon, 18 Feb 2008 15:13:30 +0100
From: Laszlo Attila Toth <panther@balabit.hu>
Organization: BalaBit IT Ltd.
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com> <Pine.LNX.4.64.0802171301430.7699@twin.jikos.cz> <20080217.183621.110686685.davem@davemloft.net> <47B982C9.60207@balabit.hu> <Pine.LNX.4.64.0802181441300.30955@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0802181441300.30955@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 18 Feb 2008, Laszlo Attila Toth wrote:
> 
>> Okay, but I can't figure out what's the problem with it. I don't have 
>> wireless card on my linux box also I can't test it but everything else 
>> works. Swap is mounted. The concurrency cannot be a problem because the 
>> write operation is protected by a lock.
> 
> -               write_lock_bh(&dev_base_lock);
> -               dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
> -               write_unlock_bh(&dev_base_lock);
> +               if (dev->link_mode != nla_get_u8(tb[IFLA_LINKMODE])) {
> +                       write_lock_bh(&dev_base_lock);
> +                       dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
> +                       write_lock_bh(&dev_base_lock);
> +                       modified = 1;
> +               }
>         }
> 
> 1) you are accessing dev->link_mode and tb[] outside the dev_base_lock 

yes, because tb[IFLA_LINKMODE] is not used by someone else in this case 
only dev->link_mode. Although its value is unpredictable in case of a 
concurrent access in the condition, it does not affect the final value 
of dev->link_mode but the length of the critical section remains 
minimal. The if statement may be inside the lock.

> 2) there is obvious and immediate deadlock -- you acquire the 
>    dev_base_lock twice, without any unlock, just look at the chunk above

Indeed:
"Feb 16 16:51:49 sandman kernel: BUG: rwlock recursion on CPU#0,"

I missed it. I copied the code from another patch which didn't contain 
the two locking statements and when I copied them back it became a 
copy-paste bug.


> 3) even with this deadlock fixed, Rafael states that either NM or 
>    wpa_supplicant (I don't recall from top of my head) still don't work

That's bad. Does my suggestion solve the problem? Again:

-      if (modified)
-                 netdev_state_change(dev);
+      if (modified && dev->flags & IFF_UP)
+                 call_netdevice_notifiers(NETDEV_CHANGE, dev)

Regards,
Attila
