Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZKEPZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZKEPZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZKEPZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:25:17 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49636 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZKEPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:25:15 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, miklos@szeredi.hu, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091105145054.11f36b35@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Thu, 5 Nov 2009 14:50:54 +0000)
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091105145054.11f36b35@lxorguk.ukuu.org.uk>
Message-Id: <E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Nov 2009 16:24:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Alan Cox wrote:
> The examples on the list are not entirely theoretical but based on
> accepted and normal behaviour for application programming and Unix
> security models -so they are a security bug, minor or otherwise.
> 
> Fortunately you can patch it by hand.

How do you patch it by hand?

> > And as for reopening O_NODE files with increased permission: that's
> > feature people actually expressed interest in, so it's hardly a
> > security hole, is it?
> 
> Its a very unexpected semantic particularly for a passed file handle.

All of this is about new and unexpected semantics.  I don't think
anything more needs to be done than document it in the manpage:

  "A file descriptor opened with O_NODE | O_NOACCESS may be used to
   re-open the same file later with increased permissions
   (e.g. O_RDWR) if the access mode allows.  This is true even if the
   permissions on the path leading up to the file would prevent it"

> > > Wrong way around. The defailt should be that O_NODE fails for any handle
> > > which has not specifically added support.
> > 
> > Why?  O_NODE can be nicely implemented without any filesystem support.
> 
> So that you audit the behaviour for unexpected surprises as you go. And
> in most filesystem cases that consists of "dum de dum, nothing to see,
> add default handler, tick".
> 
> But that isn't the case for some things - consider CIFS and other network
> file systems.

Why?

Why would the server need to know anything about that?  O_NODE is
similar to a chdir() in this respect, and chdir doesn't have a handler
either.

> > > You also need to address the open with no permissions pinning a removable
> > > device question.
> > 
> > The whole point of O_NODE is that it doesn't do that, it only goes as
> > far as the mnt/dentry for the filesystem node and not further.  It
> > does not get to touch the device at all, so it can't pin it or have
> > any other side effect.
> 
> You have a reference to the mnt/dentry pinned so how will you unmount the
> volume ?

Oh, I see what you are getting at.  So the situation is this: the root
of the volume does not allow any access to the user, so normal
open/chdir won't work.  Yet open(O_NODE) will and so user can pin the
volume.

However, there's not all that much difference between the above and
doing "stat()" on the mountpoint in a tight loop, except the former is
a more reliable way to prevent unmounting.

I don't see this as a huge issue, but ideas about handling it better
are welcome.

Thanks,
Miklos
