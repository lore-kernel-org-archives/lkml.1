Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbZLQRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbZLQRA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764865AbZLQRAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:00:53 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:52512 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762414AbZLQRAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:00:52 -0500
Message-ID: <4B2A6394.3080705@knaff.lu>
Date: Thu, 17 Dec 2009 18:00:04 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: markh@compro.net
CC: fdutils@fdutils.linux.lu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com>	<4B2610F8.7050609@cfl.rr.com>	<4B2618EF.9020709@knaff.lu>	<4B264448.5040604@compro.net>	<4B26884C.8000306@knaff.lu>	<4B2697C4.2040204@compro.net>	<4B26A82E.5040902@knaff.lu>	<4B26B031.4060301@compro.net>	<4B26BAE3.2090408@knaff.lu>	<4B275975.8040509@cfl.rr.com>	<4B275B18.80704@knaff.lu>	<4B275D37.4090807@cfl.rr.com>	<4B2761E9.2030301@knaff.lu>	<4B276513.6030509@cfl.rr.com>	<4B276753.80807@knaff.lu>	<4B27983F.5090600@compro.net>	<4B27EF18.7050101@knaff.lu>	<4B28FDEB.3030800@compro.net>	<4B290029.90602@knaff.lu>	<4B2901DB.8040403@compro.net>	<4B29052B.9070406@knaff.lu>	<4B292D84.5040306@compro.net>	<4B29624F.2080109@knaff.lu>	<4B2A3805.8040707@compro.net>	<4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net>	<4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu>	<4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu>	<4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu>	<4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff!
 .lu>
In-Reply-To: <4B2A530D.3080606@knaff.lu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/09 16:49, Alain Knaff wrote:
> On 17/12/09 16:43, Mark Hounschell wrote:
>> On 12/17/2009 10:35 AM, Alain Knaff wrote:
>>
>>>> Should I do more work in between?
>>>
>>> No, but make sure to look at track 0... Other tracks will still have the
>>> error, as there was nothing forcing a memory flush between track 0 and 1...
>>
>> Ok track 0
> [...]
>> 0: 0
>> 1: 0
>> 2: 0
>> 3: 4f  <--
>> 4: 0 
>> 5: 1 
>> 6: 2 
>> no disk change
> 
> Yeah, that's what I meant... So the memory flusher program didn't manage to
> clear up the inconsistency...
> 
> So either my theory is wrong, or the memory flusher program was not
> efficient enough.... hmmm, maybe doing some surfing in between the formats,
> or doing another kernel compilation might be a better test.
> 
> Alain

Ok, so I had a look at the differences between 2.6.27.41 and 2.6.28, and
there have indeed been changes to the iommu and DMA handling code.

So I suspect that the problem may be lying here

Cc'ed Linus and kernel list on this. For Linux and the list, here's the
summary of what we are observing:

- A DMA transfer of a memory block transfers the wrong value for the first
byte of the block. All other bytes of the block are transferred correctly.
The value of the first byte turns out to be the value that this byte held
during the *previous* transfer. Just as if there was some kind of cache,
and the transfer started before that cache was refreshed with the new
values from main memory.

Example:

1. initial contents:  33 44 55 66
2. one DMA transfer is performed
3. program changes buffer to: 77 88 99 aa
4. new DMA transfer is performed => instead it transmits 33 88 99 aa
   (i.e. first byte is from previous contents)

This used to work in 2.6.27.41, but broke in 2.6.28 . It doesn't happen on
all hardware though.

It does indeed seem to be related to a DMA-side cache (rather than the
processor's cache not being flushed to main memory), as doing lots of
memory intensive work (kernel compilation) between 2 and 3 doesn't fix the
problem.

In the diff between 2.6.27.41 and 2.6.28, I noticed a lot of changes in
arch/x86/kernel/amd_iommu.c and related files, could any of these have
triggered this behavior?

Any ideas, anybody?

Alain
