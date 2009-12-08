Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZLHJs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZLHJs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZLHJsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:48:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:33422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZLHJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UHWZaQr0QZCSQ5wyMuGdcyrl0+x0ogEUmHMhbykesLbgHZi41+d0UMnLPm/QY0rgL6
         LT50UuLVXqQQWCtAEJN/DRlxdnvObD/SpNlCkxpcUU0kAX6y6RpNRugavVk/opK4aaOx
         TKCDWX/4jv3Yn07UG9gMUJl1qbp7x2rqJTBG8=
Date: Tue, 8 Dec 2009 10:48:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/13] ftrace: Call trace_parser_clear() properly
Message-ID: <20091208094825.GA5035@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC4D2.3000406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DC4D2.3000406@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:15:30AM +0800, Li Zefan wrote:
> I found a weird behavior:
> 
>   # echo 'fuse:*' > set_ftrace_filter
>   bash: echo: write error: Invalid argument
>   # cat set_ftrace_filter
>   fuse_dev_fasync
>   fuse_dev_poll
>   fuse_copy_do
> 
> We should call trace_parser_clear() no matter ftrace_process_regex()
> returns 0 or -errno.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 08a3fb5..ff8aecd 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2208,10 +2208,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  	    !trace_parser_cont(parser)) {
>  		ret = ftrace_process_regex(parser->buffer,
>  					   parser->idx, enable);
> +		trace_parser_clear(parser);
>  		if (ret)
>  			goto out_unlock;
> -
> -		trace_parser_clear(parser);
>  	}


I'm missing something. How that can happen. Anytime we reopen
the file, the parser is re-allocated.

I guess that happens if you open in rw mode? But not using the
example in the changelog?

