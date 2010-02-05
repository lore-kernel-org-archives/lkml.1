Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0BERQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:16:48 -0500
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:51591 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab0BERQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:16:47 -0500
X-VR-Score: -200.00
X-Authority-Analysis: v=1.1 cv=qY0/QvRffkjURHWZjC3q+nTs9PdPIIJxYa32KydkvE8=
 c=1 sm=1 a=QE3PeaPrRxQA:10 a=r7fZvFDYeqoxe+deI480ZA==:17
 a=dSWHtMXPWB3YjZWrDiQA:9 a=dd-vtoYlfPKA9TN1FwY1oi-DHAoA:4
 a=r7fZvFDYeqoxe+deI480ZA==:117
X-CM-Score: 0.00
Message-ID: <4B6C5271.9080802@cs.ucr.edu>
Date: Fri, 05 Feb 2010 09:16:33 -0800
From: John Tyner <jtyner@cs.ucr.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: Add non-Virtex 5 support for LL TEMAC driver
References: <4B6762CE.1050001@cs.ucr.edu> <fa686aa41002031501q14e8ab54s6713edc58d0fddc1@mail.gmail.com>
In-Reply-To: <fa686aa41002031501q14e8ab54s6713edc58d0fddc1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Grant Likely wrote:
> On Mon, Feb 1, 2010 at 4:25 PM, John Tyner <jtyner@cs.ucr.edu> wrote:
>> This patch adds support for using the LL TEMAC Ethernet driver on non-Virtex
>> 5 platforms by adding support for accessing the Soft DMA registers as if
>> they were memory mapped instead of solely through the DCR's (available on
>> the Virtex 5).
>>
>> Signed-off-by: John Tyner <jtyner@cs.ucr.edu>
> 
> Hi John, thanks for doing this work.  A couple of comments below.
> 

[snip]

>>   * TODO:
>> - * - Fix driver to work on more than just Virtex5.  Right now the driver
>> - *   assumes that the locallink DMA registers are accessed via DCR
>> - *   instructions.
>>   * - Factor out locallink DMA code into separate driver
>>   * - Fix multicast assignment.
>>   * - Fix support for hardware checksumming.
>> @@ -117,12 +114,20 @@
>>
>>  static u32 temac_dma_in32(struct temac_local *lp, int reg)
>>  {
>> -	return dcr_read(lp->sdma_dcrs, reg);
>> +	if (lp->sdma_regs) {
>> +		return __raw_readl(lp->sdma_regs + reg);
>> +	} else {
>> +		return dcr_read(lp->sdma_dcrs, reg);
>> +	}
> 
> Rather than taking the ugliness an if/else block on every register
> access, why not create an ops structure and populate it with the
> correct access routines at runtime?

As you can see from the comments in the TODO section, someone thinks 
(and I would tend to agree) that it would be a good idea to separate the 
DMA code from the Ethernet driver entirely. I also agree with your 
suggestion of avoiding the ugliness of the if/else block, but it seems 
like a job better left to be done when that refactoring takes place.

This patch is only about 20 lines worth of changes, and to add a bunch 
of complexity doesn't seem worthwhile to me at this time.

>> @@ -895,7 +904,7 @@
>>
>>  	lp->phy_node = of_parse_phandle(op->node, "phy-handle", 0);
>>  	if (lp->phy_node)
>> -		dev_dbg(lp->dev, "using PHY node %s (%p)\n", np->full_name, np);
>> +		dev_dbg(lp->dev, "using PHY node %s (%p)\n", lp->phy_node->full_name, lp->phy_node);
> 
> This looks like an unrelated bug fix.  Please put into a separate
> patch and post separately.

It is an unrelated bug fix. If it's really a big deal, I can submit a 
separate patch, but it seems like it would be easier for someone to 
manually make this change than for me to go back and generate a new 
patch (since I'm not working on anything related to this anymore).

I apologize for being kind of a dick about this stuff, but as I said, 
I'm not doing anything related to this stuff anymore. The change is 
really small, but adds support for something that currently doesn't 
work, so I'm hoping somebody else is willing to take up the cause in my 
stead. :)

John
