Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZGPDLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZGPDLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZGPDLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:11:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:46786 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbZGPDLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:11:45 -0400
Subject: Re: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Jones <davej@redhat.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org
In-Reply-To: <20090710234646.GA11669@redhat.com>
References: <4A561074.5080407@gmail.com> <20090710192511.GB6240@redhat.com>
	 <1247264617.21776.6.camel@pasglop>  <20090710234646.GA11669@redhat.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 13:10:47 +1000
Message-Id: <1247713847.27937.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 19:46 -0400, Dave Jones wrote:

> The fail part comes from the fact that interrupts get reenabled.
> And that's something that can easily happen out of our control if
> we call into acpi_cpufreq's ->get method for example, so powernow-k8 isn't
> the sole reason.
> 
>  > I'm happy instead of #ifdef's however to push the logic into the ppc
>  > driver, or use a flag that the ppc driver sets to enable that logic.

So I'm not too familiar with what other platforms expect here, but would
it be ok to do something like bailing our early in cpufreq_suspend() if
there's no cpufreq_driver->suspend method ?

We would need to do the same on resume, though I do wonder whether there
could be a problem with even x86 here.. do we know for sure that we come
back from suspend with the same policy we had before suspending ? IE. We
should probably always do that check on resume, but we can't do it too
early due to irqs being off...

It's all because cpufreq is a sysdev which was imho a mistake in the
first place :-)

Maybe at this stage the best option is to add suspend_prepare and
resume_finish callbacks to sysdevs that are called while IRQs are still
on, and move cpufreq to use these instead ? That probably means we also
need to keep track that we have started suspend in the cpufreq core and
forbid attempts at changing policy etc... from either userspace of
on-demand governor while suspended, so that's more work, but could be
the best approach in the long run, what do you think ?

Otherwise I'm happy to just submit a patch that makes
cpufreq_suspend/resume bail out early if driver->suspend/resume are NULL
(or do you prefer a driver flag ?)

Cheers,
Ben.



