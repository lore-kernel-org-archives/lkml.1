Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZGQWad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZGQWad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZGQWac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:30:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbZGQWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:30:32 -0400
Date: Fri, 17 Jul 2009 15:29:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: ebiederm@xmission.com, xiyou.wangcong@gmail.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [RESEND Patch] kcore: remove its pointless size
Message-Id: <20090717152955.6585cbf9.akpm@linux-foundation.org>
In-Reply-To: <20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
References: <m11vpqvozl.fsf@fess.ebiederm.org>
	<20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
	<20090701144742.6ce3535b.akpm@linux-foundation.org>
	<m14otwq94e.fsf@fess.ebiederm.org>
	<20090701171249.004968e8.akpm@linux-foundation.org>
	<20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 09:41:38 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 1 Jul 2009 17:12:49 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 01 Jul 2009 16:25:05 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
> > > Which is better than showing a random number of dubious relationship
> > > to the size we normally show.  That code is just a maintenance problem.
> > 
> > Well it's not just that st_size is wrong before the first read.  It's
> > also wrong after memory hot-add, up until the next read.
> > 
> And I found kclist_add() is not called at memory hotplug...
> 
> 
> > > > If so, should we run get_kcore_size() in proc_kcore_init(), perhaps?
> > > >
> > > > In fact, do we need to run get_kcore_size() more than once per boot? 
> > > >
> > > > AFAICT we only run kclist_add() during bootup, so if proc_kcore_init()
> > > > is called at the appropriate time, we can permanently cache its result?
> > > >
> > > > In which case get_kcore_size() and kclist_add() can be marked __init.
> > > >
> > > > Maybe that's all wrong - I didn't look terribly closely.
> > > 
> > > Memory hot add I expect is the excuse.  There is more that could be
> > > done.  But this patch is an obvious bit of chipping away nonsense
> > > code.
> > 
> > We have the infrastructure to get this right, I think:
> > 
> > - run
> > 
> > 	proc_root_kcore->size = get_kcore_size(...)
> > 
> >   within proc_kcore_init()
> > 
> yes, seems sane.
> 
> 
> > - register a memory-hotplug notifier and each time memory goes online
> >   or offline, rerun
> > 
> > 	proc_root_kcore->size = get_kcore_size(...)
> > 
> yes. and we need kclist_add() under memory hotplug.
> 
> 
> > - stop running get_kcore_size() within read_kcore().
> > 
> > I suspect that read_kcore() will not behave well if a memory hotplug
> > operation happens concurrently.  But that's a separate problem.
> > 
> > (hopefully cc's some memory-hotplug people)
> > 
> Maybe no problem. I don't think people does memory hotplug while he reads
> /proc/kcore. (It sounds like modify coredump while investigating it.)
> 

I think I'm about to forget about the above issues.  If everyone else
does the same, they won't get addressed.  Oh well.

And I still need to decide whether
kcore-fix-proc-kcores-statst_size.patch fixes things up sufficiently
well to justify merging it.

