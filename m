Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZEKCq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZEKCq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZEKCqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:46:18 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:57909 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZEKCqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:46:17 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: Q. Switch open_exec() and sys_uselib() to do_open_filp() 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090511012828.GH8633@ZenIV.linux.org.uk>
References: <29926.1242003317@jrobl> <20090511012828.GH8633@ZenIV.linux.org.uk>
Date: Mon, 11 May 2009 11:46:15 +0900
Message-ID: <31197.1242009975@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> On Mon, May 11, 2009 at 09:55:17AM +0900, hooanon05@yahoo.co.jp wrote:
> > 
> > By the commit 6e8341a11eb21826b7192d0bb88cb5b44900a9af
> > "Switch open_exec() and sys_uselib() to do_open_filp()",
> > FMODE_EXEC flag is passed to struct file. I have no objection nor
> > question about that.
> > 
> > But it is set to file->f_flags instead of f_mode.
> > Is this intended behaviour?
> 
> It is previously existing behaviour.  Check what path_lookup_open() does
> and how had it used to be called.

My poor English may make me misunderstood.
Please let me make sure.
Do you mean FMODE_EXEC was passed to struct file before this commit?

Previous open_exec() used to call
	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE)
and it calls
	filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
				     NULL);
__dentry_open()
{
	f->f_flags = flags;
	f->f_mode = ((flags+1) & O_ACCMODE) | FMODE_LSEEK |
				FMODE_PREAD | FMODE_PWRITE;
	;;;
}

So FMODE_EXEC was not set to f_flags/f_mode, O_RDONLY|O_LARGEFILE only.

After the commit, open_exec() calls
	file = do_filp_open(AT_FDCWD, name,
				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
				MAY_EXEC | MAY_OPEN);
and it calls
	filp = nameidata_to_filp(&nd, open_flag);

So f_flags becomes containing FMODE_EXEC, O_LARGEFILE | O_RDONLY | FMODE_EXEC.
This change of the behaviour is my question since a strict type fmode_t
was defined in 2.6.28 or 29 and FMODE_EXEC looks being set to f_mode.

If setting FMODE_xxx to f_flags is intended, it is OK.


J. R. Okajima
