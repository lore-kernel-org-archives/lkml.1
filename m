Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZICRoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZICRoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZICRox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZICRox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:44:53 -0400
Date: Thu, 3 Sep 2009 19:41:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core: allow setrlimit to non-current tasks
Message-ID: <20090903174106.GC27161@redhat.com>
References: <4A9FC8DA.4090001@gmail.com> <1251985948-28965-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251985948-28965-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Jiri Slaby wrote:
>
> @@ -1240,6 +1240,7 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
>  		struct rlimit *new_rlim)
>  {
>  	struct rlimit *old_rlim;
> +	unsigned int needs_locking = !same_thread_group(tsk, current);
>  	int retval;

Yes, thanks for doing this, imho this optimization is worthwhile.

But I'd suggest you to add this optimization in a separate patch
because,

> +	/* optimization: 'current' doesn't need locking, e.g. setrlimit */
> +	if (needs_locking) {
> +		/* protect tsk->signal and tsk->sighand from disappearing */
> +		read_lock(&tasklist_lock);
> +		if (!tsk->sighand) {
> +			retval = -ESRCH;
> +			goto unlock;

I should have mentioned this before, but it is not that simple.

Even if same_thread_group(tsk, current), we must not trust tsk->sighand,
it can be NULL if our subthread is dead. (well, we need ->signal, not
->sighand but this doesn't matter because they disappear simultaneously).

Actually, perhaps same_thread_group() is not needed, perhaps it is enough
to avoid tasklist in sys_setrlimit case. So, I think optimization should
do:

	retval = -ESRCH;
	if (tsk != current) {
		read_lock(&tasklist_lock);
		if (!tsk->sighand)
			goto unlock;
	}

unlock:
	if (tsk != current)
		read_unlock(&tasklist_lock);


Or, if we use same_thread_group(),

	needs_locking = !same_thread_group(tsk, current);

	if (!needs_locking)
		tsk = current;
	else {
		take tasklist, check ->sighand.
	}

Oleg.

