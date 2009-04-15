Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbZDOMcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbZDOMcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbZDOMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:31:54 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:54815 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334AbZDOMbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:31:53 -0400
Message-ID: <49E5D2F5.8060108@cosmosbay.com>
Date: Wed, 15 Apr 2009 14:28:37 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses	dev_addr_list
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com> <20090415081819.GB21342@psychotron.englab.brq.redhat.com> <49E59A1C.9030108@cn.fujitsu.com> <20090415083223.GF21342@psychotron.englab.brq.redhat.com> <49E5A896.90408@cosmosbay.com> <20090415111724.GG21342@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090415111724.GG21342@psychotron.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 15 Apr 2009 14:28:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko a écrit :
> Wed, Apr 15, 2009 at 11:27:50AM CEST, dada1@cosmosbay.com wrote:

>> kzalloc(max(sizeof(*ha), L1_CACHE_SIZE)) is thus higly recommended here.
> You mean PAGE_CACHE_SIZE? I think that would be little wasting... But I see your
> point...

No, I meant L1_CACHE_BYTES    (usually 64 bytes on x86), I always confuse BYTES and SIZE on this one...


>>> +	list_for_each_entry(ha, list, list) {
>>> +		if (i++ != ignore_index &&
>>> +		    !memcmp(ha->addr, addr, addr_len)) {
>>> +			if (--ha->refcount)
>>> +				return 0;
>>> +			list_del_rcu(&ha->list);
>>> +			synchronize_rcu();
>> Oh well... I'm pretty sure this synchronize_rcu() call can be avoided,
>> dont you think ? Check kfree_rcu() or equivalent, as it seems not yet
>> included in current kernels...
>>
> Well once kfree_rcu() will be in the tree I will be happy to replace this.

If kfree_rcu() not yet available, please use a regular call_rcu() construct
(thus adding a struct rcu_head rcu; in struct netdev_hw_addr)

If you delete say 10 addresses on a device, while RTNL (or other lock) locked,
that means a lot of calls to synchronize_rcu() and a long lock hold time.

> 
>>> +			kfree(ha);
>>> +			return 0;
>>> +		}
>>> +	}
>>> +	return -ENOENT;
> 
> <snip>
> 
>>> +	err = __hw_addr_add(&dev->dev_addr_list, addr, sizeof(*addr));
>>> +	if (!err) {
>>> +		/*
>>> +		 * Get the first (previously created) address from the list
>>> +		 * and set dev_addr pointer to this location.
>>> +		 */
>>> +		rcu_read_lock();
>> locking is not correct or unnecessary
> 
> Agree that here locking is not necessary, but I wanted to stay consistent to the
> rest of the code. Do you think I should remove locking here entirely?

Yes, it is very confusing for reviewers because we feel patch submiter
is not comfortable with locking rules.

Check for example dev_add_pack() in net/core/dev.c : It uses list_add_rcu()
but as it also uses a regular spinlock, there is no point using rcu_read_lock().

void dev_add_pack(struct packet_type *pt)
{
        int hash;

        spin_lock_bh(&ptype_lock);
        if (pt->type == htons(ETH_P_ALL))
                list_add_rcu(&pt->list, &ptype_all);
        else {
                hash = ntohs(pt->type) & PTYPE_HASH_MASK;
                list_add_rcu(&pt->list, &ptype_base[hash]);
        }
        spin_unlock_bh(&ptype_lock);
}



Please note list_add_rcu() (and/or rcu_assign_pointer()) are still needed to protect
readers that dont use the spinlock at all.

If you use fact that RTNL is locked when calling your code, you could add
ASSERT_RTNL();
at strategic points so that this assertion can be checked at runtime.

(but Patrick & David wrote that you should not assume RTNL, so you probably need another lock...)

Thank you

