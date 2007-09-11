Return-Path: <linux-kernel-owner+w=401wt.eu-S966114AbXIKKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114AbXIKKxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbXIKKxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:53:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760545AbXIKKxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:53:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 13:04:22 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709111354.25689.nigel@nigel.suspend2.net>
In-Reply-To: <200709111354.25689.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111304.23263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 05:54, Nigel Cunningham wrote:
> Hi all.
> 
> Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel threads
> nonfreezable by default) breaks freezing when attempting to resume from an
> initrd, because the init (which is freezeable) spins while waiting for another
> thread to run /linuxrc, but doesn't check whether it has been told to enter
> the refrigerator.

Hm.

I use a resume from an initrd on a regular basis and it works without the patch
below.

I think we need to investigate what happens in your test case a bit.

> The original patch replaced a call to try_to_freeze() with a 
> call to yield(). I believe a simple reversion is wrong because
> if !CONFIG_PM_SLEEP, try_to_freeze() is a noop. It should still yield.
> 
> Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
> 
>  do_mounts_initrd.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> diff -ruNp 952-fix-initrd-resume.patch-old/init/do_mounts_initrd.c 952-fix-initrd-resume.patch-new/init/do_mounts_initrd.c
> --- 952-fix-initrd-resume.patch-old/init/do_mounts_initrd.c	2007-09-11 13:43:31.000000000 +1000
> +++ 952-fix-initrd-resume.patch-new/init/do_mounts_initrd.c	2007-09-11 13:19:50.000000000 +1000
> @@ -58,8 +58,10 @@ static void __init handle_initrd(void)
>  
>  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
>  	if (pid > 0)
> -		while (pid != sys_wait4(-1, NULL, 0, NULL))
> +		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
>  			yield();
> +			try_to_freeze();
> +		}
>  
>  	if (!resume_attempted)
>  		printk(KERN_ERR "Suspend2: No attempt was made to resume from "
> 

Greetings,
Rafael
