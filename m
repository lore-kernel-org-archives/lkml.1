Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXK1WBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXK1WBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbXK1WA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:00:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41381 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755672AbXK1WA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:00:57 -0500
Date: Wed, 28 Nov 2007 17:00:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <20071128214502.GA3255@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711281654560.2729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Greg KH wrote:

> On Wed, Nov 28, 2007 at 03:42:00PM -0500, Alan Stern wrote:
> > This patch (as1020) adds a check to kobject_init() to insure that the
> > ktype field is not NULL.  This is just for safety's sake; as far as I
> > know there are no remaining places where the field is left unset.  But
> > ironically, kset_init() did fail to set it!  The patch fixes that and
> > removes some redundant initialization in kset_createa().
> > 
> > The patch also fixes up elevator_init(), where ktype was set after
> > calling kobject_init() instead of before.
> 
> No, it's safe to set ktype after kobject_init, it was just not safe to
> set the kset.  As Kay pointed out, I just added a patch to my tree to
> resolve this issue, and I'll go back and update the documentation now.
> 
> I do like the "check for a ktype" warning, I'll go add that to my local
> tree and see what breaks.  Odds are, all the static kobjects will :(

You have to be careful.  The ktype check I wrote lives in
kobject_init() -- that's why I had to make elevator_init() assign the
ktype before calling kobject_init().  If you put the check into
kobject_add() instead then you won't end up checking objects that get
initialized but not added.

Yes, nobody would deliberately use a kobject without adding it, but it 
could happen as the result of an failure between the _init and _add 
calls.

In any case, the change to kset_init() in my patch fixes a real bug.  
It never did set the ktype at all.

Alan Stern

