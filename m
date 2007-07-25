Return-Path: <linux-kernel-owner+w=401wt.eu-S1762600AbXGYFUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600AbXGYFUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXGYFUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:20:09 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34031 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752362AbXGYFUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:20:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vykiYwYCr9qirzdrw1leu/uvxl1u/IASJgizhzIfa8DhseF4sKf04zE8ZnPWn3yvLzuwm4lFYdyjBwjhpZRilSpgMzk7iacHVfcd+CnyjROizvoTBV+SHBLnE62OWIIdlUUa3rUzqpSdi0P4PiF+/zHw57VlhWpgx3zQ6ALirVI=  ;
X-YMail-OSG: dpZYypEVM1nHE8vufvS1UfN00JWtDa2OXuW2qecfiK78ONuFC_LhL3wQLwWchqlrlcovQ320Bg--
Message-ID: <46A6DD7F.1050505@yahoo.com.au>
Date: Wed, 25 Jul 2007 15:19:59 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric St-Laurent <ericstl34@sympatico.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
References: <20070721210005.000228000@chello.nl>	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>	 <20070722081010.GA6317@mail.ustc.edu.cn>	 <1185093236.6344.87.camel@localhost.localdomain>	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>
In-Reply-To: <1185338106.7105.44.camel@perkele>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric St-Laurent wrote:
> On Mon, 2007-23-07 at 19:00 +1000, Nick Piggin wrote:
> 
> 
>>I don't like this kind of conditional information going from something
>>like readahead into page reclaim. Unless it is for readahead _specific_
>>data such as "I got these all wrong, so you can reclaim them" (which
>>this isn't).
>>
>>But I don't like it as a use-once thing. The VM should be able to get
>>that right.
>>
> 
> 
> 
> Question: How work the use-once code in the current kernel? Is there
> any? I doesn't quite work for me...

What *I* think is supposed to happen is that newly read in pages get
put on the inactive list, and unless they get accessed againbefore
being reclaimed, they are allowed to fall off the end of the list
without disturbing active data too much.

I think there is a missing piece here, that we used to ease the reclaim
pressure off the active list when the inactive list grows relatively
much larger than it (which could indicate a lot of use-once pages in
the system).

Andrew got rid of that logic for some reason which I don't know, but I
can't see that use-once would be terribly effective today (so your
results don't surprise me too much).

I think I've been banned from touching vmscan.c, but if you're keen to
try a patch, I might be convinced to come out of retirement :)


> See my previous email today, I've done a small test case to demonstrate 
> the problem and the effectiveness of Peter's patch.  The only piece
> missing is the copy case (read once + write once).
> 
> Regardless of how it's implemented, I think a similar mechanism must be
> added. This is a long standing issue.
> 
> In the end, I think it's a pagecache resources allocation problem. the
> VM lacks fair-share limits between processes. The kernel doesn't have
> enough information to make the right decisions.
> 
> You can refine or use more advanced page reclaim, but some fair-share
> splitting (like the CPU scheduler) between the processes must be
> present.  Of course some process should have large or unlimited VM
> limits, like databases.
> 
> Maybe the "containers" patchset and memory controller can help.  With
> some specific configuration and/or a userspace daemon to adjust the
> limits on the fly.
> 
> Independently, the basic large file streaming read (or copy) once cases
> should not trash the pagecache. Can we agree on that?

One man's trash is another's treasure: some people will want the
files to remain in cache because they'll use them again (copy it
somewhere else, or start editing it after being copied or whatever).

But yeah, we can probably do better at the sequential read/write
case.


> I say, let's add some code to fix the problem.  If we hear about any
> regression in some workloads, we can add a tunable to limit or disable
> its effects, _if_ a better compromised solution cannot be found.

Sure, but let's figure out the workloads and look at all the
alternatives first.

-- 
SUSE Labs, Novell Inc.
