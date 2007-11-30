Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbXK3XWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbXK3XWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXK3XWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:22:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34070 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755513AbXK3XWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:22:38 -0500
Date: Fri, 30 Nov 2007 18:22:37 -0500 (EST)
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
In-Reply-To: <20071130222629.GA7653@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711301816290.2747-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Greg KH wrote:

> > However if kobject_add() is never called, or if it is called and it 
> > fails, then it's okay to use kfree().  It's not clear whether this 
> > distinction will matter in practice.  It's probably best to document 
> > this using your stronger description.
> 
> No, if kobject_add() fails, kobject_put() still must be called in order
> to free up the name pointer, unless you are somehow guessing that the
> "kobject_set_name()" portion of kobject_add() somehow failed.

Actually I imagined that if kobject_add() failed it would back out all 
the changes it made -- which means it would deallocate the name 
string.  But requiring people to call kobject_put() will do this just 
as well.

>  And you
> can't know that, so you have to call kobject_put() in order to be safe
> and clean up everything.
> 
> Now why did we not do the final kobject_put() in kobject_del() as well?
> Doing two calls, always in order, seems a bit strange, anyone know why
> it's this way?

To be symmetrical with kobject_init() and kobject_add().  Besides, 
isn't there kobject_unregister()?  Presumably it will go away along 
with kobject_register(), though.

> > You could put that a little less strongly.  After kobject_init() you
> > SHOULD call kobject_put() to clean up properly, and after kobject_add()
> > you MUST call kobject_del() and kobject_put().
>
> No, in looking at the code, you only need to call kobject_del() to clean
> everything up properly, if kobject_add() succeeds.  No need to call
> kobject_put() yet again.

Sorry, yes, that's what I meant.  After a successful call to 
kobject_add() you must call kobject_del() to undo the _add, and then
kobject_put() for the final cleanup.

Alan Stern

