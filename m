Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXK1TS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXK1TS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXK1TSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:18:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37079 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754656AbXK1TST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:18:19 -0500
Date: Wed, 28 Nov 2007 14:18:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
In-Reply-To: <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0711281407320.5566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Cornelia Huck wrote:

> We should perhaps add a bit fat warning here:
> 
> Note that once you registered your kobject via kobject_add(), you must
> never use kfree() to free it directly. The only safe way is to use

Slightly ambiguous.  Instead just say:

If you have initialized your kobject via kobject_init() or
kobject_register(), you must not deallocate the kobject anywhere other
than its release() method (which is invoked during the final
kobject_put() call).  Otherwise the kernel will leak memory.

> > One important point cannot be overstated: every kobject must have a
> > release() method, and the kobject must persist (in a consistent state)
> > until that method is called. 
> 
> Which is especially hurting if you use kobjects in modules. (Which
> reminds me: Must dig up the patchset that fixes the module unload vs.
> release problem.)

In theory modules shouldn't present a problem -- especially if Greg 
merges the "Kobjects: drop child->parent ref at unregistration" patch.

When a module is unloaded, it has to unregister all its kobjects, which 
should force all their children to be unregistered too.  At that time 
the children's drivers should drop all their references to the parent 
kobject, leaving only references held by the module being unloaded.  
Presumably it can arrange to drop its own references before its exit() 
routine returns.

The only problem arises when a child's driver retains a reference to 
the parent kobject.  If things are done properly, this reference should 
involve incrementing the module count -- which would prevent the module 
from being unloaded in the first place.

Alan Stern

