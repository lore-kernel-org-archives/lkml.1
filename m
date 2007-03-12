Return-Path: <linux-kernel-owner+w=401wt.eu-S1030387AbXCLPYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030387AbXCLPYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030371AbXCLPYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:24:06 -0400
Received: from ns.suse.de ([195.135.220.2]:46161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030384AbXCLPYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:24:05 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Mon, 12 Mar 2007 16:23:57 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703121041400.2489-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703121041400.2489-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121623.58607.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 15:57 schrieb Alan Stern:probably nece
> On Mon, 12 Mar 2007, Oliver Neukum wrote:
> 
> > > > Why? What's wrong with simply calling kref_get/put?
> > > 
> > > It's the same old problem: the race between unbind and sysfs I/O.  What
> > > good does holding a reference to the private data structure do if the
> > > show/store method gets called after the driver has been unbound from the
> > > device?  dev_get_drvdata() will no longer provide a valid pointer to the
> > > private data, so the method will have no way to access it.  Hence the
> > > method needs another argument.
> > 
> > It does half the job. You can make sure the driver is not asked to access
> > freed memory.
> > It is true that a driver will have to mark that device "disconnected"
> > and return errors if that device's attributes are referenced, but this can
> > be done internally.
> 
> No, you're missing the point.  Let's say driver A's disconnect() is
> called, so the driver marks its private data structure as "disconnected"
> and does dev_set_drvdata(NULL).  Then driver B is probed and bound to the
> device, and it does its own dev_set_drvdata().  Then a user still holding
> an open sysfs file reference for driver A calls a show() or store()  
> method.  The method will do dev_get_drvdata(), receiving the pointer to
> driver B's private data.  Now you're in trouble, because A's method will
> think it owns B's private data!

Yes, I was missing the point. In consequence, drivers must not use
dev_get_drvdata() to get their references to their private data. It's
probably necessary to store it in struct sysfs_buffer and include that
in the store/show callbacks.
(The same does apply to interfaces of course)

> > Yes, this is a bit more complicated.
> > {rant mode}
> > Who came up with the idea of making life simpler by adding a code path?
> > All these problems were already solved for device nodes. Ioctl is ugly, but
> > at least a known code path.
> > {rant off}
> 
> I'll let Greg give the complete answer.  :-)  Bear in mind, however, that
> the aim was probably to make life simpler for userspace -- which does not
> mean making life simpler for the kernel.

That doesn't mean that the method needed to be thrown out.
Sysfs could simply pass through the syscalls for a device, like
it is done in character devices. I am tempted to recommend
such radical surgery.

> (Incidentally, I'm not so sure that all these problems really were solved 
> by ioctl on device nodes.  I bet you could find plenty of cases where 
> ioctl races with disconnect if you looked.)

I will look. Death to all race conditions.

	Regards
		Oliver
