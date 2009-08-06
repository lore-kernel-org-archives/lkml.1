Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZHFFGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZHFFGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZHFFGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:06:22 -0400
Received: from [222.73.24.84] ([222.73.24.84]:57720 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbZHFFGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:06:21 -0400
Message-ID: <4A7A6470.60305@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 13:04:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ftrace: Unify effect of writing to trace_options
 and option/*
References: <4A7A4D7B.7010706@cn.fujitsu.com> <4A7A4DBC.6020403@cn.fujitsu.com>
In-Reply-To: <4A7A4DBC.6020403@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei wrote:
> "echo noglobal-clock > trace_options" can be used to change trace
> clock but "echo 0 > options/global-clock" can't.
> 
> We can fix it by using set_tracer_flags() in trace_options_core_write().
> 

Nice catch.

> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 464b7bb..2fa2bac 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3893,12 +3893,11 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  
>  	switch (val) {
>  	case 0:
> -		trace_flags &= ~(1 << index);
> +		set_tracer_flags(1 << index, 0);
>  		break;
>  	case 1:
> -		trace_flags |= 1 << index;
> +		set_tracer_flags(1 << index, 1);
>  		break;
> -
>  	default:
>  		return -EINVAL;
>  	}

The whole switch statement can be simplied:

	if (val != 0 || val != 1)
		return -EINVAL;
	set_tracer_flags(1 << index, val);


