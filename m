Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbXEJQ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbXEJQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbXEJQ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:27:54 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:65287 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755492AbXEJQ1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:27:52 -0400
Date: Thu, 10 May 2007 18:27:49 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46434123.8040801@drzeus.cx>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	<46432212.9070008@drzeus.cx>
	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
	<46434123.8040801@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 17:58:27 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> Haavard Skinnemoen wrote:
> > 
> > Ok, is there any better way to achieve the same this? As far as I
> > can tell, mmc_remove_host() uses mmc_flush_scheduled_work() for the
> > same purpose -- it ensures that scans that have already been started
> > will have completed before the function continues.
> > 
> 
> Not quite. mmc_remove_host() doesn't care if a detect has been executed or not,
> it only cares about whether or not one is executing right now. So in order for
> your patch to work, there must be no way that mmc_finish_detect() is called
> before the detect is scheduled.

Is there any way this can happen? Host controller drivers register
themselves from module_init(), their probe() function gets called,
which calls mmc_add_host(), which schedules the initial scan. If
multiple host controllers are present, they will all schedule their
scans before all module_init()s have been called. Am I missing
something?

> > I wouldn't call it luck. The way mmc_rescan() is implemented, any scans
> > that are started before late_initcall time are completed before
> > mmc_finish_detect() returns. The steps are all done synchronously in
> > the workqueue function.
> > 
> 
> Indeed. But it is not by design that they are scheduled before late_initcall().
> Also, flushing the workqueue is also not a by-design way of completing a scan,
> it just happens to be that way right now.

So how is it supposed to work "by design"?

> > And I never realized that using a block device as a parameter to the
> > root= parameter could possibly be "unofficial" functionality...?
> 
> Then you've learned something new. ;)

Guess so. It seems like the prepare_namespace stuff is getting less
useful every day.

> Only some devices work that way (generally only those with "simple" interfaces).
> And most things are these days behind more advanced buses, more akin to a network.

It's funny that NFS root does not have these kinds of problems then...

> Generally, not waiting for a lot of hardware is a good thing as it speeds up
> boot times. In my mind, the proper way is having a script in an initrd that
> waits for just the parts of the hardware that this particular system needs.
> Everything else can be brought up in the background.

Yeah, but I suspect most users will rather have a system that actually
boots than a system that would have booted very quickly if it had booted
at all.

Btw, how can I wait for the scanning to complete from early userspace?

Haavard
