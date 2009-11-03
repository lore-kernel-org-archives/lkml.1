Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZKCPfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZKCPfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZKCPfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:35:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZKCPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:35:38 -0500
Subject: Re: [PATCH] ringbuffer: synchronize for resizing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF01735.9060409@cn.fujitsu.com>
References: <4AF01735.9060409@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 10:35:40 -0500
Message-Id: <1257262540.26028.3336.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-11-03 at 19:42 +0800, Lai Jiangshan wrote:
> We got a sudden panic when we reduced the size of the
> ringbuffer.
> 
> We can reproduce the panic by the following steps:
> 
> echo 1 > events/sched/enable
> cat trace_pipe > /dev/null &
> 
> while ((1))
> do
> echo 12000 > buffer_size_kb
> echo 512 > buffer_size_kb
> done
> 
> (not more than 5 seconds, panic ...)

Thanks! I'll push this out for inclusion right away.

-- Steve

> 
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 63446f1..db223fe 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1196,6 +1196,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
>  	atomic_inc(&cpu_buffer->record_disabled);
>  	synchronize_sched();
>  
> +	spin_lock_irq(&cpu_buffer->reader_lock);
>  	rb_head_page_deactivate(cpu_buffer);
>  
>  	for (i = 0; i < nr_pages; i++) {
> @@ -1210,6 +1211,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
>  		return;
>  
>  	rb_reset_cpu(cpu_buffer);
> +	spin_unlock_irq(&cpu_buffer->reader_lock);
>  
>  	rb_check_pages(cpu_buffer);
>  
> 
> 
> 

