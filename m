Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZIIBel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZIIBel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZIIBek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:34:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZIIBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:34:39 -0400
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on
 oops
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA70198.9070500@cn.fujitsu.com>
References: <4AA70198.9070500@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 21:34:39 -0400
Message-Id: <1252460079.11070.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> Currently we always disable tracing on oops, and this patch
> adds a sysctl so one can choose to enable it.

Hmm, we already have a way to enable it.

# echo 1 > /debug/tracing/tracing_on

-- Steve

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/kernel.h     |    2 ++
>  kernel/panic.c             |    3 ++-
>  kernel/sysctl.c            |   10 ++++++++++
>  kernel/trace/ring_buffer.c |    2 ++
>  4 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index f61039e..5c4528f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -516,12 +516,14 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>   * Most likely, you want to use tracing_on/tracing_off.
>   */
>  #ifdef CONFIG_RING_BUFFER
> +extern int trace_on_oops;
>  void tracing_on(void);
>  void tracing_off(void);
>  /* trace_off_permanent stops recording with no way to bring it back */
>  void tracing_off_permanent(void);
>  int tracing_is_on(void);
>  #else
> +#define trace_on_oops 0
>  static inline void tracing_on(void) { }
>  static inline void tracing_off(void) { }
>  static inline void tracing_off_permanent(void) { }
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 512ab73..22ec502 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -301,7 +301,8 @@ int oops_may_print(void)
>   */
>  void oops_enter(void)
>  {
> -	tracing_off();
> +	if (!trace_on_oops)
> +		tracing_off();
>  	/* can't trust the integrity of the kernel anymore: */
>  	debug_locks_off();
>  	do_oops_enter_exit();
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index cdbe8d0..a768c15 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -537,6 +537,16 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= &stack_trace_sysctl,
>  	},
>  #endif
> +#ifdef CONFIG_RING_BUFFER
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "trace_on_oops",
> +		.data		= &trace_on_oops,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +#endif
>  #ifdef CONFIG_TRACING
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 454e74e..fc10962 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -155,6 +155,8 @@ static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
>  
>  #define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
>  
> +int trace_on_oops;
> +
>  /**
>   * tracing_on - enable all tracing buffers
>   *

