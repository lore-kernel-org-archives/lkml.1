Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXDQHeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXDQHeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXDQHeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:34:24 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:41821 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbXDQHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:34:22 -0400
Date: Tue, 17 Apr 2007 09:36:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Message-ID: <20070417093652.05030383@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
References: <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
	<Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
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

On Mon, 16 Apr 2007 15:38:52 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 16 Apr 2007, Dmitry Torokhov wrote:

> > Unfortunately all this "wait for refcount in module's exit" schemas
> > lead to the following deadlock:
> > 
> >         rmmod my_module < /path/to/some/file/incrementing/my/refcount
> 
> (Note that this problem will be a lot harder to provoke once Tejun's
> changes to sysfs are in place.  But it will still be possible, unless we 
> make similar changes to all the other filesystems as well.)
> 
> There are three possible approaches to this problem:
> 
>      1. Ignore it, as we do now.  If someone actually tries running your
> 	example above, an oops will result when the kobject's release
> 	method is called after my_module has been unloaded from memory.
> 
>      2. Do what Cornelia suggested, and allow the example to deadlock.
> 
>      3. Change the module code so that rmmod can return _before_ the
> 	module is actually unloaded from memory (but after the module's
> 	exit routine has completed).  This will lead to more problems.
> 	For example, what if someone tries to modprobe my_module back
> 	again before it has finished unloading?
> 
> My feeling is that either a deadlock or more complications with modprobe 
> would be preferable to an oops.  Your opinion may differ.

My current preference is 2. (obviously :)). I don't like 3. too much
(too complicated code), but I think it would still be better than 1.
(And I agree, this will be harder to trigger with Tejun's patches.)

> 
> (Also, doing this might be a good way to expose a lot of hidden 
> refcounting bugs.  They will become very obvious when rmmod hangs.)

Good point.
