Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYHAVUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYHAVUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761171AbYHAVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:11:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49902 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761148AbYHAVLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:11:30 -0400
Date: Fri, 1 Aug 2008 14:11:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] rcu: trace fix possible mem-leak
Message-ID: <20080801211128.GF14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080730182053.872043059@goodmis.org> <20080730182239.523848312@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730182239.523848312@goodmis.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 02:20:55PM -0400, Steven Rostedt wrote:
> In the initialization of the RCU trace module, if
> rcupreempt_debugfs_init() fails, we never free the the trace buffer.
> 
> This patch frees the trace buffer in case the debugfs fails.

Looks good as well!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/rcupreempt_trace.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-compile.git/kernel/rcupreempt_trace.c
> ===================================================================
> --- linux-compile.git.orig/kernel/rcupreempt_trace.c	2008-07-15 23:55:47.000000000 -0400
> +++ linux-compile.git/kernel/rcupreempt_trace.c	2008-07-30 13:58:41.000000000 -0400
> @@ -308,11 +308,16 @@ out:
> 
>  static int __init rcupreempt_trace_init(void)
>  {
> +	int ret;
> +
>  	mutex_init(&rcupreempt_trace_mutex);
>  	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
>  	if (!rcupreempt_trace_buf)
>  		return 1;
> -	return rcupreempt_debugfs_init();
> +	ret = rcupreempt_debugfs_init();
> +	if (ret)
> +		kfree(rcupreempt_trace_buf);
> +	return ret;
>  }
> 
>  static void __exit rcupreempt_trace_cleanup(void)
> 
> -- 
