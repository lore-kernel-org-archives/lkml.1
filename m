Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbYF3TB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbYF3TB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYF3TBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:01:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41928 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYF3TBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:01:20 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5328"; a="4166573"
Message-ID: <48692D7C.10403@qualcomm.com>
Date: Mon, 30 Jun 2008 12:01:16 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] S390 topology: don't use kthread() for	arch_reinit_sched_domains()
References: <20080629165132.GA11218@tv-sign.ru> <20080630134537.GC7686@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080630134537.GC7686@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sun, Jun 29, 2008 at 08:51:32PM +0400, Oleg Nesterov wrote:
>>  static void topology_work_fn(struct work_struct *work)
>>  {
>> -	/* We can't call arch_reinit_sched_domains() from a multi-threaded
>> -	 * workqueue context since it may deadlock in case of cpu hotplug.
>> -	 * So we have to create a kernel thread in order to call
>> -	 * arch_reinit_sched_domains().
>> -	 */
>> -	kthread_run(topology_kthread, NULL, "topology_update");
>> +	arch_reinit_sched_domains();
> 
> Thank you! Tested and still works ;)

btw Ideally we should not be calling arch_reinit_sched_domains() here 
because it'll nuke all sched domains created by the cpuset. We should 
instead notify cpusets subsystem and let it rebuild sched domains. In 
order to do that we either have to make rebuild_sched_domains() callable 
from any context or change arch_init_sched_domains() to no destroy 
current domains. Paul M. sent some patches to address first option and 
I'm working on the second option.

Max


