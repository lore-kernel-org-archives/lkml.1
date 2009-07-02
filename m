Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZGBAnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZGBAnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZGBAnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:43:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38811 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZGBAng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:43:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 09:41:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com (Eric W. Biederman),
       Amerigo Wang <xiyou.wangcong@gmail.com>, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RESEND Patch] kcore: remove its pointless size
Message-Id: <20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090701171249.004968e8.akpm@linux-foundation.org>
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
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 17:12:49 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 01 Jul 2009 16:25:05 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
> > Which is better than showing a random number of dubious relationship
> > to the size we normally show.  That code is just a maintenance problem.
> 
> Well it's not just that st_size is wrong before the first read.  It's
> also wrong after memory hot-add, up until the next read.
> 
And I found kclist_add() is not called at memory hotplug...


> > > If so, should we run get_kcore_size() in proc_kcore_init(), perhaps?
> > >
> > > In fact, do we need to run get_kcore_size() more than once per boot? 
> > >
> > > AFAICT we only run kclist_add() during bootup, so if proc_kcore_init()
> > > is called at the appropriate time, we can permanently cache its result?
> > >
> > > In which case get_kcore_size() and kclist_add() can be marked __init.
> > >
> > > Maybe that's all wrong - I didn't look terribly closely.
> > 
> > Memory hot add I expect is the excuse.  There is more that could be
> > done.  But this patch is an obvious bit of chipping away nonsense
> > code.
> 
> We have the infrastructure to get this right, I think:
> 
> - run
> 
> 	proc_root_kcore->size = get_kcore_size(...)
> 
>   within proc_kcore_init()
> 
yes, seems sane.


> - register a memory-hotplug notifier and each time memory goes online
>   or offline, rerun
> 
> 	proc_root_kcore->size = get_kcore_size(...)
> 
yes. and we need kclist_add() under memory hotplug.


> - stop running get_kcore_size() within read_kcore().
> 
> I suspect that read_kcore() will not behave well if a memory hotplug
> operation happens concurrently.  But that's a separate problem.
> 
> (hopefully cc's some memory-hotplug people)
> 
Maybe no problem. I don't think people does memory hotplug while he reads
/proc/kcore. (It sounds like modify coredump while investigating it.)

Thanks,
-Kame


> 
> Or we just leave /proc/kcore's st_size at zero.  It's a pretty hopeless
> exercise trying to get this "right", as nobody can safely _use_ that
> size - it can be wrong as soon as the caller has read from it.
> 
> 

