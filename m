Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZC0Lnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZC0Lnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZC0Lnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:43:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:7562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZC0Lnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="398038328"
Message-ID: <49CCBC07.6000004@linux.intel.com>
Date: Fri, 27 Mar 2009 12:44:07 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 3/3] x86, mce: Add mce=nopoll option to disable timer
 polling
References: <49CB3F4B.8070406@jp.fujitsu.com> <49CB4453.6000407@linux.intel.com> <49CCA122.8070908@jp.fujitsu.com>
In-Reply-To: <49CCA122.8070908@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:

>> Also I'm not sure a boot argument is really needed. Isn't it
>> good enough to do this early at boot through sysfs?
> 
> Maybe it is good for this option, as far as polling never run
> so soon.  Because sysfs is available after start of polling
> timer, boot argument is required just in theory of logics.

I think the best way would be to just not run mcelog if you want
the BIOS to log all. The only problem I guess is that users might be confused
by the printk. So perhaps just do a patch to shut down the printk?

> 
> One another problem is that there are multiple documentations for
> machinecheck parameters, but not linked well:
> 
>  - Documentation/kernel-parameters.txt
>     ("See Documentation/x86/x86_64/boot-options.txt" for "mce=")
>  - Documentation/x86/x86_64/boot-options.txt
>     ("AMD64 specific boot options" is not true now!)
>  - Documentation/x86/x86_64/machinecheck
>     (which I had not noticed the existence at first, oops!)

machinecheck is for the sysfs interface, boot options is for the boot parameters.

I guess a reference could be added to machinecheck to point to boot-options.txt

Undoubtedly the documentation could be further improved too. In general machine
checks are rather tricky and somewhat unobvious though and I expect no matter how good
the documentation ever is it won't be easy to understand.

>>>  static int check_interval = 5 * 60; /* 5 minutes */
>>> @@ -633,11 +635,12 @@ static void mce_init_timer(void)
>>>  {
>>>  	struct timer_list *t = &__get_cpu_var(mce_timer);
>>>  
>>> +	/* Disable polling if check_interval is 0 */
>>> +	if (!check_interval)
>>> +		return;
>> This check shouldn't be needed, the next two checks already do that.
> 
> That is for readability improvement.

it was actually a cheesy way to avoid a race with multiple initializers, but
I fixed this in a better way in a upcoming patch (now the interval is per CPU)

> +	/* Disable polling if check_interval is 0 */
> +	if (!check_interval)
> +		return;
>  	/* data race harmless because everyone sets to the same value */
>  	if (!next_interval)
>  		next_interval = check_interval * HZ;
> -	if (!next_interval)
> -		return;
> 
> Are there any case where the HZ becomes 0?

No.

-Andi
