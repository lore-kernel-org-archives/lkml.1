Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXDKMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXDKMEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXDKMEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:04:46 -0400
Received: from mail.screens.ru ([213.234.233.54]:39902 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXDKMEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:04:45 -0400
Date: Wed, 11 Apr 2007 16:04:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Don't depend on work queues
Message-ID: <20070411120431.GB165@tv-sign.ru>
References: <20070410185133.GA104@tv-sign.ru> <m13b37v517.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13b37v517.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Eric W. Biederman wrote:
> 
> +int kthreadd(void *unused)
> +{
> +	/* Setup a clean context for our children to inherit. */
> +	kthreadd_setup();
> +
> +	current->flags |= PF_NOFREEZE;
> +
> +	for (;;) {
> +		wait_event(kthread_create_work,
> +			   !list_empty(&kthread_create_list));
> +
> +		spin_lock(&kthread_create_lock);
> +		while (!list_empty(&kthread_create_list)) {

Do we need to check the condition under lock? We can miss an event,
but then it will be noticed by wait_event() above.

> +			struct kthread_create_info *create;
> +
> +			create = list_entry(kthread_create_list.next,
> +					    struct kthread_create_info, list);
> +			list_del_init(&create->list);
> +			spin_unlock(&kthread_create_lock);
> +
> +			create_kthread(create);
> +
> +			spin_lock(&kthread_create_lock);
> +		}
> +		spin_unlock(&kthread_create_lock);
> +	}

IOW,

	for (;;) {
		wait_event(kthread_create_work,
			   !list_empty(&kthread_create_list));

		while (!list_empty(&kthread_create_list)) {
			struct kthread_create_info *create;

			spin_lock(&kthread_create_lock);
			create = list_entry(kthread_create_list.next,
					    struct kthread_create_info, list);
			list_del_init(&create->list);
			spin_unlock(&kthread_create_lock);

			create_kthread(create);
		}
	}

Oleg.

