Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZLGGIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZLGGIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZLGGIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:08:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60411 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZLGGIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:08:42 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, miklos@szeredi.hu, luto@mit.edu,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091205231304.03a4af61@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Sat, 5 Dec 2009 23:13:04 +0000)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu> <20091205231304.03a4af61@lxorguk.ukuu.org.uk>
Message-Id: <E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Dec 2009 07:08:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Alan Cox wrote:
> On Sat, 05 Dec 2009 21:35:55 +0100
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > On Sat, 5 Dec 2009, Alan Cox wrote:
> > > I am concerned primarily about the lack of ability to get rid of such a
> > > handle in a controlled fashion. The udev/device unload case is simply one
> > > obvious way to exploit it.
> > 
> > I don't understand your concern.  Can you please ellaborate on the way
> > to exploit O_NODE?
> 
> You end up with a handle to an object which then changes meaning if a
> device is unloaded and something else loaded (or consider a pty
> recreation)

OK.

> In the normal udev course of things this is ok because even without
> revoke udev can just about get away with it for the sole reason it knows
> that the handle cannot be open in any form during the driver unload
> (because of the device refcounting). You seem to break that.

No.  Udev is ok, because it already does revoke access to the device
on unloading:

:/* Reset permissions on the device node, before unlinking it to make sure,
: * that permissions of possible hard links will be removed too.
: */
:int util_unlink_secure(struct udev *udev, const char *filename)
:{
:        int err;
:
:        chmod(filename, 0000);
...

So I think we agree, that some sort of revoke is needed.  But just
resetting the permissions is fine, there's no need to actually revoke
access for the file descriptor opened with O_NODE.

Do you agree?

Thanks,
Miklos
