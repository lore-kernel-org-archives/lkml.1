Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149Ab0AaSuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0AaSuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 13:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216Ab0AaSun
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 13:50:43 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:40251 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0AaSum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 13:50:42 -0500
Date: Sun, 31 Jan 2010 13:50:33 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
In-reply-to: <4B650D53.2010607@majjas.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B65D0F9.2020602@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B61ADF1.7060705@majjas.com> <4B61BEA4.1030905@majjas.com>
 <20100128090835.0d93e53a@nehalam> <4B61DB79.4080703@majjas.com>
 <20100128223447.GC3109@del.dom.local> <4B621316.8070308@majjas.com>
 <20100128225621.GD3109@del.dom.local> <4B6216B9.1010802@majjas.com>
 <20100128153643.0fca3c51@nehalam> <4B645EF4.4050701@majjas.com>
 <20100131003449.GA11935@del.dom.local> <4B650D53.2010607@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2010 11:55 PM, Michael Breuer wrote:
> On 01/30/2010 07:34 PM, Jarek Poplawski wrote:
>>
>> Could you try the patch below to show maybe some other users of
>> dma-debug entries?
>>
>> Jarek P.
>> ---
>>
> With the default # entries & dma_debug_driver=sky2:
>
> 6:00 is eth0 & 4:00 is eth1.
>
> Jan 30 23:53:14 mail kernel: DMA-API: 0000:06:00.0: entries: 31961
> ...
>
I put a printk as a third else case in sky2_tx_unmap. Looks like the 
issue is that a large number (perhaps all) calls to sky2_tx_unmap have 
re->flags set to neither TX_MAP_SINGLE or TX_MAP_PAGE. Thus the elements 
are never being unmapped.

I suspect that the system collapses when using DMAR sooner than if not 
using DMAR. Probably some hardware limitation on the number of mapped 
elements that is less than the software limitation. I don't see at 
present how a ring element can ever get to this code without re->flags 
being set to one or the other.

