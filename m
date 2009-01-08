Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbZAHPQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbZAHPQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZAHPQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:16:20 -0500
Received: from mailin.zeus.com ([212.44.21.7]:4109 "EHLO mailin.zeus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZAHPQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:16:19 -0500
Message-ID: <496618C0.4060103@zeus.com>
Date: Thu, 08 Jan 2009 15:16:16 +0000
From: Ben Mansell <ben@zeus.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Willy Tarreau <w@1wt.eu>, Jarek Poplawski <jarkao2@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
References: <20090106181559.GA29426@1wt.eu> <20090108071651.GA4496@ff.dom.local> <20090108080520.GG30749@1wt.eu> <20090108145259.GF18120@elte.hu>
In-Reply-To: <20090108145259.GF18120@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2009 15:16:16.0812 (UTC) FILETIME=[0D4746C0:01C971A4]
X-TM-AS-Product-Ver: SMEX-7.0.0.1584-5.5.1027-16388.007
X-TM-AS-Result: No--18.587200-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Willy Tarreau <w@1wt.eu> wrote:
> 
>> On Thu, Jan 08, 2009 at 07:16:51AM +0000, Jarek Poplawski wrote:
>>> On 06-01-2009 19:15, Willy Tarreau wrote:
>>> ...
>>>> Ah, so you might also have discovered a few annoyances with the API, eg
>>>> the fact that splice() returns after the first read in non-blocking mode,
>>>> as well as the fact that it never returns zero on close, but -EAGAIN,
>>>> which requires an additional recv(MSG_PEEK) to distinguish between a
>>>> close and a lack of data. But I leave that for a later discussion, let's
>>>> address the corruption issue first.
>>> FYI, this should be just fixed:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4f7d54f59bc470f0aaa932f747a95232d7ebf8b1
>>>
>> Ah cool, thanks Jarek for notifying us. Indeed, it's the exact same patch
>> I had pending here ;-)
>>
>> I'll ping Greg for a backport into -stable, as applications relying on 
>> this will clearly not work without that fix.
>>
>> The other one I had consists in removing "|| !timeo" at the end of the 
>> loop, because otherwise splice() returns very small chunks (typically 
>> 1448 or 1460 bytes), leading to disastrous performance on high bandwidth 
>> links. At 10 Gbps, this means about 800000 calls to splice() per second!
> 
> looks interesting - would you mind to submit it?

FWIW, I've also tested this change with some splice() benchmarks. I can 
confirm that removing the "|| !timeo" works well and improves 
performance significantly.


Ben
