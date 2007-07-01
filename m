Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXGAWFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXGAWFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXGAWFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:05:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbXGAWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:05:24 -0400
Message-ID: <46882518.5050906@redhat.com>
Date: Sun, 01 Jul 2007 18:05:12 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Krzysztof Oledzki <olel@ans.pl>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: IRQ handling difference between i386 and x86_64
References: <Pine.LNX.4.64.0706301617240.16011@bizon.gios.gov.pl> <1183218035.2894.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707010045040.9268@bizon.gios.gov.pl>
In-Reply-To: <Pine.LNX.4.64.0707010045040.9268@bizon.gios.gov.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Oledzki wrote:
> 
> 
> On Sat, 30 Jun 2007, Arjan van de Ven wrote:
> 
>> On Sat, 2007-06-30 at 16:55 +0200, Krzysztof Oledzki wrote:
>>> Hello,
>>>
>>> It seems that IRQ handling is somehow different between i386 and x86_64.
>>>
>>> In my Dell PowerEdge 1950 is it possible to enable interrupts spreading
>>> over all CPUs. This a single CPU, four CORE system (Quad-Core E5335 
>>> Xeon)
>>> so I think that interrupts migration may be useful. Unfortunately, it
>>> works only with 32-bit kernel. Booting it with x86_64 leads to 
>>> situation,
>>> when all interrupts goes only to the first cpu matching a smp_affinity
>>> mask.
>>
>> arguably that is the most efficient behavior... round robin of
>> interrupts is the worst possible case in terms of performance
> 
> Even on dual/quadro core CPUs with shared cache? So why it is possible 
> to enable such behaviuor in BIOS, which works only on i386 BTW. :(
> 
>> are you using irqbalance ? (www.irqbalance.org)
> 
> Yes, I'm aware about this useful tool, but in some situations (routing 
> for example) it cannot help much as it keeps three cpus idle. :(
> 
> Best regards,
> 
>                 Krzysztof Olêdzki

Interleaving interrupt delivery will completely break TCP header 
prediction, and cost you far more CPU time than it will save.  In fact, 
because of the locking, it will probably scale negatively with the 
number of CPUs, if your workload is mostly TCP/IP processing.  The way 
around this is to ensure that the packets for any given TCP socket are 
all delivered to the same processor.  If you have multiple NICs and use 
802.3ad bonding with layer3+4 hashing, header prediction will work fine, 
and you don't have to disable irqbalance, because it will do the right 
thing.

	-- Chris
