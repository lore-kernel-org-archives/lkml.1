Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYFTOSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYFTOSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYFTOSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:18:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35467 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYFTOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:18:11 -0400
Subject: Re: "r/o bind mounts" patch in 2.6.26-rc6 changes (breaks?) error
	behaviour
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <485B8361.6010708@LiPPERTEmbedded.de>
References: <485B8361.6010708@LiPPERTEmbedded.de>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 07:17:46 -0700
Message-Id: <1213971466.7512.17.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-20 at 12:16 +0200, Jens Rottmann wrote:
> 
> I noticed the following change in the error behaviour when attempting
> to delete nonexisting files/dirs from R/O-mounted directories:
> 
> Linux 2.6.25.7:
> rm /RO_mounted_path/nonexisting_file
> ==> "No such file or directory"
> 
> Linux 2.6.26-rc6-git6:
> rm /RO_mounted_path/nonexisting_file
> ==> "Read-only file system"

We looked at this way back in the beginning when I started to work on
the patches.  It was decided that the error codes weren't horribly
important.  We did have a case a bit ago where it really mattered, and
Al fixed that up.

I know this changed behavior a bit, but userspace can surely work around
it with read-only operations (stat) when it is really important to get
the error to the user just right.

> @@ -2371,8 +2373,10 @@ static long do_unlinkat(int dfd, const c
>                 if (inode)
>                         atomic_inc(&inode->i_count);
>                 error = mnt_want_write(nd.path.mnt);
> -               if (error)
> +               if (error) {
> +                       error = vfs_unlink(nd.path.dentry->d_inode, dentry);
>                         goto exit2;
> +               }
>                 error = vfs_unlink(nd.path.dentry->d_inode, dentry);
>                 mnt_drop_write(nd.path.mnt);

On a r/w fs where this is being performed on a r/o bind mount, this will
let you unlink files.  I think that's bad.  :)

-- Dave

