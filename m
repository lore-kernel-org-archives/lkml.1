Return-Path: <linux-kernel-owner+w=401wt.eu-S935456AbYEUOdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456AbYEUOdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYEUOdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:33:35 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43584 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYEUOde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:33:34 -0400
Date: Wed, 21 May 2008 08:31:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ata: fix sleep-while-holding-spinlock in sata_nv
In-reply-to: <20080520214311.2d2aa8d3@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <4834323E.1060608@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.m+kShlzXY/wmFlvZXsE0W7wQIxU@ifi.uio.no>
 <48338624.3000304@shaw.ca> <20080520214311.2d2aa8d3@infradead.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rjan van de Ven wrote:
>> I'm not certain this is safe to do it quite this way. It would be
>> better to keep that spinlock held so that no operations could be in
>> progress on either port while these operations are happening.
> 
> blk_bounce_limit can sleep. that's just a fact of life ;(

Now it can, for no reason. Under the conditions it was used before, it 
never could.

> 
>> It would be better to fix the regression from 
>> 419c434c35614609fd0c79d335c134bf4b88b30b in block/blk_settings.c that 
>> resulted in the blk_queue_bounce_limit allocation wrongly allocating 
>> emergency ISA pages in the first place as a 32-bit DMA mask does not 
>> need them.
> 
> the condition under which it sleeps might be slightly buggy on your
> exact x86 machine... but that doesn't mean that that is guaranteed to
> be so forever going forward.... it's still a sleeping function.

More than slightly buggy, I think.. It seems like it is going to be 
bouncing block layer accesses to devices with 32-bit DMA masks through 
the 16MB ZONE_DMA. If that's what's actually going on, I'm surprised 
there haven't been more regression reports. The fact that the function 
now sleeps when it didn't before is the least of the problems here..
