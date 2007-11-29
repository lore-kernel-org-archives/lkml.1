Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbXK2KFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbXK2KFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbXK2KFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:05:23 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:46720 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101AbXK2KFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:05:22 -0500
Date: Thu, 29 Nov 2007 11:05:12 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
 kobject_init
Message-ID: <20071129110512.02ae44e1@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711281654560.2729-100000@iolanthe.rowland.org>
References: <20071128214502.GA3255@kroah.com>
	<Pine.LNX.4.44L0.0711281654560.2729-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 17:00:57 -0500 (EST),
Alan Stern <stern@rowland.harvard.edu> wrote:

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

And if someone calls kobject_put() after kobject_init() to clean up,
their release function will not be called if they didn't set the ktype.
So the check really belongs into kobject_init() IMO.
