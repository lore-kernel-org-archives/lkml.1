Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXDQHNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXDQHNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXDQHNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:13:55 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:54508 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXDQHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:13:54 -0400
Date: Tue, 17 Apr 2007 09:16:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
Message-ID: <20070417091624.63436fc3@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1176778391.14322.273.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0704161539110.2685-100000@iolanthe.rowland.org>
	<1176778391.14322.273.camel@localhost.localdomain>
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

On Tue, 17 Apr 2007 12:53:10 +1000,
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 2007-04-16 at 15:53 -0400, Alan Stern wrote:
> > The fundamental rule is that whenever you hand out a pointer to a routine
> > living in a module, the receiver has to increment the module's refcount.  
> > But the driver core violates this rule all over the place.
> 
> Hi Alan,
> 
> 	Your rule is overly simplistic, unfortunately.  You have two choices:
> take a reference count, *or* ensure that the reference will go away when
> the module's cleanup routine is called.  Network drivers are a classic
> example of the latter.

Hm, but that's exactly the problem we face here. There is no race-free
way (at least, nobody could think about one yet) to make sure all
references are freed at exit time and simultaneously to make sure that
the release functions have finished before the module has been deleted.

> 
> 	Note that you cannot do both: if the cleanup routine calls something
> which drops a reference count, it implies that the cleanup routine needs
> to be called with non-zero reference count, and it won't be (ignoring
> --force).

That's where that second reference count (the kref in the embedded
kobject in the module) comes into play, that doesn't prevent rmmod from
being run.
