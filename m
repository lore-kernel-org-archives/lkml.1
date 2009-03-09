Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZCISE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZCISE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCISEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:04:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55457 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZCISEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:04:46 -0400
Message-ID: <49B55A34.8060707@us.ibm.com>
Date: Mon, 09 Mar 2009 11:04:36 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 2/7] futex: futex_top_waiter()
References: <49AC73A9.4040804@us.ibm.com> <49AC75BA.3030006@us.ibm.com> <alpine.LFD.2.00.0903071612000.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903071612000.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 2 Mar 2009, Darren Hart wrote:
> 
>> From: Darren Hart <dvhltc@us.ibm.com>
>>
>> Improve legibility by wrapping finding the top waiter in a function.  This
>> will be used by the follow-on patches for enabling requeue pi.
>> +static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
>> +					union futex_key *key)
> 
> Can we just have *head as argument instead of *hb ?
> 
>> +{
>> +	struct plist_head *head;
>> +	struct futex_q *this;
>> +	struct futex_q *top_waiter = NULL;
> 
>   	struct futex_q *this;
> 
>> +	head = &hb->chain;
>> +	plist_for_each_entry(this, head, list) {
>> +		if (match_futex(&this->key, key)) {
>   		   	return this;		    
> 
>> +			top_waiter = this;
>> +			break;
>> +		}
>> +	}
>> +	return top_waiter;
> 
>   	return NULL;
> 
> Makes the function half the size.

I'd prefer to keep a futex_hash_bucket in the signature as a plist_head 
doesn't help describe what the function does.  However, I believe I have
addressed your concerns as to length with the following.  Does this look
acceptable?  I'll be resending the entire V6 patch series soon.

/**
  * futex_top_waiter - return the highest priority waiter on a futex
  * @hb:     the hash bucket the futex_q's reside in
  * @key:    the futex key (to distinguish it from other futex futex_q's)
  *
  * Must be called with the hb lock held.
  **/
static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
					union futex_key *key)
{
	struct futex_q *this;

	plist_for_each_entry(this, &hb->chain, list) {
		if (match_futex(&this->key, key))
			return this;
	}
	return NULL;
}



-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
