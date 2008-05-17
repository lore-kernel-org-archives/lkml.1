Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYEQR2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYEQR2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 13:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYEQR22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 13:28:28 -0400
Received: from adsl-76-245-85-235.dsl.pltn13.sbcglobal.net ([76.245.85.235]:35384
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYEQR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 13:28:27 -0400
Date: Sat, 17 May 2008 06:01:32 -0700
From: Brad Boyer <flar@allandria.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/22] fat: dont call notify_change
Message-ID: <20080517130132.GB25261@cynthia.pants.nu>
References: <20080516163136.560107038@szeredi.hu> <20080516163222.235825996@szeredi.hu> <87prrl7rxg.fsf@duaron.myhome.or.jp> <E1JxGLP-000406-Eo@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JxGLP-000406-Eo@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 08:56:39AM +0200, Miklos Szeredi wrote:
> > > The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> > > the file mode before changing the inode attributes.  Replace with
> > > explicit calls to security_inode_setattr(), fat_setattr() and
> > > fsnotify_change().
> > >
> > > This is equivalent to the original.  The reason it is needed, is that
> > > later in the series we move the immutable check into notify_change().
> > > That would break the FAT_IOCTL_SET_ATTRIBUTES ioctl, as it needs to
> > > perform the mode change regardless of the immutability of the file.
> > 
> > Don't we need to add EXPORT_SYMBOL(security_inode_setattr)?
> 
> Yes we do, thanks for noticing.  Committed the below patch to the
> vfs-cleanups tree.
> ----
> Index: linux-2.6/security/security.c
> ===================================================================
> --- linux-2.6.orig/security/security.c	2008-05-14 12:49:42.000000000 +0200
> +++ linux-2.6/security/security.c	2008-05-17 08:46:52.000000000 +0200
> @@ -476,6 +476,7 @@ int security_inode_setattr(struct dentry
>  		return 0;
>  	return security_ops->inode_setattr(dentry, attr);
>  }
> +EXPORT_SYMBOL_GPL(security_inode_setattr);

Is there any particular reason you made it EXPORT_SYMBOL_GPL? It seems
like this is replacing functionality that was previously exported
without a GPL tag. I won't argue forcefully for changing it, but I
did want to mention it on the list. I understand people wanting to
make new functionality tagged that way (even though I disagree), but
this doesn't seem to fit either the notion of an internal thing that
shouldn't be touched or new functionality.

	Brad Boyer
	flar@allandria.com

