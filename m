Return-Path: <linux-kernel-owner+w=401wt.eu-S1763188AbYEFIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763188AbYEFIyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbYEFIuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:50:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34729 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187AbYEFIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:50:09 -0400
To: hirofumi@mail.parknet.co.jp
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <87myn4lem9.fsf@duaron.myhome.or.jp> (message from OGAWA Hirofumi
	on Tue, 06 May 2008 04:45:02 +0900)
Subject: Re: [patch 08/15] fat: dont call notify_change
References: <20080505095440.820370974@szeredi.hu>
	<20080505095518.844178123@szeredi.hu> <87myn4lem9.fsf@duaron.myhome.or.jp>
Message-Id: <E1JtIs2-0008VJ-Ge@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 May 2008 10:49:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> > the file mode before changing the inode attributes.  Replace with
> > explicit call to fat_setattr().
> >
> > This is equivalent, except that security_inode_setattr() is not called
> > before fat_setattr().  I think this is not needed, since the mode
> > change is just a side effect of the attribute change.
> >
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> Looks good. I'm not sure about the intent of security_inode_setattr()
> though.

security_inode_setattr() will call into the security module (selinux,
smack, apparmor) to check if the file mode change is permitted or not.
It's not really applicable to this case, since AFAICS the mode change
here is just a side effect of the attribute change.

If it's not just a side effect, but another way to change the file
mode, then the whole code is very wrong.  chmod() is perfectly fine
for changing the file mode, there's no need for a separate ioctl to
perform exactly the same task.

Miklos
