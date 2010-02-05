Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab0BEDlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 22:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696Ab0BEDlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 22:41:52 -0500
Message-ID: <4B6B93E3.1060504@redhat.com>
Date: Fri, 05 Feb 2010 11:43:31 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>	 <m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com>	 <m1zl3xt49k.fsf@fess.ebiederm.org> <20100129142223.GB12539@suse.de>	 <1264787848.24455.31.camel@laptop> <20100129181024.GA12934@suse.de>	 <1264788860.24455.35.camel@laptop> <20100129182114.GA13219@suse.de>	 <1264795834.24455.43.camel@laptop>  <m1y6jgpsax.fsf@fess.ebiederm.org> <1265283496.24455.1939.camel@laptop>
In-Reply-To: <1265283496.24455.1939.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-01-29 at 12:30 -0800, Eric W. Biederman wrote:
> 
>> We get false positives when the code of a sysfs attribute
>> synchronously removes other sysfs attributes.  In general that is not
>> safe due to hotplug etc, but there are specific instances of static
>> sysfs entries like the pm_core where it appears to be safe.
>>
>> I am not familiar with the device core lockdep issues.  Are they similar?
> 
> The device tree had the problem that we could basically hold a device
> lock and an unspecified number of parent locks (iirc this was due to
> device probing, where we hold the bus lock while probing/adding child
> device, recursively). 
> 
> If we place each dev->lock into the same class (which would naively
> happen), then this would lead to recursive lock warnings. The proposed
> solution for this is to create MAX_LOCK_DEPTH classes and assign them to
> the dev->lock depending on the depth in the device tree (Alan said that
> MAX_LOCK_DEPTH is sufficient for all practical cases).
> 
> static struct lock_class_key dev_tree_classes[MAX_LOCK_DEPTH];
> 
> device_add() or thereabouts would have something like:
> 
> #ifdef CONFIG_PROVE_LOCKING
> 	BUG_ON(dev->depth >= MAX_LOCK_DEPTH);
> 	lockdep_set_class(dev->lock, &dev_tree_classes[dev->depth]);
> #endif
> 
> 

Nice explanation!

I see, we should set the class of the lock when after we holding it...
I will update my patch.

Thank you!
