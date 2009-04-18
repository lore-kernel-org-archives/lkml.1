Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZDRIJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZDRIJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZDRIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:08:41 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38469 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZDRIIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:08:39 -0400
Message-ID: <49E98A12.9020302@cosmosbay.com>
Date: Sat, 18 Apr 2009 10:06:42 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses	dev_addr_list
 (v3)
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com> <20090415081819.GB21342@psychotron.englab.brq.redhat.com> <20090415180215.GA22540@psychotron.englab.brq.redhat.com> <20090417115723.GE9556@psychotron.englab.brq.redhat.com> <20090417083315.2f089755@nehalam> <20090418070151.GA3370@psychotron.englab.brq.redhat.com> <49E982C4.8020407@cosmosbay.com> <20090418074427.GB3370@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090418074427.GB3370@psychotron.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 18 Apr 2009 10:06:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko a écrit :
> Sat, Apr 18, 2009 at 09:35:32AM CEST, dada1@cosmosbay.com wrote:
>> Jiri Pirko a écrit :
>>> Fri, Apr 17, 2009 at 05:33:15PM CEST, shemminger@vyatta.com wrote:
>>>
>>> <snip>
>>>
>>>>> +struct netdev_hw_addr {
>>>>> +	struct list_head	list;
>>>>> +	unsigned char		addr[MAX_ADDR_LEN];
>>>>> +	int			refcount;
>>>>> +	struct rcu_head		rcu_head;
>>>>> +};
>>>> Minor nit, the ordering of elements cause holes that might not be
>>>> needed.
>>> Agree that ordering might be done better. Will do.
>>>> Space saving? is rcu_head needed or would using synchronize_net
>>>> make code cleaner and save space. 
>>>>
>>> Well I originaly had this done by synchronize_rcu(). Eric argued that it might
>>> cause especially __hw_addr_del_multiple_ii() to run long and suggested to use
>>> call_rcu() instead. I plan to switch this to kfree_rcu() (or whatever it's
>>> called) once it hits the tree.
>>>
>> Yes, and dont forget we wont save space, as we allocate a full
>> cache line to hold a 'struct netdev_hw_addr', since we dont want this
>> critical and read_mostly object polluted by a hot spot elsewhere in kernel...
>>
>> Considering this, letting 'rcu_head' at the end of structure, even if we
>> have an eventual hole on 64 bit arches is not really a problem, and IMHO
>> the best thing to do, as rcu_head is only used at dismantle time.
> 
> I will order the struct better, there are archs with small cache line size where
> it makes sense.

How exactly ?

If you consider a 32bit arch with 16 or 32 bytes cache line,
sizeof(struct_list_dead) is 8
sizeof(addr) = 32     (but we really use 6 bytes for ethernet)

struct netdev_hw_addr {
	unsigned char		addr[MAX_ADDR_LEN];
	struct list_head	list;
	int			refcount;
	struct rcu_head		rcu_head;
};

would cost more at lookup time, since we would use two cache lines

struct netdev_hw_addr {
	struct list_head	list;
	unsigned char		addr[MAX_ADDR_LEN];
	int			refcount;
	struct rcu_head		rcu_head;
};

Is nicer, because at least 8 bytes of addr share the same cache line
than list. So direct dev->dev_addr would be fast (for devices with one
address), and is_etherdev_addr() would still use one cache line per
item.


