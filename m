Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbZHQLgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbZHQLgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZHQLgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:36:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:46377 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757775AbZHQLgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,396,1246863600"; 
   d="scan'208";a="541936091"
Message-ID: <4A89409B.8020103@linux.intel.com>
Date: Mon, 17 Aug 2009 13:35:55 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, mce: Don't initialize MCEs on unknown CPUs
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817112938.GA22794@elte.hu>
In-Reply-To: <20090817112938.GA22794@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> 
> btw., i found the bug - it's due to:
> 
>   # CONFIG_CPU_SUP_INTEL is not set

Ah, thanks for debugging. Very tricky and nasty. Perhaps these options are more trouble
than what they save in code.

>  static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
> @@ -1342,11 +1352,10 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
>  	if (!mce_available(c))
>  		return;
>  
> -	if (mce_cap_init() < 0) {
> +	if (mce_cap_init() < 0 || mce_cpu_quirks(c) < 0) {
>  		mce_disabled = 1;
>  		return;
>  	}
> -	mce_cpu_quirks(c);

I'm very pedantic here and it's more a theoretical problem, but mce_cap_init() allocates
memory which you leak and this could rerun on each CPU hotplug. So if you have a unknown CPU and do
a lot of CPU hotadds in a loop then you would eventually fill all memory.
Better kfree() the bank arrays.

-Andi
