Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXK3WKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXK3WKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXK3WKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:10:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59426 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752888AbXK3WKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:10:35 -0500
Date: Fri, 30 Nov 2007 17:10:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
 functions
In-Reply-To: <20071130214819.GA7326@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711301702200.2747-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Greg KH wrote:

> Ok, how about this:
> 	void kobject_init(struct kobject *kobj, struct ktype *ktype);
> 
> and then:
> 	int kobject_add(struct kobject *kobj, struct kobject *parent, const char *fmt, ...);
> 
> After we call kobject_init() we HAVE to call kobject_put() to clean up
> properly.  So, if kobject_add() fails, we still need to clean up with
> kobject_put();

You could put that a little less strongly.  After kobject_init() you
SHOULD call kobject_put() to clean up properly, and after kobject_add()
you MUST call kobject_del() and kobject_put().

However if kobject_add() is never called, or if it is called and it 
fails, then it's okay to use kfree().  It's not clear whether this 
distinction will matter in practice.  It's probably best to document 
this using your stronger description.

The same sort of rule should apply to other kernel objects, like struct 
device.  After intialization you have to do a final _put, before that 
you just do a kfree().  (And initialization cannot fail.)

> That means we _can_ create a:
> 	int kobject_init_and_add(struct kobject *kobj, struct ktype *ktype, struct kobject *parent, const char *fmt, ...);
> 
> and if that fails, then again, you have to call kobject_put() to clean
> things up, right?

Right.  Because you know that the failure must have occurred in the 
_add portion.

> Does this look sane?

Yes, I think that will all work correctly.

Alan Stern

