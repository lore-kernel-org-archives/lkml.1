Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbZCXQBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbZCXQBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZCXQBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:01:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZCXQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:01:12 -0400
Date: Tue, 24 Mar 2009 12:01:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 3/4] tracing: add per-event filtering
In-Reply-To: <1237879085.8339.64.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903241200200.22830@gandalf.stny.rr.com>
References: <1237710665.7703.48.camel@charm-linux>  <alpine.DEB.2.00.0903231358320.3578@gandalf.stny.rr.com> <1237879085.8339.64.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Tom Zanussi wrote:

> Hi,
> 
> On Mon, 2009-03-23 at 14:06 -0400, Steven Rostedt wrote:
> > On Sun, 22 Mar 2009, Tom Zanussi wrote:
> > >  
> > > +static ssize_t
> > > +event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
> > > +		  loff_t *ppos)
> > > +{
> > > +	struct ftrace_event_call *call = filp->private_data;
> > > +	struct trace_seq *s;
> > > +	int r;
> > > +
> > > +	if (*ppos)
> > > +		return 0;
> > > +
> > > +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> > > +	if (!s)
> > > +		return -ENOMEM;
> > > +
> > > +	trace_seq_init(s);
> > > +
> > > +	r = filter_print_preds(call->preds, s->buffer);
> > 
> > You're not using any of the features of the trace_seq structure.
> > Might as well just allocate your own buffer.
> > 
> 
> Yeah, it make more sense to use the trace_seq features than do it
> myself.  I just posted a patch to do that.
> 
> > > +	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
> > > +
> > > +	kfree(s);
> > > +
> > > +	return r;
> > > +}
> > > +
> > > +static ssize_t
> > > +event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > +		   loff_t *ppos)
> > > +{
> > > +	struct ftrace_event_call *call = filp->private_data;
> > > +	char buf[64], *pbuf = buf;
> > > +	struct filter_pred *pred;
> > > +	int err;
> > > +
> > > +	if (cnt >= sizeof(buf))
> > > +		return -EINVAL;
> > > +
> > > +	if (copy_from_user(&buf, ubuf, cnt))
> > > +		return -EFAULT;
> > > +
> > > +	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
> > > +	if (!pred)
> > > +		return -ENOMEM;
> > > +
> > > +	err = filter_parse(&pbuf, pred);
> > > +	if (err < 0) {
> > > +		filter_free_pred(pred);
> > > +		return err;
> > > +	}
> > > +
> > > +	if (pred->clear) {
> > > +		filter_free_preds(call);
> > 
> > The above is very confusing. Why are we passing in "call"?
> 
> The preds are attached to the call, so it makes sense to me to pass in
> the call.  I could just pass in the preds directly, if that makes it
> less confusing...
> 
> > 
> > > +		return cnt;
> > > +	}
> > > +
> > > +	if (filter_add_pred(call, pred)) {

I'm confused because it looks like it is hooked here and not above where 
we exit.

-- Steve

> > > +		filter_free_pred(pred);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	*ppos += cnt;
> > > +
> > > +	return cnt;
> > > +}
> > > +
