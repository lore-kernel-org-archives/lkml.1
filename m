Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZAGRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZAGRVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZAGRVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:21:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbZAGRVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:21:31 -0500
Date: Wed, 7 Jan 2009 18:19:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090107171922.GA18000@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107123457.GB16268@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Ingo Molnar wrote:
>
> (Cc:-ed a few more folks who might be interested in this)
>
> * Casey Dahlin <cdahlin@redhat.com> wrote:
>
> > +asmlinkage long sys_waitfd(int which, pid_t upid, int options, int unused)
> > +{
> > +	int ufd;
> > +	struct waitfd_ctx *ctx;
> > +
> > +	/* Just to make sure we don't end up with a sys_waitfd4 */
> > +	(void)unused;
>
> looks a bit silly ...
>
> > +
> > +	if (options & ~(WNOHANG|WEXITED|WSTOPPED|WCONTINUED))
> > +		return -EINVAL;
> > +	if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
> > +		return -EINVAL;
> > +
> > +	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx)
> > +		return -ENOMEM;
> > +
> > +	ctx->ops = options;
> > +	ctx->upid = upid;
> > +	ctx->which = which;
> > +
> > +	ufd = anon_inode_getfd("[waitfd]", &waitfd_fops, ctx,
> > +			       (options & WNOHANG) ? O_NONBLOCK : 0);

minor nit...

Please note that unlike other sys_...fd() syscalls, sys_waitfd()
doesn't allow to pass O_CLOEXEC. Looks like we need a separate
"flags" argument...

Also, ioctl(FIONBIO) or fcntl(O_NONBLOCK) have no effect on
waitfd, not very good.

I'd suggest to remove WNOHANG from waitfd_ctx->ops and treat
(->f_flags & O_NONBLOCK) as WNOHANG.

(can't resist, ->ops is not the best name ;)

Oleg.

