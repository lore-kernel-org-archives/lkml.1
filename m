Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZFWHAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZFWHAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWHAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:00:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:50452 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZFWHAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:00:35 -0400
Message-ID: <4A407AB0.3000703@windriver.com>
Date: Tue, 23 Jun 2009 14:48:16 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] tracing: reset iterator in t_start()
References: <4A3B3372.4040608@cn.fujitsu.com> <4A3B34A9.30602@cn.fujitsu.com>
In-Reply-To: <4A3B34A9.30602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2009 07:00:21.0343 (UTC) FILETIME=[463586F0:01C9F3D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> The iterator is m->private, but it's not reset to trace_types in
> t_start(). If the output is larger than PAGE_SIZE and t_start()
> is called the 2nd time, things will go wrong.
> 
> [ Impact: fix output of current_tracer when it's larger than PAGE_SIZE ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.c |   18 ++++--------------
>  1 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 076fa6f..3bb3100 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2053,25 +2053,23 @@ static int tracing_open(struct inode *inode, struct file *file)
>  static void *
>  t_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct tracer *t = m->private;
> +	struct tracer *t = v;
>  
>  	(*pos)++;
>  
>  	if (t)
>  		t = t->next;
>  
> -	m->private = t;
> -
>  	return t;
>  }
>  
>  static void *t_start(struct seq_file *m, loff_t *pos)
>  {
> -	struct tracer *t = m->private;
> +	struct tracer *t;
>  	loff_t l = 0;
>  
>  	mutex_lock(&trace_types_lock);
> -	for (; t && l < *pos; t = t_next(m, t, &l))
> +	for (t = trace_types; t && l < *pos; t = t_next(m, t, &l))
>  		;
>  
>  	return t;
> @@ -2107,18 +2105,10 @@ static struct seq_operations show_traces_seq_ops = {
>  
>  static int show_traces_open(struct inode *inode, struct file *file)
>  {
> -	int ret;
> -
>  	if (tracing_disabled)
>  		return -ENODEV;
>  
> -	ret = seq_open(file, &show_traces_seq_ops);
> -	if (!ret) {
> -		struct seq_file *m = file->private_data;
> -		m->private = trace_types;
> -	}
> -
> -	return ret;
> +	return seq_open(file, &show_traces_seq_ops);
>  }
>  
>  static ssize_t
Another version:
Since we have saved current (struct tracer *) in m->private in .next, in .start, 
we don't need to call .next to find the one that should be printed in 2nd or nth 
time.

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cae34c6..02cdccc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2055,8 +2055,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
  {
         struct tracer *t = m->private;

-       (*pos)++;
-
         if (t)
                 t = t->next;

@@ -2068,11 +2066,8 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
  static void *t_start(struct seq_file *m, loff_t *pos)
  {
         struct tracer *t = m->private;
-       loff_t l = 0;

         mutex_lock(&trace_types_lock);
-       for (; t && l < *pos; t = t_next(m, t, &l))
-               ;

         return t;
  }
