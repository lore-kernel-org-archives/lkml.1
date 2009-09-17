Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZIQUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZIQUmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbZIQUms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:42:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:45224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZIQUmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:42:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,405,1249282800"; 
   d="scan'208";a="449452106"
Message-ID: <4AB29F4A.3030102@intel.com>
Date: Thu, 17 Sep 2009 13:42:50 -0700
From: "Graham, David" <david.graham@intel.com>
Reply-To: david.graham@intel.com
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909170118.53965.rjw@sisk.pl>
In-Reply-To: <200909170118.53965.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 15 September 2009, Karol Lewandowski wrote:
>> Hello,
>>
>> I'm getting following oops sometimes during resume on my Thinkpad T21
>> (where "sometimes" means about 10/1 good/bad ratio):
>>
>> ifconfig: page allocation failure. order:5, mode:0x8020
> 
> Well, this only tells you that an attempt to make order 5 allocation failed,
> which is not unusual at all.
> 
> Allocations of this order are quite likely to fail if memory is fragmented,
> the probability of which rises with the number of suspend-resume cycles already
> carried out.
> 
> I guess the driver releases its DMA buffer during suspend and attempts to
> allocate it back on resume, which is not really smart (if that really is the
> case).
> 
Yes, we free a 70KB block (0x80 by 0x230 bytes) on suspend and 
reallocate on resume, and so that's an Order 5 request. It looks 
symmetric, and hasn't changed for years. I don't think we are leaking 
memory, which points back to that the memory is too fragmented to 
satisfy the request.

I also concur that Rafael's commit 6905b1f1 shouldn't change the logic 
in the driver for systems with e100 (like yours Karol) that could 
already sleep, and I don't see anything else in the driver that looks to 
be relevant. I'm expecting that your test result without commit 6905b1f1 
will still show the problem.

So I wonder if this new issue may be triggered by some other change in 
the memory subsystem ?

Karol, how much physical RAM do you have in this system ? I'd expect 
that the fragmentation would be less of an issue if there's simply more 
memory in total.

Unfortunately I still have no actual repro in house.

I can try to rework the codepaths around suspend & resume so that we 
don't free & reallocate this order 5 memory, but I think its risky. I'm 
looking into that now.

Thanks


> Thanks,
> Rafael

