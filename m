Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZIGVZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZIGVZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZIGVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:25:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:32878 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZIGVZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:25:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AA57A15.1030705@s5r6.in-berlin.de>
Date: Mon, 07 Sep 2009 23:24:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: pageexec@freemail.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] firewire: core: reduce stack usage in bus reset tasklet
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>, <tkrat.3db711855693c0e5@s5r6.in-berlin.de> <4AA558DF.5024.3D1AC09D@pageexec.freemail.hu> <4AA55BCF.6080609@s5r6.in-berlin.de>
In-Reply-To: <4AA55BCF.6080609@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> pageexec@freemail.hu wrote:
>> On 6 Sep 2009 at 18:48, Stefan Richter wrote:
>>
>>> Index: linux-2.6.31-rc9/drivers/firewire/core-card.c
>>> ===================================================================
>>> --- linux-2.6.31-rc9.orig/drivers/firewire/core-card.c
>>> +++ linux-2.6.31-rc9/drivers/firewire/core-card.c
>>> @@ -38,16 +38,21 @@
>>>  
>>>  #include "core.h"
>>>  
>>> -int fw_compute_block_crc(u32 *block)
>>> +int fw_compute_block_crc(u32 *block, gfp_t flags)
>>>  {
>>> -    __be32 be32_block[256];
>>> -    int i, length;
>>> +    static __be32 *be32_block;
>>        ^^^^^^
>>
>> did you actually mean that to be static? if so, then you might as well 
>> allocate the
>> buffer statically and not worry about a runtime allocation failure.
> 
> Uh, that's a cut'n'paste mistake.  It shouldn't be static.  Thanks, I'll 
> correct that before I put it into linux1394-2.6.git.
> 
>>> +    int i, length = (*block >> 16) & 0xff;
>>> +
>>> +    be32_block = kmalloc(length * 4, flags);
>>> +    if (WARN_ON(!be32_block))
>>> +        goto out;
>>>  
>>> -    length = (*block >> 16) & 0xff;
>>>      for (i = 0; i < length; i++)
>>>          be32_block[i] = cpu_to_be32(block[i + 1]);
>>>      *block |= crc_itu_t(0, (u8 *) be32_block, length * 4);
>>>  
>>> +    kfree(be32_block);
>>> + out:
>>>      return length;
>>>  }

This can be optimized further to get rid of the temporary be32_block 
entirely.

There are two users of fw_compute_block_crc:  The functions which 
generate the local Config ROM CSR and then pass it down to the low-level 
driver, and the function which which generates the local Topology Map 
CSR and stores it for core-transaction.c::handle_topology_map() to read 
on demand.

The low-level driver then needs to convert the Config ROM to __be32[]. 
Likewise, handle_topology_map needs to convert the Topology Map to 
__be32[].  They would be both better off if we stored their input as 
__be32[] in the first place, and of course do so before we compute the 
CRC.  Duh.

I'll rewrite patch 1/6 and 5/6 accordingly.
-- 
Stefan Richter
-=====-==--= =--= --===
http://arcgraph.de/sr/
