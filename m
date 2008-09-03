Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYICO1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYICO1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYICO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:27:46 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14936 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbYICO1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:27:46 -0400
From: Andrey Mirkin <major@openvz.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [PATCH 3/9] Introduce context structure needed =?iso-8859-1?q?during=09checkpointing/restart?=
Date: Wed, 3 Sep 2008 18:29:52 +0400
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1220439476-16465-4-git-send-email-major@openvz.org> <48BE9B74.7010600@fr.ibm.com>
In-Reply-To: <48BE9B74.7010600@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031829.53266.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 18:13 Cedric Le Goater wrote:
> > +void context_release(struct cpt_context *ctx)
> > +{
> > +	ctx->ctx_state = CPT_CTX_ERROR;
> > +
> > +	if (ctx->file)
> > +		fput(ctx->file);
> > +	kfree(ctx);
> > +}
> > +
> > +static void context_put(struct cpt_context *ctx)
> > +{
> > +	if (!--ctx->refcount)
> > +		context_release(ctx);
> > +}
> > +
> >  static int checkpoint(pid_t pid, int fd, unsigned long flags)
> >  {
> > -	return -ENOSYS;
> > +	struct file *file;
> > +	struct cpt_context *ctx;
> > +	int err;
> > +
> > +	err = -EBADF;
> > +	file = fget(fd);
> > +	if (!file)
> > +		goto out;
> > +
> > +	err = -ENOMEM;
> > +	ctx = context_alloc();
> > +	if (!ctx)
> > +		goto out_file;
> > +
> > +	ctx->file = file;
> > +	ctx->ctx_state = CPT_CTX_DUMPING;
> > +
> > +	/* checkpoint */
> > +	err = -ENOSYS;
> > +
> > +	context_put(ctx);
> > +
> > +out_file:
> > +	fput(file);
> > +out:
> > +	return err;
> >  }
>
> it looks like fput(file) is done twice in checkpoint() and
> context_release() ?

Oh, you are right. I'm sorry, I was in rush and sent an outdated version.
Will resend correct patch shortly.

Thanks,
Andrey
