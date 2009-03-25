Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZCYF0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZCYF0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZCYF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:26:13 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:43584 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbZCYF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=yGgmHhXUZVXkBTbZCYIy1H3ANjMDoUtq9m6AOUL9StPQLBRpMzUQT3lbCm6bmitDdX
         geKQsMIcAk6DrNkp6Emz8G+3BKXK6QLoSHKI/KtFkWP4Av4Ej5e1ulBszBDa6U5vcyvu
         P4pJBuN1e9JAhMCXzMDH9MmAf9SqYvNDByQXc=
Subject: Re: [PATCH 4/4] tracing: add per-subsystem filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0903241228520.22830@gandalf.stny.rr.com>
References: <1237710677.7703.49.camel@charm-linux>
	 <alpine.DEB.2.00.0903231413270.3578@gandalf.stny.rr.com>
	 <1237879179.8339.67.camel@charm-linux>
	 <alpine.DEB.2.00.0903241228520.22830@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 00:26:07 -0500
Message-Id: <1237958767.31239.30.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 12:29 -0400, Steven Rostedt wrote:
> On Tue, 24 Mar 2009, Tom Zanussi wrote:
> > > > +
> > > > +static ssize_t
> > > > +subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > > +		       loff_t *ppos)
> > > > +{
> > > > +	struct event_subsystem *system = filp->private_data;
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
> > > > +		filter_free_subsystem_preds(system);
> > > 
> > > is "system" correct here?
> > 
> > Do you mean the naming i.e. would be better as "subsystem"?  Otherwise,
> > I think it's correct.
> 
> No, I'm just confused how the system could see the pred before it was 
> added below.

Again, in this case the pred is only used to flag clearing and never
gets added.

Tom

> 
> -- Steve
> 
> > 
> > > 
> > > > +		return cnt;
> > > > +	}
> > > > +
> > > > +	if (filter_add_subsystem_pred(system, pred)) {
> > > > +		filter_free_pred(pred);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	*ppos += cnt;
> > > > +
> > > > +	return cnt;
> > > > +}
> > > > +

