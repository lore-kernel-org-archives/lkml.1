Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZG0Qd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZG0Qd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZG0Qd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:33:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:17858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZG0Qd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,277,1246863600"; 
   d="scan'208";a="478343197"
Subject: Re: cpufreq cleanups - .30 vs .31
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20090727142532.GA22503@Krystal>
References: <200907061318.20839.trenn@suse.de>
	 <20090707015115.GB5310@redhat.com>  <20090727142532.GA22503@Krystal>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 09:31:06 -0700
Message-Id: <1248712266.11545.8824.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 07:25 -0700, Mathieu Desnoyers wrote:
> * Dave Jones (davej@redhat.com) wrote:
> > On Mon, Jul 06, 2009 at 01:18:18PM +0200, Thomas Renninger wrote:
> > 
> >  > So if not find too intrusive, I'd say:
> >  > Venkatesh's whole series of:
> >  > [patch 0/4] Take care of cpufreq lockdep issues (take 2)
> >  > should be seen in .31.
> >  >  ...
> >  > The one patch from Mathieu:
> >  > [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
> >  > is a separate, general cleanup which should show up in .31.
> > 
> > I came to the same conclusion after reading the thread, and looking
> > over the patches.  I merged the above, and sent Linus a pull request
> > a few minutes ago.
> > 
> > Thanks Mathieu and Venki for chasing this down.
> > 
> > 	Dave
> 
> Given I never got an answer to this question, I'm re-asking a question I
> asked in a previous thread about Venki's patchset:
> 
> [CPUFREQ] Cleanup locking in ondemand governor
> commit	5a75c82828e7c088ca6e7b4827911dc29cc8e774
> 
> From the earlier thread:
> Subject: Re: [patch 2.6.30 3/4] cpufreq add gov mutex
> 
> I am worried about potential races between add_dev/remove_dev, which
> currently lock the rwsem as mean of protection, and execution of timer
> handler that would not take the rwsem to protect itself anymore, due to
> your changes.
> 
> I'm especially worried about the call to
> 
>               __cpufreq_driver_target(dbs_info->cur_policy,
>                         dbs_info->freq_lo, CPUFREQ_RELATION_H);
> 
> which seems to depend on policy-level information, protected at the
> rwsem-level.
> 
> By removing the rwsem from the timer handler, I don't see how you plan
> to protect this information from add_dev/remove_dev execution.
> 

Sorry I missed the question earlier.

The invariant here is that the timer routine will not be running while
policy is inconsistent due to add/remove. The cpufreq layer calls START
at the end of add_dev when all policy stuff has been setup, which starts
the timer. And STOP along remove_dev before cleaning up policy which
stops the timer.

If you are thinking of races with other cpufreq sysfs interfaces, they
go through the per cpu rwsem along with add/remove.

Thanks,
Venki

