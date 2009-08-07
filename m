Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbZHGTXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbZHGTXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbZHGTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:23:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:61149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109AbZHGTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NIZEIWBYWN9Ew+88nBKm0w/gQLkpekrbwScuVRSnD3+kuzPEQgXxmLNku/cqAd4Dtu
         ynaqUOkjnGMZ15ft3ta37SwV/FlS+z94axc0eGqDb5rgUXbBQqX5BXip5PU4LXN80Ra8
         yzHt5pYI7wiGRwYp3n+dcV2Lh/lRYGD8LtdvU=
Date: Fri, 7 Aug 2009 21:23:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090807192333.GA4979@nowhere>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <1249564170-18627-4-git-send-email-arnd@arndb.de> <20090807062356.GA4955@nowhere> <20090807105732.1340a115@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807105732.1340a115@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:57:32AM +0100, Alan Cox wrote:
> On Fri, 7 Aug 2009 08:23:58 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > 
> > On Thu, Aug 06, 2009 at 03:09:28PM +0200, Arnd Bergmann wrote:
> > > The VT specific compat_ioctl handlers are the only ones
> > > in common code that require the BKL. Moving them into
> > > the vt driver lets us remove the BKL from the other handlers
> > > and cleans up the code.
> > 
> > 
> > Why does it require the bkl?
> 
> It's always taken the BKL - you have to prove it doesn't need it. Which
> btw isn't true - it does need it in various places still.
> 
> Alan


It was a way to tell "I would like to know what it is protecting" ;-)
I can imagine it is not here for no reason, the problem is to find why.

As an example, to find the reason of the following lines in do_tty_hangup():

	/* inuse_filps is protected by the single kernel lock */
	lock_kernel();

I had to look at a 2.2 kernel. At this time, inuse_filps existed,
and now it is replaced by the tty->tty_files field, which
is protected by file_list_lock().

So according to the comment, we can remove the bkl there, but what
guarantees its role hasn't evolved since then to make it protecting
something else...

