Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZGBJKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZGBJKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZGBJKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:10:07 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:50431 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZGBJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jp7+EmYaAnnmpmamZRC7b7CaIBD2nSiJ0bOKQDWILX5zYZ8vsbwqrfRgKU+zlJqXbX
         /nXui20gaqAGcSx/zlSQ474g0E5gCMlzoU593maK0sM+tugPxiTL8+mWW+1V4D2z0Nrp
         15paXizyXsOezJUc6W0CrftKJs6utyj8sIv7U=
Date: Thu, 2 Jul 2009 17:12:11 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: fd leak if pipe() is called with an invalid address.
Message-ID: <20090702091211.GA6372@cr0.nay.redhat.com>
References: <4A4C6013.9090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C6013.9090509@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 03:21:55PM +0800, Changli Gao wrote:
>fd leak if pipe() is called with an invalid address.
>
>Though -EFAULT is returned, the file descriptors opened by pipe() call
>are left open.

Looks reasonable.

>
>Signed-off-by: Changli Gao <xiaosuo@gmail.com>


Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>----
>
> x86/ia32/sys_ia32.c     |    5 ++++-
> xtensa/kernel/syscall.c |    5 ++++-
> 2 files changed, 8 insertions(+), 2 deletions(-)
>
>
>--- arch/x86/ia32/sys_ia32.c.orig	2009-07-02 15:08:39.000000000 +0800
>+++ arch/x86/ia32/sys_ia32.c	2009-07-02 15:09:49.000000000 +0800
>@@ -197,8 +197,11 @@
> 	retval = do_pipe_flags(fds, 0);
> 	if (retval)
> 		goto out;
>-	if (copy_to_user(fd, fds, sizeof(fds)))
>+	if (copy_to_user(fd, fds, sizeof(fds))) {
>+		sys_close(fd[0]);
>+		sys_close(fd[1]);
> 		retval = -EFAULT;
>+	}
> out:
> 	return retval;
> }
>--- arch/xtensa/kernel/syscall.c.orig	2009-07-02 15:09:01.000000000 +0800
>+++ arch/xtensa/kernel/syscall.c	2009-07-02 15:10:15.000000000 +0800
>@@ -51,8 +51,11 @@
> 
> 	error = do_pipe_flags(fd, 0);
> 	if (!error) {
>-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
>+		if (copy_to_user(userfds, fd, 2 * sizeof(int))) {
>+			sys_close(fd[0]);
>+			sys_close(fd[1]);
> 			error = -EFAULT;
>+		}
> 	}
> 	return error;
> }
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
