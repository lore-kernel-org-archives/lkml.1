Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYCDCcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYCDCcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYCDCb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:31:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:18963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYCDCb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:31:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,441,1199692800"; 
   d="scan'208";a="349361542"
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: ego@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080303153154.GA11288@in.ibm.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <20080303153154.GA11288@in.ibm.com>
Content-Type: text/plain
Organization: Intel
Date: Mon, 03 Mar 2008 22:45:04 +0800
Message-Id: <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 21:01 +0530, Gautham R Shenoy wrote:
> > This issue seems such one, but i tried to change it to follow this rule but
> > the issue is still there.
> > 
> > Why isn't the kernel thread [watchdog/1] reaped by its parent? its state
> > is TASK_RUNNING with high priority (R< means this), why it isn't done?
> > 
> > Anyone ever met such a problem? Your thought?
> 
> Hi Yi,
> 
> This is indeed strange. I am able to reproduce this problem on my 4-way
> box. From what I see in the past two runs, we're waiting in the
> cpu-hotplug callback path for the watchdog/1 thread to stop.
> 
> During cpu-offline, once the cpu goes offline, in the migration_call(), 
> we migrate any tasks associated with the offline cpus
> to some other cpu. This also mean breaking affinity for tasks which were
> affined to the cpu which went down. So watchdog/1 has been migrated to
> some other cpu.
No, [watchdog/1] is just for CPU #1, if CPU #1 has been offline, it
should be killed but not migrated to other CPU because other CPU has
such a kthread.

Maybe migration_call was doing such a bad thing. :-)
> 
> However, it remains in R< state and has not executed the
> kthread_should_stop() instruction.
> 
> I'm trying to probe further by inserting a few more printk's in there.
> 
> Will post the findings in a couple of hours.
> 
> Thanks for reporting the problem.
> 
> Regards
> gautham.


