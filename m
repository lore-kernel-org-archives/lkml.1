Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXDFXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXDFXFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXDFXFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:05:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:53977 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbXDFXFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:05:46 -0400
Message-ID: <4616D225.3030601@ncos.nec.co.jp>
Date: Fri, 06 Apr 2007 16:05:09 -0700
From: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       "David S. Miller" <davem@davemloft.net>, linux-rt-users@vger.kernel.org,
       Mark Huth <mhuth@mvista.com>, dwalker@mvista.com
Subject: Re: [PATCH 2.6.21-rc5-rt12] IPV6: Flag bit of ebitmask is not set
 in __inet6_hash.
References: <461543B5.6080605@ncos.nec.co.jp> <20070405190714.GB22092@elte.hu>
In-Reply-To: <20070405190714.GB22092@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo-san

This is a RT specific issue, and this fix is not needed in mainline.

When searching in-use sockets via netstat, RT uses a bitmap(ebitmask)
for fast search.
Non-RT doesn't use the bitmap.
Following patch is abstracted from RT patch(patch-2.6.21-rc5-rt12).

----------------------- Abstracted from RT patch
----------------------------
Index: linux/include/net/inet_hashtables.h
===================================================================
--- linux.orig/include/net/inet_hashtables.h
+++ linux/include/net/inet_hashtables.h
@@ -101,6 +101,7 @@ struct inet_hashinfo {
         * TIME_WAIT sockets use a separate chain (twchain).
         */
        struct inet_ehash_bucket        *ehash;
+       unsigned long                   *ebitmask;

        /* Ok, let's try this, I give up, we do need a local binding
         * TCP hash as well as the others for fast bind/connect.
@@ -135,6 +136,13 @@ static inline struct inet_ehash_bucket *
        return &hashinfo->ehash[hash & (hashinfo->ehash_size - 1)];
 }

snip...

 static inline void __inet_hash(struct inet_hashinfo *hashinfo,
                               struct sock *sk, const int listen_possible)
 {
        struct hlist_head *list;
        rwlock_t *lock;
+       unsigned long *bitmask = NULL;
+       unsigned int index = 0;

        BUG_TRAP(sk_unhashed(sk));
        if (listen_possible && sk->sk_state == TCP_LISTEN) {
@@ -221,12 +243,15 @@ static inline void __inet_hash(struct in
        } else {
                struct inet_ehash_bucket *head;
                sk->sk_hash = inet_sk_ehashfn(sk);
+               index = inet_ehash_index(hashinfo, sk->sk_hash);
                head = inet_ehash_bucket(hashinfo, sk->sk_hash);
                list = &head->chain;
                lock = &head->lock;
+               bitmask = hashinfo->ebitmask;
                write_lock(lock);
        }
        __sk_add_node(sk, list);
+       __inet_hash_setbit(bitmask, index);
        sock_prot_inc_use(sk->sk_prot);
        write_unlock(lock);
        if (listen_possible && sk->sk_state == TCP_LISTEN)
-------------------------------------------------------------------------------

You can see that a flag bit is set properly into the bitmap in
__inet_hash(). This function is
called when IPv4 connection is established.
But when IPv6 connection is established, a flag bit is NOT set into the
bitmap, because
the code setting a flag bit is missing in __inet6_hash(). Therefore it
is impossible to find the
IPv6 sockets in established state, when searching in-use sockets via
netstat.

In the same way as __inet_hash(), setting a flag bit is needed in
__inet6_hash().

Thanks,
Masayuki Nakagawa


Ingo Molnar wrote:
> * Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp> wrote:
>
>   
>> I found an issue with -rt patch. It is that netstat doesn't show IPv6 
>> sockets in ESTABLISHED state. This issue happens because a flag bit of 
>> ebitmask is not set when the IPv6 socket connection is established.
>>
>> The fix is to set the flag bit in __inet6_hash().
>>     
>
> thanks. I'm wondering, should this fix be done in mainline too? -rt12 is 
> based on Linus' -git kernel from yesterday.
>
> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
