Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbXI3MPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbXI3MPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 08:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbXI3MPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 08:15:08 -0400
Received: from sa2.bezeqint.net ([192.115.104.16]:49685 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXI3MPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 08:15:06 -0400
X-Greylist: delayed 2415 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 08:15:06 EDT
Message-ID: <46FF89D6.4090201@panasas.com>
Date: Sun, 30 Sep 2007 13:34:46 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] x86-64: pci-gart iommu sg chaining zeroes wrong sg.
References: <20070928013550M.tomof@acm.org> <20070928014634H.tomof@acm.org>
In-Reply-To: <20070928014634H.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 27, 2007, 18:46 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> On Fri, 28 Sep 2007 01:38:27 +0900
> FUJITA Tomonori <tomof@acm.org> wrote:
> 
>> This patch is for Jens' block tree (sg chaining branch).
>>
>> I don't have the hardware but this looks like a bug.
>>
>> ---
>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Subject: [PATCH] x86-64: pci-gart iommu sg chaining zeroes a wrong sg's dma_length
>>
>> Needs to zero the end of the list.
>>
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> ---
>>  arch/x86_64/kernel/pci-gart.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
>> index 27b7db4..a4151a7 100644
>> --- a/arch/x86_64/kernel/pci-gart.c
>> +++ b/arch/x86_64/kernel/pci-gart.c
>> @@ -425,9 +425,10 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>>  	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
>>  		goto error;
>>  	out++;
>> +	sgmap = sg_next(sgmap);
>>  	flush_gart();
>>  	if (out < nents)
>> -		ps->dma_length = 0;
>> +		sgmap->dma_length = 0;
>>  	return out;
> 
> Sorry, it should be:
> 
> 
> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> index 27b7db4..cfcc84e 100644
> --- a/arch/x86_64/kernel/pci-gart.c
> +++ b/arch/x86_64/kernel/pci-gart.c
> @@ -426,8 +426,10 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>  		goto error;
>  	out++;
>  	flush_gart();
> -	if (out < nents)
> -		ps->dma_length = 0;
> +	if (out < nents) {
> +		sgmap = sg_next(sgmap);
> +		sgmap->dma_length = 0;
> +	}

looks correct to me.
ps points at the previous "scanned" sg entry while you want to zero out
dma_length at the entry immediately following the last entry mapped
(if (out < nents))

the original code before 62296749bd421904dace1e6b0fc3c4538aac7111 was:
-	if (out < nents) 
-		sg[out].dma_length = 0; 

Benny

>  	return out;
>  
>  error:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

