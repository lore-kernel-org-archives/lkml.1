Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYBOVHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYBOVHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbYBOVFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:05:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761020AbYBOVFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:05:16 -0500
Date: Fri, 15 Feb 2008 13:01:37 -0800
From: Greg KH <gregkh@suse.de>
To: Yi Yang <yi.y.yang@intel.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davej@codemonkey.org.uk, mingo@elte.hu, cpufreq@lists.linux.org.uk,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc1] cpufreq: fix cpufreq policy refcount
	imbalance
Message-ID: <20080215210137.GE7583@suse.de>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1203032921.3897.10.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203032921.3897.10.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 07:48:41AM +0800, Yi Yang wrote:
> When one cpu is set to offline, the caller process will hang, according to
> the trace data, the problem lies in the refcount error in cpufreq driver,
> cpufreq_cpu_callback will wait for completion policy->kobj_unregister
> which is nerver completed because a refcount error in function
> __cpufreq_remove_dev in file driver/cpufreq/cpufreq.c results in not
> calling kobject release method.
> 
> In driver/cpufreq/cpufreq.c, the refcount of data->kobj isn't 1 when it
> will be unregistered, this problem didn't exist in 2.6.24 and earlier.
> 
> The root cause is kobject API switch, kobject_init_and_add and kobject_put
> replace older kobject_register and kobject_unregister in 2.6.25-rc1,
> compared to 2.6.24, kobject_unregister is deleted in function
> __cpufreq_remove_dev but it isn't replaced with kobject_put.
> 
> This patch adds kobject_put to balance refcount. I noticed Greg suggests
> it will fix a power-off issue to remove kobject_get statement block, but i
> think that isn't the best way because those code block has existed very long
> and it is helpful because the successive statements are invoking relevant
> data.
> 
> 
> Signed-off-by: Yi Yang <yi.y.yang@intel.com>

No, the additional kobject_get() needs to be removed.  I posted a patch
for this last night, and so did someone else earlier at:
		http://lkml.org/lkml/2008/2/8/342

this patch should not be added, I'll get the other one in instead.

thanks,

greg k-h
