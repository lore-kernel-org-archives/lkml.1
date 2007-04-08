Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbXDHFCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbXDHFCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 01:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXDHFCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 01:02:46 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:8934 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbXDHFCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 01:02:46 -0400
Message-ID: <46187770.1070106@sw.ru>
Date: Sun, 08 Apr 2007 09:02:40 +0400
From: Vasily Averin <vvs@sw.ru>
Organization: SW-soft
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.8_seamonkey_1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH nf-2.6.22] [netfilter] early_drop imrovement
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>
In-Reply-To: <461789CF.8000106@cosmosbay.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Vasily Averin a e'crit :
>> When the number of conntracks is reached nf_conntrack_max limit,
>> early_drop() is
>> called and tries to free one of already used conntracks in one of the
>> hash
>> buckets. If it does not find any conntracks that may be freed, it
>> leads to transmission errors.
>> However it is not fair because of current hash bucket may be empty but
>> the
>> neighbour ones can have the number of conntracks that can be freed. On
>> the other
>> hand the number of checked conntracks is not limited and it can cause
>> a long delay.
>> The following patch limits the number of checked conntracks by average
>> number of
>> conntracks in one hash bucket and allows to search conntracks in other
>> hash buckets.
> 
> Hi Vasily
> 
>>
>>              atomic_inc(&ct->ct_general.use);
>>              break;
>>          }
>> +        if (!--(*cnt)) {
>> +            dropped = 1;
>> +            break;
>> +        }
> 
> 
>> +    cnt = (nf_conntrack_max/nf_conntrack_htable_size) + 1;
> 
> I am sorry but this wont help in the case you mentioned in an earlier
> mail :
> 
> If nf_conntrack_max  < nf_conntrack_htable_size, cnt will be set to 1.
> 
> Then in __early_drop() you endup in breaking the
> list_for_each_entry_reverse() loop after the first element was tested !
> Not what you intended I'm afraid, because you wont event scan the whole
> chain as before your patch :(

I would note that in my experiment I got errors when first checked hash bucket
was empty. With this patch I have guarantee that at least one conntrack will be
checked. I'm agree 1 is not too high, but it is better than nothing. I've
checked, my testcase works now.

> I believe you should not test --cnt in __early_drop() but in the caller.
> 
> (That is not counting the number of found cells, but the number of hash
> chains you tried)

I need to count conntracks but not hash buckets. Also it is possible that all
the conntracks will be placed to only one hash bucket, and as you pointed in
your previous letter it may lead to long delays.

However how do you think, is it probably better to set low limit to default
average number of conntracks in hash bucket?

cnt = max(8U, nf_conntrack_max/nf_conntrack_htable_size);

Thank you,
	Vasily Averin

