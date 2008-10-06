Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYJFWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYJFWHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYJFWH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:07:28 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:33132 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJFWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:07:28 -0400
Date: Mon, 06 Oct 2008 17:07:11 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
In-reply-to: <48EA8197.6080502@cosmosbay.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Message-id: <48EA8C0F.5060802@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <20081006185026.GA10383@minyard.local>
 <48EA8197.6080502@cosmosbay.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Corey Minyard a écrit :
>> Change the UDP hash lock from an rwlock to RCU.
>>
>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>> ---
>>  include/net/udp.h |    9 +++++----
>>  net/ipv4/udp.c    |   47 
>> +++++++++++++++++++++++++++--------------------
>>  net/ipv6/udp.c    |   17 +++++++++--------
>>  3 files changed, 41 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/net/udp.h b/include/net/udp.h
>> index addcdc6..35aa104 100644
>> --- a/include/net/udp.h
>> +++ b/include/net/udp.h
>> @@ -51,7 +51,7 @@ struct udp_skb_cb {
>>  #define UDP_SKB_CB(__skb)    ((struct udp_skb_cb *)((__skb)->cb))
>>  
>>  extern struct hlist_head udp_hash[UDP_HTABLE_SIZE];
>> -extern rwlock_t udp_hash_lock;
>> +extern spinlock_t udp_hash_wlock;
>>  
>>  
>>  /* Note: this must match 'valbool' in sock_setsockopt */
>> @@ -112,12 +112,13 @@ static inline void udp_lib_hash(struct sock *sk)
>>  
>>  static inline void udp_lib_unhash(struct sock *sk)
>>  {
>> -    write_lock_bh(&udp_hash_lock);
>> -    if (sk_del_node_init(sk)) {
>> +    spin_lock_bh(&udp_hash_wlock);
>> +    if (sk_del_node_init_rcu(sk)) {
>>          inet_sk(sk)->num = 0;
>>          sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>>      }
>> -    write_unlock_bh(&udp_hash_lock);
>> +    spin_unlock_bh(&udp_hash_wlock);
>> +    synchronize_rcu();
>
> UDP central rwlock can hurt performance, because of cache line ping pong,
> so your patch really makes sense.
>
> Me wondering what impact this synchronize_rcu() can have on mono-threaded
> VOIP applications using lot of UDP sockets. What is the maximum delay of
> this function ?
It delays until all currently executing RCU read-side sections have 
executed (new ones don't count, just currently executing ones).  I'm not 
sure what this delay is, but I would expect it to be fairly small.  This 
function is only called when a socket is closed, too, so it's not a 
high-runner.  Paul would certainly know better than me.

>
> For "struct file" freeing, we chose call_rcu() instead of 
> synchronize_rcu()
I'd prefer that, too, but that would mean adding another member to the 
socket structure.

>
> Maybe we could add a generic rcu head to struct sock, and use 
> call_rcu() in
> sk_prot_free() for sockets needing RCU (udp after your patch is 
> applied, maybe
> tcp on future patches, while I believe previous work on the subject 
> concluded
> RCU was not giving good results for short lived http sessions) ?
RCU probably wouldn't be a good choice for short-lived http sessions, 
since you will only get a couple of messages that would matter.  I'm not 
against adding an item to struct sock, but this is not a common thing 
and struct sock was already big and ugly.

>
> Or just add SLAB_DESTROY_BY_RCU to slab creation in proto_register()
> for "struct proto udp_prot/udpv6_prot" so that kmem_cache_free() done 
> in sk_prot_free() can defer freeing to RCU...
That's an interesting thought; I didn't know that capability was there.  
I can look at that.  With this, the short-lived TCP sessions might not 
matter, though that's a different issue.

-corey
