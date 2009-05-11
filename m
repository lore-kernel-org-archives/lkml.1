Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbZEKEA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbZEKEA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 00:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZEKEAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 00:00:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34615 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZEKEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 00:00:20 -0400
Date: Mon, 11 May 2009 05:00:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q. Switch open_exec() and sys_uselib() to do_open_filp()
Message-ID: <20090511040019.GI8633@ZenIV.linux.org.uk>
References: <29926.1242003317@jrobl> <20090511012828.GH8633@ZenIV.linux.org.uk> <31197.1242009975@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31197.1242009975@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:46:15AM +0900, hooanon05@yahoo.co.jp wrote:
> My poor English may make me misunderstood.
> Please let me make sure.
> Do you mean FMODE_EXEC was passed to struct file before this commit?
> 
> Previous open_exec() used to call
> 	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE)
> and it calls
> 	filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
> 				     NULL);
> __dentry_open()
> {
> 	f->f_flags = flags;
> 	f->f_mode = ((flags+1) & O_ACCMODE) | FMODE_LSEEK |
> 				FMODE_PREAD | FMODE_PWRITE;
> 	;;;
> }
> 
> So FMODE_EXEC was not set to f_flags/f_mode, O_RDONLY|O_LARGEFILE only.

Nope.  It ended up in nd->intent.open.flags due to path_lookup_open().
Then lookup_instantiate_filp() from a filesystem that might care about
intents did
        nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->mnt),
                                             nd->intent.open.flags - 1,
                                             nd->intent.open.file,
                                             open);
and nameidata_to_filp() ended up picking nd->intent.open.file.

So f_flags is exactly where that thing used to end up, if it ended up
anywhere at all.
