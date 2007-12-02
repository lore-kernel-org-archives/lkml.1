Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbXLBGw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbXLBGw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 01:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbXLBGwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 01:52:21 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:44790 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbXLBGwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 01:52:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a1Id6ntvkKcpVZlh8WIHR1zYRMefLCHGmmL82JRJEjqLFVj9whK3RnLn8u0hKDvgb8UJ1CheUbuWE9YDtWsRoagXGlD/By4jLzGQymcyrEhFXAIDCcP0SZeQQprCJX90Thg1chvaClObNHb/w4ZZkzMRtm7t9nkMD6s/TOtgIc4=
Message-ID: <91b13c310712012252k5307735x782582fd2d7abd94@mail.gmail.com>
Date: Sun, 2 Dec 2007 14:52:17 +0800
From: "rae l" <crquan@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: Since sysfs_mount is static and used only in sysfs_init function, it could be just an automatic variable.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071202044825.GA7004@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com>
	 <20071202044825.GA7004@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 2, 2007 12:48 PM, Greg KH <gregkh@suse.de> wrote:
...
> > and where is a detailed explaination on kern_mount? could someone give
> > some comments or documentation pointers on this?
>
> See the patches that Eric Biederman just posted to lkml for why this
> structure is a static pointer this way right now, it's in preparation
> for future patches.
I have checked commit 7d0c7d676cc066413e1583b5af9fba8011972d41 by Eric
W. Biederman,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7d0c7d676cc066413e1583b5af9fba8011972d41

which just make sysfs_mount from externally visible to static that
could be only used in one c file,

but I mean that the static variable is still on kernel bss section,
this consumes a pointer (4 or 8 bytes) memory,

through a grep from fs/sysfs/, it appears that the variable
sysfs_mount is only used in the sysfs_init function,

$ grep -RsInw sysfs_mount fs/sysfs/
fs/sysfs/mount.c:25:static struct vfsmount *sysfs_mount;
fs/sysfs/mount.c:101:           sysfs_mount = kern_mount(&sysfs_fs_type);
fs/sysfs/mount.c:102:           if (IS_ERR(sysfs_mount)) {
fs/sysfs/mount.c:104:                   err = PTR_ERR(sysfs_mount);
fs/sysfs/mount.c:105:                   sysfs_mount = NULL;

we could mark this variable an automatic one, which scope is just in
this function, thus created and destroyed with the stack,
this approach does not consume a pointer on kernel bss section,

Why not do this?

-- 
Denis Cheng
