Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZK3EQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZK3EQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 23:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZK3EQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 23:16:21 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58253 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZK3EQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 23:16:20 -0500
Date: Mon, 30 Nov 2009 09:46:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] ksm: hold anon_vma in rmap_item fix
Message-ID: <20091130041617.GJ2970@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0911291544140.14991@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911291544140.14991@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-11-29 15:50:32]:

> KSM mem_cgroup testing oopsed on NULL pointer in mem_cgroup_from_task(),
> called from the mm_match_cgroup() in page_referenced_ksm().
> 
> Right, it is inappropriate to use mm_match_cgroup() on rmap_item->mm
> there: that mm could be waiting for ksmd's final mmdrop(), with its
> mm->owner task long gone.
> 
> Move the mm_match_cgroup() test down into the anon_vma loop, which is
> where it now should be to match page_referenced_anon().  The anon_vma
> guarantees its vmas are valid, which guarantee their mms are valid.
> 
> However... although this moves the oops from easy-to-reproduce to
> never-seen, I think we shall want to do more later: so far as I can
> see, with or without KSM, the use of mm->owner from page_referenced()
> is unsafe.  No problem when NULL, but it may have been left pointing
> to a task_struct freed by now, with nonsense in mm->owner->cgroups.
>

Ideally we should not be left pointing to a stale task struct, unless
our assumption about mm_users is incorrect (discussed below).

 
> But let's put this patch in while we discuss that separately: perhaps
> mm_need_new_owner() should not short-circuit when mm_users <= 1, or
> perhaps it should then set mm->owner to NULL, or perhaps we abandon
> mm->owner as more trouble than it's worth, or... perhaps I'm wrong.
> 

We short circuit, since the task is exiting and mm_users <= 1 and we
are shorting going to do a mmput(). I suspect what you are seeing is
mm_count >= 1 and mm_users == 0. With users == 0, we should set
owner to NULL

We could look for the above condition in mmput() and clear the owner
when users become 0.


-- 
	Balbir
