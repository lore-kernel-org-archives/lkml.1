Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYCJMsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYCJMsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYCJMsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:48:41 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:26871 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYCJMsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:48:40 -0400
Message-Id: <47D4F455.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 10 Mar 2008 06:41:57 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: <mingo@elte.hu>, <dmitry.adamushko@gmail.com>, <ego@in.ibm.com>,
       <yi.y.yang@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <rjw@sisk.pl>, <oleg@sign.ru>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adjust root-domain->online span in response to
	hotplug event
References: <20080308015045.GB15909@linux-os.sc.intel.com>
 <20080308050627.4831.87630.stgit@novell1.haskins.net>
 <20080309023515.GC15909@linux-os.sc.intel.com>
In-Reply-To: <20080309023515.GC15909@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Sat, Mar 8, 2008 at  9:35 PM, in message
<20080309023515.GC15909@linux-os.sc.intel.com>, Suresh Siddha
<suresh.b.siddha@intel.com> wrote: 
> On Sat, Mar 08, 2008 at 12:10:15AM -0500, Gregory Haskins wrote:
>> Suresh Siddha wrote:
>>  >
>>  > -	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
>>  > +	cpus_and(*lowest_mask, task->cpus_allowed, cpu_online_map);
>> 
>> Hi Suresh,
>>    Unfortunately, this patch will introduce its own set of bugs. 
> 
> Is that because of the missing get/put_online_cpus() ?

Actually, I was referring to the problem of potentially including "out of domain" CPUs in the search, but that is a good point too.  Ill have to think about whether a get/put is needed here.


> 
>> However, your analysis was spot-on.  I think I see the problem now.  It 
>> was introduced when I put a hack in to "fix" s2ram problems in -mm as a 
>> result of the new root-domain logic.  I think the following patch will 
>> fix both issues:
> 
> BTW, what is use of per root domains online map, when we have global
> cpu_online_map() ? Each domains span & cpu_online_map should give
> domain_online_map anyhow.


Thats exactly right.  rd->online is a cached version of "rd->span & cpu_online_map".  It simply saves us from having to do an extra cpu_and() at run-time (which can be expensive as the NR_CPUS grows large).

> 
> And is n't it buggy if someone accesses rd->online with out 
> get/put_online_map()

See above: I'm not sure, but you may be right about that.

Regards,
-Greg

