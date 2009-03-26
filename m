Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZCZJAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZCZJAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZCZJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:00:40 -0400
Received: from mga10.intel.com ([192.55.52.92]:41373 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408AbZCZJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:00:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,425,1233561600"; 
   d="scan'208";a="676133614"
Message-ID: <49CB4453.6000407@linux.intel.com>
Date: Thu, 26 Mar 2009 10:01:07 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 3/3] x86, mce: Add mce=nopoll option to disable timer
 polling
References: <49CB3F4B.8070406@jp.fujitsu.com>
In-Reply-To: <49CB3F4B.8070406@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> This patch adds "mce=nopoll" option to disable timer polling
> for corrected errors from boot.  Unlike "mce=off", it doesn't
> prevent handling for uncorrected errors.
> 
> It is useful if:
>  - You don't have any interests in corrected errors. You may
>    use option mce_threshold=0 to disable cmci too.
>  - You'd like to care banks only which cmci are supported.

These two seem to be conflicting. CMCI errors are corrected errors
too. Why would the user care about the reporting mechanism
and only shut down one or not another?

Also I'm not sure a boot argument is really needed. Isn't it
good enough to do this early at boot through sysfs?

>  - You have an application such as hardware monitor that
>    checks error banks, and that can conflict with OS's polling.

Well then your patch is not enough because it doesn't shut off
boot time clearing/logging of corrected errors left over from
boot for once. And CMCI.

>  - Your system have an intelligent BIOS which can provide
>    enough health information, so reports from OS is redundant.

It would seem inconvenient then to require the user to set a special
boot option. I think it would be better if the BIOS set a flag
somewhere that the kernel can check.

> Once booted, we can disable polling by setting check_interval
> to 0, but there are no mention about the fact.

That's true, Documentation/x86/x86_64/machinecheck should be fixed
to say 0 means no polling. I'm not sure new boot option are the
preferred fix for missing documentation though @)

>  static int check_interval = 5 * 60; /* 5 minutes */
> @@ -633,11 +635,12 @@ static void mce_init_timer(void)
>  {
>  	struct timer_list *t = &__get_cpu_var(mce_timer);
>  
> +	/* Disable polling if check_interval is 0 */
> +	if (!check_interval)
> +		return;

This check shouldn't be needed, the next two checks already do that.

Also there's a conflicting patch pending which moves next_interval
to be per CPU.

-Andi
