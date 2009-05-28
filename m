Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbZE1Lpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbZE1Lpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZE1Lpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:45:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50958 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZE1Lpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:45:32 -0400
Date: Thu, 28 May 2009 13:45:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, niel.lambrechts@gmail.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de, rjw@sisk.pl
Subject: Re: 2.6.29.4: hibernation fails with large kernel trace
Message-ID: <20090528114527.GA2140@elf.ucw.cz>
References: <4A1C36FF.4080000@gmail.com> <20090527223241.c6fb2caf.akpm@linux-foundation.org> <E1M9ZJI-0003bh-HD@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M9ZJI-0003bh-HD@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The process "fuser" is stuck down in the fuse code awaiting a response
> > or something.  I'd suspect that this is the cause of the freezing
> > failure:
> 
> Yup, the 'gvfs-fuse-daemon' process is already in the refrigerator, so
> it cannot complete the request from the 'fuser' process.
> 
> The solution is simple, really: just allow the 'fuser' task to freeze
> despite the fact that it's inside a syscall.  There's the small detail
> of actually implementing this, without breaking everything else...
> 
> What complicates the above is that we need to enable freezing not just
> inside fuse callbacks, but in the VFS as well.  E.g. sys_rename()
> sleeping on i_mutex needs to be freezable as well, otherwise another
> thread that is already frozen and holding that i_mutex will block that
> rename.
> 
> So,
> 
> a) we need some sort of mechanism to selectively disable freezing only
>    for those syscalls which might (directly) touch hardware state.  It
>    _hopefully_ should be enough to do so with read, write and ioctl,
> 
> b) we need to re-enable freezing for these in fuse.
> 
> That's the theory.  I promised a prototype some time ago but haven't
> yet got around to doing it.

In the meantime, people should stop/restart fuse around
suspend/hibernation, I guess...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
