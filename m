Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYBSPJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYBSPJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbYBSPIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:08:55 -0500
Received: from lazybastard.de ([212.112.238.170]:57673 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYBSPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:08:52 -0500
Date: Tue, 19 Feb 2008 16:08:22 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephane Chazelas <stephane.chazelas@emerson.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <20080219150822.GA29587@lazybastard.org>
References: <chaz20080212134751.GI30304@artesyncp.com> <20080212152124.GA21878@lazybastard.org> <chaz20080212161034.GJ30304@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <chaz20080212161034.GJ30304@artesyncp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Just returned home. ]

On Tue, 12 February 2008 16:10:34 +0000, Stephane Chazelas wrote:
> 
> OK, I can do that. Would the "simple" fix go to the
> trivial@kernel.org Trivial Patch Monkey?

That or to me or to dwmw2...  I'm not too picky about the path, as long
as it gets merged eventually.

> > The core of remove_device_by_name() is shared with block2mtd_exit(),
> > so a common helper would be good.  Your error handling is better, so
> > let's keep that version.
> 
> Well, yes that raised a concern to me, the "exit" function
> returns "void". If the del_mtd_device fails with EBUSY at the
> moment (such as when a /dev/mtdblock<x> is mounted), we ignore
> it and go on with freeing everything leaving a dangling mtd.
> 
> Is there a way around that?

For module unload we should be safe.  Errors are only returned if the
device doesn't exist (a clear bug) or if the device is still being used.
Module refcounting should prevent the latter case, so either way we have
a bug if del_mtd_device returns an error.

When removing the device via your proposed interface we should simply
return the error to userspace, if the interface permits.  Sysfs doesn't
seem to permit error returns, so we should keep the device alive and do
nothing.

> Another problem is that it's not easy to check whether a mtd
> creation was successful or not. Basically, you have to write to
> a /sys file and then parse /proc/mtd to get the result.

Agreed, sysfs' lack of error indication isn't ideal.

> What about having a /dev/block2mtd (with owner/permissions that
> could allow non-root users to use it), with 2 ioctls:
> 
> - one to "link" a block dev to a mtd that would take as
>   parameter a fd to an open block dev (again allowing for
>   flexible permissions) and would return the number of the
>   allocated mtd and success/failure in errno. Upon sucess it
>   would increase the refcnt of block2mtd.
> 
> - and one to "release" the link. That would fail if the mtd is
>   in use and decrease block2mtd's refcnt upon success.
> 
> A bit like the loop devices (or /dev/ptmx) actually. What do you
> think?

Could work.  Passing the fd raises several alarm bells.  Arnd, any
comments from you?

In general I'd like to see some good reasons for adding an ioctl (or any
other) interface first.  Creating interfaces is hard and you rarely get
a second chance to fix the mess you created before you knew all the
consequenses.

> (also, with the /sys interface, isn't there a potential problem
> with chroots wrt the path given to the /sys file?)

There may be.  Can you check if there is?

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
