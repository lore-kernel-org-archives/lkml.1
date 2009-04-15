Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZDOLUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZDOLUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZDOLUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:20:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZDOLUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:20:14 -0400
Date: Wed, 15 Apr 2009 13:17:25 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses
	dev_addr_list
Message-ID: <20090415111724.GG21342@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com> <20090415081819.GB21342@psychotron.englab.brq.redhat.com> <49E59A1C.9030108@cn.fujitsu.com> <20090415083223.GF21342@psychotron.englab.brq.redhat.com> <49E5A896.90408@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49E5A896.90408@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Apr 15, 2009 at 11:27:50AM CEST, dada1@cosmosbay.com wrote:
>Jiri Pirko a écrit :
>> This patch introduces a new list in struct net_device and brings a set of
>> functions to handle the work with device address list. The list is a replacement
>> for the original dev_addr field and because in some situations there is need to
>> carry several device addresses with the net device. To be backward compatible,
>> dev_addr is made to point to the first member of the list so original drivers
>> sees no difference.
>> 
>
>You see no difference ? Please look more closely...
>
>I see one additional dereference in hot path, to small objects possibly
>with false sharing effects.
>
>So I would advise not changing dev_addr[] to a pointer.
>And instead copy first netdev_hw_addr into it.

Hmm :( That is what I was trying to avoid. If the first netdev_hw_addr in the
list is a copy of dev_addr, then there must be synchronizing of those two. This
would be a pain.. Plus I thought that eventually dev_addr would not be
accessible directly but only by set of macros/inlines to accesse the list, and
then dev_addr would be removed from struct net_device.
>
>Also, doing a kzalloc(sizeof(struct netdev_hw_addr)) for allocating these structs
>might give a block of memory < L1_CACHE_SIZE so kernel is free to give other
>part of this cache line to some other layer that could be a hot spot, so
>false sharing could happen.
>
>kzalloc(max(sizeof(*ha), L1_CACHE_SIZE)) is thus higly recommended here.
You mean PAGE_CACHE_SIZE? I think that would be little wasting... But I see your
point...
>
>> Note: patch adding list_first_entry_rcu (currently in Ingo's tip tree) needed.
>> 
>> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>> ---
>>  include/linux/etherdevice.h |   24 ++++
>>  include/linux/netdevice.h   |   31 +++++-
>>  net/core/dev.c              |  263 +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 316 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
>> index a1f17ab..348a75e 100644
>> --- a/include/linux/etherdevice.h
>> +++ b/include/linux/etherdevice.h
>> @@ -205,4 +205,28 @@ static inline int compare_ether_header(const void *a, const void *b)
>>  	       (a32[1] ^ b32[1]) | (a32[2] ^ b32[2]);
>>  }
>>  
>> +/**
>> + * is_etherdev_addr - Tell if given Ethernet address belongs to the device.
>> + * @dev: Pointer to a device structure
>> + * @addr: Pointer to a six-byte array containing the Ethernet address
>> + *
>> + * Compare passed address with all addresses of the device. Return true if the
>> + * address if one of the device addresses.
>> + */
>> +static inline bool is_etherdev_addr(const struct net_device *dev,
>> +				    const u8 *addr)
>> +{
>> +	struct netdev_hw_addr *ha;
>> +	int res = 1;
>> +
>> +	rcu_read_lock();
>> +	for_each_dev_addr(dev, ha) {
>> +		res = compare_ether_addr(addr, ha->addr);
>
>compare_ether_addr_64bits() please ?
>
I used the original as the bridge code used it. Ok, noted.

<snip>

>> +static int __hw_addr_add_ii(struct list_head *list, unsigned char *addr,
>> +			    int addr_len, int ignore_index)
>> +{
>> +	struct netdev_hw_addr *ha;
>> +	int i = 0;
>> +
>> +	if (addr_len > MAX_ADDR_LEN)
>> +		return -EINVAL;
>> +
>> +	rcu_read_lock();
>
>This locking is highly suspect.
>
>> +	list_for_each_entry_rcu(ha, list, list) {
>> +		if (i++ != ignore_index &&
>> +		    !memcmp(ha->addr, addr, addr_len)) {
>> +			ha->refcount++;
>> +			rcu_read_unlock();
>> +			return 0;
>> +		}
>> +	}
>> +	rcu_read_unlock();
>
>Since you obviously need a write lock here to be sure following
>can be done by one cpu only.
>
>You have same problem all over this patch.

Yes, as Dave wrote, this is guarded by RTNL mutex.
>
>> +
>> +	ha = kzalloc(sizeof(*ha), GFP_ATOMIC);
>
>kzalloc(max(sizeof(*ha), L1_CACHE_SIZE), GFP_...) is thus higly recommended here.
>
>Also, why GFP_ATOMIC is needed here ?

Yes, it is not needed here. I've copied it here from the original unicast and
multicast add funtion to stay close but as I can see, there is no need for it
there either.
Noted.
>

<snip>

>> +	list_for_each_entry(ha, list, list) {
>> +		if (i++ != ignore_index &&
>> +		    !memcmp(ha->addr, addr, addr_len)) {
>> +			if (--ha->refcount)
>> +				return 0;
>> +			list_del_rcu(&ha->list);
>> +			synchronize_rcu();
>
>Oh well... I'm pretty sure this synchronize_rcu() call can be avoided,
>dont you think ? Check kfree_rcu() or equivalent, as it seems not yet
>included in current kernels...
>
Well once kfree_rcu() will be in the tree I will be happy to replace this.

>> +			kfree(ha);
>> +			return 0;
>> +		}
>> +	}
>> +	return -ENOENT;

<snip>

>> +	err = __hw_addr_add(&dev->dev_addr_list, addr, sizeof(*addr));
>> +	if (!err) {
>> +		/*
>> +		 * Get the first (previously created) address from the list
>> +		 * and set dev_addr pointer to this location.
>> +		 */
>> +		rcu_read_lock();
>
>locking is not correct or unnecessary

Agree that here locking is not necessary, but I wanted to stay consistent to the
rest of the code. Do you think I should remove locking here entirely?

>
>> +		ha = list_first_entry_rcu(&dev->dev_addr_list,
>> +					  struct netdev_hw_addr, list);
>> +		dev->dev_addr = ha->addr;
>> +		rcu_read_unlock();
>> +	}
>
>
