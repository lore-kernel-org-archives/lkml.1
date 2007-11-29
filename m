Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbXK2KNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbXK2KNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbXK2KMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:12:55 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:13442 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbXK2KMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:12:54 -0500
Date: Thu, 29 Nov 2007 11:12:51 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129111251.35b3b17d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711281407320.5566-100000@iolanthe.rowland.org>
References: <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0711281407320.5566-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 14:18:18 -0500 (EST),
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 28 Nov 2007, Cornelia Huck wrote:
> 
> > We should perhaps add a bit fat warning here:
> > 
> > Note that once you registered your kobject via kobject_add(), you must
> > never use kfree() to free it directly. The only safe way is to use
> 
> Slightly ambiguous.  Instead just say:
> 
> If you have initialized your kobject via kobject_init() or
> kobject_register(), you must not deallocate the kobject anywhere other
> than its release() method (which is invoked during the final
> kobject_put() call).  Otherwise the kernel will leak memory.

And references to the kobject's kset...

> 
> > > One important point cannot be overstated: every kobject must have a
> > > release() method, and the kobject must persist (in a consistent state)
> > > until that method is called. 
> > 
> > Which is especially hurting if you use kobjects in modules. (Which
> > reminds me: Must dig up the patchset that fixes the module unload vs.
> > release problem.)
> 
> In theory modules shouldn't present a problem -- especially if Greg 
> merges the "Kobjects: drop child->parent ref at unregistration" patch.
> 
> When a module is unloaded, it has to unregister all its kobjects, which 
> should force all their children to be unregistered too.  At that time 
> the children's drivers should drop all their references to the parent 
> kobject, leaving only references held by the module being unloaded.  
> Presumably it can arrange to drop its own references before its exit() 
> routine returns.
> 
> The only problem arises when a child's driver retains a reference to 
> the parent kobject.  If things are done properly, this reference should 
> involve incrementing the module count -- which would prevent the module 
> from being unloaded in the first place.

This still leaves the possibility that random code may grab a reference
once the kobject is present in the tree and lookupable. You gave up the
control of the number of references to your object once you made it
public.
