Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYIZNh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYIZNh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYIZNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:37:46 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:60742 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYIZNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:37:45 -0400
Date: Fri, 26 Sep 2008 08:37:33 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
In-reply-to: <20080926054600.GA4141@ff.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, shemminger@vyatta.com
Message-id: <48DCE59D.6060003@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080926031832.GA27289@minyard.local>
 <20080926054600.GA4141@ff.dom.local>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Thu, Sep 25, 2008 at 10:18:33PM -0500, Corey Minyard wrote:
> ...
>   
>> This patch is the second try; I believe I fixed all issues that people
>> raised.
>>     
>
> Actually, you've skipped my first question, so I still don't know, why
> you don't use an _init version of sk_del_node (even if it's safe in the
> current implementation), while the non-rcu code uses only this?
>   
I guess it didn't matter, but it doesn't matter and consistency is 
important, so I've changed it.

-corey

> ...
>   
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 06c5259..65110a6 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>>     
> ...
>   
>>  static inline int sk_unhashed(const struct sock *sk)
>>  {
>>  	return hlist_unhashed(&sk->sk_node);
>> @@ -361,6 +374,27 @@ static __inline__ int sk_del_node_init(struct sock *sk)
>>  	return rc;
>>  }
>>  
>> +static inline int __sk_del_node_rcu(struct sock *sk)
>> +{
>> +	if (sk_hashed(sk)) {
>> +		hlist_del_rcu(&sk->sk_node);
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static inline int sk_del_node_rcu(struct sock *sk)
>> +{
>> +	int rc = __sk_del_node_rcu(sk);
>> +
>> +	if (rc) {
>> +		/* paranoid for a while -acme */
>> +		WARN_ON(atomic_read(&sk->sk_refcnt) == 1);
>> +		__sock_put(sk);
>> +	}
>> +	return rc;
>> +}
>>     
> ...
>
> Jarek P.
>
>   

