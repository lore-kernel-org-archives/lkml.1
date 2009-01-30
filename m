Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZA3V7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZA3V7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZA3V71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:59:27 -0500
Received: from ozlabs.org ([203.10.76.45]:60489 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZA3V70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:59:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Sat, 31 Jan 2009 08:29:15 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901301633.54013.rusty@rustcorp.com.au> <20090129223042.47dc42a1.akpm@linux-foundation.org>
In-Reply-To: <20090129223042.47dc42a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901310829.17099.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 17:00:42 Andrew Morton wrote:
> On Fri, 30 Jan 2009 16:33:53 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Thursday 29 January 2009 12:42:05 Andrew Morton wrote:
> > > On Thu, 29 Jan 2009 12:13:32 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > 
> > > > On Thursday 29 January 2009 06:14:40 Andrew Morton wrote:
> > > > > It's vulnerable to the same deadlock, I think?  Suppose we have:
> > > > ...
> > > > > - A calls work_on_cpu() and takes woc_mutex.
> > > > > 
> > > > > - Before function_which_takes_L() has started to execute, task B takes L
> > > > >   then calls work_on_cpu() and task B blocks on woc_mutex.
> > > > > 
> > > > > - Now function_which_takes_L() runs, and blocks on L
> > > > 
> > > > Agreed, but now it's a fairly simple case.  Both sides have to take lock L, and both have to call work_on_cpu.
> > > > 
> > > > Workqueues are more generic and widespread, and an amazing amount of stuff gets called from them.  That's why I felt uncomfortable with removing the one known problematic caller.
> > > > 
> > > 
> > > hm.  it's a bit of a timebomb.
> > > 
> > > y'know, the original way in which acpi-cpufreq did this is starting to
> > > look attractive.  Migrate self to that CPU then just call the dang
> > > function.  Slow, but no deadlocks (I think)?
> > 
> > Just buggy.  What random thread was it mugging?  If there's any path where
> > it's not a kthread, what if userspace does the same thing at the same time?
> > We risk running on the wrong cpu, *then* overriding userspace when we restore
> > it.
> 
> hm, Ok, not unficable but not pleasant.
> 
> > In general these cpumask games are a bad idea.
> 
> So we still don't have any non-buggy proposal.

I disagree about the avoiding-workqueue one being buggy.  The same logic
applies to any simple callback function.

Rusty.
