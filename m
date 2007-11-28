Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXK1Wjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXK1Wjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760485AbXK1Wje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:39:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33137 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233AbXK1Wjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:39:32 -0500
Date: Wed, 28 Nov 2007 14:38:40 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
Message-ID: <20071128223840.GA28007@kroah.com>
References: <20071128214502.GA3255@kroah.com> <Pine.LNX.4.44L0.0711281654560.2729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711281654560.2729-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 05:00:57PM -0500, Alan Stern wrote:
> On Wed, 28 Nov 2007, Greg KH wrote:
> 
> > On Wed, Nov 28, 2007 at 03:42:00PM -0500, Alan Stern wrote:
> > > This patch (as1020) adds a check to kobject_init() to insure that the
> > > ktype field is not NULL.  This is just for safety's sake; as far as I
> > > know there are no remaining places where the field is left unset.  But
> > > ironically, kset_init() did fail to set it!  The patch fixes that and
> > > removes some redundant initialization in kset_createa().
> > > 
> > > The patch also fixes up elevator_init(), where ktype was set after
> > > calling kobject_init() instead of before.
> > 
> > No, it's safe to set ktype after kobject_init, it was just not safe to
> > set the kset.  As Kay pointed out, I just added a patch to my tree to
> > resolve this issue, and I'll go back and update the documentation now.
> > 
> > I do like the "check for a ktype" warning, I'll go add that to my local
> > tree and see what breaks.  Odds are, all the static kobjects will :(
> 
> You have to be careful.  The ktype check I wrote lives in
> kobject_init() -- that's why I had to make elevator_init() assign the
> ktype before calling kobject_init().  If you put the check into
> kobject_add() instead then you won't end up checking objects that get
> initialized but not added.
> 
> Yes, nobody would deliberately use a kobject without adding it, but it 
> could happen as the result of an failure between the _init and _add 
> calls.

No, people do deliberately do this.  Right now, after a few cleanup
patches in my tree, there are only two users who create kobjects but do
not register them, struct cdev and the kobj_map stuff.

The cdev code I'll work on cleaning up, there's just some historical
usages there that I've never felt all that comfortable with, and the
kobj_map code I'd like to convert to just use a list and a kref and not
a kobject at all so that I stop getting emails about it over time :)

thanks,

greg k-h
