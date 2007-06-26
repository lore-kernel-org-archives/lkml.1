Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbXFZMeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbXFZMeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXFZMdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:33:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:35895 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbXFZMdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:33:50 -0400
Date: Tue, 26 Jun 2007 16:34:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sys_time-speedup-small-cleanup
Message-ID: <20070626123424.GA259@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on top of sys_time-speedup.patch

Ingo Molnar wrote:
>
>  asmlinkage long sys_time(time_t __user * tloc)
>  {
> -	time_t i;
> -	struct timeval tv;
> +	/*
> +	 * We read xtime.tv_sec atomically - it's updated
> +	 * atomically by update_wall_time(), so no need to
> +	 * even read-lock the xtime seqlock:
> +	 */
> +	time_t i = xtime.tv_sec;
>  
> -	do_gettimeofday(&tv);
> -	i = tv.tv_sec;
> +	smp_rmb(); /* sys_time() results are coherent */

Why do we need this barrier? My guess it is needed to prevent
the reading of xtime.tv_sec twice, yes? In that case a simple
barrier() should be enough.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/time.c~	2007-06-26 16:28:59.000000000 +0400
+++ t/kernel/time.c	2007-06-26 16:32:09.000000000 +0400
@@ -64,7 +64,7 @@ asmlinkage long sys_time(time_t __user *
 	 */
 	time_t i = xtime.tv_sec;
 
-	smp_rmb(); /* sys_time() results are coherent */
+	barrier(); /* sys_time() results are coherent */
 
 	if (tloc) {
 		if (put_user(i, tloc))

