Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZJGRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZJGRQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZJGRQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:16:52 -0400
Received: from [71.74.56.122] ([71.74.56.122]:37947 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbZJGRQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:16:51 -0400
Subject: Re: [PATCH 2/2] tracing - correct module boundaries for
 ftrace_release
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1254934835-363-3-git-send-email-jolsa@redhat.com>
References: <1254934835-363-1-git-send-email-jolsa@redhat.com>
	 <1254934835-363-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 13:14:03 -0400
Message-Id: <1254935643.1696.172.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 19:00 +0200, jolsa@redhat.com wrote:
> When the module is about the unload we release its call records.
> The ftrace_release function was given wrong values representing
> the module core boundaries, thus not releasing its call records.
> 
> Plus making ftrace_release function module specific.
> 

I'll take this version. Thanks! I'll get this ready for mainline urgent,
as well as push it off to stable.

-- Steve

> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/ftrace.h |    2 +-
>  kernel/trace/ftrace.c  |   12 ++++--------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index cd3d2ab..0b4f97d 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -241,7 +241,7 @@ extern void ftrace_enable_daemon(void);
>  # define ftrace_set_filter(buf, len, reset)	do { } while (0)
>  # define ftrace_disable_daemon()		do { } while (0)
>  # define ftrace_enable_daemon()			do { } while (0)
> -static inline void ftrace_release(void *start, unsigned long size) { }
> +static inline void ftrace_release_mod(struct module *mod) {}
>  static inline int register_ftrace_command(struct ftrace_func_command *cmd)
>  {
>  	return -EINVAL;
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 9a72853..559e552 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2608,19 +2608,17 @@ static int ftrace_convert_nops(struct module *mod,
>  }
>  
>  #ifdef CONFIG_MODULES
> -void ftrace_release(void *start, void *end)
> +void ftrace_release_mod(struct module *mod)
>  {
>  	struct dyn_ftrace *rec;
>  	struct ftrace_page *pg;
> -	unsigned long s = (unsigned long)start;
> -	unsigned long e = (unsigned long)end;
>  
> -	if (ftrace_disabled || !start || start == end)
> +	if (ftrace_disabled)
>  		return;
>  
>  	mutex_lock(&ftrace_lock);
>  	do_for_each_ftrace_rec(pg, rec) {
> -		if ((rec->ip >= s) && (rec->ip < e)) {
> +		if (within_module_core(rec->ip, mod)) {
>  			/*
>  			 * rec->ip is changed in ftrace_free_rec()
>  			 * It should not between s and e if record was freed.
> @@ -2652,9 +2650,7 @@ static int ftrace_module_notify(struct notifier_block *self,
>  				   mod->num_ftrace_callsites);
>  		break;
>  	case MODULE_STATE_GOING:
> -		ftrace_release(mod->ftrace_callsites,
> -			       mod->ftrace_callsites +
> -			       mod->num_ftrace_callsites);
> +		ftrace_release_mod(mod);
>  		break;
>  	}
>  

