Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZCXFck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZCXFck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZCXFca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:32:30 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:56221 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZCXFc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:32:29 -0400
Message-ID: <49C87017.1000408@cosmosbay.com>
Date: Tue, 24 Mar 2009 06:31:03 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private	futexes
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <20090322045414.GD7278@localdomain> <49C5F3FD.9010606@cosmosbay.com> <20090323202837.GE7278@localdomain> <49C805E3.4060808@cosmosbay.com> <20090324031925.GF7278@localdomain>
In-Reply-To: <20090324031925.GF7278@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Mar 2009 06:31:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai a écrit :
> On Mon, Mar 23, 2009 at 10:57:55PM +0100, Eric Dumazet wrote:
>> Ravikiran G Thirumalai a écrit :
> [...]
>>> Hmm!  How about
>>> a) Reduce hash table size for private futex hash and increase hash table
>>>    size for the global hash?
>>>
>>> OR, better,
>>>
>>> b) Since it is multiple spinlocks on the same cacheline which is a PITA
>>>    here, how about keeping the global table, but just add a dereference
>>>    to each hash slot, and interleave the adjacent hash buckets between
>>>    nodes/cpus? So even without needing to  lose out memory from padding,
>>>    we avoid false sharing on cachelines due to unrelated futexes hashing
>>>    onto adjacent hash buckets?
>>>
>> Because of jhash(), futex slots are almost random. No need to try to interleave
>> them. Since you have a "cache line" of 4096 bytes, you need almost 4 pages
>> per cpu to avoid in a statistical way false sharing.
> 
> How did you come up with that number?  So there is no way adjacent
> cachelines will never ever be used in the global hash??
> 
> 

There is no way, unless you use one chain per 4096 bytes block, and that
would be a waste of memory.

Its about statistics (assuming jhash gives us normally distributed values),
not hard and guaranted constraints.

http://en.wikipedia.org/wiki/Standard_deviation

For a particular process, you can carefully chose (knowing hash function
in use by kernel), user land futexes that will *all* be hashed in a *single*
hash chain, protected by a single spinlock.

This process will then suffer from contention, using private futexes
and private or shared hash table.

Even without knowing hash function, there is still a small chance that it
can happen.

Please note that the hash table size has several purposes, first one being storing
potentially many futexes (say 30000 threads are waiting on different futexes),
and being able to avoid cache line ping pongs or misses. This is why I chose
at least 256 slots per cpu, and not 4 cache lines per cpu.


