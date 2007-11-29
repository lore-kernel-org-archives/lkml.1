Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXK2K7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXK2K7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXK2K65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:58:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:58952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXK2K6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:58:55 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20071129110512.02ae44e1@gondolin.boeblingen.de.ibm.com>
References: <20071128214502.GA3255@kroah.com>
	 <Pine.LNX.4.44L0.0711281654560.2729-100000@iolanthe.rowland.org>
	 <20071129110512.02ae44e1@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 11:59:06 +0100
Message-Id: <1196333946.3242.214.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19Y3uUAUH+CAPFvYpw3RyJHgPq46fz/JfLKKgW
 AyuOk4V/jpDt+JTnuNJrL4fQk9JuX8NpN0jCInMs7Z0tYrd/oU
 gSXbwYF3lxCcEj+HngZNPHRm5klgy2K
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 11:05 +0100, Cornelia Huck wrote:
> On Wed, 28 Nov 2007 17:00:57 -0500 (EST),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 28 Nov 2007, Greg KH wrote:
> > > On Wed, Nov 28, 2007 at 03:42:00PM -0500, Alan Stern wrote:
> > > > This patch (as1020) adds a check to kobject_init() to insure that the
> > > > ktype field is not NULL.  This is just for safety's sake; as far as I
> > > > know there are no remaining places where the field is left unset.  But
> > > > ironically, kset_init() did fail to set it!  The patch fixes that and
> > > > removes some redundant initialization in kset_createa().
> > > > 
> > > > The patch also fixes up elevator_init(), where ktype was set after
> > > > calling kobject_init() instead of before.
> > > 
> > > No, it's safe to set ktype after kobject_init, it was just not safe to
> > > set the kset.  As Kay pointed out, I just added a patch to my tree to
> > > resolve this issue, and I'll go back and update the documentation now.
> > > 
> > > I do like the "check for a ktype" warning, I'll go add that to my local
> > > tree and see what breaks.  Odds are, all the static kobjects will :(
> > 
> > You have to be careful.  The ktype check I wrote lives in
> > kobject_init() -- that's why I had to make elevator_init() assign the
> > ktype before calling kobject_init().  If you put the check into
> > kobject_add() instead then you won't end up checking objects that get
> > initialized but not added.
> > 
> > Yes, nobody would deliberately use a kobject without adding it, but it 
> > could happen as the result of an failure between the _init and _add 
> > calls.
> 
> And if someone calls kobject_put() after kobject_init() to clean up,
> their release function will not be called if they didn't set the ktype.
> So the check really belongs into kobject_init() IMO.

Hmm, will one expect that the whole object will also be free'd when we
suggest to call kobject_put() to cleanup? That might be pretty
unexpected, right?

Kay

