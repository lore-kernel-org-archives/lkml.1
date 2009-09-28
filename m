Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZI1I7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZI1I7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZI1I7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:59:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48170 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI1I7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:59:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC07AE4.7010203@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 17:59:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v2] x86, mce, inject: Make injected mce valid only during
 faked handler call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC05A57.1080505@jp.fujitsu.com>	 <1254121753.15717.1373.camel@yhuang-dev.sh.intel.com>	 <4AC06D96.4000508@jp.fujitsu.com> <1254126457.15717.1405.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1254126457.15717.1405.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
>>>> Are there the reverse case - is it possible that the faked handler
>>>> call might consume real error which is not handled yet by the real
>>>> machine_check_poll?
>>> Yes. It's possible at least in theory. But whole mce-inject.c is used
>>> for testing only. The faked handler call will not occur on real system.
>> Just I concerned that it may confuse the mce test suite.
> 
> I don't think that is a big issue. Real MCE is very rare for a normal
> machine.

It's true.
However it is better not to touch the real data during the test, to
minimize the confusion.

>>> MCX_ prefix is the naming convention used all over the mce.h, such as
>>> MCG_, MCI_, MCM_, if we want to change MCJ_ into MCE_INJ_, we should
>>> consider changing all these into similar style to keep consistent. 
>> That is bad naming convention, isn't it?
>> I don't mind considering changing all those.
> 
> MCG_ and MCI_ (MCi) comes from "Intel Software developer's manual Vol
> 3A", I think keep consistent is more important.

Keeping consistent for defined in spec is good, but I don't think using
same convention between defined and undefined is required.
So now I think MCM_ should be changed, while MCG_ and MCI_ should not.

>>>> I think the "finished" is not good name. (I suppose it is named
>>>> after "loading data to structure have been finished" or so.)
>>> No. Its name is not invented for injecting. It stands for the MCE record
>>> writing to mce log buffer has finished. That is, it is named according
>>> to normal path, not testing path.
>> I know it.
>> I just point that there is a bad name since early times.
> 
> It is not a bad time when it is used for mce_log and mce_read. Only
> finished mce can be read out.

It would be good time to rename/restructure all when your "ring buffer"
patch is applied.

>>>> I believe what you want to do here is "make mce_rdmsrl()/mce_wrmsrl()
>>>> to refer faked data only during faked handler call."
>>>> Then what we have to do is making a flag to indicate that "now
>>>> in faked handler call," for an example:
>>>>
>>>>     309         if (__get_cpu_var(mce_fake_in_progress)) {
>>>>
>>>> and:
>>>> 	local_irq_save(flags);
>>>> 	__get_cpu_var(mce_fake_in_progress) = 1;
>>>> 	machine_check_poll(0, &b);
>>>> 	__get_cpu_var(mce_fake_in_progress) = 0;
>>>> 	local_irq_restore(flags);
>>> I don't think this method is better than the original one. They are just
>>> equivalent. 
>> No, you changed usage of .finished, and transfer the functionality of the
>> flag to newly introduced MCJ_LOADED.
>> We can keep .finished as is, and introduce one new flag for this.
> 
> You just use .finished as MCJ_LOADED and mce_fake_in_progress
> as .finished.

I just recommends you to keep .finished as a flag indicates "loading finished."

> Use a per-CPU variable mce_fake_in_progress make it hard to add support
> to inject multiple MCEs in one CPU.

Why?  I think it can with such per-cpu flag.


Thanks,
H.Seto

