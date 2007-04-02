Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXDBJU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXDBJU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965267AbXDBJU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:20:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45208 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXDBJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:20:57 -0400
Date: Mon, 2 Apr 2007 14:58:18 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402092818.GE2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402061612.GA7072@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 08:16:12AM +0200, Ingo Molnar wrote:
> hm, shouldnt the make be frozen immediately?
> 
> doesnt the 'please freeze ASAP' flag get propagated to all tasks, 
> immediately? After that point any cloning activity should duplicate that 
> flag too, resulting in any new child freezing immediately too.

afaics, setting the 'please freeze asap' flag is racy wrt dup_task_struct
(where the child's tsk->thread_info->flags are copied from its parent?). 
Secondly, from what I understand, it takes a 'flag to be set + signal marked
pending' for the child task to be frozen. If that is the case, then
copy_process may not propogae the signal to the child, which could mean
mean that we can be in a catch-up game in freeze_processes, trying to
freeze processes we didnt see in earlier passes.

I think copy_process() can check for something like this:

	write_lock_irq(&tasklist_lock);

	...

	if (freezing(current))
		freeze_process(p);	/* function exported by freezer */

	...

	write_unlock_irq(&tasklist_lock);


-- 
Regards,
vatsa
