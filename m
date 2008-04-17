Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYDQEzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYDQEzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYDQEzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:55:39 -0400
Received: from stinky.trash.net ([213.144.137.162]:51806 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYDQEzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:55:38 -0400
Message-ID: <4806D847.2030806@trash.net>
Date: Thu, 17 Apr 2008 06:55:35 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: 12o3l@tiscali.nl, hadi@cyberus.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: catch signed nla_len() retval in tcf_simp_init()
References: <4806C501.20300@tiscali.nl> <20080416.213712.78410382.davem@davemloft.net>
In-Reply-To: <20080416.213712.78410382.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------010509000709090900030409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010509000709090900030409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Roel Kluin <12o3l@tiscali.nl>
> Date: Thu, 17 Apr 2008 05:33:21 +0200
> 
>> 'datalen' is unsigned, use 'ret' instead to catch a negative return value.
>>
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
>> index fbde461..b78d015 100644
>> --- a/net/sched/act_simple.c
>> +++ b/net/sched/act_simple.c
>> @@ -114,9 +114,10 @@ static int tcf_simp_init(struct nlattr *nla, struct nlattr *est,
>>  	if (defdata == NULL)
>>  		return -EINVAL;
>>  
>> -	datalen = nla_len(tb[TCA_DEF_DATA]);
>> -	if (datalen <= 0)
>> +	ret = nla_len(tb[TCA_DEF_DATA]);
>> +	if (ret <= 0)
>>  		return -EINVAL;
>> +	datalen = ret;
>>  
>>  	pc = tcf_hash_check(parm->index, a, bind, &simp_hash_info);
>>  	if (!pc) {
> 
> This clobbers 'ret' which is compared to ACT_P_CREATED
> later in the function.  If the !pc branch below this code
> is not taken, ret must be left at it's initial value of
> zero.  Now, it will take on some non-zero positive value
> which is not correct.

The change is also unnecessary because the attribute was
already validated and the length can not be less than zero.

This patch changes it to only check for zero length.

Signed-off-by: Patrick McHardy <kaber@trash.net>


--------------010509000709090900030409
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index fbde461..64b2d13 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -115,7 +115,7 @@ static int tcf_simp_init(struct nlattr *nla, struct nlattr *est,
 		return -EINVAL;
 
 	datalen = nla_len(tb[TCA_DEF_DATA]);
-	if (datalen <= 0)
+	if (datalen == 0)
 		return -EINVAL;
 
 	pc = tcf_hash_check(parm->index, a, bind, &simp_hash_info);

--------------010509000709090900030409--
