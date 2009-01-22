Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZAVFPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZAVFPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 00:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZAVFPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 00:15:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:55104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303AbZAVFPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 00:15:23 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Thu, 22 Jan 2009 10:42:50 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200901211638.23101.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <20090122115324.b954c6a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090122115324.b954c6a1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221042.51622.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 08:23:24 KAMEZAWA Hiroyuki wrote:
> On Wed, 21 Jan 2009 12:49:50 -0800 (PST)
>
> David Rientjes <rientjes@google.com> wrote:
> > On Wed, 21 Jan 2009, Nikanth Karthikesan wrote:
> > > This is a container group based approach to override the oom killer
> > > selection without losing all the benefits of the current oom killer
> > > heuristics and oom_adj interface.
> > >
> > > It adds a tunable oom.victim to the oom cgroup. The oom killer will
> > > kill the process using the usual badness value but only within the
> > > cgroup with the maximum value for oom.victim before killing any process
> > > from a cgroup with a lesser oom.victim number. Oom killing could be
> > > disabled by setting oom.victim=0.
> >
> > This doesn't help in memcg or cpuset constrained oom conditions, which
> > still go through select_bad_process().
> >
> > If the oom.victim value is high for a specific cgroup and a memory
> > controller oom occurs in a disjoint cgroup, for example, it's possible to
> > needlessly kill tasks.  Obviously that is up to the administrator to
> > configure, but may not be his or her desire for system-wide oom
> > conditions.
>
> Hmm...after this patch, select_bad_process's filter to select process will
> be
>
> ==
> 	1. ->mm is NULL ?		=> don't select this
> 	2. is init task ?		=> don't select this
> 	3. is under specified memcg ?   => don't select this
> 	4. marked as MEMDIE ?		=> return -1.
> 	5. PF_EXITING?			=> select this.
> 	6. OOM_DISABLE ?		=> don't select this
> 	points = badness(p, uptime.tv_sec);
> 	7. adjust point & select logic depends on OOM cgroup
> ==
>
> Not looks good ;)
>

Yes, we do throw away a lot of needless work done. But this is how we already 
do and this is not a regression. But this could be used to improve the OOM 
killer's speed.

> > It may be preferred to kill tasks in a specific cgroup first when the
> > entire system is out of memory or kill tasks within a cgroup attached to
> > a memory controller when it is oom.
>
> I agree here.
>
> Above filter logic should be
> ==
> 	current_victim_level++;
> 	1. p is under oom cgroup of victim_level > current_victim_level => don't
> select this. 2. ->mm is NULL ?		=> don't select this
> 	3. is init task ?		=> don't select this
> 	4. is under specified memcg ?   => don't select this
> 	5. marked as MEMDIE ?		=> return -1.
> 	6. PF_EXITING?			=> select this.
> 	7. OOM_DISABLE ?		=> don't select this
> 	points = badness(p, uptime.tv_sec)
> ==
> But this will be too slow.
>
> I think do_each_thread() in select_bad_process() should be replaced with
> a routine like this, finally.
> ==
> 	for_each_oom_cgroup_in_victim_value_order() {
> 		for_each_threads_in_oom_cgroup(oom) {
> 			select one bad thread.
> 		}
> 		if (selected_one_is_enough_bad ?)
> 			return selected_one;
> 	}
> ==
>

Yes.

> And this can be a help for "spped up OOM killer" problem.
>

Yes.

Thanks
Nikanth
