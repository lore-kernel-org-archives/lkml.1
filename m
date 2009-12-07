Return-Path: <linux-kernel-owner+w=401wt.eu-S935243AbZLGPLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbZLGPLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935211AbZLGPLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:11:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47148 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028AbZLGPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:11:10 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, miklos@szeredi.hu, luto@mit.edu,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091207144623.692fbc1e@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Mon, 7 Dec 2009 14:46:23 +0000)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
	<20091205231304.03a4af61@lxorguk.ukuu.org.uk>
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk>
	<E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu>
	<20091207130339.620b904b@lxorguk.ukuu.org.uk>
	<E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu>
	<20091207131546.2af06647@lxorguk.ukuu.org.uk>
	<E1NHdS9-00039i-B6@pomaz-ex.szeredi.hu>
	<20091207141321.0964461d@lxorguk.ukuu.org.uk>
	<E1NHeXH-0003Lb-3q@pomaz-ex.szeredi.hu> <20091207144623.692fbc1e@lxorguk.ukuu.org.uk>
Message-Id: <E1NHfEu-0003SM-U0@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Dec 2009 16:11:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Alan Cox wrote:
> > > First obvious attack: get an O_NODE handle to a device you have assigned
> > > to your ownership
> > > 
> > > 	while(1)
> > > 		fchmod(fd, 0666);
> > > 
> > > wait for device to unload, reload and be intended for another user
> > > Race udev to a real open. You have a similar problem with vhangup() and
> > > ttys.
> > 
> > If this was a udev device, the same attack is possible with a hard
> > link to the device.  Except the attacker simply does link() instad of
> > open(O_NODE) and chmod() instead of fchmod().
> 
> If your distribution does not use a separate tmpfs for devices then yes -
> but that's old news - and also needs revoke() to fix.

How does revoke() fix the hard link attack?  It revokes file
descriptors, doesn't it?

>  It's a requirement
> of udev as it stands that it runs on its own file system and I would hope
> that all distributions using udev get this right.

Not the one I'm running.

>  With O_NODE I don't
> need to make the hardlink and all the "same as a hardlink" justifications
> come crashing down.

Well, yes.  That's true.  But I still don't think revoke() is the
answer here.  For example even without the possibility of hard links
there's still a race in udev in the following course of events:

  open("/dev/foo", O_RDWR)
  ... open passes permission checks
  ... driver gets unloaded
  ... driver intended for other user gets loaded
  ... open finds new driver

revoke() isn't going to help there, there's no open file descriptor
yet, it's only in the making.

What we really need is to revoke the *inode*, so that it cannot be
opened any more.  Doing it with unlink() and revoke() and requiring
that link() does not work on the filesystem is a poor and racy
substitute for that.

Miklos
