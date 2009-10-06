Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZJFQTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZJFQTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZJFQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:19:22 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:32931 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbZJFQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:19:21 -0400
Message-ID: <4ACB6DAF.4000709@gmail.com>
Date: Tue, 06 Oct 2009 18:17:51 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 2/4] tree rcu: Add debug RCU head option
References: <20091006143727.868480435@polymtl.ca> <20091006144038.140258698@polymtl.ca> <4ACB684A.6060107@gmail.com> <20091006160948.GB15904@Krystal>
In-Reply-To: <20091006160948.GB15904@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 06 Oct 2009 18:17:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers a écrit :
> * Eric Dumazet (eric.dumazet@gmail.com) wrote:
>> Mathieu Desnoyers a écrit :
>>> Poisoning the rcu_head callback list. Only for rcu tree for now.
>>>
>>> Helps finding racy users of call_rcu(), which results in hangs because list
>>> entries are overwritten and/or skipped. Using the lower bit to poison because
>>> include/net/dst.h __pad_to_align_refcnt complains when struct rcu_head grows.
>>>
>> I see :)
>>
> 
> I don't know if there is an easy fix for __pad_to_align_refcnt ?


This check was added to make sure some tbench regression was not added if
dst->__refcnt was moved around, I am sure you dont care about tbench being 10% slower,
do you ?


diff --git a/include/net/dst.h b/include/net/dst.h
index 5a900dd..b8fba74 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -154,7 +154,9 @@ static inline void dst_hold(struct dst_entry * dst)
 	 * If your kernel compilation stops here, please check
 	 * __pad_to_align_refcnt declaration in struct dst_entry
 	 */
+#if !defined(DEBUG_RCU_HEAD)
 	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
+#endif
 	atomic_inc(&dst->__refcnt);
 }
 

