Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYKETqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYKETqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYKETqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:46:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:51399 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYKETq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:46:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lA47cYnzJOAYAphzC/GcM7Ug/xsqa4GEEhP5yVVK+igOnM8vEu5hVsYTivqwva9sJE
         Yzfuzn/BwPSJ1UkdW+TgJYqK6WZDnEz5A/tJmo2YMwrDWq5cLAJaXohIQXZjXgygg84q
         VpS9DzkQPVWiKijY436ohPbtdrlWA9Amd1VC8=
Date: Wed, 5 Nov 2008 20:43:31 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081105194326.GA5839@joi>
References: <20081105094902.27ec4b39@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105094902.27ec4b39@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 09:49:02AM -0800, Arjan van de Ven wrote:
> --- /dev/null
> +++ b/kernel/trace/trace_fsync.c
> @@ -0,0 +1,165 @@
> +/*
> + * trace fsync calls
> + * Copyright (C) 2008 Intel Corporation
> + *
> + * Based extensively on trace_sched_switch.c
> + * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/debugfs.h>
> +#include <linux/kallsyms.h>
> +#include <linux/uaccess.h>
> +#include <linux/ftrace.h>
> +#include <trace/fs.h>
> +
> +#include "trace.h"
> +
> +static struct trace_array	*ctx_trace;
> +static int __read_mostly	tracer_enabled;
> +static atomic_t			fsync_ref;
> +
> +static void
> +probe_do_fsync(struct file *file, int datasync)
> +{
> +	char *buffer;
> +	char *err;
> +
> +	if (!atomic_read(&fsync_ref))
> +		return;
> +
> +	if (!tracer_enabled)
> +		return;
> +
> +	buffer = kmalloc(4096, GFP_KERNEL);
> +	if (!buffer)
> +		return;
> +
> +	memset(buffer, 0, 4096);

kzalloc?

> +	err = d_path(&file->f_path, buffer, 4096);
> +
> +	if (IS_ERR(err))
> +		goto out;
> +
> +	ftrace_printk("Process %s is calling fsync on %s\n",
> +			current->comm, err);

err? not buffer?

> +
> +out:
> +	kfree(buffer);
> +}
> +
> (...)
