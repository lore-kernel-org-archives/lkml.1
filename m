Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZDRHpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZDRHpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZDRHpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:45:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58991 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZDRHpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:45:20 -0400
Date: Sat, 18 Apr 2009 09:44:28 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses
	dev_addr_list (v3)
Message-ID: <20090418074427.GB3370@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com> <20090415081819.GB21342@psychotron.englab.brq.redhat.com> <20090415180215.GA22540@psychotron.englab.brq.redhat.com> <20090417115723.GE9556@psychotron.englab.brq.redhat.com> <20090417083315.2f089755@nehalam> <20090418070151.GA3370@psychotron.englab.brq.redhat.com> <49E982C4.8020407@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49E982C4.8020407@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sat, Apr 18, 2009 at 09:35:32AM CEST, dada1@cosmosbay.com wrote:
>Jiri Pirko a écrit :
>> Fri, Apr 17, 2009 at 05:33:15PM CEST, shemminger@vyatta.com wrote:
>> 
>> <snip>
>> 
>>>> +struct netdev_hw_addr {
>>>> +	struct list_head	list;
>>>> +	unsigned char		addr[MAX_ADDR_LEN];
>>>> +	int			refcount;
>>>> +	struct rcu_head		rcu_head;
>>>> +};
>>> Minor nit, the ordering of elements cause holes that might not be
>>> needed.
>> 
>> Agree that ordering might be done better. Will do.
>>> Space saving? is rcu_head needed or would using synchronize_net
>>> make code cleaner and save space. 
>>>
>> 
>> Well I originaly had this done by synchronize_rcu(). Eric argued that it might
>> cause especially __hw_addr_del_multiple_ii() to run long and suggested to use
>> call_rcu() instead. I plan to switch this to kfree_rcu() (or whatever it's
>> called) once it hits the tree.
>> 
>
>Yes, and dont forget we wont save space, as we allocate a full
>cache line to hold a 'struct netdev_hw_addr', since we dont want this
>critical and read_mostly object polluted by a hot spot elsewhere in kernel...
>
>Considering this, letting 'rcu_head' at the end of structure, even if we
>have an eventual hole on 64 bit arches is not really a problem, and IMHO
>the best thing to do, as rcu_head is only used at dismantle time.

I will order the struct better, there are archs with small cache line size where
it makes sense.

>
>And yes, maybe kfree_rcu() will makes its way in kernel, eventually :)
>
>Thank you
>
>
