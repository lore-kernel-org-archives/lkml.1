Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXK3U0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXK3U0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXK3UZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:25:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49070 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752768AbXK3UZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:25:54 -0500
Date: Fri, 30 Nov 2007 15:25:52 -0500 (EST)
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
In-Reply-To: <20071130195300.GB4659@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711301513390.2941-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Greg KH wrote:

> +/**
> + * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
> + * @kobj: pointer to the kobject to initialize
> + * @ktype: pointer to the ktype for this kobject.
> + * @parent: pointer to the parent of this kobject.
> + * @fmt: the name of the kobject.
> + *
> + * This function will properly initialize a kobject and then call
> + * kobject_add().
> + *
> + * If the function returns an error, the memory allocated by the kobject
> + * can be safely freed, no other functions need to be called.
> + */
> +int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
> +			 struct kobject *parent, const char *fmt, ...)
> +{
> +	va_list args;
> +	int retval;
> +
> +	va_start(args, fmt);
> +	retval = kobject_init_varg(kobj, ktype, parent, fmt, args);
> +	va_end(args);
> +	if (retval)
> +		return retval;
> +
> +	retval = kobject_add(kobj);
> +	if (retval)
> +		kobject_put(kobj);

No, no!

You have recreated the problem we have been discussing during the last
couple of days.  If the kobject_init_varg() routine gets an error then
the kobject will need to be deallocated manually.  If the kobject_add()
routine gets an error then the cleanup invoked by kobject_put() will do
the deallocation automatically.

But the caller can't tell in which subroutine an error occurred, so it
won't know what to do when kobject_init_and_add() returns an error.

The only way to resolve this problem is to have the _init routine 
consume no resources and never fail.  That way the only possible 
failure mode would be if the _add routine doesn't work, in which case 
either a kfree() or a kobject_put() would be acceptable.

In particular, this implies that the name should be set as part of the 
_add() call, not as part of _init().  This is more in line with the way 
the code tends to use kobjects anyhow.  Unless people want to name 
unregistered kobjects -- does this ever happen?  And it if does, can 
these kobjects simply be replaced by krefs?

My suggestion: Have kobject_init_ng() accept a ktype pointer but not a 
parent or name.  Instead, make kobject_add_ng() take the parent and 
name (possibly a kset also).  Then when kobject_init_and_add() 
encounters an error, it shouldn't do a _put() -- the caller can either 
do the _put() or just do a kfree().

Alan Stern

