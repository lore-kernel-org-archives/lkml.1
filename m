Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXDPPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXDPPCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXDPPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:02:39 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:64973 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXDPPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:02:38 -0400
Date: Mon, 16 Apr 2007 17:05:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
Message-ID: <20070416170508.07939b18@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704161028330.4861-100000@iolanthe.rowland.org>
References: <20070416105316.0b91c2fd@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0704161028330.4861-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007 10:43:01 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> Actually it has to be done in kobject_init() since the release method can 
> be called any time after that, even if the kobject is never add'ed.

True. This would also imply that we only ever must free a kobject with
kobject_put() if kobject_init() has been called.

> 
> > from now on it may be looked up). kobject_get()/kobject_put() wouldn't
> > need to grab an extra reference (we already have refcounting for this
> > object in place). kobject_cleanup() could do something like:
> > 
> > struct module * kobject_owner = kobj->owner;
> > ...
> > call_release();
> > put_second_module_refcount(kobject_owner);
> > 
> > combined with the module unloading code waiting after calling the exit
> > function until the second type refcount dropped to 0. This would make
> > sure that the module is not deleted until the last release function has
> > been called.
> > 
> > The module would stay in memory (not be unloaded) until the last
> > kobject created by the module is deleted, but I think that is just what
> > we want. At least this doesn't mean that the module blocks its own
> > unloading.
> 
> Yes, that's what I had in mind.
> 
> It would have to apply to other things besides kobjects -- in principle,
> anything with a release routine, although in many cases it wouldn't be 
> needed.  But in particular, it _would_ be needed for struct device.
> 
> (In fact, perhaps kobject would not need it.  There aren't too many places
> where a raw kobject is used; almost always it is embedded in some larger
> object -- like struct device -- along with a release method pointer.  
> This larger object would need an owner but its embedded kobject usually
> would not.)

Yes, struct device might be enough for most use cases. However, this
would involve looking hard at the code :)

> 
> On the other hand, this proposal involves adding a fair amount of overhead
> (all those .owner fields) for a rather small benefit.  And it involves
> modifying a core kernel subsystem (kernel/module.c).  All to prevent
> certain unlikely sorts of errors when removing a module -- something which
> Linus has said repeatedly need not be supported terribly well.

The basic infrastructure isn't too hard (I'm having a patch using mkobj
on my disk that is in nearly workable state). And I think that this is
something that really should be fixed - it is just way too easy for a
driver writer to mess this up (and the race window becomes even bigger
on virtualized platforms).
