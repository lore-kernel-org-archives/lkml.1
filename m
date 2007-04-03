Return-Path: <linux-kernel-owner+w=401wt.eu-S966116AbXDCTay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966116AbXDCTay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966118AbXDCTay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:30:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60487 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116AbXDCTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:30:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com, akpm@linux-foundation.org
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Date: Tue, 3 Apr 2007 21:34:28 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070403120104.GB29308@in.ibm.com>
In-Reply-To: <20070403120104.GB29308@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704032134.29720.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 April 2007 14:01, Gautham R Shenoy wrote:
> On Mon, Apr 02, 2007 at 08:16:12AM +0200, Ingo Molnar wrote:
> > 
> > i'm wondering about how TASK_UNINTERRUPTIBLE tasks are handled by the 
> > freezer: are they assumed frozen immediately, or do we wait until they 
> > notice their PF_FREEZING and go into try_to_freeze()? I'd expect 
> > TASK_UNINTERRUPTIBLE to be the largest source of latency. (and hence be 
> > the primary source for freezing 'failures')
> 
> Ok, we might be in some luck. I panic()ed on freezer fail and checked
> the stacktrace of the unfrozen tasks. The stacktrace of each one looks
> like:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> PID: 7697   TASK: cc354a70  CPU: 7   COMMAND: "make"
> #0 [cc37fe50] schedule at c0431752
> #1 [cc37fec4] wait_for_completion at c04318d0
> #2 [cc37ff24] do_fork at c01249a6
> #3 [cc37ff94] sys_vfork at c0103c1f
> #4 [cc37ffb4] system_call at c0104d8d
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Rafael had sent out a patch to fix the vfork race, which can be found at
> http://lkml.org/lkml/2007/3/1/212
> 
> However, the hunk
> 
> @@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
> 		tracehook_report_clone_complete(clone_flags, nr, p);
> 
> 		if (clone_flags & CLONE_VFORK) {
> +			freezer_do_not_count();
> 			wait_for_completion(&vfork);
> +			freezer_count();
> 			tracehook_report_vfork_done(p, nr);
> 		}
> 	} else {
> 
> Seems to be missing in the latest -mm's.

Good catch!

> Rafael / Andrew, 
> 	Any reasons for leaving this hunk out?

No, absolutely not.  It's needed.

Moreover, freezer-fix-vfork-problem.patch from the broken-out -rc5-mm3
contains it, so some other patch must have reverted this change.

[looks]

Ah, it's utrace-prep-2.patch .  Andrew?
