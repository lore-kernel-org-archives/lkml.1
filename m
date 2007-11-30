Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbXK3W1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbXK3W1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXK3W12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:27:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60416 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbXK3W12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:27:28 -0500
Date: Fri, 30 Nov 2007 14:26:29 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
	functions
Message-ID: <20071130222629.GA7653@kroah.com>
References: <20071130214819.GA7326@kroah.com> <Pine.LNX.4.44L0.0711301702200.2747-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711301702200.2747-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 05:10:33PM -0500, Alan Stern wrote:
> On Fri, 30 Nov 2007, Greg KH wrote:
> 
> > Ok, how about this:
> > 	void kobject_init(struct kobject *kobj, struct ktype *ktype);
> > 
> > and then:
> > 	int kobject_add(struct kobject *kobj, struct kobject *parent, const char *fmt, ...);
> > 
> > After we call kobject_init() we HAVE to call kobject_put() to clean up
> > properly.  So, if kobject_add() fails, we still need to clean up with
> > kobject_put();
> 
> You could put that a little less strongly.  After kobject_init() you
> SHOULD call kobject_put() to clean up properly, and after kobject_add()
> you MUST call kobject_del() and kobject_put().
> 
> However if kobject_add() is never called, or if it is called and it 
> fails, then it's okay to use kfree().  It's not clear whether this 
> distinction will matter in practice.  It's probably best to document 
> this using your stronger description.

No, if kobject_add() fails, kobject_put() still must be called in order
to free up the name pointer, unless you are somehow guessing that the
"kobject_set_name()" portion of kobject_add() somehow failed.  And you
can't know that, so you have to call kobject_put() in order to be safe
and clean up everything.

Now why did we not do the final kobject_put() in kobject_del() as well?
Doing two calls, always in order, seems a bit strange, anyone know why
it's this way?

> The same sort of rule should apply to other kernel objects, like struct 
> device.  After intialization you have to do a final _put, before that 
> you just do a kfree().  (And initialization cannot fail.)

Yes.

> > That means we _can_ create a:
> > 	int kobject_init_and_add(struct kobject *kobj, struct ktype *ktype, struct kobject *parent, const char *fmt, ...);
> > 
> > and if that fails, then again, you have to call kobject_put() to clean
> > things up, right?
> 
> Right.  Because you know that the failure must have occurred in the 
> _add portion.

Ok, good, I might get this right yet :)

thanks,

greg k-h
