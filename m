Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbZGQJjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbZGQJjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934303AbZGQJjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:39:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54747 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934293AbZGQJjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:39:02 -0400
Message-ID: <4A604654.1090303@cn.fujitsu.com>
Date: Fri, 17 Jul 2009 17:37:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when opened
 with r/w perm
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com>
In-Reply-To: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> with read&write permissions, the previous setup will be removed.
> 

Currently:

 # echo 'sys_open sys_close' > set_ftrace_filter
 # cat set_ftrace_filter
 sys_open
 sys_close

After your patch:

 # echo 'sys_open sys_close' > set_ftrace_filter
 # cat set_ftrace_filter
 sys_close

> Tested with following program:
...
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
> --

