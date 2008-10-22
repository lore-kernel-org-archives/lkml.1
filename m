Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYJVUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYJVUDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYJVUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbYJVUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:03:08 -0400
Date: Wed, 22 Oct 2008 13:01:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-Id: <20081022130150.00836eba.akpm@linux-foundation.org>
In-Reply-To: <20081022195245.GS4390@tekkaman>
References: <1224683240-15439-1-git-send-email-giometti@linux.it>
	<1224683240-15439-2-git-send-email-giometti@linux.it>
	<20081022174004.GB10587@kroah.com>
	<20081022111145.e5f3c632.akpm@linux-foundation.org>
	<20081022195245.GS4390@tekkaman>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 21:52:46 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Wed, Oct 22, 2008 at 11:11:45AM -0700, Andrew Morton wrote:
> 
> > No opinion yet - I haven't review them.
> > 
> > <looks>
> > 
> > <wonders why c2port_idr_lock and c2port_idr are kernel-wide symbols>
> 
> Fixed.
> 
> > <wonders what local_irq_disable() is supposed to achieve on SMP>
> 
> The SMP is achieved by mutex_lock(), the local_irq_disable() is used
> to avoid interructions in code execution. C2 port has very stringent
> timings.

Please add code comments explaning this (unless I missed them).

> > <spots an error-path memory leak in c2port_device_register>
> > 
> > <spots a stray semicolon in c2port_device_register>
> 
> Can you please explain these two points?

> +struct c2port_device *c2port_device_register(char *name,
> +					struct c2port_ops *ops, void *devdata)
> +{
> +	struct c2port_device *c2dev;
> +	int id, ret;
> +
> +	if (unlikely(!ops) || unlikely(!ops->access) || \
> +		unlikely(!ops->c2d_dir) || unlikely(!ops->c2ck_set) || \
> +		unlikely(!ops->c2d_get) || unlikely(!ops->c2d_set))
> +		return ERR_PTR(-EINVAL);
> +
> +	c2dev = kmalloc(sizeof(struct c2port_device), GFP_KERNEL);
> +	if (unlikely(!c2dev))
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = idr_pre_get(&c2port_idr, GFP_KERNEL);
> +	if (!ret)
> +		return ERR_PTR(-ENOMEM);

		^^ leaks c2dev

> +	spin_lock_irq(&c2port_idr_lock);
> +	ret = idr_get_new(&c2port_idr, c2dev, &id);
> +	spin_unlock_irq(&c2port_idr_lock);
> +
> +	if (ret < 0)
> +		goto error_idr_get_new;
> +	c2dev->id = id;
> +
> +	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
> +					"c2port%d", id);
> +	if (unlikely(!c2dev->dev)) {
> +		ret = -ENOMEM;
> +		goto error_device_create;
> +	};

         ^

> > > <suggests that update_lock be initialised at compile-time, not at runtime>
> 
> Fixed.
> 
> > 
> > What I haven't yet got my head around is this:
> > 
> >   Currently this code supports only flash programming through sysfs
> >   interface but extensions shoud be easy to add.
> > 
> > is that really what we want to use sysfs for?  As the prime interface
> > to a device driver (or is it a bus driver?) Didn't we used to use
> > device nodes for that sort of thing?
> 
> I decided to use this interface since the C2 ports are simple and very
> easy to manage with such files abstraction.

well..  what _is_ the implemented interface?  What alternatives were
considered and why were they judged inappropriate?  What interfaces do
any similar in-tree drivers use?

> Whould you like I repropose the code with the fixed issues for your
> review?

yup
