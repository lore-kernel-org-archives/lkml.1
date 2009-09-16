Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZIPBBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZIPBBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZIPBBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:01:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZIPBBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:01:37 -0400
Message-ID: <4AB038A7.2070108@cn.fujitsu.com>
Date: Wed, 16 Sep 2009 09:00:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: jolsa@redhat.com
CC: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tracing - support multiple pids in set_pid_ftrace file
References: <1253019893-30131-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1253019893-30131-1-git-send-email-jolsa@redhat.com>
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

Looks good.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

a few nitpicks.

>  /* set when tracing only a pid */

This comment should be removed too.

> -struct pid *ftrace_pid_trace;
>  static struct pid * const ftrace_swapper_pid = &init_struct_pid;
>  
...
> +static int ftrace_pid_add(int p)
> +{
> +	struct pid *pid;
> +	struct ftrace_pid *fpid;
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&ftrace_lock);
> +
> +	if (!p)
> +		pid = ftrace_swapper_pid;
> +	else
> +		pid = find_get_pid(p);
> +
> +	if (!pid)
> +		goto out;
> +
> +	list_for_each_entry(fpid, &ftrace_pids, list)
> +		if (fpid->pid == pid)
> +			goto out_put;

rather than returning EINVAL, return EEXIST or just return 0?

> +
> +	ret = -ENOMEM;
