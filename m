Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZDOXgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZDOXgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZDOXf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:35:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794AbZDOXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:35:57 -0400
Date: Wed, 15 Apr 2009 16:32:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-Id: <20090415163243.94a00ba6.akpm@linux-foundation.org>
In-Reply-To: <20090413214513.GA1119@redhat.com>
References: <20090413214513.GA1119@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 23:45:13 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> - Fix the comment, is_single_threaded(p) actually means that nobody shares
>   ->mm with p.
> 
>   I think this helper should be renamed, and it should not have arguments.
>   With or without this patch it must not be used unless p == current,
>   otherwise we can't safely use p->signal or p->mm.
> 
> - "if (atomic_read(&p->signal->count) != 1)" is not right when we have a
>   zombie group leader, use signal->live instead.
> 
> - Add PF_KTHREAD check to skip kernel threads which may borrow p->mm,
>   otherwise we can return the wrong "false".
> 
> - Use for_each_process() instead of do_each_thread(), all threads must use
>   the same ->mm.
> 
> - Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
>   to iterate over the process list. If there is another CLONE_VM process
>   it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
>   a freshly forked CLONE_VM task, but this doesn't matter because we must
>   see its parent and return false.

hum.  I'm searching for a reason to merge this into 2.6.30 but I'm not
seeing one?

