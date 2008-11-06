Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYKFUfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYKFUfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYKFUfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:35:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYKFUfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:35:36 -0500
Date: Thu, 6 Nov 2008 21:35:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081106203520.GD3578@elte.hu>
References: <b040c32a0811061101j4a93a0f2pe30c0598726acd08@mail.gmail.com> <20081106195107.GA17545@x200.localdomain> <b040c32a0811061212x2630fda9xdd5adfdf3105044d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811061212x2630fda9xdd5adfdf3105044d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> On Thu, Nov 6, 2008 at 11:51 AM, Alexey Dobriyan wrote:
> > Please, name handler proc_pid_stack following current convention.
> > And drop space before casts.
> 
> OK.  handler name changed.  For the space between cast, it looks 
> like there are different styles in the code base, either with or 
> without. I dropped the space since I don't have strong opinion one 
> way or the other.

best way is to run scripts/checkpatch.pl on your patch, that will 
remind you of any potential style issues.

> Also wrap proc_pid_stack() inside CONFIG_STACKTRACE to fix compile 
> time error when config option is not selected.

> +#ifdef CONFIG_STACKTRACE
> +#define MAX_STACK_TRACE_DEPTH	32

How about 64 instead? (it's such a nice round number)

> +static int proc_pid_stack(struct task_struct *task, char *buffer)
> +{
> +	int i, len = 0;
> +	unsigned long *entries;
> +	struct stack_trace trace;
> +
> +	entries = kmalloc(sizeof(*entries) * MAX_STACK_TRACE_DEPTH, GFP_KERNEL);
> +	if (!entries)
> +		goto out;
> +
> +	trace.nr_entries = 0;
> +	trace.max_entries = MAX_STACK_TRACE_DEPTH;
> +	trace.entries = entries;
> +	trace.skip = 0;
> +
> +	read_lock(&tasklist_lock);
> +	save_stack_trace_tsk(task, &trace);
> +	read_unlock(&tasklist_lock);
> +
> +	for (i = 0; i < trace.nr_entries; i++) {
> +		len += sprintf(buffer + len, "[<%p>] %pS\n",
> +				(void *)entries[i], (void *)entries[i]);

hm, this looks like a potential buffer overflow - isnt 'buffer' here 
only valid up to the next PAGE_SIZE boundary?

> +	}

> +	kfree(entries);
> +out:
> +	return len;

Not sure about the error path convention here: in the !entries kmalloc 
failure path, shouldnt we return -ENOMEM? Otherwise userspace will get 
zero length and would retry again and again?

Also, please rename 'out:' to 'error:' - to make it clear that it's an 
error path.

	Ingo
