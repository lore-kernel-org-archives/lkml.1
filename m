Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbZLGRO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbZLGRO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964805AbZLGRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:14:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58672 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbZLGRO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:14:56 -0500
Date: Mon, 7 Dec 2009 17:16:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091207171638.1cfbbb97@lxorguk.ukuu.org.uk>
In-Reply-To: <cb0375e10912070703j4e5769c7tec6090378248a187@mail.gmail.com>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk>
	<E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu>
	<20091207130339.620b904b@lxorguk.ukuu.org.uk>
	<E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu>
	<20091207131546.2af06647@lxorguk.ukuu.org.uk>
	<E1NHdS9-00039i-B6@pomaz-ex.szeredi.hu>
	<20091207141321.0964461d@lxorguk.ukuu.org.uk>
	<cb0375e10912070703j4e5769c7tec6090378248a187@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >        while(1)
> >                fchmod(fd, 0666);
> >
> > wait for device to unload, reload and be intended for another user
> > Race udev to a real open. You have a similar problem with vhangup() and
> > ttys.
> 
> Huh?  I would've thought that udev would (and already does?), on
> device unload, chown to 0:0, then chmod to 0000, then unlink, in which
> case that attack doesn't work.

udev doesn't control the device unload/reload. It responds to messages
from the kernel which are to some extent asynchronous to actual events.
It may be ok if udev is very careful but the fact it requires a close
inspection of the kernel and user space sides doesn't bode well (with or
without O_NODE). The fact we currently have an implied revoke by the
device refcounts is a big helper at the moment.

The tty cases using vhangup() assume that the handle is killed and would
also need addressing.

> Would you be okay with a patch that prevented opening
> /proc/self/fd/xxx on O_NODE handles?  I personally don't care about

I'd like to see what Al Viro has to say on the subject first.
The /proc/self stuff bothers me less - I've not seen a convincing
description of it being misuable where ptrace wouldn't allow the same
actions. Even the constructed scenarios share that property.

> O_NODE all that much, but I'd like a decent in-kernel AFS
> implementation (and a decent revoke() implementation, and especially
> the ability to revoke whole filesystems would be really nice too).

The AFS case is probably the easier one - its things like device files
where one handle can change completely what it references (due to device
loads/unloads and dynamic major/minor assignment) that make it evil.

CIFS/SMB is horrible for different reasons (a handle open on some piece
of namespace isn't going to always been the same actual file) but you
could simply decide CIFS/SMB and any other problematic cases don't
support it.

I don't really have a problem with it providing its restricted to
ordinary files on a file system where having a local inode reference
means you have a stable reference to an object on the remote system or
the local media.

The way to start this is firstly to convince Al Viro (always a good
sanity check), and then to start with the obviously safe cases only -
regular files, only file systems with stable inode references.

Devices are hard - why do we need O_NODE on devices anyway ?

