Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbZE0RBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbZE0RBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbZE0RBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:01:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54124 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756688AbZE0RBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:01:09 -0400
Date: Wed, 27 May 2009 13:01:05 -0400 (EDT)
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
In-Reply-To: <1243441460.6067.18.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0905271255340.15613-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, James Bottomley wrote:

> > I don't understand all the subtle issues here.  In other contexts, the 
> > solution would be to initialize a refcount to 1 when the target is 
> > allocated, increment it when a device is added, and decrement it when a 
> > device is removed or the host is removed.  When the refcount goes to 0, 
> > the target is deleted.  Why wouldn't this kind of approach work?
> 
> Um, well that's exactly how it works (modulo the fact that there are
> parts of the lifecycle where the ref count is zero, like scanning).

Why does that happen?  It's reasonable that there should be times 
during scanning when the target doesn't have any children, but the 
refcount should still be positive.

>  The
> problem you're complaining about is that the device ref on the target
> may take a long time to release, so we can't key the del event on the
> refcount going to zero, which is what we do today.

Maybe we should be talking about two separate refcounts: a normal 
get_device/put_device kref counter for the target's lifetime, and a 
visibility counter (one for each child device and one overall) which 
keys the del event and must go to 0 before the host removal finishes.

Alan Stern

