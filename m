Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZCYFYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZCYFYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZCYFYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:24:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:13753 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZCYFYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=goE0jLSyg7gOjf/FPmvpBpvGA0TBh8ezLaRC5+YM6FTAkT3dHTjsbh18EGuwDBlt7f
         LAlPKRyhit8wYHWpoj/EDLZtFVsImI9Nr5wyBA0HGyT9zd3CQlyTzXZek2IilEgtUU/F
         6TKPQgtnxYiF4Gh/wvek+BhryuSCwJKRdHcwU=
Subject: Re: [PATCH 3/4] tracing: add per-event filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0903241200200.22830@gandalf.stny.rr.com>
References: <1237710665.7703.48.camel@charm-linux>
	 <alpine.DEB.2.00.0903231358320.3578@gandalf.stny.rr.com>
	 <1237879085.8339.64.camel@charm-linux>
	 <alpine.DEB.2.00.0903241200200.22830@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 00:23:57 -0500
Message-Id: <1237958637.31239.28.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 12:01 -0400, Steven Rostedt wrote:
> On Tue, 24 Mar 2009, Tom Zanussi wrote:
> 
> > Hi,
> > 
> > On Mon, 2009-03-23 at 14:06 -0400, Steven Rostedt wrote:
> > > On Sun, 22 Mar 2009, Tom Zanussi wrote:
> > > >  
> > > > +static ssize_t
> > > > +event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
> > > > +		  loff_t *ppos)
> > > > +{
> > > > +	struct ftrace_event_call *call = filp->private_data;
> > > > +	struct trace_seq *s;
> > > > +	int r;
> > > > +
> > > > +	if (*ppos)
> > > > +		return 0;
> > > > +
> > > > +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> > > > +	if (!s)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	trace_seq_init(s);
> > > > +
> > > > +	r = filter_print_preds(call->preds, s->buffer);
> > > 
> > > You're not using any of the features of the trace_seq structure.
> > > Might as well just allocate your own buffer.
> > > 
> > 
> > Yeah, it make more sense to use the trace_seq features than do it
> > myself.  I just posted a patch to do that.
> > 
> > > > +	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
> > > > +
> > > > +	kfree(s);
> > > > +
> > > > +	return r;
> > > > +}
> > > > +
> > > > +static ssize_t
> > > > +event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > > +		   loff_t *ppos)
> > > > +{
> > > > +	struct ftrace_event_call *call = filp->private_data;
> > > > +	char buf[64], *pbuf = buf;
> > > > +	struct filter_pred *pred;
> > > > +	int err;
> > > > +
> > > > +	if (cnt >= sizeof(buf))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (copy_from_user(&buf, ubuf, cnt))
> > > > +		return -EFAULT;
> > > > +
> > > > +	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
> > > > +	if (!pred)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	err = filter_parse(&pbuf, pred);
> > > > +	if (err < 0) {
> > > > +		filter_free_pred(pred);
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +	if (pred->clear) {
> > > > +		filter_free_preds(call);
> > > 
> > > The above is very confusing. Why are we passing in "call"?
> > 
> > The preds are attached to the call, so it makes sense to me to pass in
> > the call.  I could just pass in the preds directly, if that makes it
> > less confusing...
> > 
> > > 
> > > > +		return cnt;
> > > > +	}
> > > > +
> > > > +	if (filter_add_pred(call, pred)) {
> 
> I'm confused because it looks like it is hooked here and not above where 
> we exit.
> 

It's probably confusing because pred is used not only to define the
predicate by filter_parse() (which should probably be called
pred_parse()) but also to flag the case where '0' is written to clear
the whole filter.  If the clear flag isn't set, pred gets added to the
filter as expected, but if it is, all the other predicates currently
defined for the filter are removed and pred is discarded as well.

Hope that makes it a little less confusing - in any case this will all
be going away soon when I upgrade the parser to handle complete
expressions.

Tom

> -- Steve
> 
> > > > +		filter_free_pred(pred);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	*ppos += cnt;
> > > > +
> > > > +	return cnt;
> > > > +}
> > > > +

