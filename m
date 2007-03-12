Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbXCLVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbXCLVhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXCLVhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:37:08 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33389 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbXCLVhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:37:06 -0400
Subject: Re: refcounting drivers' data structures used in sysfs buffers
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000703121331s73fa5462p5da58ba391ea7101@mail.gmail.com>
References: <200703122049.03113.oneukum@suse.de>
	 <Pine.LNX.4.44L0.0703121557360.4003-100000@iolanthe.rowland.org>
	 <d120d5000703121331s73fa5462p5da58ba391ea7101@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 21:31:15 +0000
Message-Id: <1173735075.5936.139.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 16:31 -0400, Dmitry Torokhov wrote:
> On 3/12/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 12 Mar 2007, Oliver Neukum wrote:
> > > > >  I don't like reverting my own code. But I predict he'll tell you that a
> > > > > driver's bond with a device should be represented in a data structure
> > > > > that is to be refcounted.
> >
> > There still would be a synchronization problem.  Refcounts don't solve
> > races; they only solve lifetime problems.  And you would still have to
> > change the sysfs API, plus all the other stuff...
> >
> > Do you think Linus would listen if all three of us (plus maybe Greg) tried
> > to convince him?
> >
> 
> If we'd accompany the argument with the patch that changes scsi to use
> wq to perform deletion so we don't have deadlock regression in the
> kernel he might be more perceptive... He is right about lifetime
> issues but this is not strictly lifetime issue as you correctly point
> out. Plus, refcounting also bloats the kernel so I don't relly want to
> use refcount for every integer I happen to export through sysfs if I
> can simply "revoke" access.

For what its worth, I think it makes sense if the driver no longer has
to worry about sysfs attributes after they've been removed. This is
something the core should look after, not each and every driver.

http://marc.theaimsgroup.com/?l=linux-kernel&m=117355959020831&w=2

makes a lot of sense, particularly that "No driver callbacks occur after
unregistration". When writing the backlight class code, I remember
checking into this, concluding that seemed to be the design of sysfs and
thinking it a sane design.

The alternative is to force each and every driver to do its own
refcounting. My experience with locking in the extremely simple
backlight class shows nobody reads the documentation or writes the code
correctly. With that, I've given up and added suitable locking to the
core even if not every driver needs it. In doing so, I made a net
removal of a few hundred lines of broken "ticking timebomb" style code.
I dread to think what would happen if every driver had to deal with
sysfs refcounting.

So count me as a vote for handling this in the sysfs core, not the
drivers.

Richard


