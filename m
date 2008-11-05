Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYKEUff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYKEUff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYKEUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:35:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:54075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbYKEUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:35:26 -0500
Date: Wed, 5 Nov 2008 12:36:04 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081105123604.633105ca@infradead.org>
In-Reply-To: <20081105194326.GA5839@joi>
References: <20081105094902.27ec4b39@infradead.org>
	<20081105194326.GA5839@joi>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 20:43:31 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Wed, Nov 05, 2008 at 09:49:02AM -0800, Arjan van de Ven wrote:
> > --- /dev/null
> > +++ b/kernel/trace/trace_fsync.c
> > @@ -0,0 +1,165 @@
> > +/*
> > + * trace fsync calls
> > + * Copyright (C) 2008 Intel Corporation
> > + *
> > + * Based extensively on trace_sched_switch.c
> > + * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
> > + *
> > + */
> > +#include <linux/module.h>
> > +#include <linux/fs.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/kallsyms.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/ftrace.h>
> > +#include <trace/fs.h>
> > +
> > +#include "trace.h"
> > +
> > +static struct trace_array	*ctx_trace;
> > +static int __read_mostly	tracer_enabled;
> > +static atomic_t			fsync_ref;
> > +
> > +static void
> > +probe_do_fsync(struct file *file, int datasync)
> > +{
> > +	char *buffer;
> > +	char *err;
> > +
> > +	if (!atomic_read(&fsync_ref))
> > +		return;
> > +
> > +	if (!tracer_enabled)
> > +		return;
> > +
> > +	buffer = kmalloc(4096, GFP_KERNEL);
> > +	if (!buffer)
> > +		return;
> > +
> > +	memset(buffer, 0, 4096);
> 
> kzalloc?

could do I suppose

> 
> > +	err = d_path(&file->f_path, buffer, 4096);
> > +
> > +	if (IS_ERR(err))
> > +		goto out;
> > +
> > +	ftrace_printk("Process %s is calling fsync on %s\n",
> > +			current->comm, err);
> 
> err? not buffer?

correct, not buffer

it won't work if you use buffer.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
