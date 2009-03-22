Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbZCVEyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbZCVEyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 00:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZCVEyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 00:54:22 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:52113 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZCVEyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 00:54:21 -0400
Date: Sat, 21 Mar 2009 21:54:14 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private
	futexes
Message-ID: <20090322045414.GD7278@localdomain>
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C4AE64.4060400@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 10:07:48AM +0100, Eric Dumazet wrote:
>Ravikiran G Thirumalai a écrit :
>> 
>> We found this patch to improve the runtime of a certain FEA solver by about
>> 15% on a 32 core vSMP system.
>> 
>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>> Signed-off-by: Shai Fultheim <shai@scalex86.org>
>> 
>
>First incantation of PRIVATE_FUTEXES had process private hash table
>
>http://lkml.org/lkml/2007/3/15/230
>
>I dont remember objections at that time, maybe it was going to slow down small
>users of these PRIVATE_FUTEXES, ie processes that will maybe use one futex_wait()
> in their existence, because they'll have to allocate their private hash table
>and populate it.
>

With the current proposal, we can still use the global futex hashes for such
workloads (with the sysctl setting).

>So I dropped parts about NUMA and private hash tables to get PRIVATE_FUTEXES into mainline
>
>http://lwn.net/Articles/229668/
>
>Did you tried to change FUTEX_HASHBITS instead, since current value is really really
>ridiculous ?

We tried it in the past and I remember on a 16 core machine, we had to
use 32k hash slots to avoid false sharing.

>
>You could also try to adapt this patch to current kernels :
>
>http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-03/msg06504.html
>
>[PATCH 3/3] FUTEX : NUMA friendly global hashtable
>
>On NUMA machines, we should get better performance using a big futex
>hashtable, allocated with vmalloc() so that it is spreaded on several nodes.
>
>I chose a static size of four pages. (Very big NUMA machines have 64k page
>size)

Yes, dynamically changing the hash table is better (looking at the patch you
have posted), but still there are no locality guarantees here.  A process
pinned to node X may still end up accessing remote memory locations while
accessing the hash table.  A process private table on the other hand should
not have this problem. I think using a global hash for entirely process local
objects is bad design wise here.
