Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbXHGRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbXHGRVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760250AbXHGRVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:21:39 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:39226 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbXHGRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:21:38 -0400
Message-ID: <46B8A9DA.9030804@csr.com>
Date: Tue, 07 Aug 2007 18:20:26 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] sdio: set the functions' block size
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86B88.5050009@csr.com> <20070807153800.734a6cbf@poseidon.drzeus.cx>
In-Reply-To: <20070807153800.734a6cbf@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 17:20:33.0496 (UTC) FILETIME=[4300F580:01C7D917]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 07 Aug 2007 13:54:32 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>>  
>> Index: mmc/drivers/mmc/core/sdio.c
>> ===================================================================
>> --- mmc.orig/drivers/mmc/core/sdio.c	2007-08-07
>> 00:38:33.000000000 +0100 +++ mmc/drivers/mmc/core/sdio.c
>> 2007-08-07 07:17:29.000000000 +0100 @@ -53,6 +53,7 @@
>>  {
>>  	int ret;
>>  	struct sdio_func *func;
>> +	unsigned block_size;
>>  
>>  	BUG_ON(fn > SDIO_MAX_FUNCS);
>>  
>> @@ -70,6 +71,15 @@
>>  	if (ret)
>>  		goto fail;
>>  
>> +	/*
>> +	 * Set the function's block size to the largest supported by
>> +	 * both the function and the host.
>> +	 */
>> +	block_size = min(func->max_blksize,
>> func->card->host->max_blk_size);
>> +	ret = sdio_set_block_size(func, block_size);
>> +	if (ret)
>> +		goto fail;
>> +
>>  	card->sdio_func[fn - 1] = func;
>>  
>>  	return 0;
> 
> This is probably better done in the sdio_enable_func().

I don't think so. A driver might enable/disable a function multiple
times but there's no need to set the block size every time.

It may be best to move setting the block size back to before the probe
so a driver can be sure the block size is something sensible.  Consider
a failed probe that called sdio_set_block_size() -- this will currently
mess up drivers probed later.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
