Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZBXNWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZBXNWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZBXNWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:22:31 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:57631 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZBXNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:22:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JPAhOexZCKOTH8NgxHpE7IhPbF2f99SVBIma9KZVDRRnPD0LPV+33BWWo2MC8G0APy
         gn68cQ7T6SUuxWoM54j0qlnRrUW6jbDfcW3mCqdA1IWdwU/TT2noYhq3LXXx2mMWsMqO
         9LGCR0qsmrhYNy4kqSsDAZoTKKNMZ5pbzyyy8=
Message-ID: <49A3F48E.5030008@gmail.com>
Date: Tue, 24 Feb 2009 14:22:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: broken do_each_pid_{thread,task}
References: <494581D7.6000203@gmail.com> <m1wse29roy.fsf@frodo.ebiederm.org> <20081215104716.GB11106@redhat.com> <20081215170937.GA24080@redhat.com>
In-Reply-To: <20081215170937.GA24080@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.2008 18:09, Oleg Nesterov wrote:
> On 12/15, Oleg Nesterov wrote:
>> On 12/14, Eric W. Biederman wrote:
>>> Although seeing the unexpected corner case it gets us into I think it would
>>> be good to reconsider this test.
>
> So. I can't decide whether this patch is cleanup or the further
> uglification, but if anyone likes it I will be happy to send it.

FWIW I don't like the patch :), but noone else appears to dislike it. 
Ideas, comments?

Otherwise I'll add at least a big warning about using break/cont 
statements inside the loop.

> Then we can kill do_each_pid_task/while_each_pid_task completely.
>
> Oleg.
>
> --- linux-2.6.27/include/linux/pid.h~PID_FOR_EACH	2008-10-10 00:13:53.000000000 +0200
> +++ linux-2.6.27/include/linux/pid.h	2008-12-15 17:51:50.000000000 +0100
> @@ -144,21 +144,25 @@ static inline pid_t pid_nr(struct pid *p
>   pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
>   pid_t pid_vnr(struct pid *pid);
>
> +/*
> + * Both old and new leaders may be attached to the same pid in the
> + * middle of de_thread(), that is why we do the special check for
> + * PIDTYPE_PID below.
> + */
> +#define pid_for_each_task(pid, type, p)	\
> +	for (p = (pid) ? (void*)(pid)->tasks[type].first : NULL;	\
> +	     rcu_dereference(p)&&  ({					\
> +		prefetch(((struct hlist_node*)p)->next);		\
> +		p = hlist_entry((void*)p, typeof(*p), pids[type].node);	\
> +		1; });							\
> +	     p = ((type) != PIDTYPE_PID) ?				\
> +		(void*)(p)->pids[type].node.next : NULL)
> +
>   #define do_each_pid_task(pid, type, task)				\
>   	do {								\
> -		struct hlist_node *pos___;				\
> -		if (pid != NULL)					\
> -			hlist_for_each_entry_rcu((task), pos___,	\
> -				&pid->tasks[type], pids[type].node) {
> +		pid_for_each_task(pid, type, task)
>
> -			/*
> -			 * Both old and new leaders may be attached to
> -			 * the same pid in the middle of de_thread().
> -			 */
>   #define while_each_pid_task(pid, type, task)				\
> -				if (type == PIDTYPE_PID)		\
> -					break;				\
> -			}						\
>   	} while (0)
>
>   #define do_each_pid_thread(pid, type, task)				\
>

