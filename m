Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZKEQx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZKEQx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZKEQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:53:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49866 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672AbZKEQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:53:25 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, miklos@szeredi.hu, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091105155648.4329f5b7@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Thu, 5 Nov 2009 15:56:48 +0000)
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
	<20091105145054.11f36b35@lxorguk.ukuu.org.uk>
	<E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu> <20091105155648.4329f5b7@lxorguk.ukuu.org.uk>
Message-Id: <E1N65Zt-0003L5-84@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Nov 2009 17:52:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Alan Cox wrote:
> > > Fortunately you can patch it by hand.
> > 
> > How do you patch it by hand?
> 
> I find "joe" quite useful, some people prefer vi or emacs

Emacs, please.  But I'm not quite sure anymore what we are talking
about :)

> >   "A file descriptor opened with O_NODE | O_NOACCESS may be used to
> >    re-open the same file later with increased permissions
> >    (e.g. O_RDWR) if the access mode allows.  This is true even if the
> >    permissions on the path leading up to the file would prevent it"
> 
> Which is contrary to the assumptions made by systems designers for the
> past forty years, so its a very dangerous assumption to break.

I don't know.  I would be surprised if anyone actually found a setup
where the current "hole" wrt proc makes any difference.

Take a step back and look at what would be required for this to be
exploitable:

 1) a file which is readable and writable by some user
 2) but is not reachable by said user (because of permissions on path)
 3) a privileged process opening this file with O_RDONLY
 4) sending the fd it to an unprivileged process owned by user
 5) assuming that user won't be able to write it (even though the file
    has write permission)

If I was a system designer, I'd think of that as a very fragile
assumption.

I'm still not sure which is more harmful, leaving this "hole" as it
is, or fixing it, thereby possibly breaking uses of this (mis)feature.
IMO the latter is far more likely to cause problems.

> What are the sematics with regards to vhangup ?

The file descriptor opened with O_NODE cannot refer to a terminal.

> What are the sematics of O_NODE opening a device file when the device is
> later unloaded and a new device is created on the same node with totally
> unrelated permissions ? [happens all the time btw]

Right, that's a valid point.

So re-opening a device node opened with O_NODE is not safe, I agree.
Which means, I'll either have to remove the possibilty of re-opening
O_NODE files through proc, or limit it to non-device nodes.

I'd really prefer just limiting it, since that would leave re-opening
a useful feature, while having minimal risk (especially if documented)
of it causing trouble.

But I can be convinced either way with sufficiently good arguments :)

> > > But that isn't the case for some things - consider CIFS and other network
> > > file systems.
> > 
> > Why?
> 
> open O_NODE
> remote file moves
> new one appears
> reopen

Consider

 open O_RDONLY
 remote file moves
 new one appears
 fstat

What's the difference?

> Now what should happen and what does happen ?

I'd like fstat() to work in that situation as well, but any patches in
that direction consistently get rejected by Christoph, saying
"CIFS/FUSE/etc are broken by design, we shouldn't care".

> > of the volume does not allow any access to the user, so normal
> > open/chdir won't work.  Yet open(O_NODE) will and so user can pin the
> > volume.
> 
> and without permission on the node.
> 
> > However, there's not all that much difference between the above and
> > doing "stat()" on the mountpoint in a tight loop, except the former is
> > a more reliable way to prevent unmounting.
> 
> That doesn't seem to be the case testing it, but its fixable trivially if
> so and its fixable without API breakage.

No it's not.  While a node is looked up, it will pin the mount, albeit
for just a short time.  And permission on the inode itself are not
required for lookup, only permissions on the parent.

I think you are being paranoid here.  If the user has access to the
path leading up the mountpoint, he might as well pin that mount.
Permissions on the mount itself shouldn't really make a difference.

Thanks,
Miklos
