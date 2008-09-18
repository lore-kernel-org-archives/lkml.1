Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYIRSsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYIRSsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYIRSsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:48:32 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:34619 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYIRSsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:48:31 -0400
Message-ID: <48D2A21E.7050806@linux.vnet.ibm.com>
Date: Thu, 18 Sep 2008 11:46:54 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: righi.andrea@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] memrlimit: fix task_lock() recursive locking
References: <48D29485.5010900@gmail.com>
In-Reply-To: <48D29485.5010900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> cgroup_mm_owner_callbacks() can be called with task_lock() held in
> mm_update_next_owner(), and all the .mm_owner_changed callbacks seem to
> be *always* called with task_lock() held.
> 
> Actually, memrlimit is using task_lock() via get_task_mm() in
> memrlimit_cgroup_mm_owner_changed(), raising the following recursive locking
> trace:

[snip]

Thanks for the BUG report()

[snip]

>  static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  						struct cgroup *old_cgrp,
> @@ -246,7 +246,7 @@ static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  						struct task_struct *p)
>  {
>  	struct memrlimit_cgroup *memrcg, *old_memrcg;
> -	struct mm_struct *mm = get_task_mm(p);
> +	struct mm_struct *mm = get_task_mm_task_locked(p);
> 

Since we hold task_lock(), we know that p->mm cannot change and we don't have to
worry about incrementing mm_users. I think using just p->mm will work, we do
have checks to make sure we don't pick a kernel thread. I vote for going down
that road.


-- 
	Balbir
