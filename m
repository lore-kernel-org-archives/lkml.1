Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYA1I4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYA1I4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYA1I4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:56:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:28916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYA1I4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bVve/e+maHJtJRi8X7PNJYMNqiDkg8CLyhPujCcyj6L2RCIQtuQrYHYDWr2+zvVF8T6PDr71/erAoEhDV85YKq6A7j1Hs6KIQgZTV9OkDIFj197hnmbGYuKvHz4cW1C5BDGGPC/atR6+g6H2NZKG0EnPwsfQS+aqqis5MVVpSsQ=
Message-ID: <b647ffbd0801280056p71d939d4j882d640185c40d94@mail.gmail.com>
Date: Mon, 28 Jan 2008 09:56:04 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <srostedt@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <200801280226.22013.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801272229.48955.rjw@sisk.pl> <20080127215904.GB2686@elte.hu>
	 <200801280226.22013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/2008, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 27 of January 2008, Ingo Molnar wrote:
> >
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > > Hi,
> > >
> > > 2.6.24-git3 adds a 5 - 10 sec delay to the suspend and hibernation
> > > code paths (probably related to the disabling of nonboot CPUs), which
> > > is !@#$%^&*() annoying.
> > >
> > > It's 100% reproducible on my HP nx6325 and bisection idendified the
> > > following commit as the first bad one:
> > >
> > > commit 764a9d6fe4b52995c8aba277e3634385699354f4
> > > Author: Steven Rostedt <srostedt@redhat.com>
> > > Date:   Fri Jan 25 21:08:04 2008 +0100
> > >
> > >     sched: track highest prio task queued
> >
> > hm, this patch is a NOP, so it's weird that it has an effect.
> >
> > Do you have serial logging enabled perhaps? If the following WARN_ON()
> > triggers:
> >
> > +               WARN_ON(p->prio < rq->rt.highest_prio);
> >
> > then perhaps that can cause a 5-10 seconds delay. (that's how much time
> > it takes to printk a warning on the slowest serial settings)
> >
> > but if you use suspend, then any such printks would be preserved in the
> > dmesg, right? If the WARN_ON() triggers, and if you remove it, do things
> > get faster?
>
> No, this isn't the WARN_ON().
>
> > this does have the feel of being scheduling related, but are you
> > absolutely sure about the precise identity of the patch?
>
> Actually, not quite.  That's why I have verified it and found that another
> patch is really responsible for the issue, namely:
>
> commit 82a1fcb90287052aabfa235e7ffc693ea003fe69
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jan 25 21:08:02 2008 +0100
>
>     softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
>
> Reverting this commit (it reverts with some minor modifications) fixes the
> problem for me.

What if you use the same kernel that triggers a problem and just disable
this new 'softlockup' functionality:

echo 0 > /proc/sys/kernel/hung_task_timeout_secs

does the problem disapear?

TIA,

>
> Thanks,
> Rafael
>


-- 
Best regards,
Dmitry Adamushko
