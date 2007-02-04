Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXBDFMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXBDFMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 00:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXBDFMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 00:12:53 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3204 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXBDFMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 00:12:48 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Feb 2007 21:12:46 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion
 system calls
In-Reply-To: <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
Message-ID: <Pine.LNX.4.64.0702031650150.9054@alien.or.mcafeemobile.com>
References: <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Zach Brown wrote:

> +void asys_task_exiting(struct task_struct *tsk)
> +{
> +	struct asys_result *res, *next;
> +
> +	list_for_each_entry_safe(res, next, &tsk->asys_completed, item)
> +		kfree(res);
> +
> +	/* 
> +	 * XXX this only works if tsk->fibril was allocated by
> +	 * sys_asys_submit(), not if its embedded in an asys_call.  This
> +	 * implies that we must forbid sys_exit in asys_submit.
> +	 */
> +	if (tsk->fibril) {
> +		BUG_ON(!list_empty(&tsk->fibril->run_list));
> +		kfree(tsk->fibril);
> +		tsk->fibril = NULL;
> +	}
> +}

What happens to lingering fibrils? Better keep track of both runnable and 
sleepers, and do proper cleanup.



> +asmlinkage long sys_asys_submit(struct asys_input __user *user_inp,
> +				unsigned long nr_inp)
> +{
> +	struct asys_input inp;
> +	struct asys_result *res;
> +	struct asys_call *call;
> +	struct thread_info *ti;
> +	unsigned long i;
> +	long err = 0;
> +
> +	/* Allocate a fibril for the submitter's thread_info */
> +	if (current->fibril == NULL) {
> +		current->fibril = kzalloc(sizeof(struct fibril), GFP_KERNEL);
> +		if (current->fibril == NULL)
> +			return -ENOMEM;
> +
> +		INIT_LIST_HEAD(&current->fibril->run_list);
> +		current->fibril->state = TASK_RUNNING;
> +		current->fibril->ti = current_thread_info();
> +	}

Why do we need the "special" submission fibril?




> +	for (i = 0; i < nr_inp; i++) {
> +
> +		if (copy_from_user(&inp, &user_inp[i], sizeof(inp))) {
> +			err = -EFAULT;
> +			break;
> +		}
> +
> +		res = kmalloc(sizeof(struct asys_result), GFP_KERNEL);
> +		if (res == NULL) {
> +			err = -ENOMEM;
> +			break;
> +		}
> +
> +		/* XXX kzalloc to init call.fibril.per_cpu, add helper */
> +		call = kzalloc(sizeof(struct asys_call), GFP_KERNEL);
> +		if (call == NULL) {
> +			kfree(res);
> +			err = -ENOMEM;
> +			break;
> +		}
> +
> +		ti = alloc_thread_info(tsk);
> +		if (ti == NULL) {
> +			kfree(res);
> +			kfree(call);
> +			err = -ENOMEM;
> +			break;
> +		}
> +
> +		err = asys_init_fibril(&call->fibril, ti, &inp);
> +		if (err) {
> +			kfree(res);
> +			kfree(call);
> +			free_thread_info(ti);
> +			break;
> +		}
> +
> +		res->comp.cookie = inp.cookie;
> +		call->result = res;
> +		ti->task = current;
> +
> +		sched_new_runnable_fibril(&call->fibril);
> +		schedule();
> +	}
> +
> +	return i ? i : err;
> +}

Streamline error path (kfree(NULL) is OK):

	err =  -ENOMEM;
	a = alloc();
	b = alloc();
	c = alloc();
	if (!a || !b || !c)
		goto error;
	...
error:
	kfree(c);
	kfree(b);
	kfree(a);
	return err;


- Davide


