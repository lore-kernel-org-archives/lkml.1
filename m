Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0BBN12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:27:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab0BBN1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:27:25 -0500
X-Authority-Analysis: v=1.0 c=1 a=FTcoRwaehXMA:10 a=omOdbC7AAAAA:8 a=20mNnk8DIKTiImBZipkA:9 a=qeK2edkK7lydGgcqYfQA:7 a=udKHa0rMlt9NZw6qDp3_dZ26dcYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: fix circular dead lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B67D4F9.9080905@cn.fujitsu.com>
References: <4B67D4F9.9080905@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 02 Feb 2010 08:25:35 -0500
Message-Id: <1265117135.4561.12092.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 15:32 +0800, Lai Jiangshan wrote:
> When we cat <debugfs>/tracing/stack_trace, we may cause circular lock:
> sys_read()
>   t_start()
>      arch_spin_lock(&max_stack_lock);
> 
>   t_show()
>      seq_printf(), vsnprintf() .... /* they are all trace-able,
>        when they are traced, max_stack_lock may be required again. */
> 
> 
> The following script can trigger this circular dead lock very easy:
> #!/bin/bash
> 
> echo 1 > /proc/sys/kernel/stack_tracer_enabled
> 
> mount -t debugfs xxx /mnt > /dev/null 2>&1

> (
> # make check_stack() zealous to require max_stack_lock
> for ((; ;))
> {
> 	echo 1 > /mnt/tracing/stack_max_size
> }
> ) &
> 
> for ((; ;))
> {
> 	cat /mnt/tracing/stack_trace > /dev/null
> }
> 
> 
> To fix this bug, we increase the percpu trace_active before
> require the lock.
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks Lai! I'll try to get this into 33.

-- Steve


