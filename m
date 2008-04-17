Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYDQFAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYDQFAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYDQE7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:59:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYDQE7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:59:55 -0400
Date: Wed, 16 Apr 2008 21:59:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating
 tsk->cg_list
Message-Id: <20080416215907.63d71409.akpm@linux-foundation.org>
In-Reply-To: <6599ad830804162117w14364b7cg20d3694ffdfeb867@mail.gmail.com>
References: <4806C5EB.3040102@cn.fujitsu.com>
	<20080416211144.a38f6fc0.akpm@linux-foundation.org>
	<6599ad830804162117w14364b7cg20d3694ffdfeb867@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 21:17:34 -0700 "Paul Menage" <menage@google.com> wrote:

> On Wed, Apr 16, 2008 at 9:11 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  I don't fully understand the race.  Both paths hold css_set_lock.
> >
> >  Can you describe it in more detail please?
> 
> Task A starts exiting, passes the check for unlinking current->cg_list.

So cgroup_exit() sees !list_empty(tsk->cg_list)

And the list_del() sets tsk->cg_list to LIST_POISON[12], which still means
!list_empty().  Or we remove that debugging code and avoid writing to
tsk->cg_list, and it _still_ is !list_empty().

> Before it completely exits task B does the very first
> cgroup_iter_begin() call (via reading a cgroups tasks file) which
> links all tasks in to their css_set objects via tsk->cg_list.

But it won't link this task, because it's !list_empty().

> Then task A finishes exiting and is freed, but doesn't unlink from the cg_list.
> 
> >
> >  afacit the task at *p could set PF_EXITING immediately after this code has
> >  tested PF_EXITING and then the task at *p could proceed until we hit the
> >  same race (whatever that is).
> 
> The important fact there is that the task sets PF_EXITING *before* it
> checks whether it needs to unlink from current->cg_list.
> 
> Paul
