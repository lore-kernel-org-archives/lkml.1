Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZD2IDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZD2IDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZD2ID2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:03:28 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56442 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZD2IDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:03:25 -0400
Date: Wed, 29 Apr 2009 10:02:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Gallatin <gallatin@myri.com>, linux-kernel@vger.kernel.org,
       rick.jones2@hp.com, brice@myri.com, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: IRQ / SoftIRQ CPU time accounting broken by
 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
Message-ID: <20090429100206.6371b093@skybase>
In-Reply-To: <20090428163004.46733752.akpm@linux-foundation.org>
References: <49F078FA.6010507@myri.com>
	<20090428163004.46733752.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 16:30:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc's added)
> 
> On Thu, 23 Apr 2009 10:19:38 -0400
> Andrew Gallatin <gallatin@myri.com> wrote:
> 
> > When running netperf for some 10GbE tests, I noticed
> > that  IRQ and SOFTIRQ CPU time is no longer reported for an
> > otherwise idle CPU on recent kernels, at least for x86_64.
> > 
> > I spent a few hours git-bisecting until I finally got here:
> > 
> > % git-bisect bad
> > Bisecting: 0 revisions left to test after this
> > [457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4] fix scaled & unscaled cputime 
> > accounting
> > 
> > I have neither CONFIG_NO_HZ, CONFIG_VIRT_CPU_ACCOUNTING, or XEN configured.
> > 
> 
> Thanks for doing the bisection.
> 
> 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4 was merged late last year, so
> this regression has been around for a while.
> 
> We might have fixed it in more recent kernels - stranger things have
> happened ;)

Hmm, are you sure that this commit caused the problem? I can't see how.
In regard to the accounting of system ticks on x86_64 the only change
is the bug fix that a system tick of a guest cpu has incorrectly been
added to p->stimescaled instead of p->utimescaled.
Without guest cpus in the picture nothing changes. For x86_64
CONFIG_VIRT_CPU_ACCOUNTING=n so account_process_tick is used. Before
the patch accout_process_tick accounted a system tick by calling
account_system_time and account_system_time_scaled. The second function
just added the cputime to p->stimescaled. That is now done in
accout_system_time.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

