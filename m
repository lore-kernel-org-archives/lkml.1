Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZCYDT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZCYDT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZCYDTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:19:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:53539 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZCYDTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:19:19 -0400
From: "Cai, Cliff" <Cliff.Cai@analog.com>
X-IronPort-AV: E=Sophos;i="4.38,416,1233550800"; 
   d="scan'208";a="68455436"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mmc: align data size for host which only supports power-of-2 block
Date: Wed, 25 Mar 2009 11:22:25 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03C5D7C5@chinexm1.ad.analog.com>
In-Reply-To: <20090314213038.4d14526e@mjolnir.ossman.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mmc: align data size for host which only supports power-of-2 block
Thread-Index: Acmk48Pjy0mvKYgsQ5SnpVaSqmgdGwIFA71A
References: <1236309321-23955-1-git-send-email-cooloney@kernel.org> <20090314213038.4d14526e@mjolnir.ossman.eu>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>, "Bryan Wu" <cooloney@kernel.org>
CC: <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 25 Mar 2009 03:19:14.0372 (UTC) FILETIME=[794CE840:01C9ACF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>
 

>-----Original Message-----
>From: Pierre Ossman [mailto:drzeus-mmc@drzeus.cx] 
>Sent: Sunday, March 15, 2009 4:31 AM
>To: Bryan Wu
>Cc: linux-kernel@vger.kernel.org; Cai, Cliff; Bryan Wu
>Subject: Re: [PATCH] mmc: align data size for host which only 
>supports power-of-2 block
>
>On Fri,  6 Mar 2009 11:15:21 +0800
>Bryan Wu <cooloney@kernel.org> wrote:
>
>> From: Cliff Cai <cliff.cai@analog.com>
>> 
>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>
>This patch seems premature as there is no associated 
>modification of any of the host drivers.

The SDH on Blackfin BF54x/BF51x only supports power-of-2 block
transfer,we will soon
Send the sdh driver to mainline as well.

>
>>  drivers/mmc/core/core.c  |    8 +++++++-
>>  include/linux/mmc/host.h |    1 +
>>  2 files changed, 8 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c index 
>> df6ce4a..15119df 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -321,7 +321,13 @@ unsigned int mmc_align_data_size(struct 
>mmc_card *card, unsigned int sz)
>>  	 * the core about its problems yet, so for now we just 32-bit
>>  	 * align the size.
>>  	 */
>> -	sz = ((sz + 3) / 4) * 4;
>> +
>> +	/* Align size for host which only supports power-of-2 block */
>> +	if (card->host->powerof2_block) {
>> +		if (sz & (sz - 1))
>> +			sz = 1 << fls(sz);
>> +	} else
>> +		sz = ((sz + 3) / 4) * 4;
>>  
>>  	return sz;
>>  }
>
>At the very least, the comment at the top of this function 
>must go. But really, if we want to improve this we should 
>probably do it properly and have flags for the different 
>limitations that are available.
>Padding to a power of two size can also mean a rather large 
>padding. We might need to check the host data limits after 
>doing the adjustment.

Yes,but it's the higher level driver's job. 

>
>> diff --git a/include/linux/mmc/host.h 
>b/include/linux/mmc/host.h index 
>> 4e45725..7416ed1 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -162,6 +162,7 @@ struct mmc_host {
>>  	struct dentry		*debugfs_root;
>>  
>>  	unsigned long		private[0] ____cacheline_aligned;
>> +	unsigned int		powerof2_block;	/* host only 
>supports power-of-2 block */
>>  };
>>  
>>  extern struct mmc_host *mmc_alloc_host(int extra, struct device *);
>
>This is just broken. Putting it after private completely 
>breaks accesses to the host driver private data.

Sure,it should be added before private.

Thanks

Cliff
