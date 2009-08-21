Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZHUKaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZHUKaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZHUKaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:30:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbZHUKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:30:07 -0400
Date: Fri, 21 Aug 2009 12:26:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bblum@google.com, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com
Subject: Re: +
	cgroups-add-functionality-to-read-write-lock-clone_thread-forking-pe
	r-threadgroup.patch added to -mm tree
Message-ID: <20090821102611.GA2611@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Andrew Morton wrote:
>
> Subject: cgroups: add functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
> From: Ben Blum <bblum@google.com>
>
> Add an rwsem that lives in a threadgroup's sighand_struct (next to the
> sighand's atomic count, to piggyback on its cacheline), and two functions
> in kernel/cgroup.c (for now) for easily+safely obtaining and releasing it.

Sorry. Currently I have no time to read these patched. Absolutely :/

But the very first change I noticed outside of cgroups.[ch] looks very wrong,

> +struct sighand_struct *threadgroup_fork_lock(struct task_struct *tsk)
> +{
> +	struct sighand_struct *sighand;
> +	struct task_struct *p;
> +
> +	/* tasklist lock protects sighand_struct's disappearance in exit(). */
> +	read_lock(&tasklist_lock);
> +	if (likely(tsk->sighand)) {
> +		/* simple case - check the thread we were given first */
> +		sighand = tsk->sighand;
> +	} else {
> +		sighand = NULL;
> +		/*
> +		 * tsk is exiting; try to find another thread in the group
> +		 * whose sighand pointer is still alive.
> +		 */
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {

If ->sighand == NULL we can't use list_for_each_entry_rcu(->thread_group),
and rcu_read_lock() can't help.

The task was removed from ->thread_group, its ->next points to nowhere.

list_for_rcu(head) can _only_ work if we can trust head->next: it should
point either to "head" (list_empty), or to the valid entry.

Please correct me if I missed something.

Otherwise, please send the changes which touch the process-management
code separately. And please do not forget to CC people who work with
this code ;)

Oleg.

