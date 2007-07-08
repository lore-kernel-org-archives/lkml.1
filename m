Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXGHSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXGHSbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXGHSbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:31:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54812 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbXGHSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:31:16 -0400
Date: Sun, 8 Jul 2007 19:31:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference - git-bisect result
Message-ID: <20070708183112.GJ21668@ftp.linux.org.uk>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk> <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org> <46912BF5.8080201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46912BF5.8080201@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 11:24:53AM -0700, Ulrich Drepper wrote:
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

Sigh...  There are two operations.
	1) set the timestamp to user-supplied value.  Owner-only.
	2) have the timestamp set to _now_.  Obviously can be done not
only by the owner (think of e.g. write(2)); having write access is
sufficient.

ATTR_MTIME_SET is the former.  ATTR_MTIME without ATTR_MTIME_SET is the
latter and that's what utimes(foo, NULL) ends up doing.
