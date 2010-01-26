Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710Ab0AZJHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0AZJHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492Ab0AZJHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:07:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42229 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0AZJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:07:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B5EB092.80901@jp.fujitsu.com>
Date: Tue, 26 Jan 2010 18:06:26 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic> <20100125131915.GA7801@basil.fritz.box> <20100126063343.GA18865@liondog.tnic>
In-Reply-To: <20100126063343.GA18865@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/01/26 15:33), Borislav Petkov wrote:
> In the end, even if the info were correct, it is still not nearly enough
> for all the information you might need from a system. So you end up
> pulling a dozen of different tools just to get the info you need. So
> yes, I really do think we need a tool to get do the job done right and
> on any system. And this tool should be distributed with the kernel
> sources like perf is, so that you don't have to jump through hoops to
> pull the stuff (Esp. if you have to build everything everytime like
> Andreas does :)).

How about having a system file which can be maintained with kernel,
e.g. like /proc/hwinfo, /sys/devices/platform/hwinfo, or directory
with some files like /somewhere/hwinfo/{dmi,acpi,pci,...} etc.?

>> And since it's kernel
>> based it cannot do most of the interesting reactions. And it doesn't
>> have a usable interface to add user events.
>>
>> And yes having all that crap in syslog is completely useless, unless
>> you're debugging code.
> 
> So basically, IMHO we need:
> 
> 1. Resilient error reporting that reliably pushes decoded error info to
> userspace and/or network. That one might be tricky to do but we'll get
> there.

I think it would be better to think "error" is a subset of "event",
which could be reported if interested but otherwise be filtered.
Use of TRACE_EVENT() for mce event aim such approach at least.

> 2. Error severity grading and acting upon each type accordingly. This
> might need to be vendor-specific.

I think you mean severity grading in kernel.
Even if hardware reported an error and graded it as corrected, kernel
can escalate the severity, likely based on some threshold.

> 3. Proper error format suiting all types of errors.

As mentioned in Andi's PDF, CPER format is one of good candidate
available today, I think.
However we could invent more suitable one if needed.

> 4. Vendor-specific hooks where it is needed for in-kernel handling of
> certain errors (L3 cache index disable, for example).

Some difficulty would be there to add such hook in the UE handling path,
but anyway we can have it for the CE path.  Just need to be organized.

> 5. Error thresholding, representation, etc all done in userspace (maybe
> even on a different machine).

(...BTW, how about putting mcelog tree under the /tools, Andi?)

> 6. Last but not least, and maybe this is wishful thinking, a good tool
> to dump hwinfo from the kernel. We do a great job of detecting that info
> already - we should do something with it, at least report it...

Of course I want to have a tool to get a summary (not full dump) of
current hardware status too: e.g.
  $ cat ./hwinfo/faulty
  WARN: DIMM @ slot X on node Y: 208 errors corrected in last 3 days
  INFO: PCI 0000:NN:01.1: 1 error recovered 37 hours ago

> Let's see what the others think.
> 
> Thanks.

Thanks,
H.Seto

