Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbXGHKX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbXGHKX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbXGHKXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:23:16 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:27874 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757045AbXGHKXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:23:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ycv8MWOh5TrVHogBY9RX4SEnjxzok0QVwccsKiBU+J06m7SpEP/2CBx+xuBUPflft04AHbbtovkT4QdHL+4Odj8MyxubLLD4AsiQlKtTKhwpQ0lFRxzNAG7ma1clPdrlK4sef4VMy02FT89bFj+xpGQnNxW5Aq+JZDz/2q7Yzb0=  ;
X-YMail-OSG: iEEimnIVM1mgnZXOd.Lo.fdmwvf5OpeYbAvkU_tNY9_AGdwm
Message-ID: <4690BB0A.4030801@yahoo.com.au>
Date: Sun, 08 Jul 2007 20:23:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, Matt Mackall <mpm@selenic.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <4690B1A4.4010703@yahoo.com.au> <20070708095422.GA2744@elte.hu>
In-Reply-To: <20070708095422.GA2744@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>I said exactly the same thing last time this came up. I would love to 
>>remove code if its functionality can be adequately replaced by 
>>existing code, but I think your reasons for removing SLOB aren't that 
>>good, and just handwaving away the significant memory savings doesn't 
>>work.
> 
> 
> yeah. Also, the decision here is pretty easy: the behavior of the 
> allocator is not really visible to applications. So this isnt like 
> having a parallel IO scheduler or a parallel process scheduler (which 
> cause problems to us by fragmenting the application space) - so the 
> long-term cost to us kernel maintainers should be relatively low.

Yep.


>>>A year ago the -rt kernel defaulted to the SLOB for a few releases, 
>>>and barring some initial scalability issues (which were solved in 
>>>-rt) it worked pretty well on generic PCs, so i dont buy the 'it 
>>>doesnt work' argument either.
>>
>>It's actually recently been made to work on SMP, it is much more 
>>scalable to large memories, and some initial NUMA work is happening 
>>that some embedded guys are interested in, all without increasing 
>>static footprint too much, and it has actually decreased dynamic 
>>footprint too.
> 
> 
> cool. I was referring to something else: people were running -rt on 
> their beefy desktop boxes with several gigs of RAM they complained about 
> the slowdown that is caused by SLOB's linear list walking.

That is what I meant by scalable to large memories. It is not perfect,
but it is much better now. I noticed huge slowdowns too when test booting
the slob RCU patch on my 4GB desktop, so I did a few things to improve
freelist walking as well (the patches are in -mm, prefixed with slob-).

Afterwards, performance seems to be fairly good (obviously not as good
as SLAB or SLUB on such a configuration, but definitely usable and the
desktop was not noticably slower).


> Steve Rostedt did two nice changes to fix those scalability problems. 
> I've attached Steve's two patches. With these in place SLOB was very 
> usable for large systems as well, with no measurable overhead. 
> (obviously the lack of per-cpu caching can still be measured, but it's a 
> lot less of a problem in practice than the linear list walking was.)

Thanks for sending those. One is actually obsolete because we removed
bigblock list completely, however I had not seen the other one. Such an
approach could be used, OTOH, having all allocations come from the same
pool does have its advantages in terms of memory usage.

I don't think it has been quite decided on the next step to take with
SLOB, however I have an idea that if we had per-cpu freelists (where
other lists could be used as a fallback), then that would go a long way
to improving the SMP scalability, CPU cache hotness, and long list
walking issues all at once.

However I like the fact that there is no need for a big rush to improve
it, and so patches and ideas can be brewed up slowly :)

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
