Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYDASqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYDASqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYDASqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:46:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbYDASqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:46:12 -0400
Date: Tue, 1 Apr 2008 11:45:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Mayhar <fmayhar@google.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc7 resubmit] Fix itimer/many thread hang.
Message-Id: <20080401114546.5a222cc0.akpm@linux-foundation.org>
In-Reply-To: <1206744400.19691.31.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080207165455.04ec490b@Varda>
	<alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	<alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	<1204314904.4850.23.camel@peace.smo.corp.google.com>
	<20080304070016.903E127010A@magilla.localdomain>
	<1204660376.9768.1.camel@bobble.smo.corp.google.com>
	<20080305040826.D0E6127010A@magilla.localdomain>
	<1204830243.20004.31.camel@bobble.smo.corp.google.com>
	<20080311075020.A93DB26F991@magilla.localdomain>
	<1205269507.23124.57.camel@bobble.smo.corp.google.com>
	<20080311213507.5BCDF26F991@magilla.localdomain>
	<1205455050.19551.16.camel@bobble.smo.corp.google.com>
	<20080321071846.1B22B26F9A7@magilla.localdomain>
	<1206122240.14638.31.camel@bobble.smo.corp.google.com>
	<20080322215829.D69D026F9A7@magilla.localdomain>
	<1206665568.426.24.camel@bobble.smo.corp.google.com>
	<1206744400.19691.31.camel@bobble.smo.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 15:46:40 -0700
Frank Mayhar <fmayhar@google.com> wrote:

>  asmlinkage long sys_times(struct tms __user * tbuf)
>  {
> +	struct thread_group_cputime thread_group_times;
> +
>  	/*
>  	 *	In the SMP world we might just be unlucky and have one of
>  	 *	the times increment as we use it. Since the value is an
> @@ -873,19 +875,28 @@ asmlinkage long sys_times(struct tms __user * tbuf)
>  	if (tbuf) {
>  		struct tms tmp;
>  		struct task_struct *tsk = current;
> -		struct task_struct *t;
>  		cputime_t utime, stime, cutime, cstime;
>  
>  		spin_lock_irq(&tsk->sighand->siglock);
> -		utime = tsk->signal->utime;
> -		stime = tsk->signal->stime;
> -		t = tsk;
> -		do {
> -			utime = cputime_add(utime, t->utime);
> -			stime = cputime_add(stime, t->stime);
> -			t = next_thread(t);
> -		} while (t != tsk);
> -
> +		/*
> +		 * If a POSIX interval timer is running use the process-wide
> +		 * fields, else fall back to brute force.
> +		 */
> +		if (sig->thread_group_times) {

kernel/sys.c: In function 'sys_times':
kernel/sys.c:885: error: 'sig' undeclared (first use in this function)
