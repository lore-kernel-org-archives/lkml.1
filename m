Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbZIREbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbZIREbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 00:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZIREbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 00:31:45 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39305 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZIREbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 00:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tQVWhzFRadSAETp3VWVd6JtH1uGP03vWWbT/BylX2qZBiV4SeuxXzhVSjYKDZ7wFjl
         HX8n8cyd5wxoFcBplDmpjySoWJFJ9kvSYgmrlcS5qWZIqyEZkhwoDy7pRLjiZgAt7A4r
         uEdo8FBQTI/ms80X9hiwUQ+BvztAJnq6WqJXo=
Date: Fri, 18 Sep 2009 06:31:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/2] tracing: Allocate the ftrace event profile buffer
	dynamically
Message-ID: <20090918043143.GA5186@nowhere>
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com> <1253247854-5496-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253247854-5496-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 06:24:14AM +0200, Frederic Weisbecker wrote:
>  static void prof_syscall_enter(struct pt_regs *regs, long id)
>  {
> -	struct syscall_trace_enter *rec;
>  	struct syscall_metadata *sys_data;
> +	struct syscall_trace_enter *rec;
> +	char *raw_data;
>  	int syscall_nr;
>  	int size;
> +	int cpu;
>  
>  	syscall_nr = syscall_get_nr(current, regs);
>  	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
> @@ -402,20 +404,39 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
>  	size = ALIGN(size + sizeof(u32), sizeof(u64));
>  	size -= sizeof(u32);
>  
> -	do {
> -		char raw_data[size];
> +	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
> +		      "profile buffer not large enough"))
> +		return;
> +
> +	/*
> +	 * We are not in nmi. Also we can't be preempted by a sysenter event
> +	 * from interrupt, so we can safely take this buffer without
> +	 * masking interrupts. But we still need rcu_read_lock to protect
> +	 * against concurrent buffer release.
> +	 */
> +	rcu_read_lock();



Oh...now that we use a global buffer, the buffer is not safe anymore against
interrupts or NMIs.

Looks like I will need a third iteration.

Sorry for the noise...

