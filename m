Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbZAOOdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbZAOOdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZAOOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:33:00 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3452 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754732AbZAOOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:32:59 -0500
Date: Thu, 15 Jan 2009 17:32:57 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sdhci: Fix potential spinlock recursion
Message-ID: <20090115143257.GA2192@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090114194159.GA25017@oksana.dev.rtsoft.ru> <20090115070521.25c3bda7@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090115070521.25c3bda7@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 07:05:21AM +0100, Pierre Ossman wrote:
> On Wed, 14 Jan 2009 22:41:59 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > 
> > This happens because plain spin_lock() won't protect us from
> > softirqs (tasklets). So in the sdhci interrupt handler we must
> > grab the _irq version of the lock.
> > 
> 
> ?! The docs I've read state that softirq:s are not executed until all
> the hardirq:s have finished processing. And looking at your code, that
> seems to still hold true. A softirq running esdhc_tasklet_card() gets
> preempted by a hard irq and we have the lockup.

Right you are. That was a total brain fart on my part, I apologize.

> If you're running the code you sent a few minutes later, then something
> is broken with your platform as esdhc_tasklet_card() clearly tries to
> disable interrupts when it grabs the lock.

Luckily the platform isn't broken. It's just that sdhci driver
doesn't have this bug, I was a bit confused by two these drivers
instead.

Here is the original patch that has this bug:

http://www.bitshrine.org/gpp/kernel-2.6.25-MPC837xE-RDB-add-esdhc-support.patch

Notice that esdhc_tasklet_card() grabs spin_lock(), not
spin_lock_irqsave() as sdhci driver. I fixed this in the esdhc patch
that I sent, but then I decided to "fix" irq handler too, which
wasn't necessary, of course. And that's it.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
