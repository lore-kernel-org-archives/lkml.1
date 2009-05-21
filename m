Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZEUXRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZEUXRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZEUXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:17:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZEUXRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:17:15 -0400
Message-ID: <4A15E130.1070808@kernel.org>
Date: Fri, 22 May 2009 08:18:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org>	 <1242500964.27006.8636.camel@localhost.localdomain>	 <4A0F672A.3000309@kernel.org>	 <1242674444.27006.8691.camel@localhost.localdomain>	 <4A11B9E7.8010707@zytor.com>	 <1242680835.27006.8734.camel@localhost.localdomain>	 <4A120B47.8060200@kernel.org>	 <1242860470.27006.10106.camel@localhost.localdomain>	 <4A149B89.3010104@kernel.org>	 <1242866163.27006.10125.camel@localhost.localdomain>	 <4A14B271.5010202@kernel.org> <1242933008.27006.10150.camel@localhost.localdomain>
In-Reply-To: <1242933008.27006.10150.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 23:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh.

Suresh Siddha wrote:
> On Wed, 2009-05-20 at 18:46 -0700, Tejun Heo wrote:
>> Yes it will.  The question is which way would be better.  Till now,
>> there hasn't been any actual data on how remap compares to 4k. 
> 
> I am not sure if we see any measurable difference. Even if we use 4k
> entries, it will be few  entries that kernel will be referring to
> frequently.

Yeah, I hope so too but I *really* want to see some numbers before
taking further actions.  Remap is chosen as the default because it
deviates less from the original behavior but I'll be excited to drop
it if 4k works just fine.

>> On NUMA, both remap and 4k add some level of TLB pressure.  remap will
>> waste one more PMD TLB entry (dup) while 4k adds a bunch of 4k ones
>> (non-dup but what used to be accessed by PMD TLB is now accessed with
>> PTE TLB).  Some say using one more PMD TLB is better while others
>> disagree.  So, the best course of action here seems to offer both and
>> easy way to select between them so that data can be gathered, which is
>> what this patchset does.
> 
> So with the planned future change of percpu unit allocation during cpu
> online, you are planning to try large page allocation first and then
> fallback to 4k pages, if that doesn't succeed. And then populate new
> percpu ptr accordingly and then sort wrt to other cpu ptr's, so that we
> can keep aliases in sync for future(and in parallel) cpa()'s that might
> be happening.
> 
> There is nothing wrong with all this. Just the code complexity (and
> maintenance) for what we are trying to gain ;)

No, I'll let the first chunk allocation happen the same way for cpus
available on boot and then just do 4k allocations for whatever
necessary afterward.  The needed code change in percpu proper isn't
that big.  What would take more effort is auditing all percpu users.

Thanks.

-- 
tejun
