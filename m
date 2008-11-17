Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYKQCgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYKQCgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYKQCg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:36:27 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:53368 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYKQCg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:36:26 -0500
Message-ID: <f488382f0811161836n30ed40a7tcc9a32dac4b1c3ba@mail.gmail.com>
Date: Sun, 16 Nov 2008 18:36:25 -0800
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] tracing/ftrace: make nop tracer using tracer flags
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4920D494.1010108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4920D494.1010108@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 6:19 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Impact: give an example on how to use specific tracer flags
>
> This patch propose to use the nop tracer to provide an
> example for using the tracer's custom flags implementation.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_nop.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
> index 0e77415..1d8b4f8 100644
> --- a/kernel/trace/trace_nop.c
> +++ b/kernel/trace/trace_nop.c
> @@ -41,6 +41,52 @@ static void nop_trace_reset(struct trace_array *tr)
>        stop_nop_trace(tr);
>  }
>
> +#define TRACE_NOP_OPT_ACCEPT   0x1
> +#define TRACE_NOP_OPT_REFUSE   0x2
> +/* Options for the tracer (see trace_options file) */
> +static struct tracer_opt nop_opts[] = {
> +       /* Option that will be accepted by set_flag callback */
> +       { TRACER_OPT(test_nop_accept, TRACE_NOP_OPT_ACCEPT) },
> +       /* Option that will be refused by set_flag callback */
> +       { TRACER_OPT(test_nop_refuse, TRACE_NOP_OPT_REFUSE) },
> +       { } /* Always set the last empty entry */
> +};
> +
> +static struct tracer_flags nop_flags = {
> +       /* You can check your flags value here when you want. */
> +       .val = 0, /* By default: all flags disabled */
> +       .opts = nop_opts
> +};

I'd like these #defines and structs moved to just after the #includes,
for cleanliness.

> +
> +/* It only serves as a signal handler and a callback to
> + * accept or refuse tthe setting of a flag.
> + * If you don't implement it, then the flag setting will be
> + * automatically accepted.
> + */
> +static int nop_set_flag(u32 old_flags, u32 bit, int set)
> +{
> +       /*
> +        * Note that you don't need to update nop_flags.val yourself.
> +        * The tracing Api will do it automatically if you return 0
> +        */
> +       if (bit == TRACE_NOP_OPT_ACCEPT) {
> +               printk(KERN_DEBUG "nop_test_accept flag set to %d: we accept."
> +                       " Now cat trace_options to see the result\n",
> +                       set);
> +               return 0;
> +       }
> +
> +       if (bit == TRACE_NOP_OPT_REFUSE) {
> +               printk(KERN_DEBUG "nop_test_refuse flag set to %d: we refuse."
> +                       "Now cat trace_options to see the result\n",
> +                       set);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +
>  struct tracer nop_trace __read_mostly =
>  {
>        .name           = "nop",
> @@ -49,5 +95,7 @@ struct tracer nop_trace __read_mostly =
>  #ifdef CONFIG_FTRACE_SELFTEST
>        .selftest       = trace_selftest_startup_nop,
>  #endif
> +       .flags          = &nop_flags,
> +       .set_flag       = nop_set_flag
>  };
>
> --
> 1.5.2.5
>

Other than the change noted above, I think it looks good.

Acked-by: Steven Noonan <steven@uplinklabs.net>
