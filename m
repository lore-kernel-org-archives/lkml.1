Return-Path: <linux-kernel-owner+w=401wt.eu-S1763898AbZE1UKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763898AbZE1UKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbZE1UKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:10:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54655 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975AbZE1UKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:10:39 -0400
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
In-Reply-To: <Pine.LNX.4.44L0.0905281545300.4059-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0905281545300.4059-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 20:10:39 +0000
Message-Id: <1243541439.2830.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 16:02 -0400, Alan Stern wrote:
> On Thu, 28 May 2009, James Bottomley wrote:
> 
> > > >  However, the piece that's missing, is the fact that all of
> > > > this has to be tied into the host state.  If the host is running, you
> > > > can't remove the target from visibility even if all its children are
> > > > invisible because it might get another visible child added.
> > > 
> > > Are you sure about that?  It's not obvious at all to me.
> > 
> > Yes ... otherwise you have to elongate the DEL interval from a few ms to
> > potentially anything.  That would allow locking a target in a dying
> > state and prevent any new LUNs being added.
> 
> How so?  Why not unlink the target from the host's list when the 
> device_del() call returns?  A new target can be created any time after 
> that, since the old one is now completely invisible.

The answer to that one is several emails back: we need the target in the
host list for the lifetime of the devices ... it's alterable, but even
more auditing.

> > > For example, suppose during scanning it turns out there are no LUNs at
> > > a particular target address.  Why should the empty target be retained?  
> > > You'd end up with unusable targets at all possible bus addresses.
> > > 
> > > Besides, if a target is removed from visibility and then another child
> > > is added, the answer is simply to create a new target structure.  
> > > There's already code in scsi_alloc_target() to do this.
> > 
> > As I've said several times, this could be done, but we'd have to audit
> > the code paths to make sure we allow for multiple same targets in the
> > list.
> 
> No, not if the old target is removed from the host's list before the
> new target is added.
> 
> Is there any reason the old target has to remain on the list?  If 
> there is, we can introduce a new state: STARGET_CLEANUP.  The old 
> target gets put into this state when device_del() returns.  List 
> entries in that state are ignored by __scsi_find_target() or whatever 
> else looks through the list.
> 
> Alan Stern
> 
> P.S.: Does scsi_target_reap() really ever get called in non-process
> context?  I couldn't find any place where that might happen.

>From the device release, which is done by last put, which could be I/O
context.

James


