Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbZIOJl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbZIOJl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZIOJlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:41:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZIOJlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:41:20 -0400
Message-ID: <4AAF60F7.6040107@cn.fujitsu.com>
Date: Tue, 15 Sep 2009 17:40:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: jolsa@redhat.com
CC: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - support multiple pids in set_pid_ftrace file
References: <1253005169-32709-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1253005169-32709-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jolsa@redhat.com wrote:
> Adding the possibility to set more than 1 pid in the set_pid_ftrace file,
> thus allowing to trace more than 1 independent processes.
> 
> Usage:
> 
> sh-4.0# echo 284 > ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> 284
> sh-4.0# echo 1 >> ./set_ftrace_pid 
> sh-4.0# echo 0 >> ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> swapper tasks
> 1
> 284
> sh-4.0# echo 4 > ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> 4
> sh-4.0# echo > ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> no pid
> sh-4.0# 
> 
> 
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/ftrace.c |  226 +++++++++++++++++++++++++++++++++++--------------
>  kernel/trace/trace.h  |    4 +-
>  2 files changed, 164 insertions(+), 66 deletions(-)
>  
...
> +static void ftrace_pid_reset(void)
> +{
> +	struct ftrace_pid *fpid, *safe;
> +
> +	mutex_lock(&ftrace_lock);
> +	list_for_each_entry_safe(fpid, safe, &ftrace_pids, list) {
> +		struct pid *pid = fpid->pid;
> +
> +		clear_ftrace_pid_task(&pid);

Now we can change clear_ftrace_pid_task() to take struct pid *
instead of struct pid**.

> +
> +		if (pid != ftrace_swapper_pid)
> +			put_pid(pid);
> +

clear_ftrace_pid_task() already called put_pid().

> +		list_del(&fpid->list);
> +		kfree(fpid);
> +	}
> +
> +	ftrace_update_pid_func();
> +	ftrace_startup_enable(0);
> +
> +	mutex_unlock(&ftrace_lock);
> +}
> +
...
>  static ssize_t
>  ftrace_pid_write(struct file *filp, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
> -	struct pid *pid;
>  	char buf[64];
>  	long val;
>  	int ret;
> @@ -2897,57 +3016,36 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
>  
>  	buf[cnt] = 0;
>  
> +	/*
> +	 * Allow the "echo > set_ftrace_pid" to clean
> +	 * the pids quietly.
> +	 */
> +	if (!*ppos && *buf == '\n' && cnt == 1)
> +		return 1;
> +

How about:
	strstrip(buf);
	if (strlen(buf) == 0)
		return 1;

So "echo -n '' > set_ftrace_pid" works too.

>  	ret = strict_strtol(buf, 10, &val);
>  	if (ret < 0)
>  		return ret;
>  

