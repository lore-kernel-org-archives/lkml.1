Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbZDPKG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbZDPKG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757854AbZDPKFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:05:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbZDPKFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:05:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090413214513.GA1119@redhat.com>
References: <20090413214513.GA1119@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Date: Thu, 16 Apr 2009 11:04:32 +0100
Message-ID: <14878.1239876272@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> - Fix the comment, is_single_threaded(p) actually means that nobody shares
>   ->mm with p.
> 
>   I think this helper should be renamed,

What we want to know when we ask this function is whether or not a process is
single-threaded, hence the name.  The fact that because:

	CLONE_THREAD => CLONE_SIGHAND => CLONE_VM

we can work this out purely by checking that there aren't any processes that
share VM space with us is immaterial.

> and it should not have arguments.  With or without this patch it must not be
> used unless p == current, otherwise we can't safely use p->signal or p->mm.

Well, I can live with that, but you need to check with the SELinux people too.
Whilst they do currently limit the selinux_setprocattr() to current only, they
still hand the task pointer that function is given around.

> - Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
>   to iterate over the process list. If there is another CLONE_VM process
>   it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
>   a freshly forked CLONE_VM task, but this doesn't matter because we must
>   see its parent and return false.

Hmmm...  I'd quite like to avoid using down_write() if possible.  Why do we
need to do this?  Is it just to stop processes that might cease using mm from
doing so until we've finished?

David
