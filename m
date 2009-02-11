Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZBKVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZBKVRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZBKVR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:17:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbZBKVR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:17:28 -0500
Date: Wed, 11 Feb 2009 22:14:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] reparent/untrace: do nothing if no childs/tracees
Message-ID: <20090211211452.GA16883@redhat.com>
References: <20090211211224.GA16860@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211211224.GA16860@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Oleg Nesterov wrote:
>
> However, forget_original_parent() has another problem. We can race with
> another thread which has already picked us for reparenting before we set
> PF_EXITING, so this patch also checks thread_group_empty().
>
> It is possible to be more clever, we can take tasklist for reading, or
> ensure that ->thread_group.prev is not PF_EXITING, but this is nasty.
> Perhaps even this optimization is too ugly.

Or, perhaps we can do:

	static void forget_original_parent(struct task_struct *father)
	{
		struct task_struct *p, *n, *reaper;
		LIST_HEAD(dead_childs);

		if (list_empty(&father->children))
			return;

		write_lock_irq(&tasklist_lock);
	again:
		reaper = find_new_reaper(father);

		list_for_each_entry_safe(p, n, &father->children, sibling) {
			p->real_parent = reaper;
			if (p->parent == father) {
				BUG_ON(p->ptrace);
				p->parent = p->real_parent;
			}
			reparent_thread(father, p, &dead_childs);
		}

		smp_mb(); /* do_exit() does mb() after exit_signals() */
		if (unlikely(reaper->flags & PF_EXITING)) {
			father = reaper;
			goto again;
		}
		write_unlock_irq(&tasklist_lock);

		BUG_ON(!list_empty(&father->children));

		list_for_each_entry_safe(p, n, &dead_childs, sibling) {
			list_del_init(&p->sibling);
			release_task(p);
		}
	}

but this needs a fat comment at least. I am not sure this worth the trouble.

Oleg.

