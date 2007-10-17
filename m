Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXJQCMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXJQCMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXJQCMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:12:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59599 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXJQCMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:12:45 -0400
Date: Wed, 17 Oct 2007 07:41:12 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 0/4] Refcount Based Cpu-Hotplug Revisit.
Message-ID: <20071017021112.GA15895@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <alpine.LFD.0.999.0710161015510.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710161015510.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 10:20:37AM -0700, Linus Torvalds wrote:
> On Tue, 16 Oct 2007, Gautham R Shenoy wrote:
> 
> Well, afaik, the patch series is fairly clean, and I'm obviously perfectly 
> happy with the approach, so I have no objections. 
> 
> But it looks buggy. This:
> 
> 	+static void cpu_hotplug_begin(void)
> 	+{
> 	+       mutex_lock(&cpu_hotplug.lock);
> 	+       cpu_hotplug.active_writer = current;
> 	+       while (cpu_hotplug.refcount) {
> 	+               mutex_unlock(&cpu_hotplug.lock);
> 	+               wait_for_completion(&cpu_hotplug.readers_done);
> 	+               mutex_lock(&cpu_hotplug.lock);
> 	+       }
> 	+
> 	+}
> 
> drops the cpu_hotplug.lock, which - as far as I can see - means that 
> another process can come in and do the same, and mess up the 
> "active_writer" thing. The oerson that actually *gets* the lock may not be 
> the same one that has "active_writer" set to itself. No? Am I missing 
> something.

Unless I am reading the patch wrongly, it seems cpu_hotplug_begin() is called 
while holding the cpu_add_remove_lock mutex. So, another CPU cannot come in
and do the same until _cpu_down() is over.

Thanks
Dipankar
