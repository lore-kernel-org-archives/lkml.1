Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZIKOEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZIKOEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIKOEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:04:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZIKOE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:04:29 -0400
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
 profile events
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20090911135626.421489476@goodmis.org>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.421489476@goodmis.org>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 16:04:21 +0200
Message-Id: <1252677861.7126.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 09:54 -0400, Steven Rostedt wrote:

> +#ifdef MODULE
> +# define event_trace_up_ref()					\
> +	do {							\
> +		if (!try_module_get(THIS_MODULE)) {		\
> +			atomic_dec(&event_call->profile_count);	\
> +			return -ENOENT;				\
> +		}						\
> +	} while (0)
> +# define event_trace_down_ref() module_put(THIS_MODULE)
> +#else
> +# define event_trace_up_ref() do { } while (0)
> +# define event_trace_down_ref() do { } while (0)
> +#endif

That's like truely gruesomely ugly.

At the very least write it like:

int event_trace_up_ref(struct ftrace_event_call *call)
{
	if (!try_module_get(THIS_MODULE)) {
		atomic_dev(&call->profile_count);
		return -ENOENT;
	}
	return 0;
}

