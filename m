Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZIAQ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZIAQ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZIAQ03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZIAQ03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:26:29 -0400
Date: Tue, 1 Sep 2009 18:22:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] core: allow setrlimit to non-current tasks
Message-ID: <20090901162215.GA7439@redhat.com>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com> <1251744974-29398-5-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251744974-29398-5-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, can't read these series today. Will try tomorrow.

But at first glance some parts looks suspicious to me,

On 08/31, Jiri Slaby wrote:
>
> @@ -1244,16 +1244,27 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
>
>  	if (new_rlim->rlim_cur > new_rlim->rlim_max)
>  		return -EINVAL;
> +
> +	/* protect tsk->signal and tsk->sighand from disappearing */
> +	read_lock_irq(&tasklist_lock);

Why _irq? We can take tasklist_lock for reading without disabling irqs.

And. Unless I misread the patch, update_rlimit_cpu() is called before
read_unlock_irq(&tasklist_lock), but update_rlimit_cpu() does
spin_unlock_irq(->siglock) and restores interrupts.

> +	if (!tsk->signal || !tsk->sighand) {

Please don't check !tsk->signal, !tsk->sighand is enough. If
we have ->sighand != NULL (under lock) ->signal must be valid.

But I dislike the fact the patch uses tasklist_lock. Can't
lock_task_sighand() work for you? (of course, in this case
update_rlimit_cpu() should be updated too).

Once again, I didn't actually read this series yet, sorry.

Oleg.

