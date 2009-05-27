Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbZE0Sl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbZE0Sl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbZE0SlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:41:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539AbZE0SlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:41:12 -0400
Date: Wed, 27 May 2009 21:41:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090527184106.GA18463@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com> <4A1D48FA.9080403@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D48FA.9080403@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:06:50AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> >   
> >> +static int
> >> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> >> +{
> >> +	struct _irqfd *irqfd;
> >> +	struct file *file = NULL;
> >> +	int ret;
> >> +
> >> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> >> +	if (!irqfd)
> >> +		return -ENOMEM;
> >> +
> >> +	irqfd->kvm = kvm;
> >> +	irqfd->gsi = gsi;
> >> +	INIT_LIST_HEAD(&irqfd->list);
> >> +	INIT_WORK(&irqfd->work, irqfd_inject);
> >> +
> >> +	/*
> >> +	 * Embed the file* lifetime in the irqfd.
> >> +	 */
> >> +	file = fget(fd);
> >> +	if (IS_ERR(file)) {
> >> +		ret = PTR_ERR(file);
> >> +		goto fail;
> >> +	}
> >>     
> >
> > So we get a reference to a file, and unless the user is nice to us, it
> > will only be dropped when kvm char device file is closed?
> > I think this will deadlock if the fd in question is the open kvm char device.
> >
> >
> >   
> Hmm...I hadn't considered this possibility, though I am not sure if it
> would cause a deadlock in the pattern you suggest.  It seems more like
> it would result in, at worst, an extra reference to itself (and thus a
> leak) rather than a deadlock...
> 
> I digress.  In either case, perhaps I should s/fget/eventfd_fget to at
> least limit the type of fd to eventfd.  I was trying to be "slick" by
> not needing the eventfd_fget() exported, but I am going to need to
> export it later anyway for iosignalfd, so its probably a moot point.
> 
> Thanks Michael,
> -Greg
> 

This only works as long as eventfd does not do fget on some fd as well.
Which it does not do now, and may never do - but we create a fragile
system this way.

I think it's really wrong, fundamentally, to keep a reference to a
file until another file is closed, unless you are code under fs/.
We will get nasty circular references sooner or later.

Isn't the real reason we use fd to be able to support the same interface
on top of both kvm and lguest?
And if so, wouldn't some kind of bus be a better solution?

-- 
MST
