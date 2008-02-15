Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYBOPxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYBOPxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbYBOPwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:52:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41367 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755277AbYBOPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:52:52 -0500
Date: Fri, 15 Feb 2008 10:52:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yi Yang <yi.y.yang@intel.com>
cc: akpm@linux-foundation.org, <davej@codemonkey.org.uk>,
       <cpufreq@lists.linux.org.uk>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <mingo@elte.hu>, <torvalds@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 2.6.25-rc1] cpufreq: fix cpufreq policy refcount
 imbalance
In-Reply-To: <1203032921.3897.10.camel@yangyi-dev.bj.intel.com>
Message-ID: <Pine.LNX.4.44L0.0802151043230.3423-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Yi Yang wrote:

> This patch adds kobject_put to balance refcount. I noticed Greg suggests
> it will fix a power-off issue to remove kobject_get statement block, but i
> think that isn't the best way because those code block has existed very long
> and it is helpful because the successive statements are invoking relevant
> data.

Are you referring to this section of code (before the region affected 
by your patch)?

	if (!kobject_get(&data->kobj)) {
		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
		cpufreq_debug_enable_ratelimit();
		unlock_policy_rwsem_write(cpu);
		return -EFAULT;
	}

Greg is correct that the kobject_get() here is useless and should be
removed.  kobject_get() never returns NULL unless its argument is NULL.  
Since &data->kobj can never be NULL, the "if" test will never fail.  
Hence there's no point in making the test at all.

The fact that a section of code has existed for a long time doesn't 
mean that it is right.  :-)

Furthermore, there's no reason to do the kobject_get().  Holding 2 
references to a kobject is no better than holding just 1 reference.  
Assuming you know that the kobject is still registered, then you also 
know that there is already a reference to it.  So you have no reason to 
take an additional reference.

Alan Stern

