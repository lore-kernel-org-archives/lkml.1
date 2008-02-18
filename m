Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYBRNGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYBRNGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761933AbYBRNGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:06:21 -0500
Received: from www.balabit.hu ([212.92.18.33]:57420 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761574AbYBRNGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:06:20 -0500
Message-ID: <47B982C9.60207@balabit.hu>
Date: Mon, 18 Feb 2008 14:06:17 +0100
From: Laszlo Attila Toth <panther@balabit.hu>
Organization: BalaBit IT Ltd.
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com
CC: jkosina@suse.cz, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com>	<Pine.LNX.4.64.0802171301430.7699@twin.jikos.cz> <20080217.183621.110686685.davem@davemloft.net>
In-Reply-To: <20080217.183621.110686685.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Sun, 17 Feb 2008 13:04:59 +0100 (CET)
> 
>> On Sun, 17 Feb 2008, Zdenek Kabelac wrote:
>>
>>> It looks like there is something weird as my systems stops when the swap 
>>> is mounted. I've played bisection game and this is the commit which 
>>> makes the system unusable:
>>> # bad: [45b503548210fe6f23e92b856421c2a3f05fd034] [RTNETLINK]: Send a
>>> single notification on device state changes.
>>> git-bisect bad 45b503548210fe6f23e92b856421c2a3f05fd034
>>> I've tried to reverse this commit - and it has compiled & worked.
>> This commit is completely broken (it, for example, breaks locking around 
>> dev->link_mode), as has been already mentioned by Rafael at 
>> http://lkml.org/lkml/2008/2/15/542
>>
>> Dave, do you have a proper fix queued? Otherwise I would propose just to 
>> revert it completely from Linus' tree for now.
> 
> I just reverted and I'll push that to Linus.
> 

Okay, but I can't figure out what's the problem with it. I don't have 
wireless card on my linux box also I can't test it but everything else 
works. Swap is mounted.


The concurrency cannot be a problem because the write operation is 
protected by a lock.

My only idea is the notification itself, because the netdev_state_change 
function is used which calls rtmsg_ifinfo too.

void netdev_state_change(struct net_device *dev)
{
         if (dev->flags & IFF_UP) {
                 call_netdevice_notifiers(NETDEV_CHANGE, dev);
                 rtmsg_ifinfo(RTM_NEWLINK, dev, 0);
         }
}

Also last lines of my patch could be instead of
         if (modified)
                 netdev_state_change(dev);

the following:
if (modified && dev->flags & IFF_UP) {
   call_netdevice_notifiers(NETDEV_CHANGE, dev);
}

Regards,
Attila
