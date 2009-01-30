Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZA3Vt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZA3Vt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZA3VtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:49:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbZA3VtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:49:18 -0500
Date: Fri, 30 Jan 2009 13:47:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: hch@lst.de, ebiederm@xmission.com, mingo@elte.hu, xemul@openvz.org,
       rusty@rustcorp.com.au, vgusev@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Message-Id: <20090130134736.ce5910aa.akpm@linux-foundation.org>
In-Reply-To: <20090130123358.GA26216@redhat.com>
References: <20090130123358.GA26216@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 13:33:58 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

>  int kthread_stop(struct task_struct *k)
>  {
> +	struct kthread *kthread;
>  	int ret;
>  
> -	mutex_lock(&kthread_stop_lock);
> -
> -	/* It could exit after stop_info.k set, but before wake_up_process. */
> -	get_task_struct(k);
> -
>  	trace_sched_kthread_stop(k);
> +	get_task_struct(k);
>  
> -	/* Must init completion *before* thread sees kthread_stop_info.k */
> -	init_completion(&kthread_stop_info.done);
> -	smp_wmb();
> +	kthread = to_kthread(k);
> +	barrier(); /* it might have exited */

Why the change from smp_wmb() to plain old barrier()?
