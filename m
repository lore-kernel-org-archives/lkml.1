Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYB0Xix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYB0Xix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYB0Xin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:38:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33140 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbYB0Xim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:38:42 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5239"; a="953453"
Message-ID: <47C5F470.7000802@qualcomm.com>
Date: Wed, 27 Feb 2008 15:38:24 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl>
In-Reply-To: <20080227222103.673194000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> My vision on the direction we should take wrt cpu isolation.
General impressions:
- "cpu_system_map" is %100 identical to the "~cpu_isolated_map" as in my 
patches. It's updated from different place but functionally wise it's very 
much the same. I guess you did not like the 'isolated' name ;-). As I 
mentioned before I'm not hung up on the name so it's cool :).

- Updating cpu_system_map from cpusets
There are a couple of things that I do not like about this approach:
1. We lost the ability to isolate CPUs at boot. Which means slower boot times 
for me (ie before I can start my apps I need to create cpuset, etc). Not a big 
deal, I can live with it.

2. We now need another notification mechanism to propagate the updates to the 
cpu_system_map. That by itself is not a big deal. The big deal is that now we 
need to basically audit the kernel and make sure that everything affected must
have proper notifier and react to the mask changes.
For example your current patch does not move the timers and I do not think it 
makes sense to go and add notifier for the timers. I think the better approach 
is to use CPU hotplug here. ie Enforce the rule that cpu_system_map is updated 
  only when CPU is off-line.
By bringing CPU down first we get a lot of features for free. All the kernel 
threads, timers, softirqs, HW irqs, workqueues, etc are properly 
terminated/moved/canceled/etc. This gives us a very clean state when we bring 
the CPU back online with "system" bit cleared (or "isolated" bit set like in 
my patches). I do not see a good reason for reimplementing that functionality 
via system_map notifiers.

I'll comment more on the individual patches.

> Next on the list would be figuring out a nice solution to the workqueue
> flush issue.
Do not forget the "stop machine", or more specifically module loading/unloading.

Max
