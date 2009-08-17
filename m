Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZHQLyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZHQLyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbZHQLyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:54:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650AbZHQLyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:54:20 -0400
Date: Mon, 17 Aug 2009 13:53:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, mce: Don't initialize MCEs on unknown CPUs
Message-ID: <20090817115341.GA13895@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817112938.GA22794@elte.hu> <4A89409B.8020103@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89409B.8020103@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> Ingo Molnar wrote:
>
>>
>> btw., i found the bug - it's due to:
>>
>>   # CONFIG_CPU_SUP_INTEL is not set
>
> Ah, thanks for debugging. Very tricky and nasty. Perhaps these options are more trouble
> than what they save in code.
>
>>  static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
>> @@ -1342,11 +1352,10 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
>>  	if (!mce_available(c))
>>  		return;
>>  -	if (mce_cap_init() < 0) {
>> +	if (mce_cap_init() < 0 || mce_cpu_quirks(c) < 0) {
>>  		mce_disabled = 1;
>>  		return;
>>  	}
>> -	mce_cpu_quirks(c);
>
> I'm very pedantic here and it's more a theoretical problem, but 
> mce_cap_init() allocates memory which you leak and this could 
> rerun on each CPU hotplug. So if you have a unknown CPU and do a 
> lot of CPU hotadds in a loop then you would eventually fill all 
> memory. Better kfree() the bank arrays.

Not really, we dont re-run mce_cap_init() if MCE is disabled so 
there's no memory leak that would fill all memory.

	Ingo
