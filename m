Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZBTDRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZBTDRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBTDRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:17:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:39904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZBTDRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:17:23 -0500
Message-ID: <499E20BC.4020408@kernel.org>
Date: Fri, 20 Feb 2009 12:17:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu>
In-Reply-To: <20090219110718.GK2354@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 03:17:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Tejun Heo wrote:
>>>   One trick we can do is to reserve the initial chunk in non-vmalloc
>>>   area so that at least the static cpu ones and whatever gets
>>>   allocated in the first chunk is served by regular large page
>>>   mappings.  Given that those are most frequent visited ones, this
>>>   could be a nice compromise - no noticeable penalty for usual cases
>>>   yet allowing scalability for unusual cases.  If this is something
>>>   which can be agreed on, I'll pursue this.
>> I've given more thought to this and it actually will solve 
>> most of issues for non-NUMA but it can't be done for NUMA.  
>> Any better ideas?
> 
> It could be allocated via NUMA-aware bootmem allocations.

Hmmm... not really.  Here's what I was planning to do on non-NUMA.

  Allocate the first chunk using alloc_bootmem().  After setting up
  each unit, give back extra space sans the initialized static area
  and some amount of free space which should be enough for common
  cases by calling free_bootmem().  Mark the returned space as used in
  the chunk map.

This will allow sane chunk size and scalability without adding TLB
pressure, so it's actually pretty sweet.  Unfortunately, this doesn't
really work for NUMA because we don't have control over how NUMA
addresses are laid out so we can't allocate contiguous NUMA-correct
chunk without remapping.  And if we remap, we can't give back what's
left to the allocator.  Giving back the original address doubles TLB
usage and giving back the remapped address breaks __pa/__va.  :-(

Thanks.

-- 
tejun
