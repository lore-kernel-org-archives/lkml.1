Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbYBTOhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbYBTOhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYBTOgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:36:51 -0500
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:32848 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYBTOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:36:50 -0500
Date: Wed, 20 Feb 2008 14:36:46 +0000
From: Stephane Chazelas <stephane.chazelas@emerson.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <chaz20080220143646.GJ4539@artesyncp.com>
References: <chaz20080212134751.GI30304@artesyncp.com> <20080212152124.GA21878@lazybastard.org> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080219150822.GA29587@lazybastard.org>
Organization: Embedded Computing Emerson Network Power
X-URL: http://www.emersonembeddedcomputing.com
User-Agent: Mutt/1.5.16 (2007-09-19)
X-OriginalArrivalTime: 20 Feb 2008 14:36:46.0888 (UTC) FILETIME=[05445280:01C873CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008-02-19 16:08:22 +0100, Jörn Engel:
> [ Just returned home. ]

Hi Jörn,

I've got to admit I've been a little too busy to look at it
myself. I'll send a patch for the obvious fixes soon though.

[...]
> > Well, yes that raised a concern to me, the "exit" function
> > returns "void". If the del_mtd_device fails with EBUSY at the
> > moment (such as when a /dev/mtdblock<x> is mounted), we ignore
> > it and go on with freeing everything leaving a dangling mtd.
> > 
> > Is there a way around that?
> 
> For module unload we should be safe.  Errors are only returned if the
> device doesn't exist (a clear bug) or if the device is still being used.
> Module refcounting should prevent the latter case, so either way we have
> a bug if del_mtd_device returns an error.

At the moment, when we bind a mtd device to a block device, we
don't increase the refcount. When a mtdblock on a block2mtd, the
refcount is not increased either (the mtdblock's one is I
guess).

When you unload block2mtd, the block2mtd exit code tries and
remove the mtd bindings. If it fails, it exits anyway, leaving
some dangling stuff. That's why I suggested that the exit code
doesn't do the cleaning but that the requirement of cleaning
things up is  put upon the user before he is allowed to unload
the module (increasing the refcount every time block2mtd is used
to map a mtd to a block device).

> When removing the device via your proposed interface we should simply
> return the error to userspace, if the interface permits.  Sysfs doesn't
> seem to permit error returns, so we should keep the device alive and do
> nothing.

Agreed, that's what I was doing in my patch. But I wasn't doing
anything with the refcount, this was still handled as before,
that is we relied on the exit code to do the clean up.

Best regards,
Stephane
