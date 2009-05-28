Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZE1GmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZE1GmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZE1GmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:42:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60715 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZE1GmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:42:03 -0400
To: akpm@linux-foundation.org
CC: niel.lambrechts@gmail.com, linux-kernel@vger.kernel.org, gregkh@suse.de,
       miklos@szeredi.hu, rjw@sisk.pl, pavel@ucw.cz
In-reply-to: <20090527223241.c6fb2caf.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 27 May 2009 22:32:41 -0700)
Subject: Re: 2.6.29.4: hibernation fails with large kernel trace
References: <4A1C36FF.4080000@gmail.com> <20090527223241.c6fb2caf.akpm@linux-foundation.org>
Message-Id: <E1M9ZJI-0003bh-HD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 May 2009 08:41:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Andrew Morton wrote:
> The process "fuser" is stuck down in the fuse code awaiting a response
> or something.  I'd suspect that this is the cause of the freezing
> failure:

Yup, the 'gvfs-fuse-daemon' process is already in the refrigerator, so
it cannot complete the request from the 'fuser' process.

The solution is simple, really: just allow the 'fuser' task to freeze
despite the fact that it's inside a syscall.  There's the small detail
of actually implementing this, without breaking everything else...

What complicates the above is that we need to enable freezing not just
inside fuse callbacks, but in the VFS as well.  E.g. sys_rename()
sleeping on i_mutex needs to be freezable as well, otherwise another
thread that is already frozen and holding that i_mutex will block that
rename.

So,

a) we need some sort of mechanism to selectively disable freezing only
   for those syscalls which might (directly) touch hardware state.  It
   _hopefully_ should be enough to do so with read, write and ioctl,

b) we need to re-enable freezing for these in fuse.

That's the theory.  I promised a prototype some time ago but haven't
yet got around to doing it.

Thanks,
Miklos
