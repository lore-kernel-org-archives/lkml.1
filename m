Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXDKQ1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXDKQ1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXDKQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:27:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49894 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXDKQ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:27:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Don't depend on work queues
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
	<20070411120431.GB165@tv-sign.ru>
Date: Wed, 11 Apr 2007 10:25:48 -0600
In-Reply-To: <20070411120431.GB165@tv-sign.ru> (Oleg Nesterov's message of
	"Wed, 11 Apr 2007 16:04:31 +0400")
Message-ID: <m1y7kysws3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/10, Eric W. Biederman wrote:
>> 
>> +int kthreadd(void *unused)
>> +{
>> +	/* Setup a clean context for our children to inherit. */
>> +	kthreadd_setup();
>> +
>> +	current->flags |= PF_NOFREEZE;
>> +
>> +	for (;;) {
>> +		wait_event(kthread_create_work,
>> +			   !list_empty(&kthread_create_list));
>> +
>> +		spin_lock(&kthread_create_lock);
>> +		while (!list_empty(&kthread_create_list)) {
>
> Do we need to check the condition under lock? We can miss an event,
> but then it will be noticed by wait_event() above.

We need to be certain there is something on the list before we remove
it.  Otherwise we will start dereferencing bad pointers.

> IOW,
>
> 	for (;;) {
> 		wait_event(kthread_create_work,
> 			   !list_empty(&kthread_create_list));
>
> 		while (!list_empty(&kthread_create_list)) {
> 			struct kthread_create_info *create;
>
> 			spin_lock(&kthread_create_lock);
> 			create = list_entry(kthread_create_list.next,
> 					    struct kthread_create_info, list);
> 			list_del_init(&create->list);
> 			spin_unlock(&kthread_create_lock);
>
> 			create_kthread(create);
> 		}
> 	}

I guess since we are the only process to ever remove things from the
list that would be safe.

Eric

