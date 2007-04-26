Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXDZGjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXDZGjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXDZGjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:39:13 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:33897 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933012AbXDZGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:39:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=e6VAJYEMgnUkazVrAw1BzwrWLiIq+OxXq5wyWY4YLQJqbQyueypetbkqtkM9ruueE7rqJPXFV9PlXwCOnvyWske1UB3DFgOnPQL8NRqmPLfu1GhkrzCiwUAHXtvoJWxQ5ojZehVEkfflB9kIvVvauR8ouBZVassGnJxbeaWHSks=  ;
X-YMail-OSG: _iq9A7MVM1mjlyLv6rQSAyyHmzt5RujUwR__G_sla6oDU7sThIM0FFV3WbEBqEmq.2uYXRK32Q--
Message-ID: <463048FE.5000600@yahoo.com.au>
Date: Thu, 26 Apr 2007 16:38:54 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Christoph Lameter <clameter@sgi.com> writes:

>>>Right now I don't even want to think about trying to use a swap device
>>>with a large block size when we are low on memory.
>>
>>But that is due to the VM (at least Linus tree) having no defrag methods.
>>mm has Mel's antifrag methods and can do it.
> 
> 
> This is fundamental.  Fragmentation when you multiple chunk sizes
> cannot be solved without a the ability to move things in memory,
> whereas it doesn't exist when you only have a single chunk size.

And even if you can (and you can't always, because the anti-frag is
only heuristics), then it costs you complexity and overhead to do.


>>Less meta data to manage does not reduce fsck times? Going from order 0 to 
>>order 2 blocks cuts the metadata to a fourth.
> 
> 
> I agree that less meta data helps.  But switching to extents can reduce the
> meta data much more, and still doesn't penalize you for small files if
> you have them.

Anyway, this is a general large block size issue, and not specifically
anything to do with large pagecache size.


>>There are multiple scaling issues in the kernel. What you propose is to 
>>add hack over hack into the VM to avoid having to deal with 
>>defragmentation. That in turn will cause churn with hardware etc
>>etc.
> 
> 
> No. I propose to avoid all designs that have the concept of
> fragmentation.

Yeah. IMO anti-fragmentation and defragmentation is the hack, and we
should stay away from higher order allocations whenever possible.

Hardware is built to handle many small pages efficintly, and I don't
understand how it could be an SGI-only issue. Sure, you may have an
order of magnitude or more memory than anyone else, but even my lowly
desktop _already_ has orders of magnitude more pages than it has TLB
entries or cache -- if a workload is cache-nice for me, it probably
will be on a 1TB machine as well, and if it is bad for the 1TB machine,
it is also bad on mine.

If this is instead an issue of io path or reclaim efficiency, then it
would be really nice to see numbers... but I don't think making these
fundamental paths more complex and slower is a nice way to fix it
(larger PAGE_SIZE would be, though).

-- 
SUSE Labs, Novell Inc.
