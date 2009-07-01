Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZGAOBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZGAOBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZGAOBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:01:13 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46618 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbZGAOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z7+bt1v4iut7uoQSWGEW4y5fEW8TKAKGMPe25P8MD4qeMwYQRKlUw0BwfWuydWtKYt
         6aa3cChCkZBony3BmiKgTI3F1X3OY/6zQuBKuRUnEjT2Qc4jv2BydXmpj0oty0IMB5bp
         spr3XzyloqENFVm16YN+K5HMa2hh9p0t68ltk=
Date: Wed, 1 Jul 2009 16:01:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix trace_print_seq()
Message-ID: <20090701140111.GB5097@nowhere>
References: <4A4B2351.5010300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B2351.5010300@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 04:50:25PM +0800, Xiao Guangrong wrote:
> We will lose something if trace_seq->buffer[0] is 0, because the copy length
> is calculated by strlen() in seq_puts(), so using seq_write() instead of 
> seq_puts().
> 
> There have a example:
> after reboot:
> # echo kmemtrace > current_tracer
> # echo 0 > options/kmem_minimalistic
> # cat trace
> # tracer: kmemtrace
> #
> #
> Nothing is exported, because the first byte of trace_seq->buffer[ ]
> is KMEMTRACE_USER_ALLOC.
> ( the value of KMEMTRACE_USER_ALLOC is zero, seeing
>   kmemtrace_print_alloc_user() in kernel/trace/kmemtrace.c)
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/trace/trace_output.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 7938f3a..e0c2545 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -27,8 +27,7 @@ void trace_print_seq(struct seq_file *m, struct trace_seq *s)
>  {
>  	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
>  
> -	s->buffer[len] = 0;
> -	seq_puts(m, s->buffer);
> +	seq_write(m, s->buffer, len);
>  
>  	trace_seq_init(s);
>  }
> -- 
> 1.6.1.2
> 

Looks good, thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

But having a '\0' in a non binary trace looks weird. Why do
we have such plain KMEMTRACE_USER_ALLOC whereas binary tracing
is not set, as your example shows it?

