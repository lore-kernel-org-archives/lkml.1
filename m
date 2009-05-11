Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZEKGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZEKGwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZEKGwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:52:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40318 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZEKGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:52:09 -0400
Date: Mon, 11 May 2009 07:52:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q. Switch open_exec() and sys_uselib() to do_open_filp()
Message-ID: <20090511065207.GJ8633@ZenIV.linux.org.uk>
References: <29926.1242003317@jrobl> <20090511012828.GH8633@ZenIV.linux.org.uk> <31197.1242009975@jrobl> <20090511040019.GI8633@ZenIV.linux.org.uk> <7134.1242019209@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7134.1242019209@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 02:20:09PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Al Viro:
> > Nope.  It ended up in nd->intent.open.flags due to path_lookup_open().
> 
> Yes.
> 
> 
> > Then lookup_instantiate_filp() from a filesystem that might care about
> > intents did
> >         nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->mnt),
> >                                              nd->intent.open.flags - 1,
> >                                              nd->intent.open.file,
> >                                              open);
> > and nameidata_to_filp() ended up picking nd->intent.open.file.
> 
> FS supporting lookup_instantiate_filp() is rare, isn't it?
> Simple grep told me it is called by fuse, nfsv4, cifs, and 9p only.
> In other FS, FMODE_EXEC was dropped since nameidata_to_filp() (from
> open_exec() directly) doesn't pick intent.open.flags up.

The rest of filesystems simply ignore FMODE_EXEC completely, no matter where
it is.
 
> Anyway, I could confirm that setting FMODE_EXEC to f_flags is intended.
> Thank you for your quick responces.

NOTE: "intended" != "is promised to stay that way".  Indeed, this thread is
an excellent demonstration of the reasons for massaging the entire nightmare
into saner shape.  The call graph in the current form is an obscenity, the
number of possible codepaths is way too high, thanks to the intents mess and
the paths taken by the data are interesting and hard to trace, to put it
very mildly.

The things *will* change, and final destination of FMODE_EXEC may very well
be among those.  The commit in question did the following:
	* eliminate two special codepaths
	* make FMODE_EXEC treatment consistent (it's always propagated to
f_flags) without functionality changes (filesystems that ignored the intents
are ignoring that bit in f_flags completely anyway).

We might end up changing the treatment of that thing and it might very well
end up in f_mode.  However, that would be a separate patch and it's not for
this point in cycle.
