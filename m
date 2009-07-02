Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZGBANQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZGBANQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZGBANB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:13:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbZGBANA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:13:00 -0400
Date: Wed, 1 Jul 2009 17:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RESEND Patch] kcore: remove its pointless size
Message-Id: <20090701171249.004968e8.akpm@linux-foundation.org>
In-Reply-To: <m14otwq94e.fsf@fess.ebiederm.org>
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
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 16:25:05 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> >> index 59b43a0..eca5201 100644
> >> --- a/fs/proc/kcore.c
> >> +++ b/fs/proc/kcore.c
> >> @@ -405,9 +405,6 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
> >>  static int __init proc_kcore_init(void)
> >>  {
> >>  	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
> >> -	if (proc_root_kcore)
> >> -		proc_root_kcore->size =
> >> -				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
> >>  	return 0;
> >>  }
> >>  module_init(proc_kcore_init);
> >
> > AFAICT this means that proc_root_kcore->size will remain uninitialised
> > until a process opens and reads from /proc/kcore.  So on initial boot
> > the `ls' output will presumably show a size of zero, and this will
> > change once /proc/kcore has been read?
> 
> Which is better than showing a random number of dubious relationship
> to the size we normally show.  That code is just a maintenance problem.

Well it's not just that st_size is wrong before the first read.  It's
also wrong after memory hot-add, up until the next read.

> > If so, should we run get_kcore_size() in proc_kcore_init(), perhaps?
> >
> > In fact, do we need to run get_kcore_size() more than once per boot? 
> >
> > AFAICT we only run kclist_add() during bootup, so if proc_kcore_init()
> > is called at the appropriate time, we can permanently cache its result?
> >
> > In which case get_kcore_size() and kclist_add() can be marked __init.
> >
> > Maybe that's all wrong - I didn't look terribly closely.
> 
> Memory hot add I expect is the excuse.  There is more that could be
> done.  But this patch is an obvious bit of chipping away nonsense
> code.

We have the infrastructure to get this right, I think:

- run

	proc_root_kcore->size = get_kcore_size(...)

  within proc_kcore_init()

- register a memory-hotplug notifier and each time memory goes online
  or offline, rerun

	proc_root_kcore->size = get_kcore_size(...)

- stop running get_kcore_size() within read_kcore().

I suspect that read_kcore() will not behave well if a memory hotplug
operation happens concurrently.  But that's a separate problem.

(hopefully cc's some memory-hotplug people)


Or we just leave /proc/kcore's st_size at zero.  It's a pretty hopeless
exercise trying to get this "right", as nobody can safely _use_ that
size - it can be wrong as soon as the caller has read from it.

