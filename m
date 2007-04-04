Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXDDRmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXDDRmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXDDRmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:42:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48374 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXDDRmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:42:36 -0400
Date: Wed, 4 Apr 2007 23:19:48 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070404174948.GB28328@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com> <20070404152828.GA416@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404152828.GA416@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 07:28:28PM +0400, Oleg Nesterov wrote:
> I changed my mind :) The problem is general, I am starting to believe
> it is better to change kthread_stop().

yes i agree. Although is some cases like destroy_workqueue, we need to
mark the target thread non-freezable way before we call kthread_stop (as
you pointed out).

> > I suspected that we cannot modify p->flags just like that. How abt
> > moving freezer exemption bits to a separate field, which is protected by
> > task_lock?
> 
> Probably yes... In that case it makes sense to move PF_FREEZER_SKIP/PF_FROZEN
> to the new field as well.

I wonder if there are some reserved fields in task_struct which we can
reuse here ..

> Perhaps we can ignore this problem for now. Freezer is not 100% reliable
> anyway. For example,
> 
> 	worker_thread:
> 
> 		for (;;) {
> 			try_to_freeze();
> 
> 			prepare_to_wait();
> 			if (...)
> 				schedule();
> 			finish_wait();
> 		}
> 
> This is racy, we can miss freeze_process()->signal_wake_up() if it happens
> between try_to_freeze() and prepare_to_wait(). We have to check TIF_FREEZE
> before entering schedule() if we want to fix this race.

Yes that needs a fix as well. Oh dear, freezer is so fragile to break!

> Should we? I don't know. This will uglify the code, and the probability
> of this race is very low.

Would be nice to fix IMO. Atleast serves to show "how to make your code
freezer friendly".

-- 
Regards,
vatsa
