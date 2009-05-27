Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZE0SIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZE0SIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762171AbZE0SH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:07:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53734 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761933AbZE0SH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:07:58 -0400
Date: Wed, 27 May 2009 14:07:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <1243444101.6067.24.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0905271356090.15690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, James Bottomley wrote:

> By refcount, I mean count of underlying devices.

Does that mean only registered devices, or does it include devices 
which are unregistered but not yet released?

> > >  The
> > > problem you're complaining about is that the device ref on the target
> > > may take a long time to release, so we can't key the del event on the
> > > refcount going to zero, which is what we do today.
> > 
> > Maybe we should be talking about two separate refcounts: a normal 
> > get_device/put_device kref counter for the target's lifetime, and a 
> > visibility counter (one for each child device and one overall) which 
> > keys the del event and must go to 0 before the host removal finishes.
> 
> Um, well, that's roughly how I said we'd have to fix all of this in the
> email to hannes ... it would be much easier if we could make a del'd
> device visible,

I don't follow.  Why would you want to delete a target before the host
is removed and then make it visible again later?  Because it doesn't
have any underlying devices at the moment but may gain some later on?

If that's the case, why not delete the target when there are no more
registered devices beneath it and then create a new target structure
when a new device appears?

> but now we have to have different behaviours depending
> on whether the host is going away or not.

Yes, one does get the feeling that we're going around in circles...

Okay.  So now I have made two proposals.  One is to delete targets and
create new ones as needed.  The other is to keep a target hanging
around, even if there are no underlying devices, until the host is
removed.  This can be implemented easily by making the counter
represent the number of registered devices plus one for the host.  

Alan Stern

P.S.: If the counter is made to refer to registered devices, as opposed
to un-released devices, would there ever be a situation where you want
to delete a target in a non-process context?

