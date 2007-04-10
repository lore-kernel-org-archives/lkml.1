Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXDJORv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXDJORv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXDJORv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:17:51 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:39422 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524AbXDJORt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:17:49 -0400
Message-ID: <461B9CA6.8030707@free.fr>
Date: Tue, 10 Apr 2007 16:18:14 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@timesys.com,
       John <linux.kernel@free.fr>
Subject: Re: 2.6.20-rt8 patch tweaked for 2.6.20.5
References: <461672D8.7090100@free.fr> <20070406173639.GA2929@elte.hu> <461B53CD.1030603@free.fr> <20070410131724.GA18553@elte.hu>
In-Reply-To: <20070410131724.GA18553@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> John wrote:
> 
>> I'd be happy to generate a clean patch!
>> (Would you agree to host it in your directory?)
>> http://people.redhat.com/mingo/realtime-preempt/older/
> 
> sure, i can put it there.

Great! Can you tell me how you generate the original -rt patch, so I can 
provide an updated version when a new 2.6.20 kernel is released?

>> 3. linux/kernel/futex.c
>> [ I'm not sure I've made the appropriate changes here ]
>>
>> Basically, we want to replace
>>   spin_lock(&pi_state->pi_mutex.wait_lock);
>> with
>>   spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
>>
>> and we want to replace
>>   spin_unlock(&pi_state->pi_mutex.wait_lock);
>> with
>>   spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
>>
>> Is that correct?
> 
> yes.

OK.

>> 5. linux/net/xfrm/xfrm_user.c
>> [ I'm not sure I've made the appropriate changes here ]
>>
>> Remove a patch that was already applied to 2.6.20.2
>> cf. patch-2.6.20.2
>>
>> --- a/net/xfrm/xfrm_user.c
>> +++ b/net/xfrm/xfrm_user.c
>> @@ -1273,10 +1273,6 @@ static int xfrm_get_policy(struct sk_buff *skb, 
>> struct nlmsghdr *nlh,
>>  		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, 
>>  		tmp.security, delete);
>>  		security_xfrm_policy_free(&tmp);
>>  	}
>> -	if (delete)
>> -		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
>> -			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, 
>> NULL);
>> -
>>  	if (xp == NULL)
>>  		return -ENOENT;
>>
>> @@ -1292,8 +1288,14 @@ static int xfrm_get_policy(struct sk_buff *skb, 
>> struct nlmsghdr *nlh,
>>  					      MSG_DONTWAIT);
>>  		}
>>  	} else {
>> -		if ((err = security_xfrm_policy_delete(xp)) != 0)
>> +		err = security_xfrm_policy_delete(xp);
>> +
>> +		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
>> +			       AUDIT_MAC_IPSEC_DELSPD, err ? 0 : 1, xp, 
>> NULL);
>> +
>> +		if (err != 0)
>>  			goto out;
>> +
>>  		c.data.byid = p->index;
>>  		c.event = nlh->nlmsg_type;
>>  		c.seq = nlh->nlmsg_seq;
>>
>>
>> As a side note, I find the expression
>>   err ? 0 : 1
>> suspect. Why not write !err ?
> 
> it was in the original code and i didn't want to change that. I've 
> attached the original patch below - the bug is probably fixed upstream 
> meanwhile (in a different way) so no need to do any change there.

If I understand correctly, removing that specific patch from 
patch-2.6.20-rt8 is the appropriate course of action then?

Regards.
