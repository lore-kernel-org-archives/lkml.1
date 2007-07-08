Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbXGHSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbXGHSlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbXGHSlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:41:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756407AbXGHSli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:41:38 -0400
Date: Sun, 8 Jul 2007 11:40:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
In-Reply-To: <46912BF5.8080201@redhat.com>
Message-ID: <alpine.LFD.0.999.0707081138320.31544@woody.linux-foundation.org>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
 <20070708012016.455ce8d5.akpm@linux-foundation.org>
 <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de>
 <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk>
 <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
 <46912BF5.8080201@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Linus Torvalds wrote:
> > notify_change() does *not* do permission checks for 
> > ATTR_CTIME/MTIME/ATIME.
> 
> Then I don't understand
> 
>         /* Check for setting the inode time. */
>         if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
>                 if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
>                         goto error;
>         }
> 
> in inode_change_ok.  This seems to me exactly like the check needed.

No it's not. It really allows only the _owner_ to change MTIME/ATIME.

And the thing is, other people _can_ change MTIME/ATIME, but only to the 
current time!

This is why ATTR_MTIME_SET ("set it to a _specific_ time") is so different 
from ATTR_MTIME ("set it to the _current_ time").

The former is for times() with times != NULL, and is strictly limited to 
only the owner (or root).

The latter is a "anybody who can change the inode can implicitly also 
change the inode timestamps, but only to the _current_ time".

In other words, the ATTR_A/MTIME_SET thing allows people to _lie_ about 
the time, and only the owner is allowed to do that. Which is why they are 
very different.

		Linus
