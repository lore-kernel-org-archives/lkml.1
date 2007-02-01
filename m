Return-Path: <linux-kernel-owner+w=401wt.eu-S1423001AbXBAUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbXBAUts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423004AbXBAUts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:49:48 -0500
Received: from mx1-2.mail.ru ([194.67.23.121]:15772 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423001AbXBAUtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:49:47 -0500
Date: Thu, 1 Feb 2007 23:55:57 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: Tomasz Kvarsin <kvarsin@gmail.com>, dcb314@hotmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: fs/ufs/inode.c:817: warning: array subscript is above array bounds
Message-ID: <20070201205557.GA14227@rain>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Tomasz Kvarsin <kvarsin@gmail.com>, dcb314@hotmail.com,
	linux-kernel@vger.kernel.org
References: <5157576d0701311210j737a3f40h63cef509dadc170f@mail.gmail.com> <20070131132432.e2dc4058.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131132432.e2dc4058.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 01:24:32PM -0800, Andrew Morton wrote:
> On Wed, 31 Jan 2007 23:10:57 +0300
> "Tomasz Kvarsin" <kvarsin@gmail.com> wrote:
> 
> > d binderman wrote:
> > >Hello there,
> > >
> > >I just tried to compile Linux kernel 2.6.19.2 with the
> > >new GNU C compiler version 4.3 snapshot 20070126.
> > >
> > >The compiler said
> > >
> > >fs/ufs/inode.c:817: warning: array subscript is above array bounds
> > >
> > >The source code is
> > >
> > >        for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
> > >            ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.i_data[i];
> > >
> > >but
> > >
> > >./include/linux/ufs_fs.h:                       __fs32  ui_db[UFS_NDADDR];/*
> > >0x28 data blocks */
> > >./include/linux/ufs_fs.h:                       __fs64
> > >ui_db[UFS_NDADDR]; /* 112: Direct disk blocks. */
> > >
> > >and
> > >
> > >        __fs32  i_data[15];
> > >
> > >and
> > >
> > >#define UFS_NDADDR 12
> > >#define UFS_NINDIR 3
> > >
> > >so the kernel seems to be trying to write fifteen bytes into an array only
> > >twelve
> > >bytes in size. Suggest code rework.

Actually, this is not a _real_ bug,
yes, 
for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
	ufs_inode->ui_u2.ui_addr.ui_db[i]

and ui_db only ui_db[UFS_NDADDR], but if look on more high level,
then:
union {
struct {
     __fs64     ui_db[UFS_NDADDR]; /* 112: Direct disk blocks. */
      __fs64     ui_ib[UFS_NINDIR];/* 208: Indirect disk blocks.*/
} ui_addr;
} ui_u2;

have no idea, why array splited on two parts,
may be some macros used this feature.

-- 
/Evgeniy

