Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZCTITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZCTITy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZCTITj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:19:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52759 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZCTITh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:19:37 -0400
Date: Fri, 20 Mar 2009 13:49:14 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 7/9] tracing: kprobe-tracer plugin supports
	arguments
Message-ID: <20090320081914.GD6398@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49C2B4D0.8030904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2B4D0.8030904@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 05:10:40PM -0400, Masami Hiramatsu wrote:

> +#if defined(__i386__)
> +#define REGPARMS 3
> +static unsigned long fetch_argument(struct pt_regs *regs, void *data)
> +{
> +	unsigned long n = (unsigned long)data;
> +	if (n > REGPARMS) {
> +		/*
> +		 * The typical case: arg n is on the stack.
> +		 * stack[0] = return address
> +		 */
> +		return fetch_stack(regs, (void *)(n - REGPARMS));
> +	} else {
> +		switch (n) {
> +		case 1: return regs->ax;
> +		case 2: return regs->dx;
> +		case 3: return regs->cx;
> +		}
> +		return 0;
> +	}
> +}
> +#elif define(__x86_64__)

#elif defined(__x86_64__)

> +#define REGPARMS 6
> +static unsigned long fetch_argument(struct pt_regs *regs, void *data)
> +{
> +	unsigned long n = (unsigned long)data;
> +	if (n > REGPARMS) {
> +		/*
> +		 * The typical case: arg n is on the stack.
> +		 * stack[0] = return address
> +		 */
> +		return fetch_stack(regs, (void *)(n - REGPARMS));
> +	} else {
> +		switch (n) {
> +		case 1: return regs->di;
> +		case 2: return regs->si;
> +		case 3: return regs->dx;
> +		case 4: return regs->cx;
> +		case 5: return regs->r8;
> +		case 6: return regs->r9;
> +		}
> +		return 0;
> +	}
> +}
> +#else
> +static unsigned long fetch_argument(struct pt_regs *regs, void *data)
> +{
> +	return fetch_stack(regs, data);
> +}
> +#endif

As mentioned in another email, if we can generalize something similar to
syscall_get_arguments, this can be made to work for many !x86 archs.
AFAICS the calling conventions mandated by the ABI are followed at
syscall time, isn't it?

Ananth
