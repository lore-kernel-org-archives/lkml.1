Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZGUBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZGUBLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZGUBLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:11:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZGUBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:11:36 -0400
Date: Mon, 20 Jul 2009 21:11:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jiri Olsa <jolsa@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when opened
 with r/w perm
In-Reply-To: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.0907202104130.17909@gandalf.stny.rr.com>
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Jul 2009, Jiri Olsa wrote:

> If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> with read&write permissions, the previous setup will be removed.

This is exactly what it was suppose to do.

man fopen:

       w+     Open for reading and writing.  The file is created  if  it  does
              not  exist, otherwise it is truncated.  The stream is positioned
              at the beginning of the file.

Which means that if you open a file for "w+" it will truncate it. Hence, 
you will remove all previous settings.

What you want is:

       a+     Open for reading and appending (writing at end  of  file).   The
              file is created if it does not exist.  The initial file position
              for reading is at the beginning  of  the  file,  but  output  is
              always appended to the end of the file.

Change the belowe code from "w+" to "a+" and you get your expected result.

Thus, the current code is correct.

-- Steve



> 
> Tested with following program:
> 
> [snip]
> #include <stdio.h>
> #include <string.h>
> 
> int main(int argc, char **argv)
> {
> 	FILE *f;
> 	char *mode = "w+";
> 	char *file = argv[1];
> 
> 	if (argc == 3)
> 		mode = argv[2];
> 
> 	if (NULL == (f = fopen(file, mode))) {
> 		perror("fopen failed");
> 		return -1;
> 	}
> 
> 	while(!feof(f)) {
> #define BUFLEN 100
> 		char buf[BUFLEN];
> 		memset(buf, 0, BUFLEN);
> 		fgets(buf, BUFLEN, f);
> 		printf(buf);
> 	}
> 
> 	fclose(f);
> 	return 0;
> }
> [snip]
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4521c77..11394bc 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1661,10 +1661,6 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
>  		return -ENOMEM;
>  
>  	mutex_lock(&ftrace_regex_lock);
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    !(file->f_flags & O_APPEND))
> -		ftrace_filter_reset(enable);
> -
>  	if (file->f_mode & FMODE_READ) {
>  		iter->pg = ftrace_pages_start;
>  		iter->flags = enable ? FTRACE_ITER_FILTER :
> @@ -2260,6 +2256,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  		return 0;
>  
>  	mutex_lock(&ftrace_regex_lock);
> +	if ((file->f_mode & FMODE_WRITE) &&
> +	    !(file->f_flags & O_APPEND))
> +		ftrace_filter_reset(enable);
>  
>  	if (file->f_mode & FMODE_READ) {
>  		struct seq_file *m = file->private_data;
> 
