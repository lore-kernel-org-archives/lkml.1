Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXCLIyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXCLIyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXCLIyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:54:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:49577 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXCLIya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:54:30 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Mon, 12 Mar 2007 09:54:21 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703101405330.7545-100000@patience.localdomain>
In-Reply-To: <Pine.LNX.4.44L0.0703101405330.7545-100000@patience.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703120954.22038.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 10. März 2007 20:19 schrieb Alan Stern:
> On Fri, 9 Mar 2007, Oliver Neukum wrote:
> 
> > Am Freitag, 9. März 2007 21:08 schrieb Alan Stern:
> > > After some more thought, I basically agree with what Oliver wrote
> > > originally.  sysfs_dirent is indeed the logical place to store the kref
> > > pointer.  However it needs to be used during open and release, not during
> > 
> > OK.
> > 
> > > read, write, and poll.  Another point, which Oliver didn't think of, is
> > > that the kref pointer needs to be passed to the driver as an argument in
> > > the show() and store() method calls.
> > 
> > Why? What's wrong with simply calling kref_get/put?
> 
> It's the same old problem: the race between unbind and sysfs I/O.  What
> good does holding a reference to the private data structure do if the
> show/store method gets called after the driver has been unbound from the
> device?  dev_get_drvdata() will no longer provide a valid pointer to the
> private data, so the method will have no way to access it.  Hence the
> method needs another argument.

It does half the job. You can make sure the driver is not asked to access
freed memory.
It is true that a driver will have to mark that device "disconnected"
and return errors if that device's attributes are referenced, but this can
be done internally.

Yes, this is a bit more complicated.
{rant mode}
Who came up with the idea of making life simpler by adding a code path?
All these problems were already solved for device nodes. Ioctl is ugly, but
at least a known code path.
{rant off}

> (BTW, the sysfs core would actually need more than a kref.  It would also 
> need a pointer to a release routine -- the kref contains only the atomic

Yes, this is implied.

	Regards
		Oliver
