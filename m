Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZATNoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZATNoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZATNnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:43:55 -0500
Received: from mailin.zeus.com ([212.44.21.7]:6819 "EHLO mailin.zeus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZATNny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:43:54 -0500
Message-ID: <4975D518.1000800@zeus.com>
Date: Tue, 20 Jan 2009 13:43:52 +0000
From: Ben Mansell <ben@zeus.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       herbert@gondor.apana.org.au, jarkao2@gmail.com, dada1@cosmosbay.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090115.153449.204259387.davem@davemloft.net> <20090115234255.GE1123@1wt.eu> <20090115234408.GA1693@1wt.eu> <20090115.155434.206643894.davem@davemloft.net> <20090119004206.GA10396@1wt.eu> <4975BD09.3020103@zeus.com> <20090120121115.GA17277@ioremap.net>
In-Reply-To: <20090120121115.GA17277@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2009 13:43:52.0151 (UTC) FILETIME=[215C2670:01C97B05]
X-TM-AS-Product-Ver: SMEX-7.0.0.1584-5.5.1027-16412.007
X-TM-AS-Result: No--9.741300-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Tue, Jan 20, 2009 at 12:01:13PM +0000, Ben Mansell (ben@zeus.com) wrote:
>> I've also tested on the same three patches (against 2.6.27.2 here), and 
>> the patches appear to work just fine. I'm running a similar proxy 
>> benchmark test to Willy, on a machine with 4 gigabit NICs (2xtg3, 
>> 2xforcedeth). splice is working OK now, although I get identical results 
>> when using splice() or read()/write(): 2.4 Gbps at 100% CPU (2% user, 
>> 98% system).
> 
> With small MTU or when driver does not support fragmented allocation
> (iirc at least forcedeth does not) skb will contain all the data in the
> linear part and thus will be copied in the kernel. read()/write() does
> effectively the same, but in userspace.
> This should only affect splice usage which involves socket->pipe data
> transfer.

I'll try with some larger MTUs and see if that helps - it should also 
give an improvement if I'm hitting a limit on the number of 
packets/second that the cards can process, regardless of splice...

>> I may be hitting a h/w limitation which prevents any higher throughput, 
>> but I'm a little surprised that splice() didn't use less CPU time. 
>> Anyway, the splice code is working which is the important part!
> 
> Does splice without patches (but with performance improvement for
> non-blocking splice) has the same performance? It does not copy data,
> but you may hit the data corruption? If performance is the same, this
> maybe indeed HW limitation.

With an unpatched kernel, the splice performance was worse (due to the 
one packet per-splice issues). With the small patch to fix that, I was 
getting around 2 Gbps performance, although oddly enough, I could only 
get 2 Gbps with read()/write() then as well...

I'll try and do some tests on a machine that hopefully doesn't have the 
bottlenecks (and one that uses different NICs)


Ben
