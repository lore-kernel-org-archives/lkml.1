Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbZBYLqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbZBYLqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZBYLp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:45:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZBYLpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:45:55 -0500
Date: Wed, 25 Feb 2009 12:45:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
	convert bts-tracer mutex to a spinlock
Message-ID: <20090225114542.GA14279@elte.hu>
References: <tip-2d542cf34264ac92e9e7ac55c0b096b066d569d2@kernel.org> <928CFBE8E7CB0040959E56B4EA41A77E4A4C1EF6@irsmsx504.ger.corp.intel.com> <20090225095814.GC12352@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A4C1F31@irsmsx504.ger.corp.intel.com> <20090225111116.GB15453@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A4C1FE3@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A4C1FE3@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Wednesday, February 25, 2009 12:11 PM
> >To: Metzger, Markus T
> >Cc: hpa@zytor.com; mingo@redhat.com; tglx@linutronix.de; linux-kernel@vger.kernel.org; linux-tip-
> >commits@vger.kernel.org
> 
> 
> >> And I assume you like the spinlock better than the
> >> get/put_online_cpus(), as well.
> >
> >yeah - and get/put_online_cpus is sleepable too, so it doesnt
> >really help unless i'm missing something ...
> 
> I suggested to use get/put_online_cpus() instead of the lock.
> 
> The hotplug code waits until the cpu_hotplug.refcount is zero
> and it holds the cpu_hotplug.lock during hotplug operations
> (see cpu_hotplug_begin/done()).
> 
> In turn, get_online_cpus() needs to grab the cpu_hotplug.lock
> to increment the cpu_hotplug.refcount.
> 
> Thus, we will use the cpu_hotplug.lock instead of our own lock.

... which, if you use it in the exact same spots as now still 
does a potential sleep with irqs disabled => bad.

We might be able to not take the hotplug lock in the affected 
codepath, but we should really not expand on the use of that 
lock and should make this code self-sufficient.

	Ingo
