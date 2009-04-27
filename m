Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZD0JCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZD0JCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZD0JCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:02:22 -0400
Received: from gecko.sbs.de ([194.138.37.40]:15685 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZD0JCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:02:21 -0400
X-Greylist: delayed 1046 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 05:02:20 EDT
Message-ID: <49F57030.3010802@siemens.com>
Date: Mon, 27 Apr 2009 10:43:28 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       mark.langsdorf@amd.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [BUG -tip] unable to handle kernel paging request
References: <20090413165913.GA4798@hades.domain.com> <20090413205908.GA15435@linux.vnet.ibm.com> <20090423182417.GA3679@hades.domain.com>
In-Reply-To: <20090423182417.GA3679@hades.domain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques wrote:
> (CC'ing Avi Kivity and Jan Kiszka)
> On Mon, Apr 13, 2009 at 01:59:08PM -0700, Paul E. McKenney wrote:
>> On Mon, Apr 13, 2009 at 05:59:13PM +0100, Luis Henriques wrote:
>>> Hi,
>>>
>>> (not sure if I'm CC'ing all the relevant persons...)
>>>
>>> I am hitting this bug, which occurs mainly when I am shutting down my laptop.  I
>>> took a look at the cpufreq code and found out something which I am not sure if it
>>> is related with this bug (or even if it is an issue at all):
>>>
>>> void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
>>> {
>>>         struct cpufreq_policy *policy;
>>>
>>>         BUG_ON(irqs_disabled());
>>>
>>>         freqs->flags = cpufreq_driver->flags;
>>>
>>> 		...
>>>
>>> This code accesses cpufreq_driver without using the cpufreq_driver_lock.  I
>>> believe this is the only place in the code where this lock is not obtaining
>>> before accessing the global cpufreq_driver.
>>>
>>> Any ideas?
>> Well, one thought would be that SRCU is protecting it, but when I look
>> at the code, SRCU is instead only protecting the notifier chain itself.
>> So SRCU is -not- a substitute for cpufreq_driver_lock in this case.
>>
>> But the "freqs" argument looks to be a parameter block private to the
>> caller, so the modification of freqs->old is safe.  Ditto for
>> adjust_jiffies().
>>
>> This does use per-CPU data, but it is not clear to me how preemption is
>> disabled -- or that it is always operating on the current CPU, for that
>> matter.  And the few notifier callbacks I looked at did not have any
>> locking either.
>>
>> So is the cpufreq_driver_lock acquired at a higher level, for example,
>> by the guy who calls through the cpufreq_driver control blocks?
>>
>> 							Thanx, Paul
> 
> I believe my problem has finally been solved by commit
> 888d256e9c565cb61505bd218eb37c81fe77a325 in kvm git tree.  Basically, the kvm
> notifier for the cpufreq was not being unregistered when kvm module was
> unloaded and, thus, when notifier_call_chain invoked the handler for the kvm,
> there was a NULL pointer there.
> 
> Does this make sense to everybody?

If your system unloads the kvm modules on shutdown/reboot: yes, would
make sense.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
