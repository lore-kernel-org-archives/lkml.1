Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbXK3VtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbXK3VtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXK3VtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:49:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49600 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbXK3VtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:49:16 -0500
Date: Fri, 30 Nov 2007 13:48:19 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
	functions
Message-ID: <20071130214819.GA7326@kroah.com>
References: <20071130210420.GA6097@kroah.com> <Pine.LNX.4.44L0.0711301616300.2941-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711301616300.2941-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:19:53PM -0500, Alan Stern wrote:
> On Fri, 30 Nov 2007, Greg KH wrote:
> 
> > > My suggestion: Have kobject_init_ng() accept a ktype pointer but not a 
> > > parent or name.  Instead, make kobject_add_ng() take the parent and 
> > > name (possibly a kset also).  Then when kobject_init_and_add() 
> > > encounters an error, it shouldn't do a _put() -- the caller can either 
> > > do the _put() or just do a kfree().
> > 
> > Why not the parent for init()?  Isn't it always known at that time?
> > I'll dig to be sure.
> 
> Specifying the parent during _add() is more logical, because a kobject
> doesn't actually _do_ anything to the parent until it is registered in
> the parent's directory.  Or to put it another way, an unregistered
> kobject can't have a parent in any meaningful sense so there's no point
> specifying the parent in the _init() call.

Ok, how about this:
	void kobject_init(struct kobject *kobj, struct ktype *ktype);

and then:
	int kobject_add(struct kobject *kobj, struct kobject *parent, const char *fmt, ...);

After we call kobject_init() we HAVE to call kobject_put() to clean up
properly.  So, if kobject_add() fails, we still need to clean up with
kobject_put();

That means we _can_ create a:
	int kobject_init_and_add(struct kobject *kobj, struct ktype *ktype, struct kobject *parent, const char *fmt, ...);

and if that fails, then again, you have to call kobject_put() to clean
things up, right?

Does this look sane?

thanks,

greg k-h
