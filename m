Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZE3Wnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZE3Wnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZE3WnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759220AbZE3WnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:03 -0400
Date: Sun, 31 May 2009 00:38:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/12 v3] ptrace: introduce task_struct->ptrace_cxt
Message-ID: <20090530223820.GA30474@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

	04/12:	move kfree() outside of task_lock() in alloc_ptrace_context().
		But I misread your sugesstion:

			>       task_lock(tsk);
			>       if (likely(!tsk->ptrace_ctx)) {
			>               tsk->ptrace_ctx = ptrace_ctx;
			>               task_unlock(tsk);
			>               return 0;
			>       }
			>
			>       task_unlock(tsk);
			>       kfree(ptrace_ctx);

		Just can't do that. I hate multiple unlocks very much. So it
		becomes:

			task_lock(tsk);
			if (likely(!tsk->ptrace_ctx)) {
				tsk->ptrace_ctx = ptrace_ctx;
				ptrace_ctx = NULL;
			}
			task_unlock(tsk);
			kfree(ptrace_ctx);

		kfree(NULL) is specially allowed.


	05/12:	Add the comment about tracehook_init_task to ptrace_init_task().

		I didn't change the original comment, but imho it is confusing.
		"immediately after adding @child to its parent's children list"
		does not matter. What does matter, is that it is called before
		this child is visible to the user-space and thus the unconditional
		ptrace_link() is safe: nobody could attach before us.


	08/12:	No changes, but I think it better to change format_mca_init_stack()
		right now. Imho it has nothing to do with tracehooks and it is the
		last user of ->parent (except perhaps there are some in arch/ code
		which should be tracehookfied).


	09/12:	Remove the stale "pt_" from the changelog.

Oleg.

