Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbXKWX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbXKWX3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 18:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXKWX3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 18:29:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbXKWX3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 18:29:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: freeze vs freezer
Date: Sat, 24 Nov 2007 00:47:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org>
In-Reply-To: <4744FD87.7010301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711240047.21624.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of November 2007, Jeremy Fitzhardinge wrote:
> It seems that a process blocked in a write to an xfs filesystem due to
> xfs_freeze cannot be frozen by the freezer.

The freezer doesn't handle tasks in TASK_UNINTERRUPTIBLE and I don't know how
to make it handle them without at least partially defeating its purpose.

> I see this if I suspend my laptop while doing something xfs-filesystem
> intensive, like a kernel build.  My suspend scripts freeze the XFS
> filesystem (as Dave said I should), which presumably blocks some writer,
> and then the freezer times out and fails to complete.
> 
> Here's part of the process dump the freezer does when it times out:
> 
> cc1           D 00000000     0 18138  18137
>        dd5f1e24 00200082 00000002 00000000 ecdeeb00 ecdeec64 c200f280 00000001 
>        009c09a0 dd5f1e0c dd5f1e0c 0000000f 00000000 00000000 00000000 dd5f1e74 
>        c7beb480 dd5f1e88 dd5f1ea8 c0228d97 e8889540 dd5f1e38 c015b75d dd5f1e44 
> Call Trace:
>  [<c0228d97>] xfs_write+0xf4/0x6d9
>  [<c0226038>] xfs_file_aio_write+0x53/0x5b
>  [<c0171c15>] do_sync_write+0xae/0xec
>  [<c0172343>] vfs_write+0xa4/0x120
>  [<c01728d7>] sys_write+0x3b/0x60
>  [<c0106fae>] sysenter_past_esp+0x6b/0xa1
>  =======================
> 
> 
> I haven't looked at how to fix this yet.  I only just worked out why I
> was getting suspend failures.

Well, you can add freezer_do_not_count()/freezer_count() annotations to
xfs_write() (and whatever else is blocked as a result of the XFS being frozen).

Generally, that would be risky without the freezing of XFS, however, because it
might leak us filesystem data to a storage device after creating a hibernation
image which would result in the filesystem corruption after the resume.

Still, if you only suspend to RAM, that should be safe.

Greetings,
Rafael
