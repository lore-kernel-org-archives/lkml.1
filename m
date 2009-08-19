Return-Path: <linux-kernel-owner+w=401wt.eu-S1750862AbZHSBBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862AbZHSBBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZHSBBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:01:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZHSBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:01:09 -0400
Date: Tue, 18 Aug 2009 21:01:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jiri Olsa <jolsa@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: FTRACE_ITER_CONT handling fix
In-Reply-To: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.0908182059580.18648@gandalf.stny.rr.com>
References: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Aug 2009, Jiri Olsa wrote:

> Hi,
> 
> if one filter item (for set_ftrace_filter and set_ftrace_notrace) is being 
> setup by more than 1 consecutive writes (FTRACE_ITER_CONT flag), it won't
> be handled corretly.
> 
> I used following program to test/verify:
> 
> [snip]
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <string.h>
> 
> int main(int argc, char **argv)
> {
>         int fd, i;
>         char *file = argv[1];
> 
>         if (-1 == (fd = open(file, O_WRONLY))) {
>                 perror("open failed");
>                 return -1;
>         }
> 
>         for(i = 0; i < (argc - 2); i++) {
>                 int len = strlen(argv[2+i]);
>                 int cnt, off = 0;
> 
>                 while(len) {
>                         cnt = write(fd, argv[2+i] + off, len);
>                         len -= cnt;
>                         off += cnt;
>                 }
>         }
> 
>         close(fd);
>         return 0;
> }
> [snip]

BTW, you did not need to make such a test, just doing:

 # echo sys_open | dd of=set_ftrace_filter bs=2

works as well.


> 
> before change:
> sh-4.0# echo > ./set_ftrace_filter 
> sh-4.0# /test ./set_ftrace_filter "sys" "_open "
> sh-4.0# cat ./set_ftrace_filter 
> #### all functions enabled ####
> sh-4.0# 
> 
> after change:
> sh-4.0# echo > ./set_ftrace_notrace   
> sh-4.0# test ./set_ftrace_notrace "sys" "_open "
> sh-4.0# cat ./set_ftrace_notrace 
> sys_open
> sh-4.0# 
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Thanks, applied!

-- Steve

> 
> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 0948634..da0757a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2233,7 +2233,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  	read++;
>  	cnt--;
>  
> -	if (!(iter->flags & ~FTRACE_ITER_CONT)) {
> +	/*
> +	 * If the parser haven't finished with the last write,
> +	 * continue reading the user input without skipping spaces.
> +	 */
> +	if (!(iter->flags & FTRACE_ITER_CONT)) {
>  		/* skip white space */
>  		while (cnt && isspace(ch)) {
>  			ret = get_user(ch, ubuf++);
> @@ -2243,8 +2247,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  			cnt--;
>  		}
>  
> +		/* only spaces were written */
>  		if (isspace(ch)) {
> -			file->f_pos += read;
> +			*ppos += read;
>  			ret = read;
>  			goto out;
>  		}
> @@ -2273,12 +2278,12 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  		if (ret)
>  			goto out;
>  		iter->buffer_idx = 0;
> -	} else
> +	} else {
>  		iter->flags |= FTRACE_ITER_CONT;
> +		iter->buffer[iter->buffer_idx++] = ch;
> +	}
>  
> -
> -	file->f_pos += read;
> -
> +	*ppos += read;
>  	ret = read;
>   out:
>  	mutex_unlock(&ftrace_regex_lock);
> 
