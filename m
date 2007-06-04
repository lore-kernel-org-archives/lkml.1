Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbXFDL50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbXFDL50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXFDL5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:57:06 -0400
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:37380 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbXFDL5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:57:03 -0400
Date: Mon, 4 Jun 2007 04:56:48 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Stephane Eranian <eranian@hpl.hp.com>, perfmon@napali.hpl.hp.com
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070604115648.GB8614@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ira9ca0d.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, May 31, 2007 at 05:01:38PM +0200, Andi Kleen wrote:
> > +   * pmu_desc: subdir containing the PMU register mapping information
> > +
> > +   * reset_stats(W): echo 0 > reset_stats resets the statistics collected by perfmon2.
> > +   		stats are available per-cpu in /sys/devices/system/cpu/cpu*/perfmon
> > +   	
> > +   * smpl_buffer_mem_cur(RO): reports the amount of memory currently dedicated to sampling
> > +   		buffers by the kernel.
> > +
> > +   * smpl_buffer_mem_max(RW): maximum amount of memory usable for sampling buffers.
> > +   		-1 means all that is available.
> 
> -1 seems dangerous. 
> 
> > +
> > +   * sys_group(RW): which users group is allowed to create a system-wide contexts.
> > +   		-1 means any group
> 
> Wouldn't this better be a capability bit? Then it could be just set
> in the normal pam configuration files.
> 
> > +
> > +   * sys_sessions_count(RO): number of loaded system-wide contexts
> > +
> > +   * task_group(RW): which users group is allowed to create per-thread contexts.
> > +   		-1 means any group
> 

I spent quite some time looking at the kernel code for capabilities and also how to
control them from userland. I agree with you that it would be nicer to use capabilities
to control which users can create system-wide or per-thread perfmon sessions. We could
simply create two new capabilities: CAP_PERFMON_SYS and CAP_PERFMON_THREAD. Then,
I can envision a setup where a sysadmin would grant the capabilities to users when they login
via PAM.

There are two problems with this at the moment:

	- the 32bit for capabilities have been exhausted (kernel_cap_t is u32). We would
	  need to increase to u64. That would impact __user_cap_data_struct which is used
	  by the captset()/capget() syscalls.

	- I have not been able to find how one could grant/deny capabilities via PAM and
	  especially for login. Libcap does not seem to be used. There was a pam_cap at
	  some point, it seems abandonned by now.  I am not a linux security
	  expert, so there may be newer ways of setting capabilities for processes.

Any comments?

-- 
-Stephane
