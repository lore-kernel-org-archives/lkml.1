Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZHXH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZHXH5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZHXH5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:57:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60487 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZHXH5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:57:13 -0400
Message-ID: <4A924734.6000702@cn.fujitsu.com>
Date: Mon, 24 Aug 2009 15:54:28 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Luo Chunbo <chunbo.luo@windriver.com>
CC: Vlad Yasevich <vladislav.yasevich@hp.com>, davem@davemloft.net,
       netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: fix the check for path failure detection
References: <1250838275-7444-1-git-send-email-chunbo.luo@windriver.com>	 <4A8F15F5.3020901@hp.com> <1251080117.6513.11.camel@pek-cluo-desktop>
In-Reply-To: <1251080117.6513.11.camel@pek-cluo-desktop>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luo Chunbo Ð´µÀ:
> On Fri, 2009-08-21 at 17:47 -0400, Vlad Yasevich wrote:
>   
>> Chunbo Luo wrote:
>>     
>>> The transport is marked DOWN immediately after sending the max+1 HB,
>>> which is equal to not sending the max+1 HB at all. We should wait
>>> a next period and make sure the last HB is not acknowledged.
>>>
>>>       
>> I don't think this code does what you want either...
>>
>> Let's say path_max_rxt = 2.  What we'll get is:
>> 	timeout:
>> 		err++ (1)
>> 		if (err > 2) false
>> 		send HB
>> 		reset timer
>> 	timeout:
>> 		err++ (2)
>> 		if (err > 2) false
>> 		send HB
>> 		reset timer
>> 	timeout:
>> 		err++ (3)
>> 		if (err > 2)
>> 			set transport DOWN
>> 		send HB
>> 		reset timer.
>>
>> We only had 2 unacknowledged HB when we should have had 3.
>>     
>
> The error count is increment after the HB was sent, and the error count
> check is before sending HB.
>
> Let's say path_max_rxt =2 . What we really get is:
>
> timeout:
> 	if( err > 2) false
> 	send HB
> 	err++ (1)
> 	reset timer
> timeout:
> 	if( err > 2) false
> 	send HB
> 	err++ (2)
> 	reset timer
> timeout:
> 	if( err > 2) false
> 	send HB
> 	err++ (3)
> 	reset timer
> timeout:
> 	if( err > 2)
> 		set transport DOWN
> 	send HB
> 	reset timer
>
> Here We had 3 unacknowledged HBs


But with Vlad's advice, you just need to do little change to the kernel
codes, may be two lines's patch, and it can do the same thing.



