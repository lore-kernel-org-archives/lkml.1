Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZIHMMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZIHMMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbZIHMME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:12:04 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:54463 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZIHMMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:12:03 -0400
Message-ID: <4AA64A11.7090804@gmail.com>
Date: Tue, 08 Sep 2009 14:12:01 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: BUG UNIX: Poison overwritten with 2.6.31-rc6-00223-g6c30c53
References: <alpine.DEB.2.00.0909072323350.3940@parag-desktop>	 <df9815e70909072151l2686231en76773418aaf9deeb@mail.gmail.com>	 <4AA609E8.3060408@gmail.com> <df9815e70909080109r3d61ee76v3dcba41dbd87b998@mail.gmail.com>
In-Reply-To: <df9815e70909080109r3d61ee76v3dcba41dbd87b998@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 08 Sep 2009 14:12:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song a écrit :
> On Tue, Sep 8, 2009 at 3:38 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
>> We decrement a refcnt while object already freed.
>>
>> (SLUB DEBUG poisons the zone with 0x6B pattern)
>>
>> You might add this patch to trigger a WARN_ON when refcnt >= 0x60000000U
>> in sk_free() : We'll see the path trying to delete an already freed sock
>>
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 7633422..1cb85ff 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -1058,6 +1058,7 @@ static void __sk_free(struct sock *sk)
>>
>>  void sk_free(struct sock *sk)
>>  {
>> +       WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
>>        /*
>>         * We substract one from sk_wmem_alloc and can know if
>>        * some packets are still in some tx queue.
>>
>>
> 
> The output of dmesg with this patch appllied is attached.
> 
> 

Unfortunatly this WARN_ON was not triggered,
maybe freeing comes from sock_wfree()

Could you try this patch instead ?

Thanks

diff --git a/net/core/sock.c b/net/core/sock.c
index 7633422..30469dc 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1058,6 +1058,7 @@ static void __sk_free(struct sock *sk)

 void sk_free(struct sock *sk)
 {
+	WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
 	/*
 	 * We substract one from sk_wmem_alloc and can know if
 	* some packets are still in some tx queue.
@@ -1220,6 +1221,7 @@ void sock_wfree(struct sk_buff *skb)
 	struct sock *sk = skb->sk;
 	int res;

+	WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
 	/* In case it might be waiting for more memory. */
 	res = atomic_sub_return(skb->truesize, &sk->sk_wmem_alloc);
 	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE))
