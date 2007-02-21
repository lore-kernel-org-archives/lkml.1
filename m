Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXBUOcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXBUOcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXBUOcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:32:07 -0500
Received: from mail.screens.ru ([213.234.233.54]:57838 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXBUOcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:32:06 -0500
Date: Wed, 21 Feb 2007 17:30:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070221143010.GC134@tv-sign.ru>
References: <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com> <20070216235939.GB244@tv-sign.ru> <20070217022940.GB25924@in.ibm.com> <20070217215928.GA563@tv-sign.ru> <20070220151220.GB4960@in.ibm.com> <20070220200936.GB85@tv-sign.ru> <20070221062947.GG20820@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221062947.GG20820@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Srivatsa Vaddagiri wrote:
>
> On Tue, Feb 20, 2007 at 11:09:36PM +0300, Oleg Nesterov wrote:
> > > Which caller are you referring to here? Maybe we can decide on the
> > > option after we see the users of flush_workqueue() in DOWN_PREPARE.
> > 
> > mm/slab.c:cpuup_callback()
> 
> The cancel_rearming_delayed_work, if used as it is in cpuup_callback,
> will require that we send DOWN_PREPARE before freeze_processes().
> 
> But ..I am wondering if we can avoid doing cancel_rearming_delayed_work
> (and thus flush_workqueue) in CPU_DOWN_PREPARE of slab.c. Basically,
> 
> mm/slab.c:
> 
> 	CPU_DOWN_PREPARE:	/* All processes frozen now */
> 		cancel_delayed_work(&per_cpu(reap_work, cpu).timer);
> 		del_work(&per_cpu(reap_work, cpu).work);
> 		break;
> 
> 
> At the point of CPU_DOWN_PREPARE, keventd should be frozen and hence
> del_work() is a matter of just deleting the work from cwq->worklist.

Agreed. Note that we don't need the new "del_work". It is always safe to
use cancel_work_sync() if we know that the workqueue is frozen, it won't
block. We can also do

	if (!cancel_delayed_work())
		cancel_work_sync();

but it is ok to do cancel_work_sync() unconditionally.

Oleg.

