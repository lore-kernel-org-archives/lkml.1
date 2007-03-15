Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbXCOU0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbXCOU0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933838AbXCOU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:26:00 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:45411 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933837AbXCOUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:25:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oYkdkhR/2IhvHOVPOw8zDwRKduXGKDXsAnVYdfCTk2al1m6QMd63WRWekTqgpGqTzdCxEteVMZGjwjJUmTTjZIr44W1RarWzvyt0y09falK3rrc9Nd6XwQhF9lMbs7oUQ871vLy2gU0p9qJRCSaNMuoUPKISfKGqutFKFP8g2L0=  ;
X-YMail-OSG: OAz1s3cVM1k6IGaoa3H00c2Cf4C.pp.fcbNBudvh1QCb0jnCc8X6z0fkH_qZ.BN1V6gnd5Wj5K9icgQqtbEFzjfhraP3bMZxv8E6jraujFyQtqE2Q4GGBaRRY0l99TxYJhJWCGFSF5bCeN0-
Message-ID: <45F9ABD1.70204@yahoo.com.au>
Date: Fri, 16 Mar 2007 07:25:53 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] FUTEX : introduce private hashtables
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com> <200703152016.25703.dada1@cosmosbay.com>
In-Reply-To: <200703152016.25703.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> [PATCH 2/3] FUTEX : introduce private hashtables
> 
> This patch introduces a separate hashtable per process to store _PRIVATE 
> futexes.
> This hashtable is dynamically allocated on the first _PRIVATE futex syscall.
> If memory cannot be allocated, the process will use the global hashtable.
> 
> Using a separate hashtable has the advantage of lowering the contention on the 
> global hashtable. NUMA should benefits of this separation because the 
> allocation should respect the mm policy of the process.
> 
> Code is using kmalloc()/vmalloc() depending on the size of spinlocks. For 
> normal setup, size of the private hashtable should be 768 bytes on 32bit 
> arches, 1536 bytes on 64bit arches.
> 
> Private hashtable is freed() when process exits.


I do disagree with this patch, though.

There should be little contention on the memory in the global hash anyway,
because we can roughly reduce contention as a factor of hash-size/cacheline-size.

What we will have are cache misses on the global table... but we're going to
get cache misses on those private tables as well. Also, you never know what
the use cases are going to be... there could be an application with thousands
of threads and mutexes in which case your private hash could be too small... I
think w e want to stay away from per-mm _anything_ with private futexes, which
is the direction that your patch 1 takes us.

I would just avoid the complexity and setup/teardown costs, and just use a
vmalloc'ed global hash for NUMA.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
