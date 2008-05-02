Return-Path: <linux-kernel-owner+w=401wt.eu-S936026AbYEBUaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936026AbYEBUaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764158AbYEBUar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:30:47 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58913 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765061AbYEBUaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:30:46 -0400
Message-ID: <481B79EF.3090200@austin.ibm.com>
Date: Fri, 02 May 2008 15:30:39 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Blanchard <anton@au1.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: questions on calc_delta_mine() in sched.c
References: <481A2BF6.2070406@austin.ibm.com> <1209730442.6508.3.camel@lappy>
In-Reply-To: <1209730442.6508.3.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>      if (unlikely(!lw->inv_weight))
>>          lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
>>
>>
>> Q1) This code is hit often in scenarios I run, is this really unlikely for 
>> others?
> 
> I think it became a lot more likely recently, perhaps removing that
> unlikely is not such a bad idea.

Especially if you remove the divide in the other locations, then this might 
even be likely.

> 
>> Q2) The rest of the code in sched.c seems to make inv_weight == 
>> WMULT_CONST/weight and I was wondering if you could explain why this 
>> instance is different.
> 
> because the rest of the code is wrong, there are only 2 other sites, and
> I have a patch that removes those div64_64() with =0;
> 
> The idea is to use rounding division: (x + y/2) / y
> but we can't because 'x' is touching the limits of our modulo space,
> hence we do: (x - y/2) / y
> which comes in 1 short, that fixup has been lost along the way.

Ah, that makes more sense, and the fact that it is broken explains why I 
couldn't figure it out.

