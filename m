Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYCHR5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYCHR5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCHR5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:57:37 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:2492 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYCHR5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:57:37 -0500
Message-Id: <47D28BAC.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Sat, 08 Mar 2008 10:50:52 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <dmitry.adamushko@gmail.com>, <ego@in.ibm.com>,
       <suresh.b.siddha@intel.com>, <yi.y.yang@intel.com>,
       <tglx@linutronix.de>, <akpm@linux-foundation.org>, <rjw@sisk.pl>,
       <oleg@sign.ru>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adjust root-domain->online span in response to
	hotplugevent
References: <20080308015045.GB15909@linux-os.sc.intel.com>
 <20080308050627.4831.87630.stgit@novell1.haskins.net>
 <20080308084118.GA24552@elte.hu>
In-Reply-To: <20080308084118.GA24552@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Sat, Mar 8, 2008 at  3:41 AM, in message <20080308084118.GA24552@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>>    Unfortunately, this patch will introduce its own set of bugs. 
>> However, your analysis was spot-on.  I think I see the problem now.  
>> It was introduced when I put a hack in to "fix" s2ram problems in -mm 
>> as a result of the new root-domain logic.  I think the following patch 
>> will fix both issues:
>> 
>> (I verified that I could take a cpu offline/online, but I don't have 
>> an s2ram compatible machine handy.  Andrew, I believe you could 
>> reproduce the s2ram problem a few months ago when that issue popped 
>> up.  So if you could, please verify that s2ram also works with this 
>> patch applied, in addition to the hotplug problem.
> 
> thanks Gregory, i've queued up your fix. If it passes all tests over the 
> day i'll send it to Linus in about 12 hours.
> 


After thinking about it some more, I am not sure if I got this fix quite right. The first two hunks are technically fine and should ultimately go in.  The last hunk is questionable.

Ultimately, I believe the root cause of these reported issues is that cpu_online_map and rd->online can get out of sync.  I fear that while the current patch may fix the hotplug/s2ram case, it potentially breaks the disjoint cpuset topology change case.  I will run a few cpuset tests ASAP to confirm, though I may not have a chance until Monday.

What I probably need is to tie the code that sets/clears cpu_online_map to the root-domain rd->online map somehow.  However, a cursory cscope inspection has failed to reveal the location that this cpu_online_map manipulation occurs.  If anyone knows where cpu_online_map is actually updated, please let me know.  Otherwise, let me think about this some more and get back to you.

In the meantime, cpu_and'ing "task->cpus_allowed & cpu_online_map & rd->online" in the place that Suresh identified should technically fix the hotplug issue without adding more bugs, at the expense of requiring two calls to cpu_and().  The expense should be more or less negligible on mainstream kernels, but may hurt our big-iron (e.g. SGI) brethren.  Hopefully I will come up with a real fix shortly, before it becomes a real issue.

Regards,
-Greg
