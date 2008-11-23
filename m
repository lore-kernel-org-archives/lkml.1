Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYKWIxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYKWIxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYKWIxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:53:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYKWIxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:53:24 -0500
Date: Sun, 23 Nov 2008 09:53:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the
	userspace address belongs to
Message-ID: <20081123085310.GF30453@elte.hu>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227353328-16104-3-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> Impact: modify+improve the userstacktrace tracing visualization feature

> +static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
> +				    unsigned long ip, unsigned long sym_flags)
> +{
> +	struct file *file = NULL;
> +	unsigned long vmstart = 0;
> +	int ret = 1;
> +
> +	if (mm) {
> +		const struct vm_area_struct *vma = find_vma(mm, ip);
> +		if (vma) {

Style: please put a newline after variable definition blocks.

> +			file = vma->vm_file;
> +			vmstart = vma->vm_start;

Bug: it's generally unsafe to look up a vma and use it without having 
done a down_read(&mm->mmap_sem). Another thread (of this ->mm) could 
go and modify it in parallel.

> +		}
> +	}
> +	if (file) {
> +		ret = trace_seq_path(s, &file->f_path);
> +		if (ret)
> +			ret = trace_seq_printf(s, "[+0x%lx]",
> +					ip - vmstart);

Style: that linebreak is unnecessary.

> +	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
> +		struct task_struct *task;
> +		/*
> +		 * we do the lookup on the thread group leader,
> +		 * since individual threads might have already quit!
> +		 */
> +		rcu_read_lock();
> +		task = find_task_by_vpid(entry->ent.tgid);
> +		rcu_read_unlock();
> +
> +		if (task)
> +			mm = get_task_mm(task);

Bug: it is unsafe to look up a task and then drop the RCU lock and use 
it - the task could go away the moment the RCU read-lock is dropped.

A safer sequence would be to get get_task_mm(task) reference inside 
the RCU critical section.

	Ingo
