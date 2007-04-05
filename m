Return-Path: <linux-kernel-owner+w=401wt.eu-S1766966AbXDEMVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766966AbXDEMVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766961AbXDEMVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:21:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:57670 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766966AbXDEMVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:21:12 -0400
Date: Thu, 5 Apr 2007 16:20:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070405122005.GC755@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com> <20070404152828.GA416@tv-sign.ru> <20070404174948.GB28328@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404174948.GB28328@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Srivatsa Vaddagiri wrote:
>
> On Wed, Apr 04, 2007 at 07:28:28PM +0400, Oleg Nesterov wrote:
> > 
> > 	worker_thread:
> > 
> > 		for (;;) {
> > 			try_to_freeze();
> > 
> > 			prepare_to_wait();
> > 			if (...)
> > 				schedule();
> > 			finish_wait();
> > 		}
> > 
> > This is racy, we can miss freeze_process()->signal_wake_up() if it happens
> > between try_to_freeze() and prepare_to_wait(). We have to check TIF_FREEZE
> > before entering schedule() if we want to fix this race.
> 
> Yes that needs a fix as well. Oh dear, freezer is so fragile to break!
> 
> > Should we? I don't know. This will uglify the code, and the probability
> > of this race is very low.
> 
> Would be nice to fix IMO. Atleast serves to show "how to make your code
> freezer friendly".

This is funny. I "noticed" this race a long ago, when the ->freezeable flag
was introduced. However, looking at 2.6.20 I see that the patch was correct,
and this race was in fact introduced by me in

	[PATCH 1/1] workqueue: don't migrate pending works from the dead CPU
	http://marc.info/?l=linux-kernel&m=117062192709871

I'll send a fix on weekend.

Oleg.

