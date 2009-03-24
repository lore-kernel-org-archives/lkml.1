Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZCXQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZCXQaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763368AbZCXQ3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:29:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763361AbZCXQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:29:41 -0400
Date: Tue, 24 Mar 2009 12:29:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] tracing: add per-subsystem filtering
In-Reply-To: <1237879179.8339.67.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903241228520.22830@gandalf.stny.rr.com>
References: <1237710677.7703.49.camel@charm-linux>  <alpine.DEB.2.00.0903231413270.3578@gandalf.stny.rr.com> <1237879179.8339.67.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Tom Zanussi wrote:
> > > +
> > > +static ssize_t
> > > +subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > +		       loff_t *ppos)
> > > +{
> > > +	struct event_subsystem *system = filp->private_data;
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
> > > +		filter_free_subsystem_preds(system);
> > 
> > is "system" correct here?
> 
> Do you mean the naming i.e. would be better as "subsystem"?  Otherwise,
> I think it's correct.

No, I'm just confused how the system could see the pred before it was 
added below.

-- Steve

> 
> > 
> > > +		return cnt;
> > > +	}
> > > +
> > > +	if (filter_add_subsystem_pred(system, pred)) {
> > > +		filter_free_pred(pred);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	*ppos += cnt;
> > > +
> > > +	return cnt;
> > > +}
> > > +
