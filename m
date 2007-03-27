Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbXC0SIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbXC0SIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934144AbXC0SIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:08:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5409 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136AbXC0SIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fzmMkFq3z70vYKKJtTYx6etAInQH5bPYWz6RuVQHXvM+i5InWSHAsWVeOTE4DXdY4RR+93dUR5Fec2Xxs0AqqmKOJfwaIdbkXipsqStI25wnwVRhLfQHfPlGYYwnbgaU6Dua/UAx4iU2ifQcZaEWrZUi3ZnBUBZTKk3Y1uaY9q4=
Date: Tue, 27 Mar 2007 22:08:36 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [PATCH] aoe, tb0219: fix late spin_lock_init() and friends
Message-ID: <20070327180836.GA5308@martell.zuzino.mipt.ru>
References: <20070325190221.GA5308@martell.zuzino.mipt.ru> <20070325143609.75165bf6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325143609.75165bf6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 02:36:09PM -0800, Andrew Morton wrote:
> On Sun, 25 Mar 2007 23:02:21 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > Some drivers do register_chrdev() before lock or semaphore used in
> > corresponding file_operations is initialized.

> > --- a/drivers/char/tb0219.c
> > +++ b/drivers/char/tb0219.c
> > @@ -287,6 +287,8 @@ static int __devinit tb0219_probe(struct
> >  {
> >  	int retval;
> >
> > +	spin_lock_init(&tb0219_lock);
> > +
> >  	if (request_mem_region(TB0219_START, TB0219_SIZE, "TB0219") == NULL)
> >  		return -EBUSY;
> >
> > @@ -304,8 +306,6 @@ static int __devinit tb0219_probe(struct
> >  		return retval;
> >  	}
> >
> > -	spin_lock_init(&tb0219_lock);
> > -
> >  	old_machine_restart = _machine_restart;
> >  	_machine_restart = tb0219_restart;
> >
>
> These locks can and should be initialised at compile-time.

Documentation mentions that

	- it [dynamic spinlock initialization] hurts automatic lock validators
	- it becomes intrusive for the realtime preemption patches

First reason is clearly bogus, how relevant is the second one?

