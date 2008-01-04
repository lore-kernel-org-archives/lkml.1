Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYADQY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYADQY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYADQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:24:49 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5328 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYADQYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:24:48 -0500
Subject: Re: [patch 00/19] VM pageout scalability improvements
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>, Nick Dokos <nicholas.dokos@hp.com>
In-Reply-To: <20080103170035.105d22c8@cuia.boston.redhat.com>
References: <20080102224144.885671949@redhat.com>
	 <1199379128.5295.21.camel@localhost>
	 <20080103120000.1768f220@cuia.boston.redhat.com>
	 <1199380412.5295.29.camel@localhost>
	 <20080103170035.105d22c8@cuia.boston.redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 04 Jan 2008 11:25:34 -0500
Message-Id: <1199463934.5290.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 17:00 -0500, Rik van Riel wrote:
> On Thu, 03 Jan 2008 12:13:32 -0500
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > Yes, but the problem, when it occurs, is very awkward.  The system just
> > hangs for hours/days spinning on the reverse mapping locks--in both
> > page_referenced() and try_to_unmap().  No pages get reclaimed and NO OOM
> > kill occurs because we never get that far.  So, I'm not sure I'd call
> > any OOM kills resulting from this patch as "false".  The memory is
> > effectively nonreclaimable.   Now, I think that your anon pages SEQ
> > patch will eliminate the contention in page_referenced[_anon](), but we
> > could still hang in try_to_unmap().
> 
> I am hoping that Nick's ticket spinlocks will fix this problem.
> 
> Would you happen to have any test cases for the above problem that
> I could use to reproduce the problem and look for an automatic fix?

We can easily [he says, glibly] reproduce the hang on the anon_vma lock
with AIM7 loads on our test platforms.  Perhaps we can come up with an
AIM workload to reproduce the phenomenon on one of your test platforms.
I've seen the hang with 15K-20K tasks on a 4 socket x86_64 with 16-32G
of memory and quite a bit of storage.

I've also seen related hangs on both anon_vma and i_mmap_lock during a
heavy usex stress load on the splitlru+noreclaim patches.  [This, by the
way, without and WITH my rw_lock patches for both anon_vma and
i_mmap_lock.]  I can try to package up the workload to run on your
system.

> 
> Any fix that requires the sysadmin to tune things _just_ right seems
> too dangerous to me - especially if a change in the workload can
> result in the system doing exactly the wrong thing...
> 
> The idea is valid, but it just has to work automagically.
> 
> Btw, if page_referenced() is called less, the locks that try_to_unmap()
> also takes should get less contention.

Makes sense.  we'll have to see.

Lee
> 

