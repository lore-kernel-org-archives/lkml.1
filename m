Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXDBFkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXDBFkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbXDBFkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:40:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36347 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXDBFki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:40:38 -0400
Date: Sun, 1 Apr 2007 22:39:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 5/16] fix-kthread-niceness.diff
Message-Id: <20070401223935.f73402a8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704012003580.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012003580.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:14:40 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> Fix kevent's childs priority greedy-ness. Such tasks were always scheduled
> at nice level -5 and, at that time, udev stole us the CPU time with -5.
> 
> Already posted at http://lkml.org/lkml/2005/1/10/85
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> Cc: Chris Wright <chrisw@sous-sol.org>
> 
>  kmod.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.21-rc5/kernel/kmod.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/kmod.c
> +++ linux-2.6.21-rc5/kernel/kmod.c
> @@ -165,6 +165,7 @@ static int ____call_usermodehelper(void 
>  
>  	/* We can run anywhere, unlike our parent keventd(). */
>  	set_cpus_allowed(current, CPU_MASK_ALL);
> +	set_user_nice(current, 0);
>  
>  	retval = -EPERM;
>  	if (current->fs->root)
> #<EOF>

-ETOOOBSCURE.

--- a/kernel/kmod.c~fix-kthread-nicenessdiff-fix
+++ a/kernel/kmod.c
@@ -163,6 +163,11 @@ static int ____call_usermodehelper(void 
 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed(current, CPU_MASK_ALL);
+
+	/*
+	 * Our parent is keventd, which runs with elevated scheduling priority.
+	 * Avoid propagating that into the userspace child.
+	 */
 	set_user_nice(current, 0);
 
 	retval = -EPERM;
_

