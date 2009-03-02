Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbZCBVNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbZCBVNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZCBVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:13:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZCBVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:13:24 -0500
Date: Mon, 2 Mar 2009 13:11:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       fweisbec@gmail.com, tytso@mit.edu, compudj@krystal.dyndns.org,
       tzanussi@gmail.com, mhiramat@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       jbaron@redhat.com, fche@redhat.com, acme@redhat.com,
       srostedt@redhat.com
Subject: Re: [PATCH 4/7] tracing: add format file to describe event struct
 fields
Message-Id: <20090302131109.24ab4c1d.akpm@linux-foundation.org>
In-Reply-To: <20090302203024.566861575@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
	<20090302203024.566861575@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Mar 2009 15:29:29 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds the "format" file to the trace point event directory.
> This is based off of work by Tom Zanussi, in which a file is exported
> to be tread from user land such that a user space app may read the

s/tread/read/

> binary record stored in the ring buffer.
>
> ...
>
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -3,6 +3,9 @@
>   *
>   * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
>   *
> + *  - Added format output of fields of the trace point.
> + *    This was based off of work by Tom Zanussi <tzanussi@gmail.com>.

ick.  "based on"

> + *
>   */
>  
>  #include <linux/debugfs.h>
> @@ -444,6 +447,42 @@ event_available_types_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
>  }
>  
> +static ssize_t
> +event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
> +		  loff_t *ppos)
> +{
> +	struct ftrace_event_call *call = filp->private_data;
> +	struct trace_seq *s;
> +	char *buf;
> +	int r;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	trace_seq_init(s);
> +
> +	if (*ppos)
> +		return 0;

Someone get this man a bucket!

> +	r = call->show_format(s);
> +	if (!r) {
> +		/*
> +		 * ug!  The format output is bigger than a PAGE!!
> +		 */
> +		buf = "FORMAT TOO BIG\n";
> +		r = simple_read_from_buffer(ubuf, cnt, ppos,
> +					      buf, strlen(buf));
> +		goto out;
> +	}
> +
> +	r = simple_read_from_buffer(ubuf, cnt, ppos,
> +				    s->buffer, s->len);
> + out:
> +	kfree(s);
> +	return r;
> +}

