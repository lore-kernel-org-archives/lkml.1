Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZCWSwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZCWSwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbZCWSvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:51:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZCWSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:51:51 -0400
Date: Mon, 23 Mar 2009 14:51:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] tracing: add run-time field descriptions for event
 filtering
In-Reply-To: <20090322173908.GB6002@nowhere>
Message-ID: <alpine.DEB.2.00.0903231451040.3578@gandalf.stny.rr.com>
References: <1237710639.7703.46.camel@charm-linux> <20090322173908.GB6002@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Frederic Weisbecker wrote:
> >  static DEFINE_MUTEX(event_mutex);
> >  
> > +int trace_define_field(struct ftrace_event_call *call, char *type,
> > +		       char *name, int offset, int size)
> > +{
> > +	struct ftrace_event_field *field;
> > +
> > +	field = kmalloc(sizeof(*field), GFP_KERNEL);
> > +	if (!field)
> > +		goto err;
> > +	field->name = kstrdup(name, GFP_KERNEL);
> > +	if (!field->name)
> > +		goto err;
> > +	field->type = kstrdup(type, GFP_KERNEL);
> > +	if (!field->type)
> > +		goto err;
> > +	field->offset = offset;
> > +	field->size = size;
> > +	list_add(&field->link, &call->fields);
> > +
> > +	return 0;
> > +err:
> > +	if (field) {
> > +		kfree(field->name);
> > +		kfree(field->type);
> 
> 
> You need kzalloc to allocate field.
> With kmalloc, field will point to random filled memory
> after a fresh allocation.
> 
> Imagine this path:
> 
> if (!field->name)
> 	goto err;
> ...
> err:
> 	kfree(field->name) <- field->name = NULL, correct
> 	kfree(field->type) <- field->type = ?
> 

Looks like Frederic got to you first ;-)

-- Steve

> 
> > +	}
> > +	kfree(field);
> > +	return -ENOMEM;
> > +}
> > +
