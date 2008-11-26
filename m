Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYKZOBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYKZOBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYKZOBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:01:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYKZOBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:01:13 -0500
Date: Wed, 26 Nov 2008 15:00:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126140027.GC6562@elte.hu>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
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


* eranian@googlemail.com <eranian@googlemail.com> wrote:

> +static int pfm_task_incompatible(struct pfm_context *ctx,
> +				 struct task_struct *task)
> +{
> +	/*
> +	 * cannot attach to a kernel thread
> +	 */
> +	if (!task->mm) {
> +		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
> +		return -EPERM;
> +	}
> +
> +	/*
> +	 * cannot attach to a zombie task
> +	 */
> +	if (task->exit_state == EXIT_ZOMBIE || task->exit_state == EXIT_DEAD) {
> +		PFM_DBG("cannot attach to zombie/dead task [%d]", task->pid);
> +		return -EBUSY;
> +	}
> +	return 0;
> +}

The ptrace coupling code seems broken.

It is used in the following context:

+       /*
+        * returns 0 if cannot attach
+        */
+       ret1 = ptrace_may_access(p, PTRACE_MODE_ATTACH);
+       if (ret1)
+               ret = ptrace_check_attach(p, 0);
+
+       PFM_DBG("may_attach=%d check_attach=%d", ret1, ret);
+
+       if (ret || !ret1)
+               goto error;
+
+       ret = pfm_task_incompatible(ctx, p);
+       if (ret)
+               goto error;

firstly, this code is critical to security, but the variable naming 
and the control flow is shaped in a dangerous and error-prone way: two 
opaque 'ret' and 'ret1' names, which have _inverted_ logical meaning: 
for 'ret' a nonzero value means an error, for 'ret1' a zero value 
means error.

This code _must_ be rewritten cleanly via a single 'err' variable. 
There's absolutely no need to nest ret and ret1 here. If we may not 
access via ptrace then we should error out pronto and not complicate 
the flow.

Secondly, get rid of those PFM_DBG() calls there, they are not needed 
in a production kernel and just obscure review.

Thirdly, the check for ->exit_state in pfm_task_incompatible() is not 
needed: we've just passed ptrace_check_attach() so we know we just 
transitioned the task to task->state == TASK_TRACED.

If you _ever_ see a task exit TASK_TRACED and go zombie or dead from 
there without this code allowing it that means the whole state machine 
with ptrace is borked up by perfmon. For example i dont see where the 
perfmon-control task parents itself as the exclusive debugger (parent) 
of the debuggee-task.

Without that being implemented properly, a parallel ptrace / perfmon 
scenario (triggerable by unprivileged userspace) can go amok, crash 
the kernel and likely open up various rootholes as well. The kludge in 
pfm_task_incompatible() shows that this was probably seen in the field 
and hacked around.

	Ingo
