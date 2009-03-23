Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbZCWSQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbZCWSQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760854AbZCWSMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:12:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760837AbZCWSMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:12:17 -0400
Date: Mon, 23 Mar 2009 14:12:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 1/4] tracing: add run-time field descriptions for event
 filtering
In-Reply-To: <1237710639.7703.46.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903231409490.3578@gandalf.stny.rr.com>
References: <1237710639.7703.46.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Tom Zanussi wrote:
> @@ -19,6 +19,34 @@
>  
>  static DEFINE_MUTEX(event_mutex);
>  
> +int trace_define_field(struct ftrace_event_call *call, char *type,
> +		       char *name, int offset, int size)
> +{
> +	struct ftrace_event_field *field;
> +
> +	field = kmalloc(sizeof(*field), GFP_KERNEL);
> +	if (!field)
> +		goto err;
> +	field->name = kstrdup(name, GFP_KERNEL);
> +	if (!field->name)
> +		goto err;
> +	field->type = kstrdup(type, GFP_KERNEL);
> +	if (!field->type)
> +		goto err;
> +	field->offset = offset;
> +	field->size = size;
> +	list_add(&field->link, &call->fields);
> +
> +	return 0;
> +err:
> +	if (field) {
> +		kfree(field->name);
> +		kfree(field->type);

Field was not allocated with kzalloc, if we failed to allocate name, then 
type is unknown, and kfree(field->type) may corrupt the system.

What I would do is:

	field = kzalloc(...);
	if (!field)
		return -ENOMEM;

And then we could also get rid of the if (field) check in err.


> +	}
> +	kfree(field);
> +	return -ENOMEM;
> +}
> +

-- Steve
